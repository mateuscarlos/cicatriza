import '../../domain/entities/assessment_manual.dart';

/// Eventos do AssessmentBloc
abstract class AssessmentEvent {
  const AssessmentEvent();
}

/// Carrega avaliações de uma ferida
class LoadAssessmentsByWoundEvent extends AssessmentEvent {
  final String woundId;

  const LoadAssessmentsByWoundEvent(this.woundId);
}

/// Cria uma nova avaliação
class CreateAssessmentEvent extends AssessmentEvent {
  final String woundId;
  final DateTime date;
  final int painScale;
  final double lengthCm;
  final double widthCm;
  final double depthCm;
  final String? edgeAppearance;
  final String? woundBed;
  final String? exudateType;
  final String? exudateAmount;
  final String? notes;

  const CreateAssessmentEvent({
    required this.woundId,
    required this.date,
    required this.painScale,
    required this.lengthCm,
    required this.widthCm,
    required this.depthCm,
    this.edgeAppearance,
    this.woundBed,
    this.exudateType,
    this.exudateAmount,
    this.notes,
  });
}

/// Atualiza uma avaliação existente
class UpdateAssessmentEvent extends AssessmentEvent {
  final AssessmentManual assessment;

  const UpdateAssessmentEvent(this.assessment);
}

/// Deleta uma avaliação
class DeleteAssessmentEvent extends AssessmentEvent {
  final String assessmentId;

  const DeleteAssessmentEvent(this.assessmentId);
}

/// Seleciona uma avaliação
class SelectAssessmentEvent extends AssessmentEvent {
  final AssessmentManual? assessment;

  const SelectAssessmentEvent(this.assessment);
}

/// Busca última avaliação de uma ferida
class LoadLatestAssessmentEvent extends AssessmentEvent {
  final String woundId;

  const LoadLatestAssessmentEvent(this.woundId);
}

/// Busca histórico de avaliações
class LoadAssessmentHistoryEvent extends AssessmentEvent {
  final String woundId;
  final int? limit;

  const LoadAssessmentHistoryEvent({required this.woundId, this.limit});
}

/// Filtra avaliações
class FilterAssessmentsEvent extends AssessmentEvent {
  final String? woundId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? minPainScale;
  final int? maxPainScale;

  const FilterAssessmentsEvent({
    this.woundId,
    this.fromDate,
    this.toDate,
    this.minPainScale,
    this.maxPainScale,
  });
}

/// Valida dados da avaliação
class ValidateAssessmentEvent extends AssessmentEvent {
  final DateTime date;
  final int painScale;
  final double lengthCm;
  final double widthCm;
  final double depthCm;
  final String? notes;

  const ValidateAssessmentEvent({
    required this.date,
    required this.painScale,
    required this.lengthCm,
    required this.widthCm,
    required this.depthCm,
    this.notes,
  });
}
