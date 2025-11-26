import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/entities/patient_manual.dart';
import '../../../../lib/domain/entities/wound_manual.dart';
import '../../../../lib/domain/entities/assessment_manual.dart';
import '../../../../lib/domain/repositories/patient_repository_manual.dart';
import '../../../../lib/domain/repositories/wound_repository_manual.dart';
import '../../../../lib/domain/repositories/assessment_repository_manual.dart';

import '../../../../lib/domain/usecases/assessment/create_assessment_use_case.dart';
import '../../../../lib/domain/usecases/assessment/generate_assessment_report_use_case.dart';

// Mock repositories para testes de integração
class MockPatientRepository extends Mock implements PatientRepository {}

class MockWoundRepository extends Mock implements WoundRepository {}

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

void main() {
  group('Domain Integration Tests', () {
    late MockPatientRepository mockPatientRepository;
    late MockWoundRepository mockWoundRepository;
    late MockAssessmentRepository mockAssessmentRepository;

    late CreateAssessmentUseCase createAssessmentUseCase;
    late GenerateAssessmentReportUseCase generateReportUseCase;

    setUpAll(() {
      // Register fallback values for mocks
      registerFallbackValue(
        AssessmentManual.create(
          woundId: 'test-wound-id',
          painScale: 5,
          lengthCm: 5.0,
          widthCm: 4.0,
          depthCm: 2.0,
        ),
      );
    });

    setUp(() {
      mockPatientRepository = MockPatientRepository();
      mockWoundRepository = MockWoundRepository();
      mockAssessmentRepository = MockAssessmentRepository();

      createAssessmentUseCase = CreateAssessmentUseCase(
        mockAssessmentRepository,
        mockWoundRepository,
      );

      generateReportUseCase = GenerateAssessmentReportUseCase(
        mockAssessmentRepository,
        mockWoundRepository,
        mockPatientRepository,
      );
    });

    group('Assessment-Wound-Patient Integration', () {
      test(
        'should validate cross-domain relationships when creating assessment',
        () async {
          // Arrange
          const woundId = 'wound-123';
          final wound = WoundManual(
            id: woundId,
            patientId: 'patient-123',
            type: 'Úlcera por Pressão',
            location: 'Sacro',
            status: 'Ativa',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final assessmentInput = CreateAssessmentInput(
            woundId: woundId,
            painScale: 7,
            lengthCm: 8.0,
            widthCm: 6.0,
            depthCm: 2.5,
            edgeAppearance: 'Irregular',
            woundBed: 'Granulação',
            exudateType: 'Seroso',
            exudateAmount: 'Moderada',
            notes: 'Ferida apresentando evolução positiva',
          );

          final expectedAssessment = AssessmentManual.create(
            woundId: woundId,
            painScale: 7,
            lengthCm: 8.0,
            widthCm: 6.0,
            depthCm: 2.5,
            edgeAppearance: 'Irregular',
            woundBed: 'Granulação',
            exudateType: 'Seroso',
            exudateAmount: 'Moderada',
            notes: 'Ferida apresentando evolução positiva',
          ).copyWith(id: 'assessment-456');

          // Mock repository responses
          when(
            () => mockWoundRepository.getWoundById(woundId),
          ).thenAnswer((_) async => wound);
          when(
            () => mockAssessmentRepository.createAssessment(any()),
          ).thenAnswer((_) async => expectedAssessment);

          // Act
          final result = await createAssessmentUseCase.execute(assessmentInput);

          // Assert
          expect(result.isSuccess, isTrue);
          final createdAssessment = result.valueOrNull!;
          expect(createdAssessment.woundId, equals(woundId));
          expect(createdAssessment.painScale, equals(7));
          expect(createdAssessment.lengthCm, equals(8.0));

          // Verify repository interactions
          verify(() => mockWoundRepository.getWoundById(woundId)).called(1);
          verify(
            () => mockAssessmentRepository.createAssessment(any()),
          ).called(1);
        },
      );

      test(
        'should fail assessment creation when wound does not exist',
        () async {
          // Arrange
          const invalidWoundId = 'invalid-wound-123';
          final assessmentInput = CreateAssessmentInput(
            woundId: invalidWoundId,
            painScale: 5,
            lengthCm: 5.0,
            widthCm: 4.0,
            depthCm: 2.0,
          );

          // Mock repository to return null (wound not found)
          when(
            () => mockWoundRepository.getWoundById(invalidWoundId),
          ).thenAnswer((_) async => null);

          // Act
          final result = await createAssessmentUseCase.execute(assessmentInput);

          // Assert
          expect(result.isFailure, isTrue);
          expect(result.errorOrNull, isA<NotFoundError>());

          // Verify repository interactions
          verify(
            () => mockWoundRepository.getWoundById(invalidWoundId),
          ).called(1);
          verifyNever(() => mockAssessmentRepository.createAssessment(any()));
        },
      );

      test(
        'should generate comprehensive report with cross-domain data',
        () async {
          // Arrange
          final now = DateTime.now();
          const assessmentId = 'assessment-789';
          const woundId = 'wound-456';
          const patientId = 'patient-123';

          final assessment = AssessmentManual(
            id: assessmentId,
            woundId: woundId,
            date: now,
            painScale: 5,
            lengthCm: 4.0,
            widthCm: 3.0,
            depthCm: 1.5,
            edgeAppearance: 'Regular',
            woundBed: 'Granulação',
            exudateType: 'Seroso',
            exudateAmount: 'Pequena',
            notes: 'Ferida apresentando boa evolução',
            createdAt: now,
            updatedAt: now,
          );

          final wound = WoundManual(
            id: woundId,
            patientId: patientId,
            type: 'Úlcera Venosa',
            location: 'Perna Direita',
            locationDescription: 'Terço inferior da perna direita',
            status: 'Em Cicatrização',
            createdAt: now.subtract(const Duration(days: 30)),
            updatedAt: now,
          );

          final patient = PatientManual(
            id: patientId,
            name: 'Maria dos Santos',
            birthDate: now.subtract(const Duration(days: 365 * 75)),
            nameLowercase: 'maria dos santos',
            createdAt: now,
            updatedAt: now,
          );

          // Mock repository responses
          when(
            () => mockAssessmentRepository.getAssessmentById(assessmentId),
          ).thenAnswer((_) async => assessment);
          when(
            () => mockWoundRepository.getWoundById(woundId),
          ).thenAnswer((_) async => wound);
          when(
            () => mockPatientRepository.getPatientById(patientId),
          ).thenAnswer((_) async => patient);
          when(
            () => mockWoundRepository.getWoundsByPatientId(patientId),
          ).thenAnswer((_) async => [wound]);

          // Act
          final result = await generateReportUseCase.execute(
            GenerateAssessmentReportInput(
              assessmentId: assessmentId,
              includePatientInfo: true,
              includeWoundHistory: true,
              includeRecommendations: true,
              reportFormat: 'detailed',
            ),
          );

          // Assert
          expect(result.isSuccess, isTrue);
          final report = result.valueOrNull!;

          expect(report.assessmentId, equals(assessmentId));
          expect(report.title, contains('Maria dos Santos'));
          expect(report.content, contains('DADOS DO PACIENTE'));
          expect(report.content, contains('Maria dos Santos'));
          expect(report.content, contains('DADOS DA FERIDA'));
          expect(report.content, contains('Úlcera Venosa'));
          expect(report.content, contains('DADOS DA AVALIAÇÃO'));
          expect(report.content, contains('4.0 cm'));
          expect(report.content, contains('HISTÓRICO DE FERIDAS'));
          expect(report.content, contains('RECOMENDAÇÕES'));
          expect(report.recommendations.isNotEmpty, isTrue);

          // Verify cross-repository interactions demonstrate proper integration
          verify(
            () => mockAssessmentRepository.getAssessmentById(assessmentId),
          ).called(1);
          verify(() => mockWoundRepository.getWoundById(woundId)).called(1);
          verify(
            () => mockPatientRepository.getPatientById(patientId),
          ).called(1);
          verify(
            () => mockWoundRepository.getWoundsByPatientId(patientId),
          ).called(1);
        },
      );

      test(
        'should handle missing dependencies gracefully in report generation',
        () async {
          // Arrange
          const assessmentId = 'assessment-789';

          // Mock repository to return null (assessment not found)
          when(
            () => mockAssessmentRepository.getAssessmentById(assessmentId),
          ).thenAnswer((_) async => null);

          // Act
          final result = await generateReportUseCase.execute(
            GenerateAssessmentReportInput(
              assessmentId: assessmentId,
              includePatientInfo: true,
            ),
          );

          // Assert - Should handle missing assessment gracefully
          expect(result.isFailure, isTrue);
          expect(result.errorOrNull, isA<NotFoundError>());

          // Verify proper error handling without cascading calls
          verify(
            () => mockAssessmentRepository.getAssessmentById(assessmentId),
          ).called(1);
          verifyNever(() => mockWoundRepository.getWoundById(any()));
          verifyNever(() => mockPatientRepository.getPatientById(any()));
        },
      );

      test('should validate data consistency across repositories', () async {
        // Arrange
        final now = DateTime.now();
        const assessmentId = 'assessment-100';
        const woundId = 'wound-200';
        const patientId = 'patient-300';

        final assessment = AssessmentManual(
          id: assessmentId,
          woundId: woundId,
          date: now,
          painScale: 6,
          lengthCm: 5.0,
          widthCm: 4.0,
          depthCm: 2.0,
          createdAt: now,
          updatedAt: now,
        );

        final wound = WoundManual(
          id: woundId,
          patientId: patientId,
          type: 'Úlcera por Pressão',
          location: 'Sacro',
          status: 'Ativa',
          createdAt: now,
          updatedAt: now,
        );

        final patient = PatientManual(
          id: patientId,
          name: 'João Silva',
          birthDate: now.subtract(const Duration(days: 365 * 60)),
          nameLowercase: 'joão silva',
          createdAt: now,
          updatedAt: now,
        );

        // Mock repository responses
        when(
          () => mockAssessmentRepository.getAssessmentById(assessmentId),
        ).thenAnswer((_) async => assessment);
        when(
          () => mockWoundRepository.getWoundById(woundId),
        ).thenAnswer((_) async => wound);
        when(
          () => mockPatientRepository.getPatientById(patientId),
        ).thenAnswer((_) async => patient);

        // Act
        final result = await generateReportUseCase.execute(
          GenerateAssessmentReportInput(
            assessmentId: assessmentId,
            includePatientInfo: true,
            reportFormat: 'summary',
          ),
        );

        // Assert - Data consistency validation
        expect(result.isSuccess, isTrue);
        final report = result.valueOrNull!;

        // Verify that related entities are correctly linked
        expect(assessment.woundId, equals(wound.id));
        expect(wound.patientId, equals(patient.id));

        // Verify report contains consistent data
        expect(report.title, contains('João Silva'));
        expect(report.content, contains('João Silva'));
        expect(report.content, contains('Úlcera por Pressão'));
        expect(report.content, contains('Sacro'));

        // Verify repository call sequence demonstrates proper integration
        verify(
          () => mockAssessmentRepository.getAssessmentById(assessmentId),
        ).called(1);
        verify(() => mockWoundRepository.getWoundById(woundId)).called(1);
        verify(() => mockPatientRepository.getPatientById(patientId)).called(1);
      });
    });
  });
}
