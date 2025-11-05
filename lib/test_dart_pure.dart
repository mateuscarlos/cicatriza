import 'core/utils/app_logger.dart';
import 'domain/entities/patient_manual.dart';

void main() {
  try {
    AppLogger.info('Testando PatientManual puro...');

    final patient = PatientManual.create(
      name: 'João Silva',
      birthDate: DateTime(1980, 5, 15),
      phone: '11999999999',
      email: 'joao@example.com',
    );

    AppLogger.info('✅ Paciente criado: $patient');
    AppLogger.info('✅ PatientManual funcionando!');
  } catch (e, stackTrace) {
    AppLogger.error(
      '❌ Erro ao testar PatientManual',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
