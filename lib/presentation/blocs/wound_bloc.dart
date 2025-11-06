import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/wound_manual.dart';
import '../../domain/repositories/wound_repository_manual.dart';
import 'wound_event.dart';
import 'wound_state.dart';

/// BLoC para gerenciar estado das feridas
class WoundBloc extends Bloc<WoundEvent, WoundState> {
  final WoundRepository _woundRepository;
  StreamSubscription<List<WoundManual>>? _woundsSubscription;

  WoundBloc({required WoundRepository woundRepository})
    : _woundRepository = woundRepository,
      super(const WoundInitialState()) {
    // Registra os handlers dos eventos
    on<LoadWoundsByPatientEvent>(_onLoadWoundsByPatient);
    on<CreateWoundEvent>(_onCreateWound);
    on<UpdateWoundEvent>(_onUpdateWound);
    on<UpdateWoundStatusEvent>(_onUpdateWoundStatus);
    on<DeleteWoundEvent>(_onDeleteWound);
    on<SelectWoundEvent>(_onSelectWound);
    on<FilterWoundsEvent>(_onFilterWounds);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  /// Carrega feridas de um paciente
  Future<void> _onLoadWoundsByPatient(
    LoadWoundsByPatientEvent event,
    Emitter<WoundState> emit,
  ) async {
    try {
      emit(const WoundLoadingState());

      // Cancela subscription anterior se existir
      await _woundsSubscription?.cancel();

      // Carrega feridas iniciais
      final wounds = await _woundRepository.getWoundsByPatientId(
        event.patientId,
      );

      if (!emit.isDone) {
        emit(
          WoundLoadedState(wounds: wounds, currentPatientId: event.patientId),
        );
      }

      // Inicia stream de feridas do paciente APÓS emitir o estado inicial
      await emit.forEach<List<WoundManual>>(
        _woundRepository.watchWounds(event.patientId),
        onData: (woundsList) {
          return WoundLoadedState(
            wounds: woundsList,
            currentPatientId: event.patientId,
          );
        },
      );
    } catch (e) {
      emit(
        WoundErrorState(
          message: 'Erro ao carregar feridas: $e',
          currentPatientId: event.patientId,
        ),
      );
    }
  }

  /// Cria uma nova ferida
  Future<void> _onCreateWound(
    CreateWoundEvent event,
    Emitter<WoundState> emit,
  ) async {
    try {
      final currentWounds = _getCurrentWounds();

      emit(
        WoundOperationInProgressState(
          wounds: currentWounds,
          operation: 'creating',
          selectedWound: _getCurrentSelectedWound(),
          currentPatientId: event.patientId,
        ),
      );

      final newWound = WoundManual.create(
        patientId: event.patientId,
        type: event.type,
        location: event.location,
        locationDescription: event.locationDescription,
        causeDescription: event.causeDescription,
      );

      final createdWound = await _woundRepository.createWound(newWound);

      final updatedWounds = [createdWound, ...currentWounds];

      emit(
        WoundOperationSuccessState(
          wounds: updatedWounds,
          message: 'Ferida criada com sucesso!',
          selectedWound: createdWound,
          currentPatientId: event.patientId,
        ),
      );
    } catch (e) {
      emit(
        WoundErrorState(
          message: 'Erro ao criar ferida: $e',
          wounds: _getCurrentWounds(),
          selectedWound: _getCurrentSelectedWound(),
          currentPatientId: event.patientId,
        ),
      );
    }
  }

  /// Atualiza uma ferida existente
  Future<void> _onUpdateWound(
    UpdateWoundEvent event,
    Emitter<WoundState> emit,
  ) async {
    try {
      final currentWounds = _getCurrentWounds();

      emit(
        WoundOperationInProgressState(
          wounds: currentWounds,
          operation: 'updating',
          selectedWound: _getCurrentSelectedWound(),
          currentPatientId: _getCurrentPatientId(),
        ),
      );

      final updatedWound = await _woundRepository.updateWound(event.wound);

      final updatedWounds = currentWounds.map((w) {
        return w.id == updatedWound.id ? updatedWound : w;
      }).toList();

      emit(
        WoundOperationSuccessState(
          wounds: updatedWounds,
          message: 'Ferida atualizada com sucesso!',
          selectedWound: updatedWound,
          currentPatientId: _getCurrentPatientId(),
        ),
      );
    } catch (e) {
      emit(
        WoundErrorState(
          message: 'Erro ao atualizar ferida: $e',
          wounds: _getCurrentWounds(),
          selectedWound: _getCurrentSelectedWound(),
          currentPatientId: _getCurrentPatientId(),
        ),
      );
    }
  }

  /// Atualiza apenas o status de uma ferida
  Future<void> _onUpdateWoundStatus(
    UpdateWoundStatusEvent event,
    Emitter<WoundState> emit,
  ) async {
    try {
      final currentWounds = _getCurrentWounds();

      emit(
        WoundOperationInProgressState(
          wounds: currentWounds,
          operation: 'updating_status',
          selectedWound: _getCurrentSelectedWound(),
          currentPatientId: _getCurrentPatientId(),
        ),
      );

      final updatedWound = await _woundRepository.updateWoundStatus(
        event.woundId,
        event.newStatus,
      );

      final updatedWounds = currentWounds.map((w) {
        return w.id == updatedWound.id ? updatedWound : w;
      }).toList();

      emit(
        WoundOperationSuccessState(
          wounds: updatedWounds,
          message: 'Status da ferida atualizado!',
          selectedWound: updatedWound,
          currentPatientId: _getCurrentPatientId(),
        ),
      );
    } catch (e) {
      emit(
        WoundErrorState(
          message: 'Erro ao atualizar status: $e',
          wounds: _getCurrentWounds(),
          selectedWound: _getCurrentSelectedWound(),
          currentPatientId: _getCurrentPatientId(),
        ),
      );
    }
  }

  /// Deleta uma ferida
  Future<void> _onDeleteWound(
    DeleteWoundEvent event,
    Emitter<WoundState> emit,
  ) async {
    try {
      final currentWounds = _getCurrentWounds();
      final selectedWound = _getCurrentSelectedWound();

      emit(
        WoundOperationInProgressState(
          wounds: currentWounds,
          operation: 'deleting',
          selectedWound: selectedWound,
          currentPatientId: _getCurrentPatientId(),
        ),
      );

      await _woundRepository.deleteWound(event.woundId);

      final updatedWounds = currentWounds
          .where((w) => w.id != event.woundId)
          .toList();

      // Se a ferida deletada estava selecionada, limpa a seleção
      final newSelectedWound = selectedWound?.id == event.woundId
          ? null
          : selectedWound;

      emit(
        WoundOperationSuccessState(
          wounds: updatedWounds,
          message: 'Ferida removida com sucesso!',
          selectedWound: newSelectedWound,
          currentPatientId: _getCurrentPatientId(),
        ),
      );
    } catch (e) {
      emit(
        WoundErrorState(
          message: 'Erro ao remover ferida: $e',
          wounds: _getCurrentWounds(),
          selectedWound: _getCurrentSelectedWound(),
          currentPatientId: _getCurrentPatientId(),
        ),
      );
    }
  }

  /// Seleciona uma ferida
  Future<void> _onSelectWound(
    SelectWoundEvent event,
    Emitter<WoundState> emit,
  ) async {
    if (state is WoundLoadedState) {
      final currentState = state as WoundLoadedState;
      emit(currentState.copyWith(selectedWound: event.wound));
    }
  }

  /// Filtra feridas
  Future<void> _onFilterWounds(
    FilterWoundsEvent event,
    Emitter<WoundState> emit,
  ) async {
    try {
      emit(const WoundLoadingState());

      final wounds = await _woundRepository.getWoundsWithFilters(
        patientId: event.patientId,
        status: event.status,
        type: event.type,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );

      final filters = <String, dynamic>{};
      if (event.patientId != null) filters['patientId'] = event.patientId;
      if (event.status != null) filters['status'] = event.status;
      if (event.type != null) filters['type'] = event.type;
      if (event.fromDate != null) filters['fromDate'] = event.fromDate;
      if (event.toDate != null) filters['toDate'] = event.toDate;

      emit(
        WoundLoadedState(
          wounds: wounds,
          currentPatientId: event.patientId,
          activeFilters: filters.isNotEmpty ? filters : null,
        ),
      );
    } catch (e) {
      emit(
        WoundErrorState(
          message: 'Erro ao filtrar feridas: $e',
          currentPatientId: event.patientId,
        ),
      );
    }
  }

  /// Limpa filtros
  Future<void> _onClearFilters(
    ClearFiltersEvent event,
    Emitter<WoundState> emit,
  ) async {
    // Recarrega feridas do paciente sem filtros
    add(LoadWoundsByPatientEvent(event.patientId));
  }

  /// Obtém a lista atual de feridas do estado
  List<WoundManual> _getCurrentWounds() {
    if (state is WoundLoadedState) {
      return (state as WoundLoadedState).wounds;
    }
    if (state is WoundErrorState) {
      return (state as WoundErrorState).wounds;
    }
    if (state is WoundOperationInProgressState) {
      return (state as WoundOperationInProgressState).wounds;
    }
    if (state is WoundOperationSuccessState) {
      return (state as WoundOperationSuccessState).wounds;
    }
    return [];
  }

  /// Obtém a ferida selecionada atual do estado
  WoundManual? _getCurrentSelectedWound() {
    if (state is WoundLoadedState) {
      return (state as WoundLoadedState).selectedWound;
    }
    if (state is WoundErrorState) {
      return (state as WoundErrorState).selectedWound;
    }
    if (state is WoundOperationInProgressState) {
      return (state as WoundOperationInProgressState).selectedWound;
    }
    if (state is WoundOperationSuccessState) {
      return (state as WoundOperationSuccessState).selectedWound;
    }
    return null;
  }

  /// Obtém o ID do paciente atual do estado
  String? _getCurrentPatientId() {
    if (state is WoundLoadedState) {
      return (state as WoundLoadedState).currentPatientId;
    }
    if (state is WoundErrorState) {
      return (state as WoundErrorState).currentPatientId;
    }
    if (state is WoundOperationInProgressState) {
      return (state as WoundOperationInProgressState).currentPatientId;
    }
    if (state is WoundOperationSuccessState) {
      return (state as WoundOperationSuccessState).currentPatientId;
    }
    return null;
  }

  @override
  Future<void> close() {
    _woundsSubscription?.cancel();
    return super.close();
  }
}
