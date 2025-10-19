import '../entities/assessment_manual.dart';

/// Interface para repositório de avaliações usando entidade manual
abstract class AssessmentRepository {
  /// Lista todas as avaliações de uma ferida
  Future<List<AssessmentManual>> getAssessmentsByWoundId(String woundId);

  /// Busca uma avaliação por ID
  Future<AssessmentManual?> getAssessmentById(String id);

  /// Cria uma nova avaliação
  Future<AssessmentManual> createAssessment(AssessmentManual assessment);

  /// Atualiza uma avaliação existente
  Future<AssessmentManual> updateAssessment(AssessmentManual assessment);

  /// Deleta uma avaliação
  Future<void> deleteAssessment(String assessmentId);

  /// Stream de avaliações de uma ferida para atualizações em tempo real
  Stream<List<AssessmentManual>> watchAssessments(String woundId);

  /// Stream de uma avaliação específica
  Stream<AssessmentManual?> watchAssessment(String assessmentId);

  /// Lista avaliações com filtros
  Future<List<AssessmentManual>> getAssessmentsWithFilters({
    String? woundId,
    DateTime? fromDate,
    DateTime? toDate,
    int? minPainScale,
    int? maxPainScale,
  });

  /// Busca a última avaliação de uma ferida
  Future<AssessmentManual?> getLatestAssessment(String woundId);

  /// Lista avaliações ordenadas por data (mais recente primeiro)
  Future<List<AssessmentManual>> getAssessmentsSortedByDate(
    String woundId, {
    int? limit,
  });
}
