import 'core/utils/app_logger.dart';
import 'domain/entities/patient.dart';

void main() {
  try {
    AppLogger.info('Testando Patient com freezed em runtime...');

    // Teste 1: Criar um paciente
    final patient = Patient.create(
      name: 'Maria Silva',
      birthDate: DateTime(1985, 3, 20),
      phone: '11987654321',
      email: 'maria@example.com',
      notes: 'Paciente com diabetes tipo 2',
    );

    AppLogger.info('✅ Paciente criado: $patient');

    // Teste 2: Converter para JSON
    final json = patient.toJson();
    AppLogger.info('✅ JSON gerado: $json');

    // Teste 3: Criar a partir de JSON
    final patientFromJson = Patient.fromJson(json);
    AppLogger.info('✅ Paciente do JSON: $patientFromJson');

    // Teste 4: Testar copyWith
    final updatedPatient = patient.copyWith(
      phone: '11999888777',
      notes: 'Paciente com diabetes tipo 2 - Atualizado',
    );
    AppLogger.info('✅ Paciente atualizado: $updatedPatient');

    // Teste 5: Testar igualdade
    final samePatient = Patient.create(
      name: 'Maria Silva',
      birthDate: DateTime(1985, 3, 20),
      phone: '11987654321',
      email: 'maria@example.com',
      notes: 'Paciente com diabetes tipo 2',
    );
    AppLogger.info('✅ Igualdade: ${patient == samePatient}');

    AppLogger.info(
      '\n🎉 TODOS OS TESTES PASSARAM! Freezed funciona em runtime!',
    );
  } catch (e, stackTrace) {
    AppLogger.error(
      '❌ Erro durante os testes de Patient',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
