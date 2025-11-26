import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/patient.dart';
import '../../../../lib/domain/repositories/patient_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/patient/get_patient_use_case.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

class FakePatient extends Fake implements Patient {}

void main() {
  late GetPatientUseCase useCase;
  late MockPatientRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePatient());
  });

  setUp(() {
    mockRepository = MockPatientRepository();
    useCase = GetPatientUseCase(mockRepository);
  });

  group('GetPatientUseCase', () {
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

    test('deve retornar paciente quando encontrado', () async {
      // Arrange
      const input = GetPatientInput(patientId: '1');
      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => mockPatient);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<Patient>>());
      final success = result as Success<Patient>;
      expect(success.value.id, equals('1'));
      expect(success.value.name, equals('João Silva'));
      expect(success.value.email, equals('joao@email.com'));

      verify(() => mockRepository.getPatientById('1')).called(1);
    });

    test('deve falhar quando paciente não encontrado', () async {
      // Arrange
      const input = GetPatientInput(patientId: 'inexistente');
      when(
        () => mockRepository.getPatientById('inexistente'),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<NotFoundError>());
      expect((failure.error as NotFoundError).entityType, equals('Patient'));
      expect((failure.error as NotFoundError).entityId, equals('inexistente'));

      verify(() => mockRepository.getPatientById('inexistente')).called(1);
    });

    test('deve falhar quando ID do paciente está vazio', () async {
      // Arrange
      const input = GetPatientInput(patientId: '');

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('patientId'));
      expect(
        (failure.error as ValidationError).message,
        contains('ID do paciente é obrigatório'),
      );

      verifyNever(() => mockRepository.getPatientById(any()));
    });

    test('deve falhar quando ID do paciente é só espaços', () async {
      // Arrange
      const input = GetPatientInput(patientId: '   ');

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('patientId'));

      verifyNever(() => mockRepository.getPatientById(any()));
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      const input = GetPatientInput(patientId: '1');
      when(
        () => mockRepository.getPatientById('1'),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<SystemError>());
      expect(
        (failure.error as SystemError).message,
        contains('Erro interno ao buscar paciente'),
      );
    });

    test('deve retornar paciente arquivado se existir', () async {
      // Arrange
      const input = GetPatientInput(patientId: '1');
      final archivedPatient = Patient(
        id: '1',
        name: 'João Silva',
        nameLowercase: 'joão silva',
        email: 'joao@email.com',
        birthDate: DateTime(1980, 1, 1),
        phone: '11999999999',
        notes: 'Paciente teste',
        archived: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => archivedPatient);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<Patient>>());
      final success = result as Success<Patient>;
      expect(success.value.archived, isTrue);

      verify(() => mockRepository.getPatientById('1')).called(1);
    });
  });
}
