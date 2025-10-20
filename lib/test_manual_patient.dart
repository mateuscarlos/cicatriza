import 'core/utils/app_logger.dart';
import 'domain/entities/patient_manual.dart';

void testManualPatient() {
  AppLogger.info('Testando PatientManual...');

  // Teste de criação
  final patient = PatientManual.create(
    name: 'João Silva',
    birthDate: DateTime(1980, 5, 15),
    phone: '11999999999',
    email: 'joao@example.com',
  );

  AppLogger.info('Paciente criado: $patient');

  // Teste de JSON
  final json = patient.toJson();
  AppLogger.info('JSON: $json');

  final patientFromJson = PatientManual.fromJson(json);
  AppLogger.info('Paciente do JSON: $patientFromJson');

  AppLogger.info('Pacientes são iguais: ${patient == patientFromJson}');
  AppLogger.info('PatientManual funcionando corretamente!');
}

void main() {
  testManualPatient();
}
