import '../entities/patient.dart';

/// Interface para repositório de pacientes
abstract class PatientRepository {
  /// Lista todos os pacientes do usuário
  Future<List<Patient>> getPatients();

  /// Busca pacientes por nome
  Future<List<Patient>> searchPatients(String query);

  /// Busca um paciente por ID
  Future<Patient?> getPatientById(String id);

  /// Cria um novo paciente
  Future<Patient> createPatient(Patient patient);

  /// Atualiza um paciente existente
  Future<Patient> updatePatient(Patient patient);

  /// Arquiva/desarquiva um paciente
  Future<Patient> togglePatientArchived(String patientId);

  /// Deleta um paciente (soft delete - arquiva)
  Future<void> deletePatient(String patientId);

  /// Stream de pacientes para atualizações em tempo real
  Stream<List<Patient>> watchPatients();

  /// Stream de um paciente específico
  Stream<Patient?> watchPatient(String patientId);
}
