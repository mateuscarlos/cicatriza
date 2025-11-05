import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/assessment_local_storage.dart';
import '../models/assessment_local_model_v2.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/assessment_manual.dart';

/// Repositório híbrido que funciona offline-first
/// Salva localmente e sincroniza com Firestore quando possível
class AssessmentHybridRepository {
  final AssessmentLocalStorage _localStorage;
  final ConnectivityService _connectivityService;
  final FirebaseFirestore _firestore;

  AssessmentHybridRepository({
    required AssessmentLocalStorage localStorage,
    required ConnectivityService connectivityService,
    FirebaseFirestore? firestore,
  }) : _localStorage = localStorage,
       _connectivityService = connectivityService,
       _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createAssessment(AssessmentManual assessment) async {
    // 1. Salvar localmente SEMPRE (offline-first)
    final localModel = _toLocalModel(assessment);
    await _localStorage.saveAssessment(localModel);

    // 2. Tentar sincronizar imediatamente se online
    if (await _connectivityService.hasConnection()) {
      try {
        await _syncAssessmentToFirestore(localModel);
        await _localStorage.markAsSynced(assessment.id);
      } catch (e) {
        // Se falhar, mantém local e sincroniza depois
        AppLogger.error(
          '[AssessmentHybridRepository] Erro ao sincronizar',
          error: e,
        );
      }
    }
  }

  Future<List<AssessmentManual>> getAssessmentsByWoundId(String woundId) async {
    // Retorna dados locais (sempre disponíveis)
    final localModels = await _localStorage.getAssessmentsByWoundId(woundId);
    return localModels.map(_toEntity).toList();
  }

  Future<AssessmentManual?> getAssessmentById(String id) async {
    final localModel = await _localStorage.getAssessment(id);
    return localModel != null ? _toEntity(localModel) : null;
  }

  /// Sincroniza todas as avaliações pendentes
  Future<int> syncPendingAssessments() async {
    if (!await _connectivityService.hasConnection()) {
      AppLogger.info(
        '[AssessmentHybridRepository] Sem conexão. Sync cancelada.',
      );
      return 0;
    }

    final unsyncedAssessments = await _localStorage.getUnsyncedAssessments();
    int syncedCount = 0;

    for (final assessment in unsyncedAssessments) {
      try {
        await _syncAssessmentToFirestore(assessment);
        await _localStorage.markAsSynced(assessment.id);
        syncedCount++;
      } catch (e) {
        AppLogger.error(
          '[AssessmentHybridRepository] Erro ao sincronizar ${assessment.id}',
          error: e,
        );
      }
    }

    if (syncedCount > 0) {
      AppLogger.info(
        '[AssessmentHybridRepository] ✅ Sincronizadas $syncedCount avaliações',
      );
    }

    return syncedCount;
  }

  /// Envia avaliação para Firestore
  Future<void> _syncAssessmentToFirestore(AssessmentLocalModel model) async {
    await _firestore
        .collection('assessments')
        .doc(model.id)
        .set(model.toFirestore());
  }

  /// Converte entity para modelo local
  AssessmentLocalModel _toLocalModel(AssessmentManual entity) {
    return AssessmentLocalModel(
      id: entity.id,
      woundId: entity.woundId,
      date: entity.date,
      painScale: entity.painScale ?? 0,
      lengthCm: entity.lengthCm ?? 0.0,
      widthCm: entity.widthCm ?? 0.0,
      depthCm: entity.depthCm,
      woundBed: entity.woundBed ?? '',
      exudateType: entity.exudateType ?? '',
      edgeAppearance: entity.edgeAppearance ?? '',
      notes: entity.notes,
      isSynced: false,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converte modelo local para entity
  AssessmentManual _toEntity(AssessmentLocalModel model) {
    return AssessmentManual(
      id: model.id,
      woundId: model.woundId,
      date: model.date,
      painScale: model.painScale,
      lengthCm: model.lengthCm,
      widthCm: model.widthCm,
      depthCm: model.depthCm,
      woundBed: model.woundBed,
      exudateType: model.exudateType,
      edgeAppearance: model.edgeAppearance,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
