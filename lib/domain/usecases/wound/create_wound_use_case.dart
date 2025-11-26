import '../../entities/wound.dart';
import '../../repositories/wound_repository.dart';
import '../../repositories/patient_repository.dart';
import '../base/use_case.dart';

/// Input para criação de ferida
class CreateWoundInput {
  final String patientId;
  final WoundType type;
  final WoundLocation location;
  final String description;
  final String? notes;

  const CreateWoundInput({
    required this.patientId,
    required this.type,
    required this.location,
    required this.description,
    this.notes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateWoundInput &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          type == other.type &&
          location == other.location &&
          description == other.description &&
          notes == other.notes;

  @override
  int get hashCode =>
      patientId.hashCode ^
      type.hashCode ^
      location.hashCode ^
      description.hashCode ^
      notes.hashCode;
}

/// Caso de uso para criação de novas feridas.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Verificar se paciente existe
/// - Criar entidade Wound com validações de domínio
/// - Persistir nova ferida
/// - Retornar resultado da operação
class CreateWoundUseCase implements UseCase<CreateWoundInput, Wound> {
  final WoundRepository _woundRepository;
  final PatientRepository _patientRepository;

  const CreateWoundUseCase(this._woundRepository, this._patientRepository);

  @override
  Future<Result<Wound>> execute(CreateWoundInput input) async {
    try {
      // Validar entrada
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      // Verificar se paciente existe
      final patient = await _patientRepository.getPatientById(input.patientId);
      if (patient == null) {
        return Failure(NotFoundError.withId('Patient', input.patientId));
      }

      // Verificar se paciente está arquivado
      if (patient.archived) {
        return const Failure(
          ConflictError(
            'Não é possível criar ferida para paciente arquivado',
            code: 'PATIENT_ARCHIVED',
          ),
        );
      }

      // Criar entidade Wound
      final wound = Wound.create(
        patientId: input.patientId,
        type: input.type,
        location: input.location,
        description: input.description.trim().isEmpty
            ? 'Sem descrição'
            : input.description.trim(),
        notes: input.notes?.trim().isEmpty == true ? null : input.notes?.trim(),
      );

      // Persistir ferida
      final savedWound = await _woundRepository.createWound(wound);

      return Success(savedWound);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao criar ferida: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada
  ValidationError? _validateInput(CreateWoundInput input) {
    if (input.patientId.trim().isEmpty) {
      return const ValidationError(
        'ID do paciente é obrigatório',
        field: 'patientId',
      );
    }

    if (input.description.trim().isEmpty) {
      return const ValidationError(
        'Descrição é obrigatória',
        field: 'description',
      );
    }

    return null;
  }
}
