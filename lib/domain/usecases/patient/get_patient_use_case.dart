import '../../entities/patient.dart';
import '../../repositories/patient_repository.dart';
import '../base/use_case.dart';

/// Input para busca de paciente
class GetPatientInput {
  final String patientId;

  const GetPatientInput({required this.patientId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetPatientInput &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId;

  @override
  int get hashCode => patientId.hashCode;
}

/// Caso de uso para buscar um paciente específico.
///
/// Responsabilidades:
/// - Validar ID do paciente
/// - Buscar paciente no repositório
/// - Retornar paciente encontrado ou erro apropriado
class GetPatientUseCase implements UseCase<GetPatientInput, Patient> {
  final PatientRepository _patientRepository;

  const GetPatientUseCase(this._patientRepository);

  @override
  Future<Result<Patient>> execute(GetPatientInput input) async {
    try {
      // Validar entrada
      if (input.patientId.trim().isEmpty) {
        return const Failure(
          ValidationError('ID do paciente é obrigatório', field: 'patientId'),
        );
      }

      // Buscar paciente
      final patient = await _patientRepository.getPatientById(input.patientId);

      if (patient == null) {
        return Failure(NotFoundError.withId('Patient', input.patientId));
      }

      return Success(patient);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao buscar paciente: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
