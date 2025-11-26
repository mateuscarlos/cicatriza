import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/patient.dart';
import '../../../../lib/domain/repositories/patient_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/patient/archive_patient_use_case.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

class FakePatient extends Fake implements Patient {}

void main() {
  late ArchivePatientUseCase useCase;
  late MockPatientRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePatient());
  });

  setUp(() {
    mockRepository = MockPatientRepository();
    useCase = ArchivePatientUseCase(mockRepository);
  });

  group('ArchivePatientUseCase', () {
    final activePatient = Patient(
      id: '1',
      name: 'João Silva',
      nameLowercase: 'joão silva',
      email: 'joao@email.com',
      birthDate: DateTime(1980, 1, 1),
      phone: '11999999999',
      notes: 'Paciente ativo',
      archived: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final archivedPatient = activePatient.copyWith(
      archived: true,
      updatedAt: DateTime.now(),
    );

    test('deve arquivar paciente com sucesso', () async {
      // Arrange
      const input = ArchivePatientInput(patientId: '1', archive: true);

      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => activePatient);
      when(
        () => mockRepository.updatePatient(any()),
      ).thenAnswer((_) async => archivedPatient);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<Patient>>());
      final success = result as Success<Patient>;
      expect(success.value.archived, isTrue);

      verify(() => mockRepository.getPatientById('1')).called(1);
      verify(() => mockRepository.updatePatient(any())).called(1);
    });

    test('deve falhar quando paciente não encontrado', () async {
      // Arrange
      const input = ArchivePatientInput(
        patientId: 'inexistente',
        archive: true,
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

    test('deve falhar quando ID do paciente está vazio', () async {
      // Arrange
      const input = ArchivePatientInput(patientId: '', archive: true);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('patientId'));

      verifyNever(() => mockRepository.getPatientById(any()));
    });

    test('deve desarquivar paciente já arquivado', () async {
      // Arrange
      const input = ArchivePatientInput(patientId: '1', archive: false);

      final unarchivedPatient = archivedPatient.copyWith(
        archived: false,
        updatedAt: DateTime.now(),
      );

      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => archivedPatient);
      when(
        () => mockRepository.updatePatient(any()),
      ).thenAnswer((_) async => unarchivedPatient);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<Patient>>());
      final success = result as Success<Patient>;
      expect(success.value.archived, isFalse);

      verify(() => mockRepository.getPatientById('1')).called(1);
      verify(() => mockRepository.updatePatient(any())).called(1);
    });

    test('deve falhar quando paciente já está arquivado', () async {
      // Arrange
      const input = ArchivePatientInput(patientId: '1', archive: true);

      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => archivedPatient);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<Patient>>());
      final failure = result as Failure<Patient>;
      expect(failure.error, isA<ConflictError>());
      expect((failure.error as ConflictError).code, equals('ALREADY_ARCHIVED'));

      verify(() => mockRepository.getPatientById('1')).called(1);
      verifyNever(() => mockRepository.updatePatient(any()));
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      const input = ArchivePatientInput(patientId: '1', archive: true);

      when(
        () => mockRepository.getPatientById('1'),
      ).thenAnswer((_) async => activePatient);
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
        contains('Erro interno ao arquivar/desarquivar paciente'),
      );
    });
  });
}
