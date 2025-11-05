import '../entities/assessment.dart';

/// Interface para repositório de avaliações
abstract class AssessmentRepository {
  /// Lista todas as avaliações de uma ferida
  Future<List<Assessment>> getAssessmentsByWound(String woundId);

  /// Busca uma avaliação por ID
  Future<Assessment?> getAssessmentById(String assessmentId);

  /// Cria uma nova avaliação
  Future<Assessment> createAssessment(Assessment assessment);

  /// Atualiza uma avaliação existente
  Future<Assessment> updateAssessment(Assessment assessment);

  /// Deleta uma avaliação
  Future<void> deleteAssessment(String assessmentId);

  /// Stream de avaliações de uma ferida para atualizações em tempo real
  Stream<List<Assessment>> watchAssessmentsByWound(String woundId);

  /// Stream de uma avaliação específica
  Stream<Assessment?> watchAssessment(String assessmentId);

  /// Lista avaliações por período
  Future<List<Assessment>> getAssessmentsByDateRange(
    String woundId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Busca a última avaliação de uma ferida
  Future<Assessment?> getLatestAssessment(String woundId);

  /// Lista avaliações ordenadas por data (mais recente primeiro)
  Future<List<Assessment>> getAssessmentsSortedByDate(String woundId);
}
