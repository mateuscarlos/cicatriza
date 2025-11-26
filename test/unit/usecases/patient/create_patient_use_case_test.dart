import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/patient.dart';
import '../../../../lib/domain/repositories/patient_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/patient/create_patient_use_case.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

class FakePatient extends Fake implements Patient {}

void main() {
  late CreatePatientUseCase useCase;
  late MockPatientRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePatient());
  });

  setUp(() {
    mockRepository = MockPatientRepository();
    useCase = CreatePatientUseCase(mockRepository);
  });

  group('CreatePatientUseCase', () {
    final validInput = CreatePatientInput(
      firstName: 'João',
      lastName: 'Silva',
      email: 'joao@email.com',
      birthDate: DateTime(1980, 1, 1),
      phone: '11999999999',
      notes: 'Paciente teste',
    );

    final mockPatient = Patient(
      id: '1',
      name: 'João Silva',
      nameLowercase: 'joão silva',
      email: 'joao@email.com',
      birthDate: DateTime(1980, 1, 1),
      phone: '11999999999',
      notes: 'Paciente teste',
      archived: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('deve criar paciente com sucesso quando dados válidos', () async {
      // Arrange
      when(
        () => mockRepository.getPatientById(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRepository.createPatient(any()),
      ).thenAnswer((_) async => mockPatient);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<Patient>>());
      final success = result as Success<Patient>;
      expect(success.value.name, equals('João Silva'));
      expect(success.value.email, equals('joao@email.com'));

      verify(() => mockRepository.getPatientById(any())).called(1);
      verify(() => mockRepository.createPatient(any())).called(1);
    });

    test('deve falhar quando firstName está vazio', () async {
      // Arrange
      final invalidInput = CreatePatientInput(
        firstName: '',
        lastName: 'Silva',
        email: 'joao@email.com',
        birthDate: DateTime(1980, 1, 1),
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());
      expect(
        (failure.error as ValidationError).message,
        contains('Nome é obrigatório'),
      );
      expect((failure.error as ValidationError).field, equals('firstName'));

      verifyNever(() => mockRepository.createPatient(any()));
    });

    test('deve falhar quando lastName está vazio', () async {
      // Arrange
      final invalidInput = CreatePatientInput(
        firstName: 'João',
        lastName: '',
        email: 'joao@email.com',
        birthDate: DateTime(1980, 1, 1),
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());
      expect(
        (failure.error as ValidationError).message,
        contains('Sobrenome é obrigatório'),
      );
      expect((failure.error as ValidationError).field, equals('lastName'));

      verifyNever(() => mockRepository.createPatient(any()));
    });

    test('deve falhar quando data de nascimento é no futuro', () async {
      // Arrange
      final futureDate = DateTime.now().add(const Duration(days: 1));
      final invalidInput = CreatePatientInput(
        firstName: 'João',
        lastName: 'Silva',
        email: 'joao@email.com',
        birthDate: futureDate,
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('birthDate'));

      verifyNever(() => mockRepository.createPatient(any()));
    });

    test('deve falhar quando email já existe', () async {
      // Arrange
      when(
        () => mockRepository.getPatientById(any()),
      ).thenAnswer((_) async => mockPatient);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ConflictError>());
      expect(
        (failure.error as ConflictError).code,
        equals('EMAIL_ALREADY_EXISTS'),
      );

      verify(() => mockRepository.getPatientById(any())).called(1);
      verifyNever(() => mockRepository.createPatient(any()));
    });

    test('deve falhar quando email está vazio', () async {
      // Arrange
      final invalidInput = CreatePatientInput(
        firstName: 'João',
        lastName: 'Silva',
        email: '',
        birthDate: DateTime(1980, 1, 1),
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('email'));

      verifyNever(() => mockRepository.createPatient(any()));
    });

    test('deve criar paciente sem campos opcionais', () async {
      // Arrange
      final minimalInput = CreatePatientInput(
        firstName: 'João',
        lastName: 'Silva',
        email: 'joao@email.com',
        birthDate: DateTime(1980, 1, 1),
      );

      final minimalPatient = Patient(
        id: '1',
        name: 'João Silva',
        nameLowercase: 'joão silva',
        email: 'joao@email.com',
        birthDate: DateTime(1980, 1, 1),
        phone: null,
        notes: null,
        archived: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(
        () => mockRepository.getPatientById(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRepository.createPatient(any()),
      ).thenAnswer((_) async => minimalPatient);

      // Act
      final result = await useCase.execute(minimalInput);

      // Assert
      expect(result, isA<Success<Patient>>());
      final success = result as Success<Patient>;
      expect(success.value.name, equals('João Silva'));
      expect(success.value.phone, isNull);
      expect(success.value.notes, isNull);

      verify(() => mockRepository.createPatient(any())).called(1);
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      when(
        () => mockRepository.getPatientById(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRepository.createPatient(any()),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<SystemError>());
      expect(
        (failure.error as SystemError).message,
        contains('Erro interno ao criar paciente'),
      );
    });
  });
}
