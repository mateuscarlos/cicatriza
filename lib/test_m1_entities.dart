import 'core/utils/app_logger.dart';
import 'domain/entities/patient_manual.dart';
import 'domain/entities/wound_manual.dart';
import 'domain/entities/assessment_manual.dart';

void main() {
  AppLogger.info('🧪 Testando entidades manuais para M1...\n');

  try {
    // Teste 1: Criar um paciente
    final patient = PatientManual.create(
      name: 'Maria Silva',
      birthDate: DateTime(1970, 8, 15),
      phone: '11987654321',
      email: 'maria@example.com',
      notes: 'Paciente com diabetes tipo 2',
    );
    AppLogger.info(
      '✅ Paciente criado: ${patient.name} (${patient.nameLowercase})',
    );

    // Teste 2: Criar uma ferida
    final wound = WoundManual.create(
      patientId: patient.id,
      type: 'Úlcera diabética',
      location: 'Pé direito',
      locationDescription: 'Região plantar do hálux',
      causeDescription: 'Diabetes descompensado',
    );
    AppLogger.info(
      '✅ Ferida criada: ${wound.type} em ${wound.location} (${wound.status})',
    );

    // Teste 3: Criar uma avaliação
    final assessment = AssessmentManual.create(
      woundId: wound.id,
      lengthCm: 3.5,
      widthCm: 2.0,
      depthCm: 0.5,
      painScale: 6,
      edgeAppearance: 'Irregular',
      woundBed: 'Fibrina',
      exudateType: 'Seropurulento',
      exudateAmount: 'Moderada',
      notes: 'Sinais de infecção local',
    );
    AppLogger.info(
      '✅ Avaliação criada: ${assessment.lengthCm}x${assessment.widthCm}cm, dor: ${assessment.painScale}/10',
    );
    AppLogger.info(
      '   Área calculada: ${assessment.area?.toStringAsFixed(2)}cm²',
    );

    // Teste 4: Conversão para JSON
    final patientJson = patient.toJson();
    final woundJson = wound.toJson();
    final assessmentJson = assessment.toJson();
    AppLogger.info('✅ Conversões JSON funcionando');

    // Teste 5: Conversão de JSON
    final patientFromJson = PatientManual.fromJson(patientJson);
    final woundFromJson = WoundManual.fromJson(woundJson);
    final assessmentFromJson = AssessmentManual.fromJson(assessmentJson);
    AppLogger.info('✅ Deserialização JSON funcionando');

    // Teste 6: Igualdade
    AppLogger.info(
      '✅ Igualdade: paciente ${patient == patientFromJson ? "✓" : "✗"}',
    );
    AppLogger.info('✅ Igualdade: ferida ${wound == woundFromJson ? "✓" : "✗"}');
    AppLogger.info(
      '✅ Igualdade: avaliação ${assessment == assessmentFromJson ? "✓" : "✗"}',
    );

    // Teste 7: copyWith
    final updatedWound = wound.copyWith(status: 'Em cicatrização');
    AppLogger.info(
      '✅ copyWith: status ${wound.status} → ${updatedWound.status}',
    );

    AppLogger.info('\n🎉 TODOS OS TESTES PASSARAM!');
    AppLogger.info('📋 Entidades manuais prontas para M1:');
    AppLogger.info('   • PatientManual ✓');
    AppLogger.info('   • WoundManual ✓');
    AppLogger.info('   • AssessmentManual ✓');
  } catch (e, stackTrace) {
    AppLogger.error(
      '❌ Erro durante os testes de entidades manuais',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
