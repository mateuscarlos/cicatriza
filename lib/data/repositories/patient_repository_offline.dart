import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/connectivity_service.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/patient_manual.dart';
import '../../domain/repositories/patient_repository_manual.dart';
import '../datasources/local/offline_database.dart';
import '../models/sync_operation.dart';

/// Offline-first implementation of [PatientRepository] that keeps
/// patients inside the local SQLite cache and synchronizes to Firestore
/// opportunistically whenever connectivity and authentication are available.
class PatientRepositoryOffline implements PatientRepository {
  PatientRepositoryOffline({
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

  static const _syncEntity = 'patients';
  static const _fallbackOwnerId = 'local_offline_user';

  final OfflineDatabase _database;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final ConnectivityService _connectivity;
  final String? _ownerIdOverride;

  final _patientsController = StreamController<List<PatientManual>>.broadcast();
  final List<PatientManual> _cachedPatients = [];

  bool _cacheInitialized = false;
  String? _cacheOwnerId;

  @override
  Future<List<PatientManual>> getPatients() async {
    final ownerId = _resolveOwnerId();
    await _ensureCache(ownerId);

    // Attempt to refresh from Firestore in the background when possible.
    unawaited(_refreshFromRemote(ownerId));

    return List<PatientManual>.from(_cachedPatients);
  }

  @override
  Future<List<PatientManual>> searchPatients(String query) async {
    final ownerId = _resolveOwnerId();
    await _ensureCache(ownerId);

    if (query.trim().isEmpty) {
      return List<PatientManual>.from(_cachedPatients);
    }

    final rows = await _database.searchPatients(ownerId: ownerId, query: query);

    return rows.map(_mapRowToPatient).toList();
  }

  @override
  Future<PatientManual?> getPatientById(String id) async {
    final ownerId = _resolveOwnerId();
    await _ensureCache(ownerId);

    for (final patient in _cachedPatients) {
      if (patient.id == id) {
        return patient;
      }
    }

    final row = await _database.getPatientById(id);
    if (row != null) {
      final patient = _mapRowToPatient(row);
      _cacheUpsert(patient);
      return patient;
    }

    if (_hasRemoteAccess && await _connectivity.hasConnection()) {
      try {
        final doc = await _patientsCollection(ownerId).doc(id).get();
        if (doc.exists) {
          final patient = _fromFirestore(doc);
          await _savePatientLocal(ownerId, patient);
          return patient;
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          '[PatientRepositoryOffline] Falha ao buscar paciente remoto',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    return null;
  }

  @override
  Future<PatientManual> createPatient(PatientManual patient) async {
    final ownerId = _resolveOwnerId();
    await _ensureCache(ownerId);

    final now = DateTime.now();
    final generatedId = _generateLocalId();

    final persistedPatient = patient.copyWith(
      id: patient.id.isEmpty ? generatedId : patient.id,
      createdAt: patient.createdAt.isBefore(now) ? patient.createdAt : now,
      updatedAt: now,
      name: patient.name.trim(),
      nameLowercase: patient.name.trim().toLowerCase(),
      notes: patient.notes?.trim(),
      phone: patient.phone?.trim(),
      email: patient.email?.trim(),
    );

    await _savePatientLocal(ownerId, persistedPatient);

    final op = await _queueOperation(
      ownerId: ownerId,
      patient: persistedPatient,
      type: SyncOperationType.create,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      type: SyncOperationType.create,
      patient: persistedPatient,
      op: op,
    );

    return persistedPatient;
  }

  @override
  Future<PatientManual> updatePatient(PatientManual patient) async {
    final ownerId = _resolveOwnerId();
    await _ensureCache(ownerId);

    final updated = patient.copyWith(
      updatedAt: DateTime.now(),
      name: patient.name.trim(),
      nameLowercase: patient.name.trim().toLowerCase(),
      notes: patient.notes?.trim(),
      phone: patient.phone?.trim(),
      email: patient.email?.trim(),
    );

    await _savePatientLocal(ownerId, updated);

    final op = await _queueOperation(
      ownerId: ownerId,
      patient: updated,
      type: SyncOperationType.update,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      type: SyncOperationType.update,
      patient: updated,
      op: op,
    );

    return updated;
  }

  @override
  Future<PatientManual> togglePatientArchived(String patientId) async {
    final ownerId = _resolveOwnerId();
    await _ensureCache(ownerId);

    final existing = await getPatientById(patientId);
    if (existing == null) {
      throw Exception('Paciente não encontrado');
    }

    final updated = existing.copyWith(
      archived: !existing.archived,
      updatedAt: DateTime.now(),
    );

    await _savePatientLocal(ownerId, updated);

    final op = await _queueOperation(
      ownerId: ownerId,
      patient: updated,
      type: SyncOperationType.update,
    );

    await _attemptImmediateSync(
      ownerId: ownerId,
      type: SyncOperationType.update,
      patient: updated,
      op: op,
    );

    return updated;
  }

  @override
  Future<void> deletePatient(String patientId) async {
    await togglePatientArchived(patientId);
  }

  @override
  Stream<List<PatientManual>> watchPatients() {
    return _patientsController.stream;
  }

  @override
  Stream<PatientManual?> watchPatient(String patientId) {
    return _patientsController.stream.map((patients) {
      for (final patient in patients) {
        if (patient.id == patientId) {
          return patient;
        }
      }
      return null;
    });
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _ensureCache(String ownerId) async {
    if (_cacheInitialized && _cacheOwnerId == ownerId) {
      return;
    }
    await _loadLocalPatients(ownerId);
  }

  Future<void> _loadLocalPatients(String ownerId) async {
    final rows = await _database.getPatients(ownerId: ownerId);
    _cachedPatients
      ..clear()
      ..addAll(rows.map(_mapRowToPatient));
    _sortCache();
    _emitCache();
    _cacheInitialized = true;
    _cacheOwnerId = ownerId;
  }

  Future<void> _savePatientLocal(String ownerId, PatientManual patient) async {
    await _database.upsertPatient(_toRow(ownerId, patient));
    _cacheUpsert(patient);
  }

  void _cacheUpsert(PatientManual patient) {
    final index = _cachedPatients.indexWhere((p) => p.id == patient.id);
    if (index >= 0) {
      _cachedPatients[index] = patient;
    } else {
      _cachedPatients.add(patient);
    }
    _sortCache();
    _emitCache();
  }

  void _sortCache() {
    _cachedPatients.sort((a, b) => a.nameLowercase.compareTo(b.nameLowercase));
    // Remove archived patients from the in-memory list used by the UI.
    _cachedPatients.removeWhere((patient) => patient.archived);
  }

  void _emitCache() {
    if (_patientsController.isClosed) return;
    if (!_patientsController.hasListener) return;
    _patientsController.add(List.unmodifiable(_cachedPatients));
  }

  Future<void> _refreshFromRemote(String ownerId) async {
    if (!_hasRemoteAccess) return;
    if (!await _connectivity.hasConnection()) return;

    try {
      final snapshot = await _patientsCollection(
        ownerId,
      ).orderBy('nameLowercase').get();

      final patients = snapshot.docs.map(_fromFirestore).toList();
      await _database.upsertEntities(
        'patients',
        patients.map((patient) => _toRow(ownerId, patient)).toList(),
      );

      _cachedPatients
        ..clear()
        ..addAll(patients.where((patient) => !patient.archived));
      _sortCache();
      _emitCache();
    } catch (e, stackTrace) {
      AppLogger.error(
        '[PatientRepositoryOffline] Falha ao atualizar cache remoto',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<SyncOperation?> _queueOperation({
    required String ownerId,
    required PatientManual patient,
    required SyncOperationType type,
  }) async {
    try {
      return await _database.queueOperation(
        entity: _syncEntity,
        type: type,
        payload: {'ownerId': ownerId, 'patient': _patientToJson(patient)},
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        '[PatientRepositoryOffline] Falha ao enfileirar operação',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _attemptImmediateSync({
    required String ownerId,
    required SyncOperationType type,
    required PatientManual patient,
    SyncOperation? op,
  }) async {
    if (!_hasRemoteAccess) return;
    if (!await _connectivity.hasConnection()) return;

    try {
      await _pushPatientToFirestore(ownerId, patient, type);
      if (op != null && op.id != null) {
        await _database.removeOperation(op.id!);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        '[PatientRepositoryOffline] Falha ao sincronizar imediatamente',
        error: e,
        stackTrace: stackTrace,
      );
      if (op != null && op.id != null) {
        await _database.incrementRetry(op.id!);
      }
    }
  }

  Future<void> _pushPatientToFirestore(
    String ownerId,
    PatientManual patient,
    SyncOperationType type,
  ) async {
    final docRef = _patientsCollection(ownerId).doc(patient.id);
    final data = _patientToFirestore(patient);

    switch (type) {
      case SyncOperationType.create:
        await docRef.set(data);
        break;
      case SyncOperationType.update:
        await docRef.set(data, SetOptions(merge: true));
        break;
      case SyncOperationType.delete:
        await docRef.delete();
        break;
    }
  }

  Map<String, Object?> _toRow(String ownerId, PatientManual patient) {
    return {
      'id': patient.id,
      'owner_id': ownerId,
      'name': patient.name,
      'name_lowercase': patient.nameLowercase,
      'birth_date': patient.birthDate.toIso8601String(),
      'archived': patient.archived ? 1 : 0,
      'notes': patient.notes,
      'phone': patient.phone,
      'email': patient.email,
      'created_at': patient.createdAt.millisecondsSinceEpoch,
      'updated_at': patient.updatedAt.millisecondsSinceEpoch,
    };
  }

  PatientManual _mapRowToPatient(Map<String, Object?> row) {
    return PatientManual(
      id: row['id'] as String,
      name: row['name'] as String,
      birthDate: DateTime.parse(row['birth_date'] as String),
      archived: (row['archived'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      nameLowercase: row['name_lowercase'] as String,
      notes: row['notes'] as String?,
      phone: row['phone'] as String?,
      email: row['email'] as String?,
    );
  }

  Map<String, dynamic> _patientToFirestore(PatientManual patient) {
    return {
      'name': patient.name,
      'nameLowercase': patient.nameLowercase,
      'birthDate': Timestamp.fromDate(patient.birthDate),
      'archived': patient.archived,
      'notes': patient.notes,
      'phone': patient.phone,
      'email': patient.email,
      'createdAt': Timestamp.fromDate(patient.createdAt),
      'updatedAt': Timestamp.fromDate(patient.updatedAt),
    };
  }

  Map<String, dynamic> _patientToJson(PatientManual patient) {
    final json = patient.toJson();
    return {
      ...json,
      'birthDate': patient.birthDate.toIso8601String(),
      'createdAt': patient.createdAt.toIso8601String(),
      'updatedAt': patient.updatedAt.toIso8601String(),
    };
  }

  PatientManual _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return PatientManual(
      id: doc.id,
      name: data['name'] as String? ?? '',
      birthDate:
          (data['birthDate'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      archived: data['archived'] as bool? ?? false,
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      nameLowercase:
          data['nameLowercase'] as String? ??
          (data['name'] as String? ?? '').toLowerCase(),
      notes: data['notes'] as String?,
      phone: data['phone'] as String?,
      email: data['email'] as String?,
    );
  }

  CollectionReference<Map<String, dynamic>> _patientsCollection(
    String ownerId,
  ) {
    return _firestore.collection('users').doc(ownerId).collection('patients');
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
    // Ensure uniqueness even when offline by combining timestamp and a random
    // component sourced from Firestore's auto-ID generator when possible.
    if (_hasRemoteAccess) {
      return _patientsCollection(_auth.currentUser!.uid).doc().id;
    }
    final millis = DateTime.now().millisecondsSinceEpoch;
    final random = (millis * 9973) % 1000000;
    return 'local_$millis$random';
  }
}
