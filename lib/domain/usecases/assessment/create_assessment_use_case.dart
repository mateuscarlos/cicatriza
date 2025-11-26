import '../../entities/assessment_manual.dart';
import '../../repositories/assessment_repository_manual.dart';
import '../../repositories/wound_repository.dart';
import '../base/use_case.dart';

/// Input para criação de avaliação
class CreateAssessmentInput {
  final String woundId;
  final double? lengthCm;
  final double? widthCm;
  final double? depthCm;
  final int? painScale;
  final String? edgeAppearance;
  final String? woundBed;
  final String? exudateType;
  final String? exudateAmount;
  final String? notes;

  const CreateAssessmentInput({
    required this.woundId,
    this.lengthCm,
    this.widthCm,
    this.depthCm,
    this.painScale,
    this.edgeAppearance,
    this.woundBed,
    this.exudateType,
    this.exudateAmount,
    this.notes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateAssessmentInput &&
          runtimeType == other.runtimeType &&
          woundId == other.woundId &&
          lengthCm == other.lengthCm &&
          widthCm == other.widthCm &&
          depthCm == other.depthCm &&
          painScale == other.painScale &&
          edgeAppearance == other.edgeAppearance &&
          woundBed == other.woundBed &&
          exudateType == other.exudateType &&
          exudateAmount == other.exudateAmount &&
          notes == other.notes;

  @override
  int get hashCode =>
      woundId.hashCode ^
      lengthCm.hashCode ^
      widthCm.hashCode ^
      depthCm.hashCode ^
      painScale.hashCode ^
      edgeAppearance.hashCode ^
      woundBed.hashCode ^
      exudateType.hashCode ^
      exudateAmount.hashCode ^
      notes.hashCode;
}

/// Caso de uso para criação de novas avaliações de ferida.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Verificar se ferida existe e permite avaliações
/// - Criar entidade AssessmentManual com validações de domínio
/// - Persistir nova avaliação
/// - Retornar resultado da operação
class CreateAssessmentUseCase
    implements UseCase<CreateAssessmentInput, AssessmentManual> {
  final AssessmentRepository _assessmentRepository;
  final WoundRepository _woundRepository;

  const CreateAssessmentUseCase(
    this._assessmentRepository,
    this._woundRepository,
  );

  @override
  Future<Result<AssessmentManual>> execute(CreateAssessmentInput input) async {
    try {
      // Validar entrada
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      // Verificar se ferida existe
      final wound = await _woundRepository.getWoundById(input.woundId);
      if (wound == null) {
        return Failure(NotFoundError.withId('Wound', input.woundId));
      }

      // Verificar se ferida permite novas avaliações
      if (!wound.status.allowsNewAssessments) {
        return Failure(
          ConflictError(
            'Não é possível criar avaliação para ferida com status ${wound.status.displayName}',
            code: 'WOUND_STATUS_INVALID',
          ),
        );
      }

      // Verificar se ferida está arquivada
      if (wound.archived) {
        return const Failure(
          ConflictError(
            'Não é possível criar avaliação para ferida arquivada',
            code: 'WOUND_ARCHIVED',
          ),
        );
      }

      // Criar entidade AssessmentManual
      final assessment = AssessmentManual.create(
        woundId: input.woundId,
        lengthCm: input.lengthCm,
        widthCm: input.widthCm,
        depthCm: input.depthCm,
        painScale: input.painScale,
        edgeAppearance: input.edgeAppearance?.trim().isEmpty == true
            ? null
            : input.edgeAppearance?.trim(),
        woundBed: input.woundBed?.trim().isEmpty == true
            ? null
            : input.woundBed?.trim(),
        exudateType: input.exudateType?.trim().isEmpty == true
            ? null
            : input.exudateType?.trim(),
        exudateAmount: input.exudateAmount?.trim().isEmpty == true
            ? null
            : input.exudateAmount?.trim(),
        notes: input.notes?.trim().isEmpty == true ? null : input.notes?.trim(),
      );

      // Persistir avaliação
      final savedAssessment = await _assessmentRepository.createAssessment(
        assessment,
      );

      return Success(savedAssessment);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao criar avaliação: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada
  ValidationError? _validateInput(CreateAssessmentInput input) {
    if (input.woundId.trim().isEmpty) {
      return const ValidationError(
        'ID da ferida é obrigatório',
        field: 'woundId',
      );
    }

    // Validar se pelo menos um campo de avaliação foi fornecido
    if (input.lengthCm == null &&
        input.widthCm == null &&
        input.depthCm == null &&
        input.painScale == null &&
        input.edgeAppearance == null &&
        input.woundBed == null &&
        input.exudateType == null &&
        input.exudateAmount == null &&
        input.notes == null) {
      return const ValidationError(
        'Pelo menos um campo de avaliação deve ser fornecido',
        field: 'assessment_fields',
      );
    }

    return null;
  }
}
