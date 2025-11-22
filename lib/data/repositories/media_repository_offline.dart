import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/connectivity_service.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/local/offline_database.dart';
import '../models/sync_operation.dart';

/// Repositório offline-first para gerenciar mídias (fotos de avaliações)
class MediaRepositoryOffline implements MediaRepository {
  MediaRepositoryOffline({
    OfflineDatabase? database,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    ConnectivityService? connectivityService,
    String? ownerIdOverride,
  }) : _database = database ?? OfflineDatabase.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _connectivity = connectivityService ?? ConnectivityService(),
       _ownerIdOverride = ownerIdOverride;

  static const _syncEntity = 'media';
  static const _fallbackOwnerId = 'local_offline_user';

  final OfflineDatabase _database;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final ConnectivityService _connectivity;
  final String? _ownerIdOverride;

  final Map<String, List<Media>> _mediaByAssessment = {};
  final Map<String, Media> _mediaById = {};
  final Map<String, StreamController<List<Media>>> _assessmentControllers = {};
  final Map<String, StreamController<Media?>> _mediaControllers = {};

  @override
  Future<List<Media>> getMediaByAssessment(String assessmentId) async {
    await _ensureMediaCache(assessmentId);
    return List<Media>.unmodifiable(
      _mediaByAssessment[assessmentId] ?? const [],
    );
  }

  @override
  Future<Media?> getMediaById(String mediaId) async {
    final cached = _mediaById[mediaId];
    if (cached != null) return cached;

    final row = await _database.getMediaById(mediaId);
    if (row == null) return null;

    final media = _mapRowToMedia(row);
    _cacheUpsert(media, emit: false);
    return media;
  }

  @override
  Future<Media> createMedia(Media media) async {
    final now = DateTime.now();
    final generatedId = media.id.isEmpty ? _generateLocalId() : media.id;

    final persisted = media.copyWith(
      id: generatedId,
      createdAt: media.createdAt.isBefore(now) ? media.createdAt : now,
      updatedAt: now,
    );

    await _database.upsertMedia(_toRow(persisted));
    _cacheUpsert(persisted);

    // Não enfileirar para sync automaticamente - upload será feito pelo StorageService
    AppLogger.info('Mídia criada localmente: ${persisted.id}');

    return persisted;
  }

  @override
  Future<Media> updateMedia(Media media) async {
    final updated = media.copyWith(updatedAt: DateTime.now());

    await _database.upsertMedia(_toRow(updated));
    _cacheUpsert(updated);

    // Sincronizar com Firestore se upload completado
    if (updated.uploadStatus == UploadStatus.completed && _hasRemoteAccess) {
      unawaited(_pushMediaToFirestore(updated));
    }

    return updated;
  }

  @override
  Future<void> deleteMedia(String mediaId) async {
    final existing = _mediaById[mediaId] ?? await getMediaById(mediaId);
    if (existing == null) {
      throw Exception('Mídia não encontrada');
    }

    await _database.deleteById('media', mediaId);
    _removeFromCache(existing);

    // Enfileirar exclusão no Firestore
    if (_hasRemoteAccess) {
      await _queueOperation(media: existing, type: SyncOperationType.delete);
    }

    AppLogger.info('Mídia deletada: $mediaId');
  }

  @override
  Future<Media> updateUploadProgress(String mediaId, double progress) async {
    await _database.updateMediaUploadProgress(id: mediaId, progress: progress);

    final media = await getMediaById(mediaId);
    if (media != null) {
      final updated = media.copyWith(
        uploadProgress: progress,
        updatedAt: DateTime.now(),
      );
      _cacheUpsert(updated);
      return updated;
    }

    throw Exception('Mídia não encontrada: $mediaId');
  }

  @override
  Future<Media> completeUpload(
    String mediaId,
    String storagePath,
    String downloadUrl, {
    String? thumbUrl,
  }) async {
    await _database.completeMediaUpload(
      id: mediaId,
      storagePath: storagePath,
      downloadUrl: downloadUrl,
      thumbUrl: thumbUrl,
    );

    final media = await getMediaById(mediaId);
    if (media == null) {
      throw Exception('Mídia não encontrada: $mediaId');
    }

    final completed = media.copyWith(
      storagePath: storagePath,
      downloadUrl: downloadUrl,
      thumbUrl: thumbUrl,
      uploadStatus: UploadStatus.completed,
      uploadProgress: 1.0,
      updatedAt: DateTime.now(),
    );

    _cacheUpsert(completed);

    // Sincronizar com Firestore
    if (_hasRemoteAccess) {
      unawaited(_pushMediaToFirestore(completed));
    }

    AppLogger.info('Upload concluído: $mediaId');
    return completed;
  }

