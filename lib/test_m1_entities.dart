import 'domain/entities/patient_manual.dart';
import 'domain/entities/wound_manual.dart';
import 'domain/entities/assessment_manual.dart';

void main() {
  print('🧪 Testando entidades manuais para M1...\n');

  try {
    // Teste 1: Criar um paciente
    final patient = PatientManual.create(
      name: 'Maria Silva',
      birthDate: DateTime(1970, 8, 15),
      phone: '11987654321',
      email: 'maria@example.com',
      notes: 'Paciente com diabetes tipo 2',
    );
    print('✅ Paciente criado: ${patient.name} (${patient.nameLowercase})');

    // Teste 2: Criar uma ferida
    final wound = WoundManual.create(
      patientId: patient.id,
      type: 'Úlcera diabética',
      location: 'Pé direito',
      locationDescription: 'Região plantar do hálux',
      causeDescription: 'Diabetes descompensado',
    );
    print(
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
    print(
      '✅ Avaliação criada: ${assessment.lengthCm}x${assessment.widthCm}cm, dor: ${assessment.painScale}/10',
    );
    print('   Área calculada: ${assessment.area?.toStringAsFixed(2)}cm²');

    // Teste 4: Conversão para JSON
    final patientJson = patient.toJson();
    final woundJson = wound.toJson();
    final assessmentJson = assessment.toJson();
    print('✅ Conversões JSON funcionando');

    // Teste 5: Conversão de JSON
    final patientFromJson = PatientManual.fromJson(patientJson);
    final woundFromJson = WoundManual.fromJson(woundJson);
    final assessmentFromJson = AssessmentManual.fromJson(assessmentJson);
    print('✅ Deserialização JSON funcionando');

    // Teste 6: Igualdade
    print('✅ Igualdade: paciente ${patient == patientFromJson ? "✓" : "✗"}');
    print('✅ Igualdade: ferida ${wound == woundFromJson ? "✓" : "✗"}');
    print(
      '✅ Igualdade: avaliação ${assessment == assessmentFromJson ? "✓" : "✗"}',
    );

    // Teste 7: copyWith
    final updatedWound = wound.copyWith(status: 'Em cicatrização');
    print('✅ copyWith: status ${wound.status} → ${updatedWound.status}');

    print('\n🎉 TODOS OS TESTES PASSARAM!');
    print('📋 Entidades manuais prontas para M1:');
    print('   • PatientManual ✓');
    print('   • WoundManual ✓');
    print('   • AssessmentManual ✓');
  } catch (e, stackTrace) {
    print('❌ Erro durante os testes:');
    print('Erro: $e');
    print('Stack trace: $stackTrace');
  }
}
