import 'core/utils/app_logger.dart';
import 'domain/entities/patient.dart';
import 'domain/entities/wound.dart';

void testEntities() {
  // Test Patient creation
  final patient = Patient.create(
    name: 'João Silva',
    birthDate: DateTime(1980, 5, 15),
    notes: 'Paciente teste',
  );

  AppLogger.info('Patient created: ${patient.name}');

  // Test Wound creation
  final wound = Wound.create(
    patientId: patient.id,
    type: WoundType.pressureUlcer,
    locationSimple: WoundLocation.back,
    onsetDays: 30,
    notes: 'Ferida teste',
  );

  AppLogger.info('Wound created with type: ${wound.type}');
}
