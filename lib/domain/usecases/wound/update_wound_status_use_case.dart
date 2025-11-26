import '../../entities/wound.dart';
import '../../repositories/wound_repository.dart';
import '../base/use_case.dart';

/// Input para atualização de status de ferida
class UpdateWoundStatusInput {
  final String woundId;
  final WoundStatus newStatus;
  final String? reason; // Razão para a mudança de status

  const UpdateWoundStatusInput({
    required this.woundId,
    required this.newStatus,
    this.reason,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateWoundStatusInput &&
          runtimeType == other.runtimeType &&
          woundId == other.woundId &&
          newStatus == other.newStatus &&
          reason == other.reason;

  @override
  int get hashCode => woundId.hashCode ^ newStatus.hashCode ^ reason.hashCode;
}

/// Caso de uso para atualização de status de feridas.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Buscar ferida existente
/// - Validar transição de status usando regras de domínio
/// - Aplicar mudança de status
/// - Persistir alterações
/// - Retornar ferida atualizada
class UpdateWoundStatusUseCase
    implements UseCase<UpdateWoundStatusInput, Wound> {
  final WoundRepository _woundRepository;

  const UpdateWoundStatusUseCase(this._woundRepository);

  @override
  Future<Result<Wound>> execute(UpdateWoundStatusInput input) async {
    try {
      // Validar entrada
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      // Buscar ferida existente
      final existingWound = await _woundRepository.getWoundById(input.woundId);
      if (existingWound == null) {
        return Failure(NotFoundError.withId('Wound', input.woundId));
      }

      // Verificar se status já é o desejado
      if (existingWound.status == input.newStatus) {
        return Failure(
          ConflictError(
            'Ferida já está com status ${input.newStatus.displayName}',
            code: 'STATUS_UNCHANGED',
          ),
        );
      }

      // Aplicar mudança de status (validação será feita na entidade)
      final updatedWound = existingWound.updateStatus(
        input.newStatus,
        healedDate: input.newStatus == WoundStatus.cicatrizada
            ? DateTime.now()
            : null,
      );

      // Persistir alterações
      final savedWound = await _woundRepository.updateWound(updatedWound);

      return Success(savedWound);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao atualizar status da ferida: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada
  ValidationError? _validateInput(UpdateWoundStatusInput input) {
    if (input.woundId.trim().isEmpty) {
      return const ValidationError(
        'ID da ferida é obrigatório',
        field: 'woundId',
      );
    }

    return null;
  }
}
