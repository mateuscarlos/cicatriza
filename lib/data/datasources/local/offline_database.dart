import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../models/sync_operation.dart';

/// Provides the local offline database used for M1 offline-first support.
class OfflineDatabase {
  OfflineDatabase._();

  static final OfflineDatabase instance = OfflineDatabase._();

  static const _dbName = 'cicatriza_offline.db';
  static const _dbVersion = 5;

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

    if (oldVersion < 4) {
      // Adicionar campos para controle de upload offline na tabela media
      await db.execute('ALTER TABLE media ADD COLUMN local_path TEXT;');
      await db.execute(
        'ALTER TABLE media ADD COLUMN upload_status TEXT NOT NULL DEFAULT "pending";',
      );
      await db.execute(
        'ALTER TABLE media ADD COLUMN upload_progress REAL NOT NULL DEFAULT 0.0;',
      );
      await db.execute(
        'ALTER TABLE media ADD COLUMN retry_count INTEGER NOT NULL DEFAULT 0;',
      );
      await db.execute('ALTER TABLE media ADD COLUMN file_size INTEGER;');
      await db.execute('ALTER TABLE media ADD COLUMN mime_type TEXT;');
      await db.execute('ALTER TABLE media ADD COLUMN error_message TEXT;');
      await db.execute(
        'ALTER TABLE media ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0;',
      );

      // Atualizar registros existentes
      await db.execute(
        'UPDATE media SET updated_at = created_at WHERE updated_at = 0;',
      );
    }

