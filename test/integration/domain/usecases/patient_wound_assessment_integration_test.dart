import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/entities/patient_manual.dart';
import '../../../../lib/domain/entities/wound_manual.dart';
import '../../../../lib/domain/entities/assessment_manual.dart';
import '../../../../lib/domain/repositories/patient_repository_manual.dart';
import '../../../../lib/domain/repositories/wound_repository_manual.dart';
import '../../../../lib/domain/repositories/assessment_repository_manual.dart';

import '../../../../lib/domain/usecases/patient/create_patient_use_case.dart';
import '../../../../lib/domain/usecases/patient/get_patient_use_case.dart';
import '../../../../lib/domain/usecases/wound/create_wound_use_case.dart';
import '../../../../lib/domain/usecases/wound/get_wound_history_use_case.dart';
import '../../../../lib/domain/usecases/assessment/create_assessment_use_case.dart';
import '../../../../lib/domain/usecases/assessment/analyze_healing_progress_use_case.dart';
import '../../../../lib/domain/usecases/assessment/generate_assessment_report_use_case.dart';

// Mock repositories
class MockPatientRepository extends Mock implements PatientRepository {}

class MockWoundRepository extends Mock implements WoundRepository {}

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

void main() {
  group('Patient-Wound-Assessment Integration Tests', () {
    late MockPatientRepository mockPatientRepository;
    late MockWoundRepository mockWoundRepository;
    late MockAssessmentRepository mockAssessmentRepository;

    late CreatePatientUseCase createPatientUseCase;
    late GetPatientUseCase getPatientUseCase;
    late CreateWoundUseCase createWoundUseCase;
    late GetWoundHistoryUseCase getWoundHistoryUseCase;
    late CreateAssessmentUseCase createAssessmentUseCase;
    late AnalyzeHealingProgressUseCase analyzeHealingProgressUseCase;
    late GenerateAssessmentReportUseCase generateAssessmentReportUseCase;

    setUp(() {
      mockPatientRepository = MockPatientRepository();
      mockWoundRepository = MockWoundRepository();
      mockAssessmentRepository = MockAssessmentRepository();

      createPatientUseCase = CreatePatientUseCase(mockPatientRepository);
      getPatientUseCase = GetPatientUseCase(mockPatientRepository);
      createWoundUseCase = CreateWoundUseCase(mockWoundRepository);
      getWoundHistoryUseCase = GetWoundHistoryUseCase(mockWoundRepository);
      createAssessmentUseCase = CreateAssessmentUseCase(
        mockAssessmentRepository,
      );
      analyzeHealingProgressUseCase = AnalyzeHealingProgressUseCase(
        mockAssessmentRepository,
      );
      generateAssessmentReportUseCase = GenerateAssessmentReportUseCase(
        mockAssessmentRepository,
        mockWoundRepository,
        mockPatientRepository,
      );
    });

    group('Complete Patient Journey', () {
      testWidgets('should create patient, wound, and assessment successfully', (
        tester,
      ) async {
        // Arrange
        final now = DateTime.now();

        final patient = PatientManual.create(
          name: 'João da Silva',
          birthDate: now.subtract(const Duration(days: 365 * 65)),
        );
        final createdPatient = patient.copyWith(id: 'patient-123');

        final wound = WoundManual.create(
          patientId: 'patient-123',
          type: 'Úlcera por Pressão',
          location: 'Sacro',
          locationDescription: 'Região sacral direita',
        );
        final createdWound = wound.copyWith(id: 'wound-456');

        final assessment = AssessmentManual.create(
          woundId: 'wound-456',
          painScale: 6,
          lengthCm: 8.5,
          widthCm: 6.0,
          depthCm: 2.5,
          edgeAppearance: 'Irregular',
          woundBed: 'Granulação',
          exudateType: 'Seroso',
          exudateAmount: 'Moderada',
          notes: 'Ferida apresentando melhora na granulação',
        );
        final createdAssessment = assessment.copyWith(id: 'assessment-789');

        // Mock repository responses
        when(
          () => mockPatientRepository.createPatient(any()),
        ).thenAnswer((_) async => createdPatient);
        when(
          () => mockPatientRepository.getPatientById('patient-123'),
        ).thenAnswer((_) async => createdPatient);

        when(
          () => mockWoundRepository.createWound(any()),
        ).thenAnswer((_) async => createdWound);
        when(
          () => mockWoundRepository.getWoundsByPatientId('patient-123'),
        ).thenAnswer((_) async => [createdWound]);
        when(
          () => mockWoundRepository.getWoundById('wound-456'),
        ).thenAnswer((_) async => createdWound);

        when(
          () => mockAssessmentRepository.createAssessment(any()),
        ).thenAnswer((_) async => createdAssessment);
        when(
          () => mockAssessmentRepository.getAssessmentsByWoundId('wound-456'),
        ).thenAnswer((_) async => [createdAssessment]);

        // Act & Assert - Complete journey

        // 1. Create patient
        final createPatientResult = await createPatientUseCase.execute(
          CreatePatientInput(
            name: 'João da Silva',
            birthDate: now.subtract(const Duration(days: 365 * 65)),
          ),
        );

        expect(createPatientResult.isSuccess, isTrue);
        final patientResult = createPatientResult.data!;
        expect(patientResult.name, equals('João da Silva'));
        expect(patientResult.id, equals('patient-123'));

        // 2. Create wound for patient
        final createWoundResult = await createWoundUseCase.execute(
          CreateWoundInput(
            patientId: patientResult.id,
            type: 'Úlcera por Pressão',
            location: 'Sacro',
            locationDescription: 'Região sacral direita',
          ),
        );

        expect(createWoundResult.isSuccess, isTrue);
        final woundResult = createWoundResult.data!;
        expect(woundResult.patientId, equals(patientResult.id));
        expect(woundResult.type, equals('Úlcera por Pressão'));

        // 3. Create assessment for wound
        final createAssessmentResult = await createAssessmentUseCase.execute(
          CreateAssessmentInput(
            woundId: woundResult.id,
            painScale: 6,
            lengthCm: 8.5,
            widthCm: 6.0,
            depthCm: 2.5,
            edgeAppearance: 'Irregular',
            woundBed: 'Granulação',
            exudateType: 'Seroso',
            exudateAmount: 'Moderada',
            notes: 'Ferida apresentando melhora na granulação',
          ),
        );

        expect(createAssessmentResult.isSuccess, isTrue);
        final assessmentResult = createAssessmentResult.data!;
        expect(assessmentResult.woundId, equals(woundResult.id));
        expect(assessmentResult.painScale, equals(6));

        // 4. Verify data integrity across Use Cases
        final getPatientResult = await getPatientUseCase.execute(
          GetPatientInput(patientId: patientResult.id),
        );
        expect(getPatientResult.isSuccess, isTrue);
        expect(getPatientResult.data!.id, equals(patientResult.id));

        final getWoundHistoryResult = await getWoundHistoryUseCase.execute(
          GetWoundHistoryInput(patientId: patientResult.id),
        );
        expect(getWoundHistoryResult.isSuccess, isTrue);
        expect(getWoundHistoryResult.data!.length, equals(1));
        expect(getWoundHistoryResult.data!.first.id, equals(woundResult.id));

        // Verify repository interactions
        verify(() => mockPatientRepository.createPatient(any())).called(1);
        verify(
          () => mockPatientRepository.getPatientById('patient-123'),
        ).called(1);
        verify(() => mockWoundRepository.createWound(any())).called(1);
        verify(
          () => mockWoundRepository.getWoundsByPatientId('patient-123'),
        ).called(1);
        verify(
          () => mockAssessmentRepository.createAssessment(any()),
        ).called(1);
      });

      testWidgets(
        'should analyze healing progress across multiple assessments',
        (tester) async {
          // Arrange
          final now = DateTime.now();
          final woundId = 'wound-456';

          final assessments = [
            AssessmentManual.create(
              woundId: woundId,
              painScale: 8,
              lengthCm: 10.0,
              widthCm: 8.0,
              depthCm: 3.0,
              woundBed: 'Necrose',
              exudateType: 'Purulento',
              exudateAmount: 'Grande',
            ).copyWith(
              id: 'assessment-1',
              date: now.subtract(const Duration(days: 14)),
            ),
            AssessmentManual.create(
              woundId: woundId,
              painScale: 6,
              lengthCm: 8.5,
              widthCm: 6.5,
              depthCm: 2.0,
              woundBed: 'Granulação',
              exudateType: 'Seroso',
              exudateAmount: 'Moderada',
            ).copyWith(
              id: 'assessment-2',
              date: now.subtract(const Duration(days: 7)),
            ),
            AssessmentManual.create(
              woundId: woundId,
              painScale: 4,
              lengthCm: 6.0,
              widthCm: 4.5,
              depthCm: 1.0,
              woundBed: 'Granulação',
              exudateType: 'Seroso',
              exudateAmount: 'Pequena',
            ).copyWith(id: 'assessment-3', date: now),
          ];

          when(
            () => mockAssessmentRepository.getAssessmentsByWoundId(woundId),
          ).thenAnswer((_) async => assessments);

          // Act
          final result = await analyzeHealingProgressUseCase.execute(
            AnalyzeHealingProgressInput(woundId: woundId),
          );

          // Assert
          expect(result.isSuccess, isTrue);
          final analysis = result.data!;

          // Verify healing progress indicators
          expect(analysis.totalAssessments, equals(3));
          expect(analysis.daysSinceFirstAssessment, equals(14));
          expect(analysis.isHealing, isTrue); // Pain and size decreased
          expect(analysis.volumeReductionPercentage, greaterThan(0));
          expect(analysis.painReductionPercentage, greaterThan(0));

          // Verify repository interaction
          verify(
            () => mockAssessmentRepository.getAssessmentsByWoundId(woundId),
          ).called(1);
        },
      );

      testWidgets(
        'should generate comprehensive assessment report with cross-domain data',
        (tester) async {
          // Arrange
          final now = DateTime.now();
          final patient = PatientManual(
            id: 'patient-123',
            name: 'Maria dos Santos',
            birthDate: now.subtract(const Duration(days: 365 * 75)),
            nameLowercase: 'maria dos santos',
            createdAt: now,
            updatedAt: now,
          );

          final wound = WoundManual(
            id: 'wound-456',
            patientId: 'patient-123',
            type: 'Úlcera Venosa',
            location: 'Perna Direita',
            locationDescription: 'Terço inferior da perna direita',
            status: 'Em Cicatrização',
            createdAt: now.subtract(const Duration(days: 30)),
            updatedAt: now,
          );

          final assessment = AssessmentManual(
            id: 'assessment-789',
            woundId: 'wound-456',
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

          when(
            () => mockAssessmentRepository.getAssessmentById('assessment-789'),
          ).thenAnswer((_) async => assessment);
          when(
            () => mockWoundRepository.getWoundById('wound-456'),
          ).thenAnswer((_) async => wound);
          when(
            () => mockPatientRepository.getPatientById('patient-123'),
          ).thenAnswer((_) async => patient);
          when(
            () => mockWoundRepository.getWoundsByPatientId('patient-123'),
          ).thenAnswer((_) async => [wound]);

          // Act
          final result = await generateAssessmentReportUseCase.execute(
            GenerateAssessmentReportInput(
              assessmentId: 'assessment-789',
              includePatientInfo: true,
              includeWoundHistory: true,
              includeRecommendations: true,
              reportFormat: 'detailed',
            ),
          );

          // Assert
          expect(result.isSuccess, isTrue);
          final report = result.data!;

          expect(report.assessmentId, equals('assessment-789'));
          expect(report.title, contains('Maria dos Santos'));
          expect(report.content, contains('DADOS DO PACIENTE'));
          expect(report.content, contains('Maria dos Santos'));
          expect(report.content, contains('DADOS DA FERIDA'));
          expect(report.content, contains('Úlcera Venosa'));
          expect(report.content, contains('DADOS DA AVALIAÇÃO'));
          expect(report.content, contains('4.0 cm')); // Length
          expect(report.content, contains('HISTÓRICO DE FERIDAS'));
          expect(report.content, contains('RECOMENDAÇÕES'));
          expect(report.recommendations.isNotEmpty, isTrue);

          // Verify cross-repository interactions
          verify(
            () => mockAssessmentRepository.getAssessmentById('assessment-789'),
          ).called(1);
          verify(() => mockWoundRepository.getWoundById('wound-456')).called(1);
          verify(
            () => mockPatientRepository.getPatientById('patient-123'),
          ).called(1);
          verify(
            () => mockWoundRepository.getWoundsByPatientId('patient-123'),
          ).called(1);
        },
      );
    });

    group('Error Handling Integration', () {
      testWidgets('should handle cascading failures gracefully', (
        tester,
      ) async {
        // Arrange - Patient exists but wound doesn't
        when(
          () => mockPatientRepository.getPatientById('patient-123'),
        ).thenAnswer(
          (_) async => PatientManual(
            id: 'patient-123',
            name: 'Test Patient',
            birthDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
            nameLowercase: 'test patient',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        when(
          () => mockWoundRepository.getWoundById('invalid-wound'),
        ).thenAnswer((_) async => null);

        // Act
        final result = await generateAssessmentReportUseCase.execute(
          GenerateAssessmentReportInput(
            assessmentId: 'assessment-789',
            includePatientInfo: true,
          ),
        );

        // Assert - Should handle missing wound gracefully
        expect(result.isFailure, isTrue);
        verify(
          () => mockPatientRepository.getPatientById('patient-123'),
        ).called(1);
        verify(
          () => mockWoundRepository.getWoundById('invalid-wound'),
        ).called(1);
      });

      testWidgets('should validate business rules across domains', (
        tester,
      ) async {
        // Arrange - Try to create assessment for non-existent wound
        when(
          () => mockAssessmentRepository.createAssessment(any()),
        ).thenThrow(Exception('Wound not found'));

        // Act
        final result = await createAssessmentUseCase.execute(
          CreateAssessmentInput(
            woundId: 'non-existent-wound',
            painScale: 5,
            lengthCm: 5.0,
            widthCm: 4.0,
            depthCm: 2.0,
          ),
        );

        // Assert
        expect(result.isFailure, isTrue);
        verify(
          () => mockAssessmentRepository.createAssessment(any()),
        ).called(1);
      });
    });

    group('Repository Interface Validation', () {
      testWidgets('should ensure consistent data flow between repositories', (
        tester,
      ) async {
        // Arrange
        final patientId = 'patient-123';
        final woundId = 'wound-456';

        final patient = PatientManual(
          id: patientId,
          name: 'Test Patient',
          birthDate: DateTime.now().subtract(const Duration(days: 365 * 40)),
          nameLowercase: 'test patient',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final wounds = [
          WoundManual(
            id: woundId,
            patientId: patientId,
            type: 'Úlcera por Pressão',
            location: 'Sacro',
            status: 'Ativa',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        final assessments = [
          AssessmentManual(
            id: 'assessment-1',
            woundId: woundId,
            date: DateTime.now(),
            painScale: 6,
            lengthCm: 5.0,
            widthCm: 4.0,
            depthCm: 2.0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        when(
          () => mockPatientRepository.getPatientById(patientId),
        ).thenAnswer((_) async => patient);
        when(
          () => mockWoundRepository.getWoundsByPatientId(patientId),
        ).thenAnswer((_) async => wounds);
        when(
          () => mockAssessmentRepository.getAssessmentsByWoundId(woundId),
        ).thenAnswer((_) async => assessments);

        // Act - Verify relationships
        final patientResult = await getPatientUseCase.execute(
          GetPatientInput(patientId: patientId),
        );

        final woundsResult = await getWoundHistoryUseCase.execute(
          GetWoundHistoryInput(patientId: patientId),
        );

        final progressResult = await analyzeHealingProgressUseCase.execute(
          AnalyzeHealingProgressInput(woundId: woundId),
        );

        // Assert - Data consistency
        expect(patientResult.isSuccess, isTrue);
        expect(woundsResult.isSuccess, isTrue);
        expect(progressResult.isSuccess, isTrue);

        expect(patientResult.data!.id, equals(patientId));
        expect(woundsResult.data!.first.patientId, equals(patientId));
        expect(woundsResult.data!.first.id, equals(woundId));

        // Verify proper repository method calls
        verify(() => mockPatientRepository.getPatientById(patientId)).called(1);
        verify(
          () => mockWoundRepository.getWoundsByPatientId(patientId),
        ).called(1);
        verify(
          () => mockAssessmentRepository.getAssessmentsByWoundId(woundId),
        ).called(1);
      });
    });
  });
}
