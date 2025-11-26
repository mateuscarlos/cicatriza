import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cicatriza/domain/entities/assessment_manual.dart';
import 'package:cicatriza/domain/entities/wound.dart';
import 'package:cicatriza/domain/repositories/assessment_repository_manual.dart';
import 'package:cicatriza/domain/repositories/wound_repository.dart';
import 'package:cicatriza/domain/repositories/patient_repository.dart';
import 'package:cicatriza/domain/usecases/assessment/analyze_healing_progress_use_case.dart';
import 'package:cicatriza/domain/usecases/base/use_case.dart';

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

class MockWoundRepository extends Mock implements WoundRepository {}

class MockPatientRepository extends Mock implements PatientRepository {}

class FakeAssessmentManual extends AssessmentManual {
  const FakeAssessmentManual({
    required super.id,
    required super.woundId,
    required super.date,
    required super.createdAt,
    required super.updatedAt,
    super.lengthCm,
    super.widthCm,
    super.depthCm,
    super.painScale,
    super.edgeAppearance,
    super.woundBed,
    super.exudateType,
    super.exudateAmount,
    super.notes,
  });

  factory FakeAssessmentManual.valid({
    String? id,
    String? woundId,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? lengthCm,
    double? widthCm,
    double? depthCm,
    int? painScale,
    String? edgeAppearance,
    String? woundBed,
    String? exudateType,
    String? exudateAmount,
    String? notes,
  }) {
    final now = DateTime.now();
    return FakeAssessmentManual(
      id: id ?? 'assessment-123',
      woundId: woundId ?? 'wound-456',
      date: date ?? now,
      lengthCm: lengthCm ?? 10.0,
      widthCm: widthCm ?? 8.0,
      depthCm: depthCm ?? 2.0,
      painScale: painScale ?? 5,
      edgeAppearance:
          edgeAppearance ?? AssessmentManual.edgeAppearanceOptions.first,
      woundBed: woundBed ?? AssessmentManual.woundBedOptions.first,
      exudateType: exudateType ?? AssessmentManual.exudateTypeOptions.first,
      exudateAmount:
          exudateAmount ?? AssessmentManual.exudateAmountOptions.first,
      notes: notes ?? 'Test assessment notes',
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }
}

void main() {
  late AnalyzeHealingProgressUseCase analyzeProgressUseCase;
  late MockAssessmentRepository mockAssessmentRepository;
  late MockWoundRepository mockWoundRepository;
  late MockPatientRepository mockPatientRepository;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(FakeAssessmentManual.valid());
    registerFallbackValue(
      const AnalyzeHealingProgressInput(woundId: 'test', daysToAnalyze: 30),
    );

    // Register fallback values for Wound
    final now = DateTime.now();
    registerFallbackValue(
      Wound(
        id: 'test-wound',
        patientId: 'test-patient',
        description: 'Test wound',
        type: WoundType.ulceraPressao,
        location: WoundLocation.sacro,
        status: WoundStatus.ativa,
        identificationDate: now,
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  setUp(() {
    mockAssessmentRepository = MockAssessmentRepository();
    mockWoundRepository = MockWoundRepository();
    mockPatientRepository = MockPatientRepository();

    // Setup default patient repository behavior
    when(
      () => mockPatientRepository.getPatientById(any<String>()),
    ).thenAnswer((_) async => null);

    analyzeProgressUseCase = AnalyzeHealingProgressUseCase(
      mockAssessmentRepository,
      mockWoundRepository,
      mockPatientRepository,
    );
  });

  group('AnalyzeHealingProgressUseCase', () {
    test('should return failure for invalid wound ID', () async {
      // Arrange
      final input = AnalyzeHealingProgressInput(woundId: '', daysToAnalyze: 30);

      // Act
      final result = await analyzeProgressUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect((result.errorOrNull as ValidationError).field, equals('woundId'));

      verifyNever(() => mockWoundRepository.getWoundById(any<String>()));
      verifyNever(
        () => mockAssessmentRepository.getAssessmentsWithFilters(
          woundId: any<String>(named: 'woundId'),
          fromDate: any<DateTime>(named: 'fromDate'),
          toDate: any<DateTime>(named: 'toDate'),
        ),
      );
    });

    test('should return failure for invalid days to analyze', () async {
      // Arrange
      final input = AnalyzeHealingProgressInput(
        woundId: 'wound-123',
        daysToAnalyze: 0,
      );

      // Act
      final result = await analyzeProgressUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect(
        (result.errorOrNull as ValidationError).field,
        equals('daysToAnalyze'),
      );

      verifyNever(() => mockWoundRepository.getWoundById(any<String>()));
      verifyNever(
        () => mockAssessmentRepository.getAssessmentsWithFilters(
          woundId: any<String>(named: 'woundId'),
          fromDate: any<DateTime>(named: 'fromDate'),
          toDate: any<DateTime>(named: 'toDate'),
        ),
      );
    });

    test('should return failure when wound does not exist', () async {
      // Arrange
      final input = AnalyzeHealingProgressInput(
        woundId: 'non-existent-wound',
        daysToAnalyze: 30,
      );

      when(
        () => mockWoundRepository.getWoundById('non-existent-wound'),
      ).thenAnswer((_) async => null);

      // Act
      final result = await analyzeProgressUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<NotFoundError>());

      verify(
        () => mockWoundRepository.getWoundById('non-existent-wound'),
      ).called(1);
      verifyNever(
        () => mockAssessmentRepository.getAssessmentsWithFilters(
          woundId: any<String>(named: 'woundId'),
          fromDate: any<DateTime>(named: 'fromDate'),
          toDate: any<DateTime>(named: 'toDate'),
        ),
      );
    });

    test('should return insufficient data when no assessments exist', () async {
      // Arrange
      final now = DateTime.now();
      final validWound = Wound(
        id: 'wound-456',
        patientId: 'patient-789',
        description: 'Pressure ulcer',
        type: WoundType.ulceraPressao,
        location: WoundLocation.sacro,
        status: WoundStatus.ativa,
        identificationDate: now,
        createdAt: now,
        updatedAt: now,
      );

      final input = AnalyzeHealingProgressInput(
        woundId: 'wound-456',
        daysToAnalyze: 30,
      );

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenAnswer((_) async => validWound);

      when(
        () => mockAssessmentRepository.getAssessmentsWithFilters(
          woundId: 'wound-456',
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
        ),
      ).thenAnswer((_) async => <AssessmentManual>[]);

      // Act
      final result = await analyzeProgressUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final analysis = result.valueOrNull;
      expect(analysis?.woundId, equals('wound-456'));
      expect(analysis?.overallTrend, equals(HealingTrend.insufficient));
      expect(analysis?.assessmentsAnalyzed, equals(0));

      verify(() => mockWoundRepository.getWoundById('wound-456')).called(1);
      verify(
        () => mockAssessmentRepository.getAssessmentsWithFilters(
          woundId: 'wound-456',
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
        ),
      ).called(1);
    });

    test(
      'should analyze improving trend with decreasing wound dimensions',
      () async {
        // Arrange
        final now = DateTime.now();
        final validWound = Wound(
          id: 'wound-456',
          patientId: 'patient-789',
          description: 'Pressure ulcer',
          type: WoundType.ulceraPressao,
          location: WoundLocation.sacro,
          status: WoundStatus.ativa,
          identificationDate: now,
          createdAt: now,
          updatedAt: now,
        );

        final assessments = [
          FakeAssessmentManual.valid(
            id: 'assessment-1',
            woundId: 'wound-456',
            date: now.subtract(const Duration(days: 15)),
            lengthCm: 15.0,
            widthCm: 12.0,
            depthCm: 3.0,
          ),
          FakeAssessmentManual.valid(
            id: 'assessment-2',
            woundId: 'wound-456',
            date: now.subtract(const Duration(days: 7)),
            lengthCm: 12.0,
            widthCm: 10.0,
            depthCm: 2.5,
          ),
          FakeAssessmentManual.valid(
            id: 'assessment-3',
            woundId: 'wound-456',
            date: now,
            lengthCm: 8.0,
            widthCm: 6.0,
            depthCm: 1.5,
          ),
        ];

        final input = AnalyzeHealingProgressInput(
          woundId: 'wound-456',
          daysToAnalyze: 30,
        );

        when(
          () => mockWoundRepository.getWoundById('wound-456'),
        ).thenAnswer((_) async => validWound);

        when(
          () => mockAssessmentRepository.getAssessmentsWithFilters(
            woundId: 'wound-456',
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          ),
        ).thenAnswer((_) async => assessments);

        // Act
        final result = await analyzeProgressUseCase.execute(input);

        // Assert
        expect(result.isSuccess, isTrue);
        final analysis = result.valueOrNull;
        expect(analysis?.woundId, equals('wound-456'));
        expect(analysis?.overallTrend, equals(HealingTrend.improving));
        expect(analysis?.assessmentsAnalyzed, equals(3));
        verify(() => mockWoundRepository.getWoundById('wound-456')).called(1);
        verify(
          () => mockAssessmentRepository.getAssessmentsWithFilters(
            woundId: 'wound-456',
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          ),
        ).called(1);
      },
    );

    test(
      'should analyze declining trend with increasing wound dimensions',
      () async {
        // Arrange
        final now = DateTime.now();
        final validWound = Wound(
          id: 'wound-456',
          patientId: 'patient-789',
          description: 'Pressure ulcer',
          type: WoundType.ulceraPressao,
          location: WoundLocation.sacro,
          status: WoundStatus.ativa,
          identificationDate: now,
          createdAt: now,
          updatedAt: now,
        );

        final assessments = [
          FakeAssessmentManual.valid(
            id: 'assessment-1',
            woundId: 'wound-456',
            date: now.subtract(const Duration(days: 15)),
            lengthCm: 8.0,
            widthCm: 6.0,
            depthCm: 1.5,
          ),
          FakeAssessmentManual.valid(
            id: 'assessment-2',
            woundId: 'wound-456',
            date: now.subtract(const Duration(days: 7)),
            lengthCm: 12.0,
            widthCm: 10.0,
            depthCm: 2.5,
          ),
          FakeAssessmentManual.valid(
            id: 'assessment-3',
            woundId: 'wound-456',
            date: now,
            lengthCm: 15.0,
            widthCm: 12.0,
            depthCm: 3.0,
          ),
        ];

        final input = AnalyzeHealingProgressInput(
          woundId: 'wound-456',
          daysToAnalyze: 30,
        );

        when(
          () => mockWoundRepository.getWoundById('wound-456'),
        ).thenAnswer((_) async => validWound);

        when(
          () => mockAssessmentRepository.getAssessmentsWithFilters(
            woundId: 'wound-456',
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          ),
        ).thenAnswer((_) async => assessments);

        // Act
        final result = await analyzeProgressUseCase.execute(input);

        // Assert
        expect(result.isSuccess, isTrue);
        final analysis = result.valueOrNull;
        expect(analysis?.woundId, equals('wound-456'));
        expect(analysis?.overallTrend, equals(HealingTrend.declining));
        expect(analysis?.assessmentsAnalyzed, equals(3));

        verify(() => mockWoundRepository.getWoundById('wound-456')).called(1);
        verify(
          () => mockAssessmentRepository.getAssessmentsWithFilters(
            woundId: 'wound-456',
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          ),
        ).called(1);
      },
    );

    test(
      'should analyze stable trend with minimal dimension changes',
      () async {
        // Arrange
        final now = DateTime.now();
        final validWound = Wound(
          id: 'wound-456',
          patientId: 'patient-789',
          description: 'Pressure ulcer',
          type: WoundType.ulceraPressao,
          location: WoundLocation.sacro,
          status: WoundStatus.ativa,
          identificationDate: now,
          createdAt: now,
          updatedAt: now,
        );

        final assessments = [
          FakeAssessmentManual.valid(
            id: 'assessment-1',
            woundId: 'wound-456',
            date: now.subtract(const Duration(days: 15)),
            lengthCm: 10.0,
            widthCm: 8.0,
            depthCm: 2.0,
          ),
          FakeAssessmentManual.valid(
            id: 'assessment-2',
            woundId: 'wound-456',
            date: now.subtract(const Duration(days: 7)),
            lengthCm: 10.2,
            widthCm: 7.9,
            depthCm: 2.1,
          ),
          FakeAssessmentManual.valid(
            id: 'assessment-3',
            woundId: 'wound-456',
            date: now,
            lengthCm: 9.8,
            widthCm: 8.1,
            depthCm: 1.9,
          ),
        ];

        final input = AnalyzeHealingProgressInput(
          woundId: 'wound-456',
          daysToAnalyze: 30,
        );

        when(
          () => mockWoundRepository.getWoundById('wound-456'),
        ).thenAnswer((_) async => validWound);

        when(
          () => mockAssessmentRepository.getAssessmentsWithFilters(
            woundId: 'wound-456',
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          ),
        ).thenAnswer((_) async => assessments);

        // Act
        final result = await analyzeProgressUseCase.execute(input);

        // Assert
        expect(result.isSuccess, isTrue);
        final analysis = result.valueOrNull;
        expect(analysis?.woundId, equals('wound-456'));
        expect(analysis?.overallTrend, equals(HealingTrend.stable));
        expect(analysis?.assessmentsAnalyzed, equals(3));

        verify(() => mockWoundRepository.getWoundById('wound-456')).called(1);
        verify(
          () => mockAssessmentRepository.getAssessmentsWithFilters(
            woundId: 'wound-456',
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          ),
        ).called(1);
      },
    );

    test('should handle repository errors gracefully', () async {
      // Arrange
      final input = AnalyzeHealingProgressInput(
        woundId: 'wound-456',
        daysToAnalyze: 30,
      );

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await analyzeProgressUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<SystemError>());
      expect(result.errorOrNull?.message, contains('Erro interno'));

      verify(() => mockWoundRepository.getWoundById('wound-456')).called(1);
    });

    test('should include recommendations when requested', () async {
      // Arrange
      final now = DateTime.now();
      final validWound = Wound(
        id: 'wound-456',
        patientId: 'patient-789',
        description: 'Pressure ulcer',
        type: WoundType.ulceraPressao,
        location: WoundLocation.sacro,
        status: WoundStatus.ativa,
        identificationDate: now,
        createdAt: now,
        updatedAt: now,
      );

      final assessments = [
        FakeAssessmentManual.valid(
          id: 'assessment-1',
          woundId: 'wound-456',
          date: now.subtract(const Duration(days: 7)),
          lengthCm: 8.0,
          widthCm: 6.0,
          depthCm: 1.5,
        ),
        FakeAssessmentManual.valid(
          id: 'assessment-2',
          woundId: 'wound-456',
          date: now,
          lengthCm: 7.0,
          widthCm: 5.5,
          depthCm: 1.2,
        ),
      ];

      final input = AnalyzeHealingProgressInput(
        woundId: 'wound-456',
        daysToAnalyze: 30,
        includeRecommendations: true,
      );

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenAnswer((_) async => validWound);

      when(
        () => mockAssessmentRepository.getAssessmentsWithFilters(
          woundId: 'wound-456',
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
        ),
      ).thenAnswer((_) async => assessments);

      // Act
      final result = await analyzeProgressUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final analysis = result.valueOrNull;
      expect(analysis?.recommendations, isNotEmpty);

      verify(() => mockWoundRepository.getWoundById('wound-456')).called(1);
      verify(
        () => mockAssessmentRepository.getAssessmentsWithFilters(
          woundId: 'wound-456',
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
        ),
      ).called(1);
    });
  });
}
