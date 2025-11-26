import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cicatriza/domain/entities/assessment_manual.dart';
import 'package:cicatriza/domain/repositories/assessment_repository_manual.dart';
import 'package:cicatriza/domain/usecases/assessment/update_assessment_use_case.dart';
import 'package:cicatriza/domain/usecases/base/use_case.dart';

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

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

  factory FakeAssessmentManual.valid() {
    final now = DateTime.now();
    return FakeAssessmentManual(
      id: 'assessment-123',
      woundId: 'wound-456',
      date: now,
      lengthCm: 10.0,
      widthCm: 8.0,
      depthCm: 2.0,
      painScale: 5,
      edgeAppearance: AssessmentManual.edgeAppearanceOptions.first,
      woundBed: AssessmentManual.woundBedOptions.first,
      exudateType: AssessmentManual.exudateTypeOptions.first,
      exudateAmount: AssessmentManual.exudateAmountOptions.first,
      notes: 'Test assessment notes',
      createdAt: now,
      updatedAt: now,
    );
  }
}

void main() {
  late UpdateAssessmentUseCase updateAssessmentUseCase;
  late MockAssessmentRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeAssessmentManual.valid());
  });

  setUp(() {
    mockRepository = MockAssessmentRepository();
    updateAssessmentUseCase = UpdateAssessmentUseCase(mockRepository);
  });

  group('UpdateAssessmentUseCase', () {
    test('should return success when updating with valid data', () async {
      // Arrange
      final existingAssessment = FakeAssessmentManual.valid();
      final assessmentData = {
        'lengthCm': 15.0,
        'widthCm': 12.0,
        'painScale': 6,
      };

      final input = UpdateAssessmentInput(
        assessmentId: existingAssessment.id,
        updatedBy: 'test-user-id',
        assessmentData: assessmentData,
        observations: 'Updated assessment',
      );

      when(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).thenAnswer((_) async => existingAssessment);

      final updatedAssessment = existingAssessment.copyWith(
        lengthCm: 15.0,
        widthCm: 12.0,
        painScale: 6,
        updatedAt: DateTime.now(),
      );

      when(
        () => mockRepository.updateAssessment(any()),
      ).thenAnswer((_) async => updatedAssessment);

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, equals(updatedAssessment));

      verify(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).called(1);
      verify(() => mockRepository.updateAssessment(any())).called(1);
    });

    test('should return failure when assessment does not exist', () async {
      // Arrange
      final input = UpdateAssessmentInput(
        assessmentId: 'non-existent-id',
        updatedBy: 'test-user-id',
        assessmentData: {'lengthCm': 15.0},
        observations: 'Updated assessment',
      );

      when(
        () => mockRepository.getAssessmentById('non-existent-id'),
      ).thenAnswer((_) async => null);

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<NotFoundError>());

      verify(
        () => mockRepository.getAssessmentById('non-existent-id'),
      ).called(1);
      verifyNever(() => mockRepository.updateAssessment(any()));
    });

    test('should return failure when no updates are provided', () async {
      // Arrange
      final input = UpdateAssessmentInput(
        assessmentId: 'assessment-123',
        updatedBy: 'test-user-id',
      );

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect(
        (result.errorOrNull as ValidationError).field,
        equals('hasUpdates'),
      );

      // Não deve chamar o repositório se não há atualizações
      verifyNever(() => mockRepository.getAssessmentById(any()));
      verifyNever(() => mockRepository.updateAssessment(any()));
    });
    test('should return failure when assessmentId is empty', () async {
      // Arrange
      final input = UpdateAssessmentInput(
        assessmentId: '',
        updatedBy: 'test-user-id',
        assessmentData: {'lengthCm': 15.0},
      );

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect(
        (result.errorOrNull as ValidationError).field,
        equals('assessmentId'),
      );

      verifyNever(() => mockRepository.getAssessmentById(any()));
      verifyNever(() => mockRepository.updateAssessment(any()));
    });

    test('should return failure when updatedBy is empty', () async {
      // Arrange
      final input = UpdateAssessmentInput(
        assessmentId: 'assessment-123',
        updatedBy: '',
        assessmentData: {'lengthCm': 15.0},
      );

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect(
        (result.errorOrNull as ValidationError).field,
        equals('updatedBy'),
      );

      verifyNever(() => mockRepository.getAssessmentById(any()));
      verifyNever(() => mockRepository.updateAssessment(any()));
    });

    test('should return failure when assessmentData is empty', () async {
      // Arrange
      final input = UpdateAssessmentInput(
        assessmentId: 'assessment-123',
        updatedBy: 'test-user-id',
        assessmentData: <String, dynamic>{},
      );

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect(
        (result.errorOrNull as ValidationError).field,
        equals('assessmentData'),
      );

      verifyNever(() => mockRepository.getAssessmentById(any()));
      verifyNever(() => mockRepository.updateAssessment(any()));
    });

    test('should handle repository update failure', () async {
      // Arrange
      final existingAssessment = FakeAssessmentManual.valid();

      final input = UpdateAssessmentInput(
        assessmentId: existingAssessment.id,
        updatedBy: 'test-user-id',
        assessmentData: {'lengthCm': 15.0},
        observations: 'Updated assessment',
      );

      when(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).thenAnswer((_) async => existingAssessment);

      when(
        () => mockRepository.updateAssessment(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<SystemError>());

      verify(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).called(1);
      verify(() => mockRepository.updateAssessment(any())).called(1);
    });

    test('should update observations when provided', () async {
      // Arrange
      final existingAssessment = FakeAssessmentManual.valid();

      final input = UpdateAssessmentInput(
        assessmentId: existingAssessment.id,
        updatedBy: 'test-user-id',
        observations: 'New observation notes',
      );

      when(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).thenAnswer((_) async => existingAssessment);

      final updatedAssessment = existingAssessment.copyWith(
        updatedAt: DateTime.now(),
      );

      when(
        () => mockRepository.updateAssessment(any()),
      ).thenAnswer((_) async => updatedAssessment);

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);

      verify(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).called(1);
      verify(() => mockRepository.updateAssessment(any())).called(1);
    });

    test('should trim empty observations', () async {
      // Arrange
      final existingAssessment = FakeAssessmentManual.valid();

      final input = UpdateAssessmentInput(
        assessmentId: existingAssessment.id,
        updatedBy: 'test-user-id',
        observations: '   ', // Only whitespace
        assessmentData: {'lengthCm': 15.0},
      );

      when(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).thenAnswer((_) async => existingAssessment);

      final updatedAssessment = existingAssessment.copyWith(
        lengthCm: 15.0,
        updatedAt: DateTime.now(),
      );

      when(
        () => mockRepository.updateAssessment(any()),
      ).thenAnswer((_) async => updatedAssessment);

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);

      verify(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).called(1);
      verify(() => mockRepository.updateAssessment(any())).called(1);
    });

    test('should filter empty image URLs', () async {
      // Arrange
      final existingAssessment = FakeAssessmentManual.valid();

      final input = UpdateAssessmentInput(
        assessmentId: existingAssessment.id,
        updatedBy: 'test-user-id',
        imageUrls: [
          'https://valid-url.com',
          '',
          '   ',
          'https://another-valid-url.com',
        ],
        assessmentData: {'lengthCm': 15.0},
      );

      when(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).thenAnswer((_) async => existingAssessment);

      final updatedAssessment = existingAssessment.copyWith(
        lengthCm: 15.0,
        updatedAt: DateTime.now(),
      );

      when(
        () => mockRepository.updateAssessment(any()),
      ).thenAnswer((_) async => updatedAssessment);

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);

      verify(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).called(1);
      verify(() => mockRepository.updateAssessment(any())).called(1);
    });

    test('should update partial assessment data', () async {
      // Arrange
      final existingAssessment = FakeAssessmentManual.valid();

      final input = UpdateAssessmentInput(
        assessmentId: existingAssessment.id,
        updatedBy: 'test-user-id',
        assessmentData: {
          'lengthCm': 20.0,
          'painScale': 8,
          'notes': 'Significant improvement observed',
        },
      );

      when(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).thenAnswer((_) async => existingAssessment);

      final updatedAssessment = existingAssessment.copyWith(
        lengthCm: 20.0,
        painScale: 8,
        notes: 'Significant improvement observed',
        updatedAt: DateTime.now(),
      );

      when(
        () => mockRepository.updateAssessment(any()),
      ).thenAnswer((_) async => updatedAssessment);

      // Act
      final result = await updateAssessmentUseCase.execute(input);

      // Assert
      expect(result.isSuccess, isTrue);
      final assessment = result.valueOrNull;
      expect(assessment?.lengthCm, equals(20.0));
      expect(assessment?.painScale, equals(8));
      expect(assessment?.notes, equals('Significant improvement observed'));

      verify(
        () => mockRepository.getAssessmentById(existingAssessment.id),
      ).called(1);
      verify(() => mockRepository.updateAssessment(any())).called(1);
    });
  });
}