    if (oldVersion < 5) {
      // Migração para nova estrutura de dados clínicos completa
      await _migrateToV5(db);
    }
  }

  /// Migração para V5: Nova estrutura de dados clínicos completa
  Future<void> _migrateToV5(Database db) async {
    // Backup dos dados existentes
    await db.execute('CREATE TABLE patients_backup AS SELECT * FROM patients');
    await db.execute('CREATE TABLE wounds_backup AS SELECT * FROM wounds');

    // Criar nova estrutura de pacientes com campos clínicos
    await db.execute('DROP TABLE patients');
    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        owner_id TEXT NOT NULL,
        paciente_id TEXT NOT NULL,
        name TEXT NOT NULL,
        name_lowercase TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'ativo',
        versao INTEGER NOT NULL DEFAULT 1,
        
        -- Campos básicos opcionais
        archived INTEGER NOT NULL DEFAULT 0,
        identificador TEXT,
        nome_social TEXT,
        idade INTEGER,
        sexo TEXT,
        genero TEXT,
        cpf_ou_id TEXT,
        email TEXT,
        phone TEXT,
        notes TEXT,
        
        -- Dados clínicos como JSON comprimido (Base64 + GZIP)
        clinical_data_compressed TEXT,
        
        -- Metadados
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      );
    ''');

    // Criar nova estrutura de feridas
    await db.execute('DROP TABLE wounds');
    await db.execute('''
      CREATE TABLE wounds (
        ferida_id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        owner_id TEXT NOT NULL,
        type TEXT NOT NULL,
        localizacao TEXT NOT NULL,
        status TEXT NOT NULL,
        
        -- Campos opcionais
        inicio INTEGER,
        etiologia TEXT,
        ultima_avaliacao_em INTEGER,
        contagem_avaliacoes INTEGER NOT NULL DEFAULT 0,
        
        -- Campos de compatibilidade (deprecated)
        id TEXT,
        location TEXT,
        location_description TEXT,
        cause_description TEXT,
        
        -- Metadados
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        
        FOREIGN KEY(patient_id) REFERENCES patients(id) ON DELETE CASCADE
      );
    ''');

    // Migrar dados existentes preservando informações
    await db.execute('''
      INSERT INTO patients (
        id, owner_id, paciente_id, name, name_lowercase, birth_date,
        archived, email, phone, notes, created_at, updated_at
      )
      SELECT 
        id, owner_id, 'PAC_' || substr(id, 1, 8), name, name_lowercase, birth_date,
        archived, email, phone, notes, created_at, updated_at
      FROM patients_backup
    ''');

    await db.execute('''
      INSERT INTO wounds (
        ferida_id, patient_id, owner_id, type, localizacao, status,
        etiologia, id, location, location_description, cause_description,
        created_at, updated_at
      )
      SELECT 
        'FER_' || substr(id, 1, 8), patient_id, owner_id, type, 
        COALESCE(location_description, location), status,
        cause_description, id, location, location_description, cause_description,
        created_at, updated_at
      FROM wounds_backup
    ''');

    // Criar novos índices otimizados
    await db.execute(
      'CREATE INDEX idx_patients_owner_status ON patients(owner_id, status, updated_at DESC);',
    );
    await db.execute(
      'CREATE INDEX idx_patients_search ON patients(owner_id, name_lowercase);',
    );
    await db.execute(
      'CREATE INDEX idx_wounds_patient_status ON wounds(patient_id, status, updated_at DESC);',
    );
    await db.execute(
      'CREATE INDEX idx_wounds_owner ON wounds(owner_id, ultima_avaliacao_em DESC);',
    );

    // Remover tabelas de backup
    await db.execute('DROP TABLE patients_backup');
    await db.execute('DROP TABLE wounds_backup');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Nova estrutura de pacientes com dados clínicos completos
    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        owner_id TEXT NOT NULL,
        paciente_id TEXT NOT NULL,
        name TEXT NOT NULL,
        name_lowercase TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'ativo',
        versao INTEGER NOT NULL DEFAULT 1,
        
        -- Campos básicos opcionais
        archived INTEGER NOT NULL DEFAULT 0,
        identificador TEXT,
        nome_social TEXT,
        idade INTEGER,
        sexo TEXT,
        genero TEXT,
        cpf_ou_id TEXT,
        email TEXT,
        phone TEXT,
        notes TEXT,
        
        -- Dados clínicos como JSON comprimido (Base64 + GZIP)
        clinical_data_compressed TEXT,
        
        -- Metadados
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      );
    ''');

    // Nova estrutura de feridas
    await db.execute('''
      CREATE TABLE wounds (
        ferida_id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        owner_id TEXT NOT NULL,
        type TEXT NOT NULL,
        localizacao TEXT NOT NULL,
        status TEXT NOT NULL,
        
        -- Campos opcionais
        inicio INTEGER,
        etiologia TEXT,
        ultima_avaliacao_em INTEGER,
        contagem_avaliacoes INTEGER NOT NULL DEFAULT 0,
        
        -- Campos de compatibilidade (deprecated)
        id TEXT,
        location TEXT,
        location_description TEXT,
        cause_description TEXT,
        
        -- Metadados
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
        local_path TEXT,
        storage_path TEXT NOT NULL,
        download_url TEXT,
        thumb_url TEXT,
        upload_status TEXT NOT NULL DEFAULT 'pending',
        upload_progress REAL NOT NULL DEFAULT 0.0,
        retry_count INTEGER NOT NULL DEFAULT 0,
        width INTEGER,
        height INTEGER,
        file_size INTEGER,
        mime_type TEXT,
        error_message TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
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
      'CREATE INDEX idx_patients_owner_status ON patients(owner_id, status, updated_at DESC);',
    );
    await db.execute(
      'CREATE INDEX idx_patients_search ON patients(owner_id, name_lowercase);',
    );
    await db.execute(
      'CREATE INDEX idx_wounds_patient_status ON wounds(patient_id, status, updated_at DESC);',
    );
    await db.execute(
      'CREATE INDEX idx_wounds_owner ON wounds(owner_id, ultima_avaliacao_em DESC);',
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

  // ---------------------------------------------------------------------------
  // Media CRUD methods
  // ---------------------------------------------------------------------------

  Future<List<Map<String, Object?>>> getMediaByAssessment({
    required String assessmentId,
  }) async {
    final db = await database;
    return db.query(
      'media',
      where: 'assessment_id = ?',
      whereArgs: [assessmentId],
      orderBy: 'created_at DESC',
    );
  }

  Future<Map<String, Object?>?> getMediaById(String id) async {
    final db = await database;
    final rows = await db.query(
      'media',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<List<Map<String, Object?>>> getMediaByUploadStatus({
    required String status,
  }) async {
    final db = await database;
    return db.query(
      'media',
      where: 'upload_status = ?',
      whereArgs: [status],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> updateMediaUploadProgress({
    required String id,
    required double progress,
  }) async {
    final db = await database;
    await db.update(
      'media',
      {
        'upload_progress': progress,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMediaUploadStatus({
    required String id,
    required String status,
    String? errorMessage,
  }) async {
    final db = await database;
    final updates = <String, Object?>{
      'upload_status': status,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
    if (errorMessage != null) {
      updates['error_message'] = errorMessage;
    }
    await db.update('media', updates, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> completeMediaUpload({
    required String id,
    required String storagePath,
    required String downloadUrl,
    String? thumbUrl,
  }) async {
    final db = await database;
    await db.update(
      'media',
      {
        'storage_path': storagePath,
        'download_url': downloadUrl,
        if (thumbUrl != null) 'thumb_url': thumbUrl,
        'upload_status': 'completed',
        'upload_progress': 1.0,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> incrementMediaRetry(String id) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE media SET retry_count = retry_count + 1, updated_at = ? WHERE id = ?',
      [DateTime.now().millisecondsSinceEpoch, id],
    );
  }
}
