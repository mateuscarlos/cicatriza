import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/wound.dart';
import '../../../../lib/domain/repositories/wound_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/wound/get_wound_history_use_case.dart';

class MockWoundRepository extends Mock implements WoundRepository {}

class FakeWound extends Fake implements Wound {}

void main() {
  late GetWoundHistoryUseCase useCase;
  late MockWoundRepository mockWoundRepository;

  setUpAll(() {
    registerFallbackValue(FakeWound());
  });

  setUp(() {
    mockWoundRepository = MockWoundRepository();
    useCase = GetWoundHistoryUseCase(mockWoundRepository);
  });

  group('GetWoundHistoryUseCase', () {
    final baseDate = DateTime(2024, 1, 1);

    final mockWounds = [
      Wound(
        id: 'wound-1',
        patientId: 'patient-1',
        type: WoundType.ulceraPressao,
        location: WoundLocation.costas,
        description: 'Úlcera por pressão',
        status: WoundStatus.ativa,
        identificationDate: baseDate,
        createdAt: baseDate,
        updatedAt: baseDate,
      ),
      Wound(
        id: 'wound-2',
        patientId: 'patient-1',
        type: WoundType.traumatica,
        location: WoundLocation.bracos,
        description: 'Ferida traumática',
        status: WoundStatus.cicatrizada,
        identificationDate: baseDate.add(const Duration(days: 1)),
        createdAt: baseDate.add(const Duration(days: 1)),
        updatedAt: baseDate.add(const Duration(days: 1)),
        healedDate: baseDate.add(const Duration(days: 7)),
      ),
      Wound(
        id: 'wound-3',
        patientId: 'patient-1',
        type: WoundType.peDiabetico,
        location: WoundLocation.pes,
        description: 'Úlcera diabética',
        status: WoundStatus.infectada,
        identificationDate: baseDate.add(const Duration(days: 2)),
        createdAt: baseDate.add(const Duration(days: 2)),
        updatedAt: baseDate.add(const Duration(days: 2)),
      ),
    ];

    final validInput = GetWoundHistoryInput(patientId: 'patient-1');

    test('deve retornar histórico completo de feridas do paciente', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundsByPatient('patient-1'),
      ).thenAnswer((_) async => mockWounds);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<WoundHistoryOutput>>());
      final success = result as Success<WoundHistoryOutput>;
      final output = success.value;

      expect(output.wounds.length, equals(3));
      expect(output.totalCount, equals(3));
      expect(output.hasMore, equals(false));
      expect(output.summary, isNotEmpty);

      verify(
        () => mockWoundRepository.getWoundsByPatient('patient-1'),
      ).called(1);
    });

    test('deve filtrar por status específico', () async {
      // Arrange
      final filterInput = GetWoundHistoryInput(
        patientId: 'patient-1',
        filterByStatus: WoundStatus.ativa,
      );

      when(
        () => mockWoundRepository.getWoundsByPatient('patient-1'),
      ).thenAnswer((_) async => mockWounds);

      // Act
      final result = await useCase.execute(filterInput);

      // Assert
      expect(result, isA<Success<WoundHistoryOutput>>());
      final success = result as Success<WoundHistoryOutput>;
      final output = success.value;

      expect(output.wounds.length, equals(1));
      expect(output.wounds.first.status, equals(WoundStatus.ativa));
      expect(output.totalCount, equals(1));
    });

    test('deve falhar quando ferida específica não existe', () async {
      // Arrange
      final specificWoundInput = GetWoundHistoryInput(
        patientId: 'patient-1',
        woundId: 'inexistente',
      );

      when(
        () => mockWoundRepository.getWoundById('inexistente'),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.execute(specificWoundInput);

      // Assert
      expect(result, isA<Failure<WoundHistoryOutput>>());
      final failure = result as Failure<WoundHistoryOutput>;
      expect(failure.error, isA<NotFoundError>());
    });

    test('deve falhar quando ID do paciente está vazio', () async {
      // Arrange
      final invalidInput = GetWoundHistoryInput(patientId: '');

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<WoundHistoryOutput>>());
      final failure = result as Failure<WoundHistoryOutput>;
      expect(failure.error, isA<ValidationError>());

      verifyNever(() => mockWoundRepository.getWoundsByPatient(any()));
    });

    test('deve falhar quando limite é inválido', () async {
      // Arrange
      final invalidLimitInput = GetWoundHistoryInput(
        patientId: 'patient-1',
        limit: 0,
      );

      // Act
      final result = await useCase.execute(invalidLimitInput);

      // Assert
      expect(result, isA<Failure<WoundHistoryOutput>>());
    });

    test('deve gerar resumo correto para múltiplas feridas', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundsByPatient('patient-1'),
      ).thenAnswer((_) async => mockWounds);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<WoundHistoryOutput>>());
      final success = result as Success<WoundHistoryOutput>;

      expect(success.value.summary, contains('3 feridas total'));
    });

    test('deve retornar lista vazia quando não há feridas', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundsByPatient('patient-1'),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<WoundHistoryOutput>>());
      final success = result as Success<WoundHistoryOutput>;

      expect(success.value.wounds, isEmpty);
      expect(success.value.totalCount, equals(0));
      expect(
        success.value.summary,
        equals('Nenhuma ferida encontrada para este paciente.'),
      );
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundsByPatient('patient-1'),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<WoundHistoryOutput>>());
      final failure = result as Failure<WoundHistoryOutput>;
      expect(failure.error, isA<SystemError>());
    });
  });
}
