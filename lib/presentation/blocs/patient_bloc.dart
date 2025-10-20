import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/patient_manual.dart';
import '../../domain/repositories/patient_repository_manual.dart';
import '../../core/utils/app_logger.dart';
import 'patient_event.dart';
import 'patient_state.dart';

/// BLoC para gerenciar estado dos pacientes
class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository _patientRepository;
  StreamSubscription<List<PatientManual>>? _patientsSubscription;

  PatientBloc({required PatientRepository patientRepository})
    : _patientRepository = patientRepository,
      super(const PatientInitialState()) {
    // Registra os handlers dos eventos
    on<LoadPatientsEvent>(_onLoadPatients);
    on<SearchPatientsEvent>(_onSearchPatients);
    on<CreatePatientEvent>(_onCreatePatient);
    on<UpdatePatientEvent>(_onUpdatePatient);
    on<ArchivePatientEvent>(_onArchivePatient);
    on<SelectPatientEvent>(_onSelectPatient);
    on<ClearSearchEvent>(_onClearSearch);
    on<_PatientsUpdatedEvent>(_onPatientsUpdated);
  }

  /// Carrega todos os pacientes e inicia stream de atualizações
  Future<void> _onLoadPatients(
    LoadPatientsEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(const PatientLoadingState());

      // Cancela subscription anterior se existir
      await _patientsSubscription?.cancel();

      // Inicia stream de pacientes
      _patientsSubscription = _patientRepository.watchPatients().listen((
        patients,
      ) {
        if (!isClosed) {
          add(const _PatientsUpdatedEvent());
        }
      });

      // Carrega pacientes iniciais
      final patients = await _patientRepository.getPatients();

      emit(PatientLoadedState(patients: patients));
    } catch (e) {
      emit(PatientErrorState(message: 'Erro ao carregar pacientes: $e'));
    }
  }

  /// Busca pacientes por termo
  Future<void> _onSearchPatients(
    SearchPatientsEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      if (state is PatientLoadedState) {
        final currentState = state as PatientLoadedState;

        emit(currentState.copyWith(isSearching: true));

        if (event.query.trim().isEmpty) {
          // Se busca vazia, carrega todos os pacientes
          final patients = await _patientRepository.getPatients();
          emit(
            currentState.copyWith(
              patients: patients,
              isSearching: false,
              clearSearchQuery: true,
            ),
          );
        } else {
          // Busca por termo
          final patients = await _patientRepository.searchPatients(event.query);
          emit(
            currentState.copyWith(
              patients: patients,
              searchQuery: event.query,
              isSearching: false,
            ),
          );
        }
      }
    } catch (e) {
      if (state is PatientLoadedState) {
        final currentState = state as PatientLoadedState;
        emit(
          PatientErrorState(
            message: 'Erro ao buscar pacientes: $e',
            patients: currentState.patients,
            selectedPatient: currentState.selectedPatient,
          ),
        );
      } else {
        emit(PatientErrorState(message: 'Erro ao buscar pacientes: $e'));
      }
    }
  }

  /// Cria um novo paciente
  Future<void> _onCreatePatient(
    CreatePatientEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      final currentPatients = _getCurrentPatients();

      emit(
        PatientOperationInProgressState(
          patients: currentPatients,
          operation: 'creating',
          selectedPatient: _getCurrentSelectedPatient(),
        ),
      );

      final newPatient = PatientManual.create(
        name: event.name,
        birthDate: event.birthDate,
        notes: event.notes,
        phone: event.phone,
        email: event.email,
      );

      final createdPatient = await _patientRepository.createPatient(newPatient);

      final updatedPatients = [createdPatient, ...currentPatients];

      emit(
        PatientOperationSuccessState(
          patients: updatedPatients,
          message: 'Paciente criado com sucesso!',
          selectedPatient: createdPatient,
        ),
      );
    } catch (e) {
      emit(
        PatientErrorState(
          message: 'Erro ao criar paciente: $e',
          patients: _getCurrentPatients(),
          selectedPatient: _getCurrentSelectedPatient(),
        ),
      );
    }
  }

  /// Atualiza um paciente existente
  Future<void> _onUpdatePatient(
    UpdatePatientEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      final currentPatients = _getCurrentPatients();

      emit(
        PatientOperationInProgressState(
          patients: currentPatients,
          operation: 'updating',
          selectedPatient: _getCurrentSelectedPatient(),
        ),
      );

      await _patientRepository.updatePatient(event.patient);

      final updatedPatients = currentPatients.map((p) {
        return p.id == event.patient.id ? event.patient : p;
      }).toList();

      emit(
        PatientOperationSuccessState(
          patients: updatedPatients,
          message: 'Paciente atualizado com sucesso!',
          selectedPatient: event.patient,
        ),
      );
    } catch (e) {
      emit(
        PatientErrorState(
          message: 'Erro ao atualizar paciente: $e',
          patients: _getCurrentPatients(),
          selectedPatient: _getCurrentSelectedPatient(),
        ),
      );
    }
  }

  /// Arquiva um paciente
  Future<void> _onArchivePatient(
    ArchivePatientEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      final currentPatients = _getCurrentPatients();
      final selectedPatient = _getCurrentSelectedPatient();

      emit(
        PatientOperationInProgressState(
          patients: currentPatients,
          operation: 'archiving',
          selectedPatient: selectedPatient,
        ),
      );

      await _patientRepository.togglePatientArchived(event.patientId);

      final updatedPatients = currentPatients
          .where((p) => p.id != event.patientId)
          .toList();

      // Se o paciente arquivado estava selecionado, limpa a seleção
      final newSelectedPatient = selectedPatient?.id == event.patientId
          ? null
          : selectedPatient;

      emit(
        PatientOperationSuccessState(
          patients: updatedPatients,
          message: 'Paciente arquivado com sucesso!',
          selectedPatient: newSelectedPatient,
        ),
      );
    } catch (e) {
      emit(
        PatientErrorState(
          message: 'Erro ao arquivar paciente: $e',
          patients: _getCurrentPatients(),
          selectedPatient: _getCurrentSelectedPatient(),
        ),
      );
    }
  }

  /// Seleciona um paciente
  Future<void> _onSelectPatient(
    SelectPatientEvent event,
    Emitter<PatientState> emit,
  ) async {
    if (state is PatientLoadedState) {
      final currentState = state as PatientLoadedState;
      emit(currentState.copyWith(selectedPatient: event.patient));
    }
  }

  /// Limpa a busca
  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      if (state is PatientLoadedState) {
        final currentState = state as PatientLoadedState;

        emit(currentState.copyWith(isSearching: true));

        final patients = await _patientRepository.getPatients();

        emit(
          currentState.copyWith(
            patients: patients,
            isSearching: false,
            clearSearchQuery: true,
          ),
        );
      }
    } catch (e) {
      if (state is PatientLoadedState) {
        final currentState = state as PatientLoadedState;
        emit(
          PatientErrorState(
            message: 'Erro ao limpar busca: $e',
            patients: currentState.patients,
            selectedPatient: currentState.selectedPatient,
          ),
        );
      }
    }
  }

  Future<void> _onPatientsUpdated(
    _PatientsUpdatedEvent event,
    Emitter<PatientState> emit,
  ) async {
    if (state is! PatientLoadedState) return;

    try {
      final currentState = state as PatientLoadedState;
      final query = currentState.searchQuery ?? '';
      final latestPatients = await _patientRepository.searchPatients(query);
      final currentSelected = currentState.selectedPatient;

      PatientManual? updatedSelected;
      if (currentSelected != null) {
        for (final patient in latestPatients) {
          if (patient.id == currentSelected.id) {
            updatedSelected = patient;
            break;
          }
        }
      }

      emit(
        currentState.copyWith(
          patients: latestPatients,
          selectedPatient: updatedSelected,
          clearSelectedPatient:
              currentSelected != null && updatedSelected == null,
        ),
      );
    } catch (e) {
      // Mantém o estado atual mas registra o erro para investigação.
      AppLogger.error('Erro ao atualizar pacientes via stream', error: e);
    }
  }

  /// Obtém a lista atual de pacientes do estado
  List<PatientManual> _getCurrentPatients() {
    if (state is PatientLoadedState) {
      return (state as PatientLoadedState).patients;
    }
    if (state is PatientErrorState) {
      return (state as PatientErrorState).patients;
    }
    if (state is PatientOperationInProgressState) {
      return (state as PatientOperationInProgressState).patients;
    }
    if (state is PatientOperationSuccessState) {
      return (state as PatientOperationSuccessState).patients;
    }
    return [];
  }

  /// Obtém o paciente selecionado atual do estado
  PatientManual? _getCurrentSelectedPatient() {
    if (state is PatientLoadedState) {
      return (state as PatientLoadedState).selectedPatient;
    }
    if (state is PatientErrorState) {
      return (state as PatientErrorState).selectedPatient;
    }
    if (state is PatientOperationInProgressState) {
      return (state as PatientOperationInProgressState).selectedPatient;
    }
    if (state is PatientOperationSuccessState) {
      return (state as PatientOperationSuccessState).selectedPatient;
    }
    return null;
  }

  @override
  Future<void> close() {
    _patientsSubscription?.cancel();
    return super.close();
  }
}

/// Evento interno para atualizações via stream
class _PatientsUpdatedEvent extends PatientEvent {
  const _PatientsUpdatedEvent();
}
