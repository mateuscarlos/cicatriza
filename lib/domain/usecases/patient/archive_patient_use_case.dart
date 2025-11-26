import '../../entities/patient.dart';
import '../../repositories/patient_repository.dart';
import '../base/use_case.dart';

/// Input para arquivamento de paciente
class ArchivePatientInput {
  final String patientId;
  final bool archive; // true = arquivar, false = desarquivar

  const ArchivePatientInput({required this.patientId, required this.archive});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArchivePatientInput &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          archive == other.archive;

  @override
  int get hashCode => patientId.hashCode ^ archive.hashCode;
}

/// Caso de uso para arquivar/desarquivar pacientes.
///
/// Responsabilidades:
/// - Validar entrada
/// - Buscar paciente existente
/// - Aplicar operação de arquivamento usando métodos da entidade
/// - Persistir alterações
/// - Retornar paciente atualizado
class ArchivePatientUseCase implements UseCase<ArchivePatientInput, Patient> {
  final PatientRepository _patientRepository;

  const ArchivePatientUseCase(this._patientRepository);

  @override
  Future<Result<Patient>> execute(ArchivePatientInput input) async {
    try {
      // Validar entrada
      if (input.patientId.trim().isEmpty) {
        return const Failure(
          ValidationError('ID do paciente é obrigatório', field: 'patientId'),
        );
      }

      // Buscar paciente existente
      final existingPatient = await _patientRepository.getPatientById(
        input.patientId,
      );
      if (existingPatient == null) {
        return Failure(NotFoundError.withId('Patient', input.patientId));
      }

      // Verificar se já está no estado desejado
      if (existingPatient.archived == input.archive) {
        final action = input.archive ? 'arquivado' : 'desarquivado';
        return Failure(
          ConflictError(
            'Paciente já está $action',
            code: input.archive ? 'ALREADY_ARCHIVED' : 'ALREADY_UNARCHIVED',
          ),
        );
      }

      // Aplicar arquivamento usando métodos da entidade
      final updatedPatient = input.archive
          ? existingPatient.archive()
          : existingPatient.unarchive();

      // Persistir alterações
      final savedPatient = await _patientRepository.updatePatient(
        updatedPatient,
      );

      return Success(savedPatient);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao arquivar/desarquivar paciente: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
