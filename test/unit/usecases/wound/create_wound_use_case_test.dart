import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/patient.dart';
import '../../../../lib/domain/entities/wound.dart';
import '../../../../lib/domain/repositories/patient_repository.dart';
import '../../../../lib/domain/repositories/wound_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/wound/create_wound_use_case.dart';

class MockWoundRepository extends Mock implements WoundRepository {}

class MockPatientRepository extends Mock implements PatientRepository {}

class FakeWound extends Fake implements Wound {}

class FakePatient extends Fake implements Patient {}

void main() {
  late CreateWoundUseCase useCase;
  late MockWoundRepository mockWoundRepository;
  late MockPatientRepository mockPatientRepository;

  setUpAll(() {
    registerFallbackValue(FakeWound());
    registerFallbackValue(FakePatient());
  });

  setUp(() {
    mockWoundRepository = MockWoundRepository();
    mockPatientRepository = MockPatientRepository();
    useCase = CreateWoundUseCase(mockWoundRepository, mockPatientRepository);
  });

  group('CreateWoundUseCase', () {
    final validInput = CreateWoundInput(
      patientId: 'patient-1',
      type: WoundType.ulceraPressao,
      location: WoundLocation.costas,
      description: 'Úlcera por pressão no cóccix',
      notes: 'Paciente acamado há 2 meses',
    );

    final mockPatient = Patient(
      id: 'patient-1',
      name: 'João Silva',
      nameLowercase: 'joão silva',
      email: 'joao@email.com',
      phone: '(11) 98888-8888',
      birthDate: DateTime(1980, 1, 1),
      archived: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final mockWound = Wound(
      id: 'wound-1',
      patientId: 'patient-1',
      type: WoundType.ulceraPressao,
      location: WoundLocation.costas,
      description: 'Úlcera por pressão no cóccix',
      notes: 'Paciente acamado há 2 meses',
      status: WoundStatus.ativa,
      identificationDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('deve criar ferida com sucesso quando dados válidos', () async {
      // Arrange
      when(
        () => mockPatientRepository.getPatientById('patient-1'),
      ).thenAnswer((_) async => mockPatient);
      when(
        () => mockWoundRepository.createWound(any()),
      ).thenAnswer((_) async => mockWound);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<Wound>>());
      final success = result as Success<Wound>;
      expect(success.value.type, equals(WoundType.ulceraPressao));
      expect(success.value.location, equals(WoundLocation.costas));
      expect(success.value.patientId, equals('patient-1'));

      verify(() => mockPatientRepository.getPatientById('patient-1')).called(1);
      verify(() => mockWoundRepository.createWound(any())).called(1);
    });

    test('deve falhar quando paciente não existe', () async {
      // Arrange
      when(
        () => mockPatientRepository.getPatientById('inexistente'),
      ).thenAnswer((_) async => null);

      final invalidInput = CreateWoundInput(
        patientId: 'inexistente',
        type: WoundType.ulceraPressao,
        location: WoundLocation.costas,
        description: 'Teste',
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<NotFoundError>());
      expect((failure.error as NotFoundError).entityType, equals('Patient'));
      expect((failure.error as NotFoundError).entityId, equals('inexistente'));

      verify(
        () => mockPatientRepository.getPatientById('inexistente'),
      ).called(1);
      verifyNever(() => mockWoundRepository.createWound(any()));
    });

    test('deve falhar quando paciente está arquivado', () async {
      // Arrange
      final archivedPatient = mockPatient.copyWith(archived: true);
      when(
        () => mockPatientRepository.getPatientById('patient-1'),
      ).thenAnswer((_) async => archivedPatient);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<ConflictError>());
      expect((failure.error as ConflictError).code, equals('PATIENT_ARCHIVED'));

      verify(() => mockPatientRepository.getPatientById('patient-1')).called(1);
      verifyNever(() => mockWoundRepository.createWound(any()));
    });

    test('deve falhar quando ID do paciente está vazio', () async {
      // Arrange
      final invalidInput = CreateWoundInput(
        patientId: '',
        type: WoundType.ulceraPressao,
        location: WoundLocation.costas,
        description: 'Teste',
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('patientId'));

      verifyNever(() => mockPatientRepository.getPatientById(any()));
      verifyNever(() => mockWoundRepository.createWound(any()));
    });

    test('deve falhar quando descrição está vazia', () async {
      // Arrange
      final invalidInput = CreateWoundInput(
        patientId: 'patient-1',
        type: WoundType.ulceraPressao,
        location: WoundLocation.costas,
        description: '',
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('description'));

      verifyNever(() => mockPatientRepository.getPatientById(any()));
      verifyNever(() => mockWoundRepository.createWound(any()));
    });

    test('deve criar ferida sem campos opcionais', () async {
      // Arrange
      final minimalInput = CreateWoundInput(
        patientId: 'patient-1',
        type: WoundType.traumatica,
        location: WoundLocation.bracos,
        description: 'Ferida traumática simples',
      );

      final minimalWound = mockWound.copyWith(
        type: WoundType.traumatica,
        location: WoundLocation.bracos,
        description: 'Ferida traumática simples',
        notes: null,
      );

      when(
        () => mockPatientRepository.getPatientById('patient-1'),
      ).thenAnswer((_) async => mockPatient);
      when(
        () => mockWoundRepository.createWound(any()),
      ).thenAnswer((_) async => minimalWound);

      // Act
      final result = await useCase.execute(minimalInput);

      // Assert
      expect(result, isA<Success<Wound>>());
      final success = result as Success<Wound>;
      expect(success.value.type, equals(WoundType.traumatica));
      expect(success.value.notes, isNull);

      verify(() => mockWoundRepository.createWound(any())).called(1);
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      when(
        () => mockPatientRepository.getPatientById('patient-1'),
      ).thenAnswer((_) async => mockPatient);
      when(
        () => mockWoundRepository.createWound(any()),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<SystemError>());
      expect(
        (failure.error as SystemError).message,
        contains('Erro interno ao criar ferida'),
      );
    });
  });
}
