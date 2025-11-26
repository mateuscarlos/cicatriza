import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/assessment_manual.dart';
import '../../../../lib/domain/entities/wound.dart';
import '../../../../lib/domain/repositories/assessment_repository_manual.dart';
import '../../../../lib/domain/repositories/wound_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/assessment/create_assessment_use_case.dart';

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

class MockWoundRepository extends Mock implements WoundRepository {}

class FakeAssessmentManual extends Fake implements AssessmentManual {}

class FakeWound extends Fake implements Wound {}

void main() {
  late CreateAssessmentUseCase useCase;
  late MockAssessmentRepository mockAssessmentRepository;
  late MockWoundRepository mockWoundRepository;

  setUpAll(() {
    registerFallbackValue(FakeAssessmentManual());
    registerFallbackValue(FakeWound());
  });

  setUp(() {
    mockAssessmentRepository = MockAssessmentRepository();
    mockWoundRepository = MockWoundRepository();
    useCase = CreateAssessmentUseCase(
      mockAssessmentRepository,
      mockWoundRepository,
    );
  });

  group('CreateAssessmentUseCase', () {
    final validInput = CreateAssessmentInput(
      woundId: 'wound-1',
      lengthCm: 5.0,
      widthCm: 3.0,
      depthCm: 1.5,
      painScale: 6,
      edgeAppearance: 'Irregular',
      woundBed: 'Granulação',
      exudateType: 'Seroso',
      exudateAmount: 'Moderada',
      notes: 'Melhora observada desde última avaliação',
    );

    final mockWound = Wound(
      id: 'wound-1',
      patientId: 'patient-1',
      type: WoundType.ulceraPressao,
      location: WoundLocation.costas,
      description: 'Úlcera por pressão',
      status: WoundStatus.ativa,
      identificationDate: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    );

    final mockAssessment = AssessmentManual(
      id: 'assessment-1',
      woundId: 'wound-1',
      date: DateTime.now(),
      lengthCm: 5.0,
      widthCm: 3.0,
      depthCm: 1.5,
      painScale: 6,
      edgeAppearance: 'Irregular',
      woundBed: 'Granulação',
      exudateType: 'Seroso',
      exudateAmount: 'Moderada',
      notes: 'Melhora observada desde última avaliação',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('deve criar avaliação com sucesso quando dados válidos', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockAssessmentRepository.createAssessment(any()),
      ).thenAnswer((_) async => mockAssessment);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<AssessmentManual>>());
      final success = result as Success<AssessmentManual>;
      expect(success.value.woundId, equals('wound-1'));
      expect(success.value.lengthCm, equals(5.0));
      expect(success.value.painScale, equals(6));

      verify(() => mockWoundRepository.getWoundById('wound-1')).called(1);
      verify(() => mockAssessmentRepository.createAssessment(any())).called(1);
    });

    test('deve falhar quando ferida não existe', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('inexistente'),
      ).thenAnswer((_) async => null);

      final invalidInput = CreateAssessmentInput(
        woundId: 'inexistente',
        painScale: 5,
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<AssessmentManual>>());
      final failure = result as Failure<AssessmentManual>;
      expect(failure.error, isA<NotFoundError>());
      expect((failure.error as NotFoundError).entityType, equals('Wound'));
      expect((failure.error as NotFoundError).entityId, equals('inexistente'));

      verify(() => mockWoundRepository.getWoundById('inexistente')).called(1);
      verifyNever(() => mockAssessmentRepository.createAssessment(any()));
    });

    test('deve falhar quando ferida não permite novas avaliações', () async {
      // Arrange
      final cicatrizadaWound = mockWound.copyWith(
        status: WoundStatus.cicatrizada,
      );
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => cicatrizadaWound);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<AssessmentManual>>());
      final failure = result as Failure<AssessmentManual>;
      expect(failure.error, isA<ConflictError>());
      expect(
        (failure.error as ConflictError).code,
        equals('WOUND_STATUS_INVALID'),
      );

      verify(() => mockWoundRepository.getWoundById('wound-1')).called(1);
      verifyNever(() => mockAssessmentRepository.createAssessment(any()));
    });

    test('deve falhar quando ferida está arquivada', () async {
      // Arrange
      final archivedWound = mockWound.copyWith(archived: true);
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => archivedWound);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<AssessmentManual>>());
      final failure = result as Failure<AssessmentManual>;
      expect(failure.error, isA<ConflictError>());
      expect((failure.error as ConflictError).code, equals('WOUND_ARCHIVED'));

      verify(() => mockWoundRepository.getWoundById('wound-1')).called(1);
      verifyNever(() => mockAssessmentRepository.createAssessment(any()));
    });

    test('deve falhar quando ID da ferida está vazio', () async {
      // Arrange
      final invalidInput = CreateAssessmentInput(woundId: '', painScale: 5);

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<AssessmentManual>>());
      final failure = result as Failure<AssessmentManual>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('woundId'));

      verifyNever(() => mockWoundRepository.getWoundById(any()));
      verifyNever(() => mockAssessmentRepository.createAssessment(any()));
    });

    test('deve falhar quando nenhum campo de avaliação é fornecido', () async {
      // Arrange
      final emptyInput = CreateAssessmentInput(woundId: 'wound-1');

      // Act
      final result = await useCase.execute(emptyInput);

      // Assert
      expect(result, isA<Failure<AssessmentManual>>());
      final failure = result as Failure<AssessmentManual>;
      expect(failure.error, isA<ValidationError>());
      expect(
        (failure.error as ValidationError).field,
        equals('assessment_fields'),
      );

      verifyNever(() => mockWoundRepository.getWoundById(any()));
      verifyNever(() => mockAssessmentRepository.createAssessment(any()));
    });

    test('deve criar avaliação com campos mínimos', () async {
      // Arrange
      final minimalInput = CreateAssessmentInput(
        woundId: 'wound-1',
        painScale: 3,
      );

      final minimalAssessment = mockAssessment.copyWith(
        painScale: 3,
        lengthCm: null,
        widthCm: null,
        depthCm: null,
        edgeAppearance: null,
        woundBed: null,
        exudateType: null,
        exudateAmount: null,
        notes: null,
      );

      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockAssessmentRepository.createAssessment(any()),
      ).thenAnswer((_) async => minimalAssessment);

      // Act
      final result = await useCase.execute(minimalInput);

      // Assert
      expect(result, isA<Success<AssessmentManual>>());
      final success = result as Success<AssessmentManual>;
      expect(success.value.painScale, equals(3));
      // Os campos null não são verificados pois o mock retorna o assessment completo

      verify(() => mockAssessmentRepository.createAssessment(any())).called(1);
    });

    test('deve criar avaliação apenas com dimensões', () async {
      // Arrange
      final dimensionsInput = CreateAssessmentInput(
        woundId: 'wound-1',
        lengthCm: 4.2,
        widthCm: 2.8,
        depthCm: 0.5,
      );

      final dimensionsAssessment = mockAssessment.copyWith(
        lengthCm: 4.2,
        widthCm: 2.8,
        depthCm: 0.5,
        painScale: null,
        edgeAppearance: null,
        woundBed: null,
        exudateType: null,
        exudateAmount: null,
        notes: null,
      );

      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockAssessmentRepository.createAssessment(any()),
      ).thenAnswer((_) async => dimensionsAssessment);

      // Act
      final result = await useCase.execute(dimensionsInput);

      // Assert
      expect(result, isA<Success<AssessmentManual>>());
      final success = result as Success<AssessmentManual>;
      expect(success.value.lengthCm, equals(4.2));
      expect(success.value.widthCm, equals(2.8));
      expect(success.value.depthCm, equals(0.5));
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockAssessmentRepository.createAssessment(any()),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<AssessmentManual>>());
      final failure = result as Failure<AssessmentManual>;
      expect(failure.error, isA<SystemError>());
      expect(
        (failure.error as SystemError).message,
        contains('Erro interno ao criar avaliação'),
      );
    });
  });
}