  @override
  Future<Media> failUpload(String mediaId, String errorMessage) async {
    await _database.updateMediaUploadStatus(
      id: mediaId,
      status: 'failed',
      errorMessage: errorMessage,
    );

    await _database.incrementMediaRetry(mediaId);

    final media = await getMediaById(mediaId);
    if (media == null) {
      throw Exception('Mídia não encontrada: $mediaId');
    }

    final failed = media.copyWith(
      uploadStatus: UploadStatus.failed,
      errorMessage: errorMessage,
      retryCount: media.retryCount + 1,
      updatedAt: DateTime.now(),
    );

    _cacheUpsert(failed);

    AppLogger.error('Upload falhou: $mediaId - $errorMessage');
    return failed;
  }

  @override
  Stream<List<Media>> watchMediaByAssessment(String assessmentId) {
    late final StreamController<List<Media>> controller;
    controller = StreamController<List<Media>>.broadcast(
      onListen: () {
        unawaited(() async {
          await _ensureMediaCache(assessmentId);
          controller.add(
            List<Media>.unmodifiable(
              _mediaByAssessment[assessmentId] ?? const [],
            ),
          );
        }());
      },
      onCancel: () {
        _assessmentControllers.remove(assessmentId);
        controller.close();
      },
    );

    _assessmentControllers[assessmentId] = controller;
    return controller.stream;
  }

  @override
  Stream<Media?> watchMedia(String mediaId) {
    late final StreamController<Media?> controller;
    controller = StreamController<Media?>.broadcast(
      onListen: () {
        unawaited(() async {
          final media = await getMediaById(mediaId);
          controller.add(media);
        }());
      },
      onCancel: () {
        _mediaControllers.remove(mediaId);
        controller.close();
      },
    );

    _mediaControllers[mediaId] = controller;
    return controller.stream;
  }

  @override
  Future<List<Media>> getMediaByUploadStatus(UploadStatus status) async {
    final rows = await _database.getMediaByUploadStatus(
      status: _uploadStatusToString(status),
    );
    return rows.map(_mapRowToMedia).toList();
  }

  @override
  Future<List<Media>> getPendingUploads() async {
    return getMediaByUploadStatus(UploadStatus.pending);
  }

