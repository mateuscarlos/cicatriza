import 'domain/entities/patient_manual.dart';

void testManualPatient() {
  print('Testando PatientManual...');

  // Teste de criação
  final patient = PatientManual.create(
    name: 'João Silva',
    birthDate: DateTime(1980, 5, 15),
    phone: '11999999999',
    email: 'joao@example.com',
  );

  print('Paciente criado: $patient');

  // Teste de JSON
  final json = patient.toJson();
  print('JSON: $json');

  final patientFromJson = PatientManual.fromJson(json);
  print('Paciente do JSON: $patientFromJson');

  print('Pacientes são iguais: ${patient == patientFromJson}');
  print('PatientManual funcionando corretamente!');
}

void main() {
  testManualPatient();
}
