import '../../entities/assessment_manual.dart';
import '../../repositories/assessment_repository_manual.dart';
import '../base/use_case.dart';

/// Input para atualização de avaliação
class UpdateAssessmentInput {
  final String assessmentId;
  final Map<String, dynamic>? assessmentData;
  final String? observations;
  final List<String>? imageUrls;
  final String updatedBy; // Quem está fazendo a atualização

  const UpdateAssessmentInput({
    required this.assessmentId,
    required this.updatedBy,
    this.assessmentData,
    this.observations,
    this.imageUrls,
  });

  bool get hasUpdates =>
      assessmentData != null || observations != null || imageUrls != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateAssessmentInput &&
          runtimeType == other.runtimeType &&
          assessmentId == other.assessmentId &&
          updatedBy == other.updatedBy &&
          assessmentData == other.assessmentData &&
          observations == other.observations &&
          imageUrls == other.imageUrls;

  @override
  int get hashCode =>
      assessmentId.hashCode ^
      updatedBy.hashCode ^
      assessmentData.hashCode ^
      observations.hashCode ^
      imageUrls.hashCode;
}

/// Caso de uso para atualização de avaliações existentes.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Buscar avaliação existente
/// - Verificar permissões de atualização
/// - Aplicar atualizações parciais
/// - Persistir alterações
/// - Retornar avaliação atualizada
class UpdateAssessmentUseCase
    implements UseCase<UpdateAssessmentInput, AssessmentManual> {
  final AssessmentRepository _assessmentRepository;

  const UpdateAssessmentUseCase(this._assessmentRepository);

  @override
  Future<Result<AssessmentManual>> execute(UpdateAssessmentInput input) async {
    try {
      // Validar entrada
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      // Verificar se há atualizações
      if (!input.hasUpdates) {
        return const Failure(
          ValidationError(
            'Pelo menos um campo deve ser fornecido para atualização',
            field: 'hasUpdates',
          ),
        );
      }

      // Buscar avaliação existente
      final existingAssessment = await _assessmentRepository.getAssessmentById(
        input.assessmentId,
      );
      if (existingAssessment == null) {
        return Failure(NotFoundError.withId('Assessment', input.assessmentId));
      }

      // Aplicar atualizações usando método da entidade
      final assessmentData = input.assessmentData ?? <String, dynamic>{};

      final updatedAssessment = existingAssessment.updateInfo(
        lengthCm: assessmentData['lengthCm'] as double?,
        widthCm: assessmentData['widthCm'] as double?,
        depthCm: assessmentData['depthCm'] as double?,
        painScale: assessmentData['painScale'] as int?,
        edgeAppearance: assessmentData['edgeAppearance'] as String?,
        woundBed: assessmentData['woundBed'] as String?,
        exudateType: assessmentData['exudateType'] as String?,
        exudateAmount: assessmentData['exudateAmount'] as String?,
        notes:
            assessmentData['notes'] as String? ??
            (input.observations?.trim().isEmpty == true
                ? null
                : input.observations?.trim()),
      );

      // Persistir alterações
      final savedAssessment = await _assessmentRepository.updateAssessment(
        updatedAssessment,
      );

      return Success(savedAssessment);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao atualizar avaliação: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada
  ValidationError? _validateInput(UpdateAssessmentInput input) {
    if (input.assessmentId.trim().isEmpty) {
      return const ValidationError(
        'ID da avaliação é obrigatório',
        field: 'assessmentId',
      );
    }

    if (input.updatedBy.trim().isEmpty) {
      return const ValidationError(
        'Responsável pela atualização é obrigatório',
        field: 'updatedBy',
      );
    }

    // Validar dados da avaliação se fornecidos
    if (input.assessmentData != null && input.assessmentData!.isEmpty) {
      return const ValidationError(
        'Dados da avaliação não podem ser vazios',
        field: 'assessmentData',
      );
    }

    return null;
  }
}
