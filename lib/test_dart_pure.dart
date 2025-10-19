import 'domain/entities/patient_manual.dart';

void main() {
  try {
    print('Testando PatientManual puro...');

    final patient = PatientManual.create(
      name: 'João Silva',
      birthDate: DateTime(1980, 5, 15),
      phone: '11999999999',
      email: 'joao@example.com',
    );

    print('✅ Paciente criado: $patient');
    print('✅ PatientManual funcionando!');
  } catch (e, stackTrace) {
    print('❌ Erro: $e');
    print('Stack trace: $stackTrace');
  }
}
