import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/connectivity_service.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/wound_manual.dart';
import '../../domain/repositories/wound_repository_manual.dart';
import '../datasources/local/offline_database.dart';
import '../models/sync_operation.dart';

/// Offline-first repository for wounds that keeps data in the local SQLite cache
/// and synchronizes to Firestore whenever connectivity is available.
class WoundRepositoryOffline implements WoundRepository {
  WoundRepositoryOffline({
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

  static const _syncEntity = 'wounds';
  static const _fallbackOwnerId = 'local_offline_user';

  final OfflineDatabase _database;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final ConnectivityService _connectivity;
  final String? _ownerIdOverride;

  final Map<String, List<WoundManual>> _woundsByPatient = {};
  final Map<String, WoundManual> _woundsById = {};
  final Set<String> _loadedPatients = {};
  final Map<String, List<StreamController<List<WoundManual>>>>
  _patientControllers = {};
  final Map<String, List<StreamController<WoundManual?>>> _woundControllers =
      {};

  @override
  Future<List<WoundManual>> getWoundsByPatientId(String patientId) async {
    final ownerId = _resolveOwnerId();
    await _ensurePatientCache(ownerId, patientId);
    final wounds = _woundsByPatient[patientId] ?? const [];
    return List<WoundManual>.unmodifiable(wounds);
  }

  @override
  Future<WoundManual?> getWoundById(String id) async {
    final cached = _woundsById[id];
    if (cached != null) {
      return cached;
    }

    final row = await _database.getWoundById(id);
    if (row == null) return null;
    final wound = _mapRowToWound(row);
    _cacheUpsert(wound);
    return wound;
  }

  @override
  Future<WoundManual> createWound(WoundManual wound) async {
    final ownerId = _resolveOwnerId();
    final patientId = wound.patientId;
    await _ensurePatientCache(ownerId, patientId);

    final now = DateTime.now();
    final generatedId = _generateLocalId(patientId);
    final persisted = wound.copyWith(
      id: wound.id.isEmpty ? generatedId : wound.id,
      createdAt: wound.createdAt.isBefore(now) ? wound.createdAt : now,
      updatedAt: now,
      locationDescription: wound.locationDescription?.trim(),
      causeDescription: wound.causeDescription?.trim(),
    );

    await _database.upsertWound(_toRow(ownerId, persisted));
    _cacheUpsert(persisted);

    final op = await _queueOperation(
      ownerId: ownerId,
      patientId: patientId,
      wound: persisted,
      type: SyncOperationType.create,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      patientId: patientId,
      wound: persisted,
      type: SyncOperationType.create,
      op: op,
    );

    return persisted;
  }

  @override
  Future<WoundManual> updateWound(WoundManual wound) async {
    final ownerId = _resolveOwnerId();
    final patientId = wound.patientId;
    await _ensurePatientCache(ownerId, patientId);

    final updated = wound.copyWith(
      updatedAt: DateTime.now(),
      locationDescription: wound.locationDescription?.trim(),
      causeDescription: wound.causeDescription?.trim(),
    );

    await _database.upsertWound(_toRow(ownerId, updated));
    _cacheUpsert(updated);

    final op = await _queueOperation(
      ownerId: ownerId,
      patientId: patientId,
      wound: updated,
      type: SyncOperationType.update,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      patientId: patientId,
      wound: updated,
      type: SyncOperationType.update,
      op: op,
    );

    return updated;
  }

  @override
  Future<void> deleteWound(String woundId) async {
    final existing = _woundsById[woundId] ?? await getWoundById(woundId);
    if (existing == null) {
      throw Exception('Ferida não encontrada');
    }

    final ownerId = _resolveOwnerId();
    final patientId = existing.patientId;

    await _database.deleteById('wounds', woundId);
    _removeFromCache(existing);

    final op = await _queueOperation(
      ownerId: ownerId,
      patientId: patientId,
      wound: existing,
      type: SyncOperationType.delete,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      patientId: patientId,
      wound: existing,
      type: SyncOperationType.delete,
      op: op,
    );
  }

  @override
  Future<WoundManual> updateWoundStatus(
    String woundId,
    String newStatus,
  ) async {
    final wound = await getWoundById(woundId);
    if (wound == null) {
      throw Exception('Ferida não encontrada');
    }
    return updateWound(wound.copyWith(status: newStatus));
  }

  @override
  Stream<List<WoundManual>> watchWounds(String patientId) {
    late final StreamController<List<WoundManual>> controller;
    controller = StreamController<List<WoundManual>>.broadcast(
      onListen: () {
        unawaited(() async {
          final ownerId = _resolveOwnerId();
          await _ensurePatientCache(ownerId, patientId);
          controller.add(
            List<WoundManual>.unmodifiable(
              _woundsByPatient[patientId] ?? const [],
            ),
          );
        }());
      },
      onCancel: () {
        final controllers = _patientControllers[patientId];
        controllers?.remove(controller);
        if (controllers != null && controllers.isEmpty) {
          _patientControllers.remove(patientId);
        }
        controller.close();
      },
    );

    _patientControllers.putIfAbsent(patientId, () => []).add(controller);
    return controller.stream;
  }

  @override
  Stream<WoundManual?> watchWound(String woundId) {
    late final StreamController<WoundManual?> controller;
    controller = StreamController<WoundManual?>.broadcast(
      onListen: () {
        unawaited(() async {
          final wound = await getWoundById(woundId);
          controller.add(wound);
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
  Future<List<WoundManual>> getWoundsWithFilters({
    String? patientId,
    String? status,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final ownerId = _resolveOwnerId();
    final rows = await _database.getWoundsWithFilters(
      ownerId: ownerId,
      patientId: patientId,
      status: status,
      type: type,
      fromDate: fromDate,
      toDate: toDate,
    );
    final wounds = rows.map(_mapRowToWound).toList();
    for (final wound in wounds) {
      _cacheUpsert(wound, emit: false);
    }
    if (patientId != null) {
      _emitPatient(patientId);
    }
    return wounds;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _ensurePatientCache(String ownerId, String patientId) async {
    if (_loadedPatients.contains(patientId)) return;
    final rows = await _database.getWoundsByPatient(
      ownerId: ownerId,
      patientId: patientId,
    );
    final wounds = rows.map(_mapRowToWound).toList();
    _woundsByPatient[patientId] = wounds;
    for (final wound in wounds) {
      _woundsById[wound.id] = wound;
    }
    _sortPatientList(patientId);
    _loadedPatients.add(patientId);
  }

  void _cacheUpsert(WoundManual wound, {bool emit = true}) {
    _woundsById[wound.id] = wound;
    final list = _woundsByPatient.putIfAbsent(wound.patientId, () => []);
    final index = list.indexWhere((w) => w.id == wound.id);
    if (index >= 0) {
      list[index] = wound;
    } else {
      list.add(wound);
    }
    _sortPatientList(wound.patientId);
    if (emit) {
      _emitPatient(wound.patientId);
      _emitWound(wound.id, wound);
    }
  }

  void _removeFromCache(WoundManual wound) {
    _woundsById.remove(wound.id);
    final list = _woundsByPatient[wound.patientId];
    list?.removeWhere((w) => w.id == wound.id);
    if (list != null) {
      _sortPatientList(wound.patientId);
    }
    _emitPatient(wound.patientId);
    _emitWound(wound.id, null);
  }

  void _sortPatientList(String patientId) {
    final list = _woundsByPatient[patientId];
    list?.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  void _emitPatient(String patientId) {
    final controllers = _patientControllers[patientId];
    if (controllers == null) return;
    final snapshot = List<WoundManual>.unmodifiable(
      _woundsByPatient[patientId] ?? const [],
    );
    for (final controller in controllers.toList()) {
      if (!controller.isClosed) {
        controller.add(snapshot);
      }
    }
  }

  void _emitWound(String woundId, WoundManual? wound) {
    final controllers = _woundControllers[woundId];
    if (controllers == null) return;
    for (final controller in controllers.toList()) {
      if (!controller.isClosed) {
        controller.add(wound);
      }
    }
  }

  Future<SyncOperation?> _queueOperation({
    required String ownerId,
    required String patientId,
    required WoundManual wound,
    required SyncOperationType type,
  }) async {
    try {
      return await _database.queueOperation(
        entity: _syncEntity,
        type: type,
        payload: {
          'ownerId': ownerId,
          'patientId': patientId,
          'woundId': wound.id,
          if (type != SyncOperationType.delete) 'wound': _woundToJson(wound),
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        '[WoundRepositoryOffline] Erro ao enfileirar operação',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _attemptImmediateSync({
    required String ownerId,
    required String patientId,
    required WoundManual wound,
    required SyncOperationType type,
    SyncOperation? op,
  }) async {
    if (!_hasRemoteAccess) return;
    if (!await _connectivity.hasConnection()) return;

    try {
      await _pushWoundToFirestore(
        ownerId: ownerId,
        patientId: patientId,
        wound: wound,
        type: type,
      );
      if (op != null && op.id != null) {
        await _database.removeOperation(op.id!);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        '[WoundRepositoryOffline] Falha ao sincronizar wound',
        error: e,
        stackTrace: stackTrace,
      );
      if (op != null && op.id != null) {
        await _database.incrementRetry(op.id!);
      }
    }
  }

  Future<void> _pushWoundToFirestore({
    required String ownerId,
    required String patientId,
    required WoundManual wound,
    required SyncOperationType type,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(ownerId)
        .collection('patients')
        .doc(patientId)
        .collection('wounds')
        .doc(wound.id);

    switch (type) {
      case SyncOperationType.create:
      case SyncOperationType.update:
        await docRef.set(_woundToFirestore(ownerId, patientId, wound));
        break;
      case SyncOperationType.delete:
        await docRef.delete();
        break;
    }
  }

  Map<String, Object?> _toRow(String ownerId, WoundManual wound) {
    return {
      'id': wound.id,
      'owner_id': ownerId,
      'patient_id': wound.patientId,
      'type': wound.type,
      'location': wound.location,
      'location_description': wound.locationDescription,
      'status': wound.status,
      'cause_description': wound.causeDescription,
      'created_at': wound.createdAt.millisecondsSinceEpoch,
      'updated_at': wound.updatedAt.millisecondsSinceEpoch,
    };
  }

  WoundManual _mapRowToWound(Map<String, Object?> row) {
    return WoundManual(
      id: row['id'] as String,
      patientId: row['patient_id'] as String,
      type: row['type'] as String,
      location: row['location'] as String,
      locationDescription: row['location_description'] as String?,
      status: row['status'] as String,
      causeDescription: row['cause_description'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
    );
  }

  Map<String, dynamic> _woundToJson(WoundManual wound) {
    return {
      'id': wound.id,
      'patientId': wound.patientId,
      'type': wound.type,
      'location': wound.location,
      'locationDescription': wound.locationDescription,
      'status': wound.status,
      'causeDescription': wound.causeDescription,
      'createdAt': wound.createdAt.toIso8601String(),
      'updatedAt': wound.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _woundToFirestore(
    String ownerId,
    String patientId,
    WoundManual wound,
  ) {
    final data = <String, dynamic>{
      'ownerId': ownerId,
      'patientId': patientId,
      'type': wound.type,
      'location': wound.location,
      'status': wound.status,
      'createdAt': Timestamp.fromDate(wound.createdAt),
      'updatedAt': Timestamp.fromDate(wound.updatedAt),
    };

    void addOptionalString(String key, String? value) {
      if (value == null) return;
      final trimmed = value.trim();
      if (trimmed.isEmpty) return;
      data[key] = trimmed;
    }

    addOptionalString('locationDescription', wound.locationDescription);
    addOptionalString('causeDescription', wound.causeDescription);

    return data;
  }

  String _resolveOwnerId() {
    final override = _ownerIdOverride;
    if (override != null && override.isNotEmpty) {
      return override;
    }
    return _auth.currentUser?.uid ?? _fallbackOwnerId;
  }

  bool get _hasRemoteAccess => _auth.currentUser != null;

  String _generateLocalId(String? patientId) {
    if (_hasRemoteAccess && patientId != null && patientId.isNotEmpty) {
      final ownerId = _auth.currentUser!.uid;
      return _firestore
          .collection('users')
          .doc(ownerId)
          .collection('patients')
          .doc(patientId)
          .collection('wounds')
          .doc()
          .id;
    }
    final millis = DateTime.now().millisecondsSinceEpoch;
    final random = (millis * 977) % 1000000;
    return 'local_wound_${millis}_$random';
  }
}
