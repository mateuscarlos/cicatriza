import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../models/sync_operation.dart';

/// Provides the local offline database used for M1 offline-first support.
class OfflineDatabase {
  OfflineDatabase._();

  static final OfflineDatabase instance = OfflineDatabase._();

  static const _dbName = 'cicatriza_offline.db';
  static const _dbVersion = 3;

  Database? _database;

  /// Lazily opens (or returns) the singleton database instance.
  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final filePath = p.join(dbPath, _dbName);

    _database = await openDatabase(
      filePath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );

    return _database!;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE patients ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0;',
      );
      await db.execute(
        'ALTER TABLE wounds ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0;',
      );
      await db.execute(
        'ALTER TABLE assessments ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0;',
      );

      await db.execute(
        'UPDATE patients SET created_at = updated_at WHERE created_at = 0;',
      );
      await db.execute(
        'UPDATE wounds SET created_at = updated_at WHERE created_at = 0;',
      );
      await db.execute(
        'UPDATE assessments SET created_at = updated_at WHERE created_at = 0;',
      );
    }

    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE assessments ADD COLUMN edge_appearance TEXT;',
      );
      await db.execute('ALTER TABLE assessments ADD COLUMN wound_bed TEXT;');
      await db.execute('ALTER TABLE assessments ADD COLUMN exudate_type TEXT;');
      await db.execute(
        'ALTER TABLE assessments ADD COLUMN exudate_amount TEXT;',
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Patients are the root entity scoped by Firebase owner id (uid).
    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        owner_id TEXT NOT NULL,
        name TEXT NOT NULL,
        name_lowercase TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        archived INTEGER NOT NULL DEFAULT 0,
        notes TEXT,
        phone TEXT,
        email TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE wounds (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        owner_id TEXT NOT NULL,
        type TEXT NOT NULL,
        location TEXT NOT NULL,
        location_description TEXT,
        status TEXT NOT NULL,
        cause_description TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY(patient_id) REFERENCES patients(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE assessments (
        id TEXT PRIMARY KEY,
        wound_id TEXT NOT NULL,
        patient_id TEXT NOT NULL,
        owner_id TEXT NOT NULL,
        date TEXT NOT NULL,
        pain_scale INTEGER NOT NULL,
        length_cm REAL NOT NULL,
        width_cm REAL NOT NULL,
        depth_cm REAL NOT NULL,
        notes TEXT,
        edge_appearance TEXT,
        wound_bed TEXT,
        exudate_type TEXT,
        exudate_amount TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        attachments_count INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(wound_id) REFERENCES wounds(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE media (
        id TEXT PRIMARY KEY,
        assessment_id TEXT NOT NULL,
        wound_id TEXT NOT NULL,
        patient_id TEXT NOT NULL,
        owner_id TEXT NOT NULL,
        storage_path TEXT NOT NULL,
        download_url TEXT,
        thumb_url TEXT,
        width INTEGER,
        height INTEGER,
        created_at INTEGER NOT NULL,
        FOREIGN KEY(assessment_id) REFERENCES assessments(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE sync_ops (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity TEXT NOT NULL,
        operation TEXT NOT NULL,
        payload TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        retry_count INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await db.execute(
      'CREATE INDEX idx_patients_owner ON patients(owner_id, updated_at DESC);',
    );
    await db.execute(
      'CREATE INDEX idx_wounds_patient ON wounds(patient_id, updated_at DESC);',
    );
    await db.execute(
      'CREATE INDEX idx_assessments_wound ON assessments(wound_id, date DESC);',
    );
    await db.execute(
      'CREATE INDEX idx_media_assessment ON media(assessment_id, created_at DESC);',
    );
    await db.execute(
      'CREATE INDEX idx_sync_ops_created ON sync_ops(created_at ASC);',
    );
  }

  Future<List<Map<String, Object?>>> getPatients({
    required String ownerId,
    bool includeArchived = false,
  }) async {
    final db = await database;
    final whereBuffer = StringBuffer('owner_id = ?');
    final whereArgs = <Object>[ownerId];
    if (!includeArchived) {
      whereBuffer.write(' AND archived = 0');
    }

    return db.query(
      'patients',
      where: whereBuffer.toString(),
      whereArgs: whereArgs,
      orderBy: 'name_lowercase ASC',
    );
  }

  Future<Map<String, Object?>?> getPatientById(String id) async {
    final db = await database;
    final rows = await db.query(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<List<Map<String, Object?>>> searchPatients({
    required String ownerId,
    required String query,
    bool includeArchived = false,
  }) async {
    final db = await database;
    final lowerQuery = query.toLowerCase();
    final buffer = StringBuffer('owner_id = ? AND name_lowercase LIKE ?');
    final whereArgs = <Object>[ownerId, '%$lowerQuery%'];
    if (!includeArchived) {
      buffer.write(' AND archived = 0');
    }

    return db.query(
      'patients',
      where: buffer.toString(),
      whereArgs: whereArgs,
      orderBy: 'name_lowercase ASC',
    );
  }

  Future<List<Map<String, Object?>>> getWoundsByPatient({
    required String ownerId,
    required String patientId,
  }) async {
    final db = await database;
    return db.query(
      'wounds',
      where: 'owner_id = ? AND patient_id = ?',
      whereArgs: [ownerId, patientId],
      orderBy: 'updated_at DESC',
    );
  }

  Future<Map<String, Object?>?> getWoundById(String id) async {
    final db = await database;
    final rows = await db.query(
      'wounds',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<List<Map<String, Object?>>> getWoundsWithFilters({
    required String ownerId,
    String? patientId,
    String? status,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final db = await database;
    final whereParts = <String>[];
    final whereArgs = <Object>[];

    whereParts.add('owner_id = ?');
    whereArgs.add(ownerId);

    if (patientId != null) {
      whereParts.add('patient_id = ?');
      whereArgs.add(patientId);
    }

    if (status != null) {
      whereParts.add('status = ?');
      whereArgs.add(status);
    }

    if (type != null) {
      whereParts.add('type = ?');
      whereArgs.add(type);
    }

    if (fromDate != null) {
      whereParts.add('created_at >= ?');
      whereArgs.add(fromDate.millisecondsSinceEpoch);
    }

    if (toDate != null) {
      whereParts.add('created_at <= ?');
      whereArgs.add(toDate.millisecondsSinceEpoch);
    }

    final whereClause = whereParts.join(' AND ');

    return db.query(
      'wounds',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'updated_at DESC',
    );
  }

  Future<List<Map<String, Object?>>> getAssessmentsByWound({
    required String ownerId,
    required String patientId,
    required String woundId,
  }) async {
    final db = await database;
    return db.query(
      'assessments',
      where: 'owner_id = ? AND patient_id = ? AND wound_id = ?',
      whereArgs: [ownerId, patientId, woundId],
      orderBy: 'date DESC',
    );
  }

  Future<Map<String, Object?>?> getAssessmentById(String id) async {
    final db = await database;
    final rows = await db.query(
      'assessments',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<List<Map<String, Object?>>> getAssessmentsWithFilters({
    required String ownerId,
    String? patientId,
    String? woundId,
    DateTime? fromDate,
    DateTime? toDate,
    int? minPainScale,
    int? maxPainScale,
  }) async {
    final db = await database;
    final whereParts = <String>[];
    final whereArgs = <Object>[];

    whereParts.add('owner_id = ?');
    whereArgs.add(ownerId);

    if (patientId != null) {
      whereParts.add('patient_id = ?');
      whereArgs.add(patientId);
    }

    if (woundId != null) {
      whereParts.add('wound_id = ?');
      whereArgs.add(woundId);
    }

    if (fromDate != null) {
      whereParts.add('date >= ?');
      whereArgs.add(fromDate.toIso8601String());
    }

    if (toDate != null) {
      whereParts.add('date <= ?');
      whereArgs.add(toDate.toIso8601String());
    }

    if (minPainScale != null) {
      whereParts.add('pain_scale >= ?');
      whereArgs.add(minPainScale);
    }

    if (maxPainScale != null) {
      whereParts.add('pain_scale <= ?');
      whereArgs.add(maxPainScale);
    }

    final whereClause = whereParts.join(' AND ');

    return db.query(
      'assessments',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );
  }

  Future<Map<String, Object?>?> getLatestAssessmentRow({
    required String ownerId,
    required String patientId,
    required String woundId,
  }) async {
    final db = await database;
    final rows = await db.query(
      'assessments',
      where: 'owner_id = ? AND patient_id = ? AND wound_id = ?',
      whereArgs: [ownerId, patientId, woundId],
      orderBy: 'date DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<List<Map<String, Object?>>> getAssessmentsSortedByDate({
    required String ownerId,
    required String patientId,
    required String woundId,
    int? limit,
  }) async {
    final db = await database;
    return db.query(
      'assessments',
      where: 'owner_id = ? AND patient_id = ? AND wound_id = ?',
      whereArgs: [ownerId, patientId, woundId],
      orderBy: 'date DESC',
      limit: limit,
    );
  }

  Future<void> clear() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('media');
      await txn.delete('assessments');
      await txn.delete('wounds');
      await txn.delete('patients');
      await txn.delete('sync_ops');
    });
  }

  Future<void> upsertPatient(Map<String, Object?> patient) async {
    final db = await database;
    await db.insert(
      'patients',
      patient,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertWound(Map<String, Object?> wound) async {
    final db = await database;
    await db.insert(
      'wounds',
      wound,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertAssessment(Map<String, Object?> assessment) async {
    final db = await database;
    await db.insert(
      'assessments',
      assessment,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertMedia(Map<String, Object?> media) async {
    final db = await database;
    await db.insert(
      'media',
      media,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteById(String tableName, String id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> enqueueOperation(SyncOperation operation) async {
    final db = await database;
    return db.insert('sync_ops', operation.toMap());
  }

  Future<List<SyncOperation>> nextPendingOperations({int limit = 20}) async {
    final db = await database;
    final rows = await db.query(
      'sync_ops',
      orderBy: 'created_at ASC',
      limit: limit,
    );
    return rows.map(SyncOperation.fromMap).toList();
  }

  Future<void> removeOperation(int id) async {
    final db = await database;
    await db.delete('sync_ops', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> incrementRetry(int id) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE sync_ops SET retry_count = retry_count + 1 WHERE id = ?',
      [id],
    );
  }

  Future<void> upsertEntity(String table, Map<String, Object?> row) async {
    final db = await database;
    await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> upsertEntities(
    String table,
    List<Map<String, Object?>> rows,
  ) async {
    if (rows.isEmpty) return;
    final db = await database;
    await db.transaction((txn) async {
      for (final row in rows) {
        await txn.insert(
          table,
          row,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> applySyncResult(List<SyncOperation> processed) async {
    if (processed.isEmpty) return;
    final db = await database;
    await db.transaction((txn) async {
      for (final op in processed) {
        await txn.delete('sync_ops', where: 'id = ?', whereArgs: [op.id]);
      }
    });
  }

  Future<Map<String, Object?>> exportState() async {
    final db = await database;
    final patients = await db.query('patients');
    final wounds = await db.query('wounds');
    final assessments = await db.query('assessments');
    final media = await db.query('media');

    return {
      'patients': patients,
      'wounds': wounds,
      'assessments': assessments,
      'media': media,
    };
  }

  Future<void> importState(Map<String, dynamic> snapshot) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('media');
      await txn.delete('assessments');
      await txn.delete('wounds');
      await txn.delete('patients');

      for (final table in ['patients', 'wounds', 'assessments', 'media']) {
        final rows = (snapshot[table] as List<dynamic>? ?? [])
            .cast<Map<String, Object?>>();
        for (final row in rows) {
          await txn.insert(
            table,
            row,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }

  Future<void> dispose() async {
    if (_database == null) return;
    await _database!.close();
    _database = null;
  }

  /// Convenience helper to enqueue a mutation and return the persisted op.
  Future<SyncOperation> queueOperation({
    required String entity,
    required SyncOperationType type,
    required Map<String, dynamic> payload,
  }) async {
    final op = SyncOperation(
      id: null,
      entity: entity,
      type: type,
      payload: payload,
      createdAt: DateTime.now(),
      retryCount: 0,
    );
    final opId = await enqueueOperation(op);
    return op.copyWith(id: opId);
  }
}
