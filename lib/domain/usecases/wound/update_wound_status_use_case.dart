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
      final existingWound = await _woundRepository.findById(input.woundId);
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

      // Validar transição de status usando métodos da entidade
      if (!existingWound.canTransitionTo(input.newStatus)) {
        return Failure(
          ConflictError(
            'Transição de ${existingWound.status.displayName} para ${input.newStatus.displayName} não é permitida',
            code: 'INVALID_STATUS_TRANSITION',
          ),
        );
      }

      // Aplicar mudança de status
      final updatedWound = existingWound.updateStatus(
        input.newStatus,
        reason: input.reason?.trim().isEmpty == true
            ? null
            : input.reason?.trim(),
      );

      // Persistir alterações
      final savedWound = await _woundRepository.save(updatedWound);

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
