import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cicatriza/domain/entities/assessment_manual.dart';
import 'package:cicatriza/domain/entities/wound.dart';
import 'package:cicatriza/domain/entities/patient.dart';
import 'package:cicatriza/domain/repositories/assessment_repository_manual.dart';
import 'package:cicatriza/domain/repositories/wound_repository.dart';
import 'package:cicatriza/domain/repositories/patient_repository.dart';
import 'package:cicatriza/domain/usecases/assessment/generate_assessment_report_use_case.dart';
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
  late GenerateAssessmentReportUseCase generateReportUseCase;
  late MockAssessmentRepository mockAssessmentRepository;
  late MockWoundRepository mockWoundRepository;
  late MockPatientRepository mockPatientRepository;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(FakeAssessmentManual.valid());
    registerFallbackValue(
      const GenerateAssessmentReportInput(assessmentId: 'test'),
    );

    // Register fallback values for Wound and Patient
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

    registerFallbackValue(
      Patient(
        id: 'test-patient',
        name: 'Test Patient',
        birthDate: now.subtract(const Duration(days: 365 * 30)),
        nameLowercase: 'test patient',
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

    generateReportUseCase = GenerateAssessmentReportUseCase(
      mockAssessmentRepository,
      mockWoundRepository,
      mockPatientRepository,
    );
  });

  group('GenerateAssessmentReportUseCase', () {
    test('should return failure for invalid assessment ID', () async {
      // Arrange
      final input = GenerateAssessmentReportInput(assessmentId: '');

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect(
        (result.errorOrNull as ValidationError).field,
        equals('assessmentId'),
      );

      verifyNever(
        () => mockAssessmentRepository.getAssessmentById(any<String>()),
      );
    });

    test('should return failure for invalid report format', () async {
      // Arrange
      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
        reportFormat: 'invalid',
      );

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect(
        (result.errorOrNull as ValidationError).field,
        equals('reportFormat'),
      );

      verifyNever(
        () => mockAssessmentRepository.getAssessmentById(any<String>()),
      );
    });

    test('should return failure when assessment does not exist', () async {
      // Arrange
      final input = GenerateAssessmentReportInput(
        assessmentId: 'non-existent-assessment',
      );

      when(
        () => mockAssessmentRepository.getAssessmentById(
          'non-existent-assessment',
        ),
      ).thenAnswer((_) async => null);

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<NotFoundError>());

      verify(
        () => mockAssessmentRepository.getAssessmentById(
          'non-existent-assessment',
        ),
      ).called(1);
    });

    test('should return failure when wound does not exist', () async {
      // Arrange
      final assessment = FakeAssessmentManual.valid(
        id: 'assessment-123',
        woundId: 'non-existent-wound',
      );

      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
      );

      when(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).thenAnswer((_) async => assessment);

      when(
        () => mockWoundRepository.getWoundById('non-existent-wound'),
      ).thenAnswer((_) async => null);

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<NotFoundError>());

      verify(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).called(1);
      verify(
        () => mockWoundRepository.getWoundById('non-existent-wound'),
      ).called(1);
    });

    test('should generate basic report successfully', () async {
      // Arrange
      final now = DateTime.now();
      final assessment = FakeAssessmentManual.valid(
        id: 'assessment-123',
        woundId: 'wound-456',
        lengthCm: 5.0,
        widthCm: 3.0,
        depthCm: 1.0,
        painScale: 4,
        notes: 'Test assessment notes',
      );

      final wound = Wound(
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

      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
        includePatientInfo: false,
        includeWoundHistory: false,
      );

      when(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).thenAnswer((_) async => assessment);

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenAnswer((_) async => wound);

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final report = result.valueOrNull;
      expect(report?.assessmentId, equals('assessment-123'));
      expect(report?.title, contains('Relatório de Avaliação'));
      expect(report?.content, isNotEmpty);
      expect(report?.generatedAt, isNotNull);

      verify(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).called(1);
      verify(() => mockWoundRepository.getWoundById('wound-456')).called(1);
    });

    test('should include patient info when requested', () async {
      // Arrange
      final now = DateTime.now();
      final assessment = FakeAssessmentManual.valid(
        id: 'assessment-123',
        woundId: 'wound-456',
      );

      final wound = Wound(
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

      final patient = Patient(
        id: 'patient-789',
        name: 'João Silva',
        birthDate: now.subtract(const Duration(days: 365 * 60)),
        nameLowercase: 'joão silva',
        createdAt: now,
        updatedAt: now,
      );

      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
        includePatientInfo: true,
        includeWoundHistory: false,
      );

      when(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).thenAnswer((_) async => assessment);

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenAnswer((_) async => wound);

      when(
        () => mockPatientRepository.getPatientById('patient-789'),
      ).thenAnswer((_) async => patient);

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final report = result.valueOrNull;
      expect(report?.title, contains('João Silva'));
      expect(report?.content, contains('DADOS DO PACIENTE'));
      expect(report?.content, contains('João Silva'));

      verify(
        () => mockPatientRepository.getPatientById('patient-789'),
      ).called(1);
    });

    test('should include wound history when requested', () async {
      // Arrange
      final now = DateTime.now();
      final assessment = FakeAssessmentManual.valid(
        id: 'assessment-123',
        woundId: 'wound-456',
      );

      final wound = Wound(
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

      final woundHistory = [wound];

      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
        includePatientInfo: false,
        includeWoundHistory: true,
      );

      when(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).thenAnswer((_) async => assessment);

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenAnswer((_) async => wound);

      when(
        () => mockWoundRepository.getWoundsByPatient('patient-789'),
      ).thenAnswer((_) async => woundHistory);

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final report = result.valueOrNull;
      expect(report?.content, contains('HISTÓRICO DE FERIDAS'));

      verify(
        () => mockWoundRepository.getWoundsByPatient('patient-789'),
      ).called(1);
    });

    test('should generate detailed format report', () async {
      // Arrange
      final now = DateTime.now();
      final assessment = FakeAssessmentManual.valid(
        id: 'assessment-123',
        woundId: 'wound-456',
        lengthCm: 8.5,
        widthCm: 6.2,
        depthCm: 2.1,
        painScale: 6,
        edgeAppearance: 'Irregular',
        woundBed: 'Granulação',
        exudateType: 'Seroso',
        exudateAmount: 'Moderado',
      );

      final wound = Wound(
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

      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
        reportFormat: 'detailed',
        includePatientInfo: false,
        includeWoundHistory: false,
      );

      when(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).thenAnswer((_) async => assessment);

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenAnswer((_) async => wound);

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final report = result.valueOrNull;
      expect(report?.content, contains('COMPRIMENTO: 8.5 cm'));
      expect(report?.content, contains('LARGURA: 6.2 cm'));
      expect(report?.content, contains('PROFUNDIDADE: 2.1 cm'));
      expect(report?.content, contains('DOR (0-10): 6'));
      expect(report?.content, contains('BORDA: Irregular'));
      expect(report?.content, contains('LEITO: Granulação'));
    });

    test('should generate summary format report', () async {
      // Arrange
      final now = DateTime.now();
      final assessment = FakeAssessmentManual.valid(
        id: 'assessment-123',
        woundId: 'wound-456',
        lengthCm: 4.0,
        widthCm: 3.0,
        depthCm: 1.5,
      );

      final wound = Wound(
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

      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
        reportFormat: 'summary',
        includePatientInfo: false,
        includeWoundHistory: false,
      );

      when(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).thenAnswer((_) async => assessment);

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenAnswer((_) async => wound);

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final report = result.valueOrNull;
      expect(report?.content, contains('SCORE DE GRAVIDADE'));
      // Volume = 4.0 * 3.0 * 1.5 = 18, should give severity score of 4
      expect(report?.content, contains('4/10'));
    });

    test('should include recommendations when requested', () async {
      // Arrange
      final now = DateTime.now();
      final assessment = FakeAssessmentManual.valid(
        id: 'assessment-123',
        woundId: 'wound-456',
        painScale: 8, // High pain
        exudateType: 'Purulento', // Infection signs
      );

      final wound = Wound(
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

      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
        includeRecommendations: true,
        includePatientInfo: false,
        includeWoundHistory: false,
      );

      when(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).thenAnswer((_) async => assessment);

      when(
        () => mockWoundRepository.getWoundById('wound-456'),
      ).thenAnswer((_) async => wound);

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final report = result.valueOrNull;
      expect(report?.recommendations, isNotEmpty);
      expect(report?.content, contains('RECOMENDAÇÕES'));
    });

    test('should handle repository errors gracefully', () async {
      // Arrange
      final input = GenerateAssessmentReportInput(
        assessmentId: 'assessment-123',
      );

      when(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await generateReportUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<SystemError>());
      expect(result.errorOrNull?.message, contains('Erro interno'));

      verify(
        () => mockAssessmentRepository.getAssessmentById('assessment-123'),
      ).called(1);
    });
  });
}
