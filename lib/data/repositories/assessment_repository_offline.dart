import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/connectivity_service.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/assessment_manual.dart';
import '../../domain/repositories/assessment_repository_manual.dart';
import '../datasources/local/offline_database.dart';
import '../models/sync_operation.dart';

/// Offline-first repository implementation for assessments that keeps data in
/// SQLite and synchronizes to Firestore whenever connectivity allows.
class AssessmentRepositoryOffline implements AssessmentRepository {
  AssessmentRepositoryOffline({
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

  static const _syncEntity = 'assessments';
  static const _fallbackOwnerId = 'local_offline_user';

  final OfflineDatabase _database;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final ConnectivityService _connectivity;
  final String? _ownerIdOverride;

  final Map<String, List<AssessmentManual>> _assessmentsByWound = {};
  final Map<String, AssessmentManual> _assessmentsById = {};
  final Map<String, String> _woundToPatient = {};
  final Set<String> _loadedWounds = {};
  final Map<String, List<StreamController<List<AssessmentManual>>>>
  _woundControllers = {};
  final Map<String, List<StreamController<AssessmentManual?>>>
  _assessmentControllers = {};

  @override
  Future<List<AssessmentManual>> getAssessmentsByWoundId(String woundId) async {
    final ownerId = _resolveOwnerId();
    final patientId = await _ensurePatientForWound(woundId);
    await _ensureWoundCache(ownerId, patientId, woundId);
    final assessments = _assessmentsByWound[woundId] ?? const [];
    _woundToPatient[woundId] = patientId;
    return List<AssessmentManual>.unmodifiable(assessments);
  }

  @override
  Future<AssessmentManual?> getAssessmentById(String id) async {
    final cached = _assessmentsById[id];
    if (cached != null) return cached;
    final row = await _database.getAssessmentById(id);
    if (row == null) return null;
    final assessment = _mapRowToAssessment(row);
    final woundId = assessment.woundId;
    final patientId = row['patient_id'] as String;
    _woundToPatient[woundId] = patientId;
    _cacheUpsert(assessment, emit: false);
    return assessment;
  }

  @override
  Future<AssessmentManual> createAssessment(AssessmentManual assessment) async {
    final ownerId = _resolveOwnerId();
    final patientId = await _ensurePatientForWound(assessment.woundId);
    await _ensureWoundCache(ownerId, patientId, assessment.woundId);

    final now = DateTime.now();
    final generatedId = _generateLocalId(patientId, assessment.woundId);

    final persisted = assessment.copyWith(
      id: assessment.id.isEmpty ? generatedId : assessment.id,
      createdAt: assessment.createdAt.isBefore(now)
          ? assessment.createdAt
          : now,
      updatedAt: now,
      notes: assessment.notes?.trim(),
    );

    await _database.upsertAssessment(_toRow(ownerId, patientId, persisted));
    _cacheUpsert(persisted);

    final op = await _queueOperation(
      ownerId: ownerId,
      patientId: patientId,
      assessment: persisted,
      type: SyncOperationType.create,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      patientId: patientId,
      assessment: persisted,
      type: SyncOperationType.create,
      op: op,
    );

    return persisted;
  }

  @override
  Future<AssessmentManual> updateAssessment(AssessmentManual assessment) async {
    final ownerId = _resolveOwnerId();
    final patientId = await _ensurePatientForWound(assessment.woundId);
    await _ensureWoundCache(ownerId, patientId, assessment.woundId);

    final updated = assessment.copyWith(
      updatedAt: DateTime.now(),
      notes: assessment.notes?.trim(),
    );

    await _database.upsertAssessment(_toRow(ownerId, patientId, updated));
    _cacheUpsert(updated);

    final op = await _queueOperation(
      ownerId: ownerId,
      patientId: patientId,
      assessment: updated,
      type: SyncOperationType.update,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      patientId: patientId,
      assessment: updated,
      type: SyncOperationType.update,
      op: op,
    );

    return updated;
  }

  @override
  Future<void> deleteAssessment(String assessmentId) async {
    final existing =
        _assessmentsById[assessmentId] ?? await getAssessmentById(assessmentId);
    if (existing == null) {
      throw Exception('Avaliação não encontrada');
    }

    final ownerId = _resolveOwnerId();
    final patientId = await _ensurePatientForWound(existing.woundId);

    await _database.deleteById('assessments', assessmentId);
    _removeFromCache(existing);

    final op = await _queueOperation(
      ownerId: ownerId,
      patientId: patientId,
      assessment: existing,
      type: SyncOperationType.delete,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      patientId: patientId,
      assessment: existing,
      type: SyncOperationType.delete,
      op: op,
    );
  }

  @override
  Stream<List<AssessmentManual>> watchAssessments(String woundId) {
    late final StreamController<List<AssessmentManual>> controller;
    controller = StreamController<List<AssessmentManual>>.broadcast(
      onListen: () {
        unawaited(() async {
          final ownerId = _resolveOwnerId();
          final patientId = await _ensurePatientForWound(woundId);
          await _ensureWoundCache(ownerId, patientId, woundId);
          controller.add(
            List<AssessmentManual>.unmodifiable(
              _assessmentsByWound[woundId] ?? const [],
            ),
          );
        }());
      },
      onCancel: () {
        final controllers = _woundControllers[woundId];
        controllers?.remove(controller);
        if (controllers != null && controllers.isEmpty) {
          _woundControllers.remove(woundId);
        }
        controller.close();
      },
    );

    _woundControllers.putIfAbsent(woundId, () => []).add(controller);
    return controller.stream;
  }

  @override
  Stream<AssessmentManual?> watchAssessment(String assessmentId) {
    late final StreamController<AssessmentManual?> controller;
    controller = StreamController<AssessmentManual?>.broadcast(
      onListen: () {
        unawaited(() async {
          final assessment = await getAssessmentById(assessmentId);
          controller.add(assessment);
        }());
      },
      onCancel: () {
        final controllers = _assessmentControllers[assessmentId];
        controllers?.remove(controller);
        if (controllers != null && controllers.isEmpty) {
          _assessmentControllers.remove(assessmentId);
        }
        controller.close();
      },
    );

    _assessmentControllers.putIfAbsent(assessmentId, () => []).add(controller);
    return controller.stream;
  }

  @override
  Future<List<AssessmentManual>> getAssessmentsWithFilters({
    String? woundId,
    DateTime? fromDate,
    DateTime? toDate,
    int? minPainScale,
    int? maxPainScale,
  }) async {
    final ownerId = _resolveOwnerId();
    final patientId = woundId != null
        ? await _ensurePatientForWound(woundId)
        : null;
    final rows = await _database.getAssessmentsWithFilters(
      ownerId: ownerId,
      patientId: patientId,
      woundId: woundId,
      fromDate: fromDate,
      toDate: toDate,
      minPainScale: minPainScale,
      maxPainScale: maxPainScale,
    );
    final assessments = rows.map(_mapRowToAssessment).toList();
    for (var i = 0; i < rows.length; i++) {
      final assessment = assessments[i];
      final pid = rows[i]['patient_id'] as String;
      _woundToPatient[assessment.woundId] = pid;
      _cacheUpsert(assessment, emit: false);
    }
    if (woundId != null) {
      _emitWoundAssessments(woundId);
    }
    return assessments;
  }

  @override
  Future<AssessmentManual?> getLatestAssessment(String woundId) async {
    final ownerId = _resolveOwnerId();
    final patientId = await _ensurePatientForWound(woundId);
    final row = await _database.getLatestAssessmentRow(
      ownerId: ownerId,
      patientId: patientId,
      woundId: woundId,
    );
    if (row == null) return null;
    final assessment = _mapRowToAssessment(row);
    _woundToPatient[woundId] = patientId;
    _cacheUpsert(assessment, emit: false);
    return assessment;
  }

  @override
  Future<List<AssessmentManual>> getAssessmentsSortedByDate(
    String woundId, {
    int? limit,
  }) async {
    final ownerId = _resolveOwnerId();
    final patientId = await _ensurePatientForWound(woundId);
    final rows = await _database.getAssessmentsSortedByDate(
      ownerId: ownerId,
      patientId: patientId,
      woundId: woundId,
      limit: limit,
    );
    final assessments = rows.map(_mapRowToAssessment).toList();
    for (final assessment in assessments) {
      _cacheUpsert(assessment, emit: false);
    }
    if (assessments.isNotEmpty) {
      _woundToPatient[woundId] = patientId;
    }
    return assessments;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _ensureWoundCache(
    String ownerId,
    String patientId,
    String woundId,
  ) async {
    if (_loadedWounds.contains(woundId)) return;
    final rows = await _database.getAssessmentsByWound(
      ownerId: ownerId,
      patientId: patientId,
      woundId: woundId,
    );
    final assessments = rows.map(_mapRowToAssessment).toList();
    _assessmentsByWound[woundId] = assessments;
    for (final assessment in assessments) {
      _assessmentsById[assessment.id] = assessment;
    }
    _woundToPatient[woundId] = patientId;
    _sortWoundList(woundId);
    _loadedWounds.add(woundId);
  }

  void _cacheUpsert(AssessmentManual assessment, {bool emit = true}) {
    _assessmentsById[assessment.id] = assessment;
    final list = _assessmentsByWound.putIfAbsent(assessment.woundId, () => []);
    final index = list.indexWhere((a) => a.id == assessment.id);
    if (index >= 0) {
      list[index] = assessment;
    } else {
      list.add(assessment);
    }
    _sortWoundList(assessment.woundId);
    if (emit) {
      _emitWoundAssessments(assessment.woundId);
      _emitAssessment(assessment.id, assessment);
    }
  }

  void _removeFromCache(AssessmentManual assessment) {
    _assessmentsById.remove(assessment.id);
    final list = _assessmentsByWound[assessment.woundId];
    list?.removeWhere((a) => a.id == assessment.id);
    if (list != null) {
      _sortWoundList(assessment.woundId);
    }
    _emitWoundAssessments(assessment.woundId);
    _emitAssessment(assessment.id, null);
  }

  void _sortWoundList(String woundId) {
    final list = _assessmentsByWound[woundId];
    list?.sort((a, b) => b.date.compareTo(a.date));
  }

  void _emitWoundAssessments(String woundId) {
    final controllers = _woundControllers[woundId];
    if (controllers == null) return;
    final snapshot = List<AssessmentManual>.unmodifiable(
      _assessmentsByWound[woundId] ?? const [],
    );
    for (final controller in controllers.toList()) {
      if (!controller.isClosed) {
        controller.add(snapshot);
      }
    }
  }

  void _emitAssessment(String assessmentId, AssessmentManual? assessment) {
    final controllers = _assessmentControllers[assessmentId];
    if (controllers == null) return;
    for (final controller in controllers.toList()) {
      if (!controller.isClosed) {
        controller.add(assessment);
      }
    }
  }

  Future<SyncOperation?> _queueOperation({
    required String ownerId,
    required String patientId,
    required AssessmentManual assessment,
    required SyncOperationType type,
  }) async {
    try {
      return await _database.queueOperation(
        entity: _syncEntity,
        type: type,
        payload: {
          'ownerId': ownerId,
          'patientId': patientId,
          'woundId': assessment.woundId,
          'assessmentId': assessment.id,
          if (type != SyncOperationType.delete)
            'assessment': _assessmentToJson(assessment),
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        '[AssessmentRepositoryOffline] Erro ao enfileirar operação',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _attemptImmediateSync({
    required String ownerId,
    required String patientId,
    required AssessmentManual assessment,
    required SyncOperationType type,
    SyncOperation? op,
  }) async {
    if (!_hasRemoteAccess) return;
    if (!await _connectivity.hasConnection()) return;

    try {
      await _pushAssessmentToFirestore(
        ownerId: ownerId,
        patientId: patientId,
        assessment: assessment,
        type: type,
      );
      if (op != null && op.id != null) {
        await _database.removeOperation(op.id!);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        '[AssessmentRepositoryOffline] Falha ao sincronizar avaliação',
        error: e,
        stackTrace: stackTrace,
      );
      if (op != null && op.id != null) {
        await _database.incrementRetry(op.id!);
      }
    }
  }

  Future<void> _pushAssessmentToFirestore({
    required String ownerId,
    required String patientId,
    required AssessmentManual assessment,
    required SyncOperationType type,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(ownerId)
        .collection('patients')
        .doc(patientId)
        .collection('wounds')
        .doc(assessment.woundId)
        .collection('assessments')
        .doc(assessment.id);

    switch (type) {
      case SyncOperationType.create:
      case SyncOperationType.update:
        await docRef.set(
          _assessmentToFirestore(ownerId, patientId, assessment),
        );
        break;
      case SyncOperationType.delete:
        await docRef.delete();
        break;
    }
  }

  Map<String, Object?> _toRow(
    String ownerId,
    String patientId,
    AssessmentManual assessment,
  ) {
    return {
      'id': assessment.id,
      'owner_id': ownerId,
      'patient_id': patientId,
      'wound_id': assessment.woundId,
      'date': assessment.date.toIso8601String(),
      'pain_scale': assessment.painScale ?? -1,
      'length_cm': assessment.lengthCm ?? 0,
      'width_cm': assessment.widthCm ?? 0,
      'depth_cm': assessment.depthCm ?? 0,
      'notes': assessment.notes,
      'edge_appearance': assessment.edgeAppearance,
      'wound_bed': assessment.woundBed,
      'exudate_type': assessment.exudateType,
      'exudate_amount': assessment.exudateAmount,
      'created_at': assessment.createdAt.millisecondsSinceEpoch,
      'updated_at': assessment.updatedAt.millisecondsSinceEpoch,
      'attachments_count': 0,
    };
  }

  AssessmentManual _mapRowToAssessment(Map<String, Object?> row) {
    final painScale = row['pain_scale'] as int? ?? -1;
    final length = (row['length_cm'] as num?)?.toDouble() ?? 0;
    final width = (row['width_cm'] as num?)?.toDouble() ?? 0;
    final depth = (row['depth_cm'] as num?)?.toDouble() ?? 0;

    return AssessmentManual(
      id: row['id'] as String,
      woundId: row['wound_id'] as String,
      date: DateTime.parse(row['date'] as String),
      painScale: painScale >= 0 ? painScale : null,
      lengthCm: length > 0 ? length : null,
      widthCm: width > 0 ? width : null,
      depthCm: depth > 0 ? depth : null,
      notes: _normalizeTextField(row['notes']),
      edgeAppearance: _normalizeTextField(row['edge_appearance']),
      woundBed: _normalizeTextField(row['wound_bed']),
      exudateType: _normalizeTextField(row['exudate_type']),
      exudateAmount: _normalizeTextField(row['exudate_amount']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
    );
  }

  Map<String, dynamic> _assessmentToJson(AssessmentManual assessment) {
    return {
      'id': assessment.id,
      'woundId': assessment.woundId,
      'date': assessment.date.toIso8601String(),
      'painScale': assessment.painScale,
      'lengthCm': assessment.lengthCm,
      'widthCm': assessment.widthCm,
      'depthCm': assessment.depthCm,
      'notes': assessment.notes,
      'edgeAppearance': assessment.edgeAppearance,
      'woundBed': assessment.woundBed,
      'exudateType': assessment.exudateType,
      'exudateAmount': assessment.exudateAmount,
      'createdAt': assessment.createdAt.toIso8601String(),
      'updatedAt': assessment.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _assessmentToFirestore(
    String ownerId,
    String patientId,
    AssessmentManual assessment,
  ) {
    final data = <String, dynamic>{
      'ownerId': ownerId,
      'patientId': patientId,
      'woundId': assessment.woundId,
      'date': Timestamp.fromDate(assessment.date),
      'createdAt': Timestamp.fromDate(assessment.createdAt),
      'updatedAt': Timestamp.fromDate(assessment.updatedAt),
    };

    if (assessment.painScale != null) {
      data['painScale'] = assessment.painScale;
    }
    if (assessment.lengthCm != null) {
      data['lengthCm'] = assessment.lengthCm;
    }
    if (assessment.widthCm != null) {
      data['widthCm'] = assessment.widthCm;
    }
    if (assessment.depthCm != null) {
      data['depthCm'] = assessment.depthCm;
    }

    void addOptionalString(String key, String? value) {
      if (value == null) return;
      final trimmed = value.trim();
      if (trimmed.isEmpty) return;
      data[key] = trimmed;
    }

    addOptionalString('edgeAppearance', assessment.edgeAppearance);
    addOptionalString('woundBed', assessment.woundBed);
    addOptionalString('exudateType', assessment.exudateType);
    addOptionalString('exudateAmount', assessment.exudateAmount);
    addOptionalString('notes', assessment.notes);

    return data;
  }

  String? _normalizeTextField(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  Future<String> _ensurePatientForWound(String woundId) async {
    final cached = _woundToPatient[woundId];
    if (cached != null) return cached;
    final woundRow = await _database.getWoundById(woundId);
    if (woundRow == null) {
      throw Exception('Ferida não encontrada para avaliação');
    }
    final patientId = woundRow['patient_id'] as String;
    _woundToPatient[woundId] = patientId;
    return patientId;
  }

  String _resolveOwnerId() {
    final override = _ownerIdOverride;
    if (override != null && override.isNotEmpty) {
      return override;
    }
    return _auth.currentUser?.uid ?? _fallbackOwnerId;
  }

  bool get _hasRemoteAccess => _auth.currentUser != null;

  String _generateLocalId(String patientId, String woundId) {
    if (_hasRemoteAccess) {
      final ownerId = _auth.currentUser!.uid;
      return _firestore
          .collection('users')
          .doc(ownerId)
          .collection('patients')
          .doc(patientId)
          .collection('wounds')
          .doc(woundId)
          .collection('assessments')
          .doc()
          .id;
    }
    final millis = DateTime.now().millisecondsSinceEpoch;
    final random = (millis * 1499) % 1000000;
    return 'local_assessment_${millis}_$random';
  }
}
