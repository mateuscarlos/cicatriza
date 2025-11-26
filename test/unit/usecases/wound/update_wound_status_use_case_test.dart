import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/wound.dart';
import '../../../../lib/domain/repositories/wound_repository.dart';
import '../../../../lib/domain/usecases/base/use_case.dart';
import '../../../../lib/domain/usecases/wound/update_wound_status_use_case.dart';

class MockWoundRepository extends Mock implements WoundRepository {}

class FakeWound extends Fake implements Wound {}

void main() {
  late UpdateWoundStatusUseCase useCase;
  late MockWoundRepository mockWoundRepository;

  setUpAll(() {
    registerFallbackValue(FakeWound());
  });

  setUp(() {
    mockWoundRepository = MockWoundRepository();
    useCase = UpdateWoundStatusUseCase(mockWoundRepository);
  });

  group('UpdateWoundStatusUseCase', () {
    final mockWound = Wound(
      id: 'wound-1',
      patientId: 'patient-1',
      type: WoundType.ulceraPressao,
      location: WoundLocation.costas,
      description: 'Úlcera por pressão',
      status: WoundStatus.ativa,
      identificationDate: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    );

    final validInput = UpdateWoundStatusInput(
      woundId: 'wound-1',
      newStatus: WoundStatus.emCicatrizacao,
      reason: 'Melhora observada após tratamento',
    );

    test('deve atualizar status com sucesso quando dados válidos', () async {
      // Arrange
      final updatedWound = mockWound.copyWith(
        status: WoundStatus.emCicatrizacao,
        updatedAt: DateTime.now(),
      );

      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockWoundRepository.updateWound(any()),
      ).thenAnswer((_) async => updatedWound);

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Success<Wound>>());
      final success = result as Success<Wound>;
      expect(success.value.status, equals(WoundStatus.emCicatrizacao));

      verify(() => mockWoundRepository.getWoundById('wound-1')).called(1);
      verify(() => mockWoundRepository.updateWound(any())).called(1);
    });

    test('deve falhar quando ferida não existe', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('inexistente'),
      ).thenAnswer((_) async => null);

      final invalidInput = UpdateWoundStatusInput(
        woundId: 'inexistente',
        newStatus: WoundStatus.emCicatrizacao,
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<NotFoundError>());
      expect((failure.error as NotFoundError).entityType, equals('Wound'));
      expect((failure.error as NotFoundError).entityId, equals('inexistente'));

      verify(() => mockWoundRepository.getWoundById('inexistente')).called(1);
      verifyNever(() => mockWoundRepository.updateWound(any()));
    });

    test('deve falhar quando status já é o desejado', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);

      final sameStatusInput = UpdateWoundStatusInput(
        woundId: 'wound-1',
        newStatus: WoundStatus.ativa, // Mesmo status atual
      );

      // Act
      final result = await useCase.execute(sameStatusInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<ConflictError>());
      expect((failure.error as ConflictError).code, equals('STATUS_UNCHANGED'));

      verify(() => mockWoundRepository.getWoundById('wound-1')).called(1);
      verifyNever(() => mockWoundRepository.updateWound(any()));
    });

    test('deve falhar quando ID da ferida está vazio', () async {
      // Arrange
      final invalidInput = UpdateWoundStatusInput(
        woundId: '',
        newStatus: WoundStatus.emCicatrizacao,
      );

      // Act
      final result = await useCase.execute(invalidInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<ValidationError>());
      expect((failure.error as ValidationError).field, equals('woundId'));

      verifyNever(() => mockWoundRepository.getWoundById(any()));
      verifyNever(() => mockWoundRepository.updateWound(any()));
    });

    test('deve marcar como cicatrizada com data de cura', () async {
      // Arrange
      final healedWound = mockWound.copyWith(
        status: WoundStatus.cicatrizada,
        healedDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final healInput = UpdateWoundStatusInput(
        woundId: 'wound-1',
        newStatus: WoundStatus.cicatrizada,
        reason: 'Cicatrização completa observada',
      );

      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockWoundRepository.updateWound(any()),
      ).thenAnswer((_) async => healedWound);

      // Act
      final result = await useCase.execute(healInput);

      // Assert
      expect(result, isA<Success<Wound>>());
      final success = result as Success<Wound>;
      expect(success.value.status, equals(WoundStatus.cicatrizada));
      expect(success.value.healedDate, isNotNull);

      verify(() => mockWoundRepository.updateWound(any())).called(1);
    });

    test('deve atualizar status sem motivo', () async {
      // Arrange
      final updatedWound = mockWound.copyWith(
        status: WoundStatus.infectada,
        updatedAt: DateTime.now(),
      );

      final inputWithoutReason = UpdateWoundStatusInput(
        woundId: 'wound-1',
        newStatus: WoundStatus.infectada,
      );

      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockWoundRepository.updateWound(any()),
      ).thenAnswer((_) async => updatedWound);

      // Act
      final result = await useCase.execute(inputWithoutReason);

      // Assert
      expect(result, isA<Success<Wound>>());
      final success = result as Success<Wound>;
      expect(success.value.status, equals(WoundStatus.infectada));

      verify(() => mockWoundRepository.updateWound(any())).called(1);
    });

    test('deve tratar exceção do repositório', () async {
      // Arrange
      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => mockWound);
      when(
        () => mockWoundRepository.updateWound(any()),
      ).thenThrow(Exception('Erro de conectividade'));

      // Act
      final result = await useCase.execute(validInput);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<SystemError>());
      expect(
        (failure.error as SystemError).message,
        contains('Erro interno ao atualizar status'),
      );
    });

    test('deve tratar transição inválida através da entidade', () async {
      // Arrange
      final cicatrizadaWound = mockWound.copyWith(
        status: WoundStatus.cicatrizada,
      );

      when(
        () => mockWoundRepository.getWoundById('wound-1'),
      ).thenAnswer((_) async => cicatrizadaWound);
      when(
        () => mockWoundRepository.updateWound(any()),
      ).thenThrow(Exception('Transição inválida'));

      final invalidTransition = UpdateWoundStatusInput(
        woundId: 'wound-1',
        newStatus: WoundStatus.emCicatrizacao,
      );

      // Act
      final result = await useCase.execute(invalidTransition);

      // Assert
      expect(result, isA<Failure<Wound>>());
      final failure = result as Failure<Wound>;
      expect(failure.error, isA<SystemError>());
    });
  });
}
