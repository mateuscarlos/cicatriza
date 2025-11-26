import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/patient.dart';
import '../../../../lib/domain/repositories/patient_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/patient/list_patients_use_case.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

void main() {
  late ListPatientsUseCase useCase;
  late MockPatientRepository mockRepository;

  setUp(() {
    mockRepository = MockPatientRepository();
    useCase = ListPatientsUseCase(mockRepository);
  });

  group('ListPatientsUseCase', () {
    final patients = [
      Patient(
        id: '1',
        name: 'Ana Silva',
        nameLowercase: 'ana silva',
        email: 'ana@email.com',
        birthDate: DateTime(1985, 5, 15),
        archived: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: '2',
        name: 'João Santos',
        nameLowercase: 'joão santos',
        email: 'joao@email.com',
        birthDate: DateTime(1990, 10, 20),
        archived: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: '3',
        name: 'Carlos Lima',
        nameLowercase: 'carlos lima',
        email: 'carlos@email.com',
        birthDate: DateTime(1975, 3, 8),
        archived: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    test('deve retornar lista de todos os pacientes por padrão', () async {
      // Arrange
      const input = ListPatientsInput();

      when(
        () => mockRepository.getPatients(),
      ).thenAnswer((_) async => patients);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<ListPatientsOutput>>());
      final success = result as Success<ListPatientsOutput>;
      expect(success.value.patients.length, equals(3));
      expect(success.value.totalCount, equals(3));
      expect(success.value.hasMore, isFalse);

      verify(() => mockRepository.getPatients()).called(1);
    });

    test(
      'deve retornar apenas pacientes ativos quando includeArchived é false',
      () async {
        // Arrange
        const input = ListPatientsInput(includeArchived: false);

        when(
          () => mockRepository.getPatients(),
        ).thenAnswer((_) async => patients);

        // Act
        final result = await useCase.execute(input);

        // Assert
        expect(result, isA<Success<ListPatientsOutput>>());
        final success = result as Success<ListPatientsOutput>;
        expect(success.value.patients.length, equals(2));
        expect(success.value.patients.every((p) => !p.archived), isTrue);
        expect(success.value.totalCount, equals(2));

        verify(() => mockRepository.getPatients()).called(1);
      },
    );

    test(
      'deve retornar apenas pacientes arquivados quando includeArchived é true',
      () async {
        // Arrange
        const input = ListPatientsInput(includeArchived: true);

        when(
          () => mockRepository.getPatients(),
        ).thenAnswer((_) async => patients);

        // Act
        final result = await useCase.execute(input);

        // Assert
        expect(result, isA<Success<ListPatientsOutput>>());
        final success = result as Success<ListPatientsOutput>;
        expect(success.value.patients.length, equals(1));
        expect(success.value.patients.every((p) => p.archived), isTrue);
        expect(success.value.totalCount, equals(1));

        verify(() => mockRepository.getPatients()).called(1);
      },
    );

    test('deve filtrar pacientes por termo de busca', () async {
      // Arrange
      const input = ListPatientsInput(searchQuery: 'Silva');
      final filteredPatients = patients
          .where((p) => p.name.contains('Silva'))
          .toList();

      when(
        () => mockRepository.searchPatients('Silva'),
      ).thenAnswer((_) async => filteredPatients);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<ListPatientsOutput>>());
      final success = result as Success<ListPatientsOutput>;
      expect(success.value.patients.length, equals(1));
      expect(success.value.patients.first.name, equals('Ana Silva'));

      verify(() => mockRepository.searchPatients('Silva')).called(1);
    });

    test('deve aplicar paginação corretamente', () async {
      // Arrange
      const input = ListPatientsInput(limit: 2, offset: 0);

      when(
        () => mockRepository.getPatients(),
      ).thenAnswer((_) async => patients);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<ListPatientsOutput>>());
      final success = result as Success<ListPatientsOutput>;
      expect(success.value.patients.length, equals(2));
      expect(success.value.totalCount, equals(3));
      expect(success.value.hasMore, isTrue);

      verify(() => mockRepository.getPatients()).called(1);
    });

    test('deve falhar quando limit é negativo', () async {
      // Arrange
      const input = ListPatientsInput(limit: -1);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<ListPatientsOutput>>());
      final failure = result as Failure<ListPatientsOutput>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('limit'));

      verifyNever(() => mockRepository.getPatients());
    });

    test('deve falhar quando offset é negativo', () async {
      // Arrange
      const input = ListPatientsInput(offset: -1);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<ListPatientsOutput>>());
      final failure = result as Failure<ListPatientsOutput>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('offset'));

      verifyNever(() => mockRepository.getPatients());
    });

    test('deve falhar quando limit é maior que 1000', () async {
      // Arrange
      const input = ListPatientsInput(limit: 1001);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<ListPatientsOutput>>());
      final failure = result as Failure<ListPatientsOutput>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('limit'));

      verifyNever(() => mockRepository.getPatients());
    });

    test('deve retornar lista vazia quando não há pacientes', () async {
      // Arrange
      const input = ListPatientsInput();

      when(() => mockRepository.getPatients()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<ListPatientsOutput>>());
      final success = result as Success<ListPatientsOutput>;
      expect(success.value.patients.isEmpty, isTrue);
      expect(success.value.totalCount, equals(0));
      expect(success.value.hasMore, isFalse);
    });

    test('deve ordenar pacientes por nome', () async {
      // Arrange
      const input = ListPatientsInput();

      when(
        () => mockRepository.getPatients(),
      ).thenAnswer((_) async => patients);

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Success<ListPatientsOutput>>());
      final success = result as Success<ListPatientsOutput>;

      // Deve estar ordenado: Ana Silva, Carlos Lima, João Santos
      expect(success.value.patients[0].name, equals('Ana Silva'));
      expect(success.value.patients[1].name, equals('Carlos Lima'));
      expect(success.value.patients[2].name, equals('João Santos'));
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      const input = ListPatientsInput();

      when(
        () => mockRepository.getPatients(),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(input);

      // Assert
      expect(result, isA<Failure<ListPatientsOutput>>());
      final failure = result as Failure<ListPatientsOutput>;
      expect(failure.error, isA<SystemError>());
      expect(
        (failure.error as SystemError).message,
        contains('Erro interno ao listar pacientes'),
      );
    });
  });
}
