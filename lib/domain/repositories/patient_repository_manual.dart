import '../entities/patient_manual.dart';

/// Interface para repositório de pacientes usando entidade manual
abstract class PatientRepository {
  /// Lista todos os pacientes do usuário
  Future<List<PatientManual>> getPatients();

  /// Busca pacientes por nome
  Future<List<PatientManual>> searchPatients(String query);

  /// Busca um paciente por ID
  Future<PatientManual?> getPatientById(String id);

  /// Cria um novo paciente
  Future<PatientManual> createPatient(PatientManual patient);

  /// Atualiza um paciente existente
  Future<PatientManual> updatePatient(PatientManual patient);

  /// Arquiva/desarquiva um paciente
  Future<PatientManual> togglePatientArchived(String patientId);

  /// Deleta um paciente (soft delete - arquiva)
  Future<void> deletePatient(String patientId);

  /// Stream de pacientes para atualizações em tempo real
  Stream<List<PatientManual>> watchPatients();

  /// Stream de um paciente específico
  Stream<PatientManual?> watchPatient(String patientId);
}
