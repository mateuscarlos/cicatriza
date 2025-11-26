import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:cicatriza/core/services/analytics_service.dart';
import 'package:cicatriza/domain/entities/patient_manual.dart';
import 'package:cicatriza/domain/repositories/patient_repository_manual.dart';
import 'package:cicatriza/presentation/blocs/patient_bloc.dart';
import 'package:cicatriza/presentation/blocs/patient_event.dart';
import 'package:cicatriza/presentation/blocs/patient_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class FakePatientManual extends Fake implements PatientManual {}

void main() {
  late PatientBloc patientBloc;
  late MockPatientRepository mockPatientRepository;
  late MockAnalyticsService mockAnalyticsService;

  final testPatient = PatientManual(
    id: '1',
    name: 'Test Patient',
    nameLowercase: 'test patient',
    birthDate: DateTime(1990),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    notes: 'Test notes',
    phone: '123456789',
    email: 'test@example.com',
  );

  setUpAll(() {
    registerFallbackValue(FakePatientManual());
  });

  setUp(() {
    mockPatientRepository = MockPatientRepository();
    mockAnalyticsService = MockAnalyticsService();

    // Default stub for watchPatients to avoid null pointer if called
    when(
      () => mockPatientRepository.watchPatients(),
    ).thenAnswer((_) => const Stream.empty());

    patientBloc = PatientBloc(
      patientRepository: mockPatientRepository,
      analytics: mockAnalyticsService,
    );
  });

  tearDown(() {
    patientBloc.close();
  });

  group('PatientBloc', () {
    test('initial state is PatientInitialState', () {
      expect(patientBloc.state, const PatientInitialState());
    });

    blocTest<PatientBloc, PatientState>(
      'emits [PatientLoadingState, PatientLoadedState] when LoadPatientsEvent succeeds',
      build: () {
        when(
          () => mockPatientRepository.getPatients(),
        ).thenAnswer((_) async => [testPatient]);
        return patientBloc;
      },
      act: (bloc) => bloc.add(const LoadPatientsEvent()),
      expect: () => [
        const PatientLoadingState(),
        PatientLoadedState(patients: [testPatient]),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'emits [PatientLoadingState, PatientErrorState] when LoadPatientsEvent fails',
      build: () {
        when(
          () => mockPatientRepository.getPatients(),
        ).thenThrow(Exception('Load failed'));
        return patientBloc;
      },
      act: (bloc) => bloc.add(const LoadPatientsEvent()),
      expect: () => [
        const PatientLoadingState(),
        isA<PatientErrorState>().having(
          (s) => s.message,
          'message',
          contains('Load failed'),
        ),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'emits [PatientOperationInProgressState, PatientOperationSuccessState] when CreatePatientEvent succeeds',
      build: () {
        when(
          () => mockPatientRepository.createPatient(any()),
        ).thenAnswer((_) async => testPatient);
        when(
          () => mockAnalyticsService.logPatientCreated(),
        ).thenAnswer((_) async {});
        return patientBloc;
      },
      seed: () => const PatientLoadedState(patients: []),
      act: (bloc) => bloc.add(
        CreatePatientEvent(
          name: testPatient.name,
          birthDate: testPatient.birthDate,
          notes: testPatient.notes,
          phone: testPatient.phone,
          email: testPatient.email,
        ),
      ),
      expect: () => [
        isA<PatientOperationInProgressState>(),
        isA<PatientOperationSuccessState>().having(
          (s) => s.patients,
          'patients',
          contains(testPatient),
        ),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'emits [PatientOperationInProgressState, PatientErrorState] when CreatePatientEvent fails',
      build: () {
        when(
          () => mockPatientRepository.createPatient(any()),
        ).thenThrow(Exception('Create failed'));
        return patientBloc;
      },
      seed: () => const PatientLoadedState(patients: []),
      act: (bloc) => bloc.add(
        CreatePatientEvent(
          name: testPatient.name,
          birthDate: testPatient.birthDate,
        ),
      ),
      expect: () => [
        isA<PatientOperationInProgressState>(),
        isA<PatientErrorState>().having(
          (s) => s.message,
          'message',
          contains('Create failed'),
        ),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'emits [PatientOperationInProgressState, PatientOperationSuccessState] when UpdatePatientEvent succeeds',
      build: () {
        when(
          () => mockPatientRepository.updatePatient(any()),
        ).thenAnswer((_) async => testPatient);
        return patientBloc;
      },
      seed: () => PatientLoadedState(patients: [testPatient]),
      act: (bloc) => bloc.add(UpdatePatientEvent(testPatient)),
      expect: () => [
        isA<PatientOperationInProgressState>(),
        isA<PatientOperationSuccessState>(),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'emits [PatientOperationInProgressState, PatientOperationSuccessState] when ArchivePatientEvent succeeds',
      build: () {
        when(
          () => mockPatientRepository.togglePatientArchived(any()),
        ).thenAnswer((_) async => testPatient);
        return patientBloc;
      },
      seed: () => PatientLoadedState(patients: [testPatient]),
      act: (bloc) => bloc.add(ArchivePatientEvent(testPatient.id)),
      expect: () => [
        isA<PatientOperationInProgressState>(),
        isA<PatientOperationSuccessState>().having(
          (s) => s.patients,
          'patients',
          isEmpty,
        ),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'emits [PatientLoadedState] with selected patient when SelectPatientEvent is added',
      build: () => patientBloc,
      seed: () => PatientLoadedState(patients: [testPatient]),
      act: (bloc) => bloc.add(SelectPatientEvent(testPatient)),
      expect: () => [
        isA<PatientLoadedState>().having(
          (s) => s.selectedPatient,
          'selectedPatient',
          testPatient,
        ),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'emits [PatientLoadedState] with search results when SearchPatientsEvent is added',
      build: () {
        when(
          () => mockPatientRepository.searchPatients(any()),
        ).thenAnswer((_) async => [testPatient]);
        return patientBloc;
      },
      seed: () => PatientLoadedState(patients: [testPatient]),
      act: (bloc) => bloc.add(const SearchPatientsEvent('Test')),
      expect: () => [
        isA<PatientLoadedState>().having(
          (s) => s.isSearching,
          'isSearching',
          true,
        ),
        isA<PatientLoadedState>()
            .having((s) => s.isSearching, 'isSearching', false)
            .having((s) => s.searchQuery, 'searchQuery', 'Test')
            .having((s) => s.patients, 'patients', [testPatient]),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'emits [PatientLoadedState] with all patients when ClearSearchEvent is added',
      build: () {
        when(
          () => mockPatientRepository.getPatients(),
        ).thenAnswer((_) async => [testPatient]);
        return patientBloc;
      },
      seed: () =>
          PatientLoadedState(patients: [testPatient], searchQuery: 'Test'),
      act: (bloc) => bloc.add(const ClearSearchEvent()),
      expect: () => [
        isA<PatientLoadedState>().having(
          (s) => s.isSearching,
          'isSearching',
          true,
        ),
        isA<PatientLoadedState>()
            .having((s) => s.isSearching, 'isSearching', false)
            .having((s) => s.searchQuery, 'searchQuery', isNull),
      ],
    );
  });
}
