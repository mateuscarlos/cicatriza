import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/patient.dart';
import '../../../../lib/domain/repositories/patient_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/patient/update_patient_use_case.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

class FakePatient extends Fake implements Patient {}

void main() {
  late UpdatePatientUseCase useCase;
  late MockPatientRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePatient());
  });

  setUp(() {
    mockRepository = MockPatientRepository();
    useCase = UpdatePatientUseCase(mockRepository);
  });

  group('UpdatePatientUseCase', () {
    final existingPatient = Patient(
      id: '1',
      name: 'João Silva',
      nameLowercase: 'joão silva',
      email: 'joao@email.com',
      birthDate: DateTime(1980, 1, 1),
      phone: '11999999999',
      notes: 'Notas originais',
      archived: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('deve atualizar paciente com sucesso', () async {
      // Arrange
      const input = UpdatePatientInput(
        patientId: '1',
        firstName: 'João',
        lastName: 'Santos',
        email: 'joao.santos@email.com',
        phone: '(11) 98888-8888',
        notes: 'Notas atualizadas',
      );

      final updatedPatient = existingPatient.copyWith(
        name: 'João Santos',
        nameLowercase: 'joão santos',
        email: 'joao.santos@email.com',
        phone: '(11) 98888-8888',
        notes: 'Notas atualizadas',
      );

      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => existingPatient);
      when(
        () => mockRepository.getPatientById('joao.santos@email.com'),
      ).thenAnswer((_) async => null);
      when(
        () => mockRepository.updatePatient(any()),
      ).thenAnswer((_) async => updatedPatient);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<Patient>>());
      final success = result as Success<Patient>;
      expect(success.value.name, equals('João Santos'));
      expect(success.value.email, equals('joao.santos@email.com'));
      expect(success.value.phone, equals('(11) 98888-8888'));

      verify(() => mockRepository.getPatientById('1')).called(1);
      verify(() => mockRepository.updatePatient(any())).called(1);
    });

    test('deve falhar quando paciente não existe', () async {
      // Arrange
      const input = UpdatePatientInput(
        patientId: 'inexistente',
        firstName: 'João',
        lastName: 'Santos',
      );

      when(
        () => mockRepository.getPatientById('inexistente'),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<NotFoundError>());

      verify(() => mockRepository.getPatientById('inexistente')).called(1);
      verifyNever(() => mockRepository.updatePatient(any()));
    });

    test(
      'deve falhar quando email já está em uso por outro paciente',
      () async {
        // Arrange
        const input = UpdatePatientInput(
          patientId: '1',
          email: 'outro@email.com',
        );

        final otherPatient = existingPatient.copyWith(
          id: '2',
          email: 'outro@email.com',
        );

        when(
          () => mockRepository.getPatientById('1'),
        ).thenAnswer((_) async => existingPatient);
        when(
          () => mockRepository.getPatientById('outro@email.com'),
        ).thenAnswer((_) async => otherPatient);

        // Act
        final result = await useCase.execute(input);

        // Assert
        expect(result, isA<Failure<Patient>>());
        final failure = result as Failure<Patient>;
        expect(failure.error, isA<ConflictError>());
        expect(
          (failure.error as ConflictError).code,
          equals('EMAIL_ALREADY_EXISTS'),
        );

        verify(() => mockRepository.getPatientById('1')).called(1);
        verify(
          () => mockRepository.getPatientById('outro@email.com'),
        ).called(1);
        verifyNever(() => mockRepository.updatePatient(any()));
      },
    );

    test('deve falhar quando nenhuma atualização é fornecida', () async {
      // Arrange
      const input = UpdatePatientInput(patientId: '1');

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());

      verifyNever(() => mockRepository.getPatientById(any()));
    });

    test('deve falhar quando ID do paciente está vazio', () async {
      // Arrange
      const input = UpdatePatientInput(
        patientId: '',
        firstName: 'João',
        lastName: 'Santos',
      );

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('patientId'));

      verifyNever(() => mockRepository.getPatientById(any()));
    });

    test('deve atualizar apenas campos fornecidos', () async {
      // Arrange
      const input = UpdatePatientInput(
        patientId: '1',
        notes: 'Apenas novas notas',
      );

      final updatedPatient = existingPatient.copyWith(
        notes: 'Apenas novas notas',
      );

      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => existingPatient);
      when(
        () => mockRepository.updatePatient(any()),
      ).thenAnswer((_) async => updatedPatient);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<Patient>>());
      final success = result as Success<Patient>;
      expect(success.value.notes, equals('Apenas novas notas'));
      expect(success.value.name, equals(existingPatient.name)); // Não mudou
      expect(success.value.email, equals(existingPatient.email)); // Não mudou

      verify(() => mockRepository.getPatientById('1')).called(1);
      verify(() => mockRepository.updatePatient(any())).called(1);
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      const input = UpdatePatientInput(
        patientId: '1',
        firstName: 'João',
        lastName: 'Santos',
      );

      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => existingPatient);
      when(
        () => mockRepository.updatePatient(any()),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<SystemError>());
      expect(
        (failure.error as SystemError).message,
        contains('Erro interno ao atualizar paciente'),
      );
    });
  });
}