  @override
  Future<List<Media>> getFailedUploads() async {
    return getMediaByUploadStatus(UploadStatus.failed);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _ensureMediaCache(String assessmentId) async {
    if (_mediaByAssessment.containsKey(assessmentId)) return;

    final rows = await _database.getMediaByAssessment(
      assessmentId: assessmentId,
    );
    final mediaList = rows.map(_mapRowToMedia).toList();
    _mediaByAssessment[assessmentId] = mediaList;

    for (final media in mediaList) {
      _mediaById[media.id] = media;
    }
  }

  void _cacheUpsert(Media media, {bool emit = true}) {
    _mediaById[media.id] = media;
    final list = _mediaByAssessment.putIfAbsent(media.assessmentId, () => []);
    final index = list.indexWhere((m) => m.id == media.id);

    if (index >= 0) {
      list[index] = media;
    } else {
      list.add(media);
    }

    _sortMediaList(media.assessmentId);

    if (emit) {
      _emitAssessmentMedia(media.assessmentId);
      _emitMedia(media.id, media);
    }
  }

  void _removeFromCache(Media media) {
    _mediaById.remove(media.id);
    final list = _mediaByAssessment[media.assessmentId];
    list?.removeWhere((m) => m.id == media.id);

    if (list != null) {
      _sortMediaList(media.assessmentId);
    }

    _emitAssessmentMedia(media.assessmentId);
    _emitMedia(media.id, null);
  }

  void _sortMediaList(String assessmentId) {
    final list = _mediaByAssessment[assessmentId];
    list?.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _emitAssessmentMedia(String assessmentId) {
    final controller = _assessmentControllers[assessmentId];
    if (controller == null || controller.isClosed) return;

    final snapshot = List<Media>.unmodifiable(
      _mediaByAssessment[assessmentId] ?? const [],
    );
    controller.add(snapshot);
  }

  void _emitMedia(String mediaId, Media? media) {
    final controller = _mediaControllers[mediaId];
    if (controller == null || controller.isClosed) return;
    controller.add(media);
  }

  Future<SyncOperation?> _queueOperation({
    required Media media,
    required SyncOperationType type,
  }) async {
    try {
      return await _database.queueOperation(
        entity: _syncEntity,
        type: type,
        payload: {
          'mediaId': media.id,
          'assessmentId': media.assessmentId,
          if (type != SyncOperationType.delete) 'media': _mediaToJson(media),
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        '[MediaRepositoryOffline] Erro ao enfileirar operação',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _pushMediaToFirestore(Media media) async {
    if (!_hasRemoteAccess || media.uploadStatus != UploadStatus.completed) {
      return;
    }

    if (!await _connectivity.hasConnection()) return;

    try {
      final ownerId = _resolveOwnerId();

      // Precisamos buscar patientId e woundId do assessment
      final assessmentRow = await _database.getAssessmentById(
        media.assessmentId,
      );
      if (assessmentRow == null) {
        AppLogger.warning(
          'Assessment não encontrado para mídia: ${media.assessmentId}',
        );
        return;
      }

      final patientId = assessmentRow['patient_id'] as String;
      final woundId = assessmentRow['wound_id'] as String;

      final docRef = _firestore
          .collection('users')
          .doc(ownerId)
          .collection('patients')
          .doc(patientId)
          .collection('wounds')
          .doc(woundId)
          .collection('assessments')
          .doc(media.assessmentId)
          .collection('media')
          .doc(media.id);

      await docRef.set(_mediaToFirestore(ownerId, patientId, woundId, media));

      AppLogger.info('Mídia sincronizada com Firestore: ${media.id}');
    } catch (e, stackTrace) {
      AppLogger.error(
        '[MediaRepositoryOffline] Erro ao sincronizar mídia',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Map<String, Object?> _toRow(Media media) {
    return {
      'id': media.id,
      'assessment_id': media.assessmentId,
      'wound_id': '', // Será preenchido via assessment
      'patient_id': '', // Será preenchido via assessment
      'owner_id': _resolveOwnerId(),
      'local_path': media.localPath,
      'storage_path': media.storagePath ?? '',
      'download_url': media.downloadUrl,
      'thumb_url': media.thumbUrl,
      'upload_status': _uploadStatusToString(media.uploadStatus),
      'upload_progress': media.uploadProgress,
      'retry_count': media.retryCount,
      'width': media.width,
      'height': media.height,
      'file_size': media.fileSize,
      'mime_type': media.mimeType,
      'error_message': media.errorMessage,
      'created_at': media.createdAt.millisecondsSinceEpoch,
      'updated_at': media.updatedAt.millisecondsSinceEpoch,
    };
  }

  Media _mapRowToMedia(Map<String, Object?> row) {
    return Media(
      id: row['id'] as String,
      assessmentId: row['assessment_id'] as String,
      type: MediaType.image, // Por enquanto, apenas imagens
      uploadStatus: _uploadStatusFromString(row['upload_status'] as String),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      localPath: row['local_path'] as String?,
      storagePath: _normalizeField(row['storage_path']),
      downloadUrl: row['download_url'] as String?,
      thumbUrl: row['thumb_url'] as String?,
      width: row['width'] as int?,
      height: row['height'] as int?,
      fileSize: row['file_size'] as int?,
      mimeType: row['mime_type'] as String?,
      uploadProgress: (row['upload_progress'] as num?)?.toDouble() ?? 0.0,
      retryCount: row['retry_count'] as int? ?? 0,
      errorMessage: row['error_message'] as String?,
    );
  }

  Map<String, dynamic> _mediaToJson(Media media) {
    return {
      'id': media.id,
      'assessmentId': media.assessmentId,
      'type': media.type.toString(),
      'uploadStatus': media.uploadStatus.toString(),
      'localPath': media.localPath,
      'storagePath': media.storagePath,
      'downloadUrl': media.downloadUrl,
      'thumbUrl': media.thumbUrl,
      'width': media.width,
      'height': media.height,
      'fileSize': media.fileSize,
      'mimeType': media.mimeType,
      'uploadProgress': media.uploadProgress,
      'retryCount': media.retryCount,
      'errorMessage': media.errorMessage,
      'createdAt': media.createdAt.toIso8601String(),
      'updatedAt': media.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _mediaToFirestore(
    String ownerId,
    String patientId,
    String woundId,
    Media media,
  ) {
    return {
      'ownerId': ownerId,
      'patientId': patientId,
      'woundId': woundId,
      'assessmentId': media.assessmentId,
      'storagePath': media.storagePath,
      'downloadUrl': media.downloadUrl,
      'thumbUrl': media.thumbUrl,
      'width': media.width,
      'height': media.height,
      'createdAt': Timestamp.fromDate(media.createdAt),
    };
  }

  String? _normalizeField(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  String _uploadStatusToString(UploadStatus status) {
    switch (status) {
      case UploadStatus.pending:
        return 'pending';
      case UploadStatus.uploading:
        return 'uploading';
      case UploadStatus.completed:
        return 'completed';
      case UploadStatus.failed:
        return 'failed';
    }
  }

  UploadStatus _uploadStatusFromString(String status) {
    switch (status) {
      case 'pending':
        return UploadStatus.pending;
      case 'uploading':
        return UploadStatus.uploading;
      case 'completed':
        return UploadStatus.completed;
      case 'failed':
        return UploadStatus.failed;
      default:
        return UploadStatus.pending;
    }
  }

  String _resolveOwnerId() {
    final override = _ownerIdOverride;
    if (override != null && override.isNotEmpty) {
      return override;
    }
    return _auth.currentUser?.uid ?? _fallbackOwnerId;
  }

  bool get _hasRemoteAccess => _auth.currentUser != null;

  String _generateLocalId() {
    if (_hasRemoteAccess) {
      return _firestore.collection('media').doc().id;
    }
    final millis = DateTime.now().millisecondsSinceEpoch;
    final random = (millis * 1499) % 1000000;
    return 'local_media_${millis}_$random';
  }
}
