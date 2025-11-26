import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/patient.dart';
import '../../../../lib/domain/entities/wound.dart';
import '../../../../lib/domain/repositories/patient_repository.dart';
import '../../../../lib/domain/repositories/wound_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/wound/assess_wound_risk_use_case.dart';

class MockWoundRepository extends Mock implements WoundRepository {}

class MockPatientRepository extends Mock implements PatientRepository {}

class FakeWound extends Fake implements Wound {}

class FakePatient extends Fake implements Patient {}

void main() {
  late AssessWoundRiskUseCase useCase;
  late MockWoundRepository mockWoundRepository;
  late MockPatientRepository mockPatientRepository;

  setUpAll(() {
    registerFallbackValue(FakeWound());
    registerFallbackValue(FakePatient());
  });

  setUp(() {
    mockWoundRepository = MockWoundRepository();
    mockPatientRepository = MockPatientRepository();
    useCase = AssessWoundRiskUseCase(
      mockWoundRepository,
      mockPatientRepository,
    );
  });

  group('AssessWoundRiskUseCase', () {
    final mockWound = Wound(
      id: 'wound-1',
      patientId: 'patient-1',
      type: WoundType.ulceraPressao,
      location: WoundLocation.costas,
      description: 'Úlcera por pressão',
      status: WoundStatus.ativa,
      identificationDate: DateTime.now().subtract(const Duration(days: 10)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    );

    final mockPatient = Patient(
      id: 'patient-1',
      name: 'João Silva',
      nameLowercase: 'joão silva',
      email: 'joao@email.com',
      phone: '(11) 98888-8888',
      birthDate: DateTime(1945, 1, 1), // Paciente idoso
      archived: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final validInput = AssessWoundRiskInput(
      woundId: 'wound-1',
      includePatientFactors: true,
    );

    test(
      'deve avaliar risco com sucesso incluindo fatores do paciente',
      () async {
        // Arrange
        when(
          () => mockWoundRepository.getWoundById('wound-1'),
        ).thenAnswer((_) async => mockWound);
        when(
          () => mockPatientRepository.getPatientById('patient-1'),
        ).thenAnswer((_) async => mockPatient);

        // Act
        final result = await useCase.execute(validInput);

        // Assert
        expect(result, isA<Success<WoundRiskAssessment>>());
        final success = result as Success<WoundRiskAssessment>;
        final assessment = success.value;

        expect(assessment.woundId, equals('wound-1'));
        expect(assessment.riskLevel, isA<WoundRiskLevel>());
        expect(assessment.riskFactors, isNotEmpty);
        expect(assessment.recommendations, isNotEmpty);
        expect(assessment.assessedAt, isA<DateTime>());

        // Deve incluir fatores básicos da ferida
        expect(
          assessment.riskFactors.any((f) => f.contains('Tipo de ferida')),
          isTrue,
        );
        expect(
          assessment.riskFactors.any((f) => f.contains('Localização')),
          isTrue,
        );
        expect(assessment.riskFactors.any((f) => f.contains('Status')), isTrue);

        verify(() => mockWoundRepository.getWoundById('wound-1')).called(1);
        verify(
          () => mockPatientRepository.getPatientById('patient-1'),
        ).called(1);
      },
    );

    test(
      'deve avaliar risco sem fatores do paciente quando desabilitado',
      () async {
        // Arrange
        final inputWithoutPatientFactors = AssessWoundRiskInput(
          woundId: 'wound-1',
          includePatientFactors: false,
        );

        when(
          () => mockWoundRepository.getWoundById('wound-1'),
        ).thenAnswer((_) async => mockWound);

        // Act
        final result = await useCase.execute(inputWithoutPatientFactors);

        // Assert
        expect(result, isA<Success<WoundRiskAssessment>>());
        final success = result as Success<WoundRiskAssessment>;
        final assessment = success.value;

        expect(assessment.riskFactors, isNotEmpty);
        expect(assessment.recommendations, isNotEmpty);

        verify(() => mockWoundRepository.getWoundById('wound-1')).called(1);
        verifyNever(() => mockPatientRepository.getPatientById(any()));
      },
    );

    test('deve falhar quando ferida não existe', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('inexistente'),
      ).thenAnswer((_) async => null);

      final invalidInput = AssessWoundRiskInput(woundId: 'inexistente');

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<WoundRiskAssessment>>());
      final failure = result as Failure<WoundRiskAssessment>;
      expect(failure.error, isA<NotFoundError>());
      expect((failure.error as NotFoundError).entityType, equals('Wound'));
      expect((failure.error as NotFoundError).entityId, equals('inexistente'));

      verify(() => mockWoundRepository.getWoundById('inexistente')).called(1);
      verifyNever(() => mockPatientRepository.getPatientById(any()));
    });

    test('deve falhar quando ID da ferida está vazio', () async {
      // Arrange
      final invalidInput = AssessWoundRiskInput(woundId: '');

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<WoundRiskAssessment>>());
      final failure = result as Failure<WoundRiskAssessment>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('woundId'));

      verifyNever(() => mockWoundRepository.getWoundById(any()));
      verifyNever(() => mockPatientRepository.getPatientById(any()));
    });

    test('deve funcionar mesmo quando paciente não é encontrado', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockPatientRepository.getPatientById('patient-1'),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<WoundRiskAssessment>>());
      final success = result as Success<WoundRiskAssessment>;

      // Deve ter fatores da ferida, mesmo sem dados do paciente
      expect(success.value.riskFactors, isNotEmpty);
      expect(success.value.recommendations, isNotEmpty);

      verify(() => mockWoundRepository.getWoundById('wound-1')).called(1);
      verify(() => mockPatientRepository.getPatientById('patient-1')).called(1);
    });

    test(
      'deve identificar ferida crônica e adicionar fatores de risco',
      () async {
        // Arrange
        final chronicWound = mockWound.copyWith(
          identificationDate: DateTime.now().subtract(
            const Duration(days: 40),
          ), // Ferida antiga
        );

        when(
          () => mockWoundRepository.getWoundById('wound-1'),
        ).thenAnswer((_) async => chronicWound);
        when(
          () => mockPatientRepository.getPatientById('patient-1'),
        ).thenAnswer((_) async => mockPatient);

        // Act
        final result = await useCase.execute(validInput);

        // Assert
        expect(result, isA<Success<WoundRiskAssessment>>());
        final success = result as Success<WoundRiskAssessment>;
        final assessment = success.value;

        // Deve incluir fatores de ferida crônica
        expect(
          assessment.riskFactors.any((f) => f.contains('crônica')),
          isTrue,
        );
        expect(
          assessment.recommendations.any(
            (r) => r.contains('abordagem terapêutica'),
          ),
          isTrue,
        );
      },
    );

    test('deve identificar localização de alto risco para infecção', () async {
      // Arrange
      final infectionRiskWound = mockWound.copyWith(
        location: WoundLocation.genitais, // Localização de alto risco
      );

      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => infectionRiskWound);
      when(
        () => mockPatientRepository.getPatientById('patient-1'),
      ).thenAnswer((_) async => mockPatient);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<WoundRiskAssessment>>());
      final success = result as Success<WoundRiskAssessment>;

      expect(
        success.value.riskFactors.any(
          (f) => f.contains('alto risco de infecção'),
        ),
        isTrue,
      );
      expect(
        success.value.recommendations.any((r) => r.contains('higiene')),
        isTrue,
      );
    });

    test('deve fornecer recomendações baseadas no nível de risco', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockPatientRepository.getPatientById('patient-1'),
      ).thenAnswer((_) async => mockPatient);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<WoundRiskAssessment>>());
      final success = result as Success<WoundRiskAssessment>;
      final assessment = success.value;

      // Deve ter recomendações apropriadas para o nível de risco
      expect(assessment.recommendations, isNotEmpty);

      switch (assessment.riskLevel) {
        case WoundRiskLevel.low:
          expect(
            assessment.recommendations.any((r) => r.contains('rotina')),
            isTrue,
          );
          break;
        case WoundRiskLevel.medium:
          expect(
            assessment.recommendations.any((r) => r.contains('frequência')),
            isTrue,
          );
          break;
        case WoundRiskLevel.high:
          expect(
            assessment.recommendations.any((r) => r.contains('imediato')),
            isTrue,
          );
          break;
      }
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<WoundRiskAssessment>>());
      final failure = result as Failure<WoundRiskAssessment>;
      expect(failure.error, isA<SystemError>());
      expect(
        (failure.error as SystemError).message,
        contains('Erro interno ao avaliar risco'),
      );
    });
  });
}
