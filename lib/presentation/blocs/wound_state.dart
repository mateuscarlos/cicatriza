import 'package:equatable/equatable.dart';
import '../../domain/entities/wound_manual.dart';

/// Estados do WoundBloc
abstract class WoundState extends Equatable {
  const WoundState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class WoundInitialState extends WoundState {
  const WoundInitialState();
}

/// Carregando feridas
class WoundLoadingState extends WoundState {
  const WoundLoadingState();
}

/// Feridas carregadas com sucesso
class WoundLoadedState extends WoundState {
  final List<WoundManual> wounds;
  final WoundManual? selectedWound;
  final String? currentPatientId;
  final Map<String, dynamic>? activeFilters;

  const WoundLoadedState({
    required this.wounds,
    this.selectedWound,
    this.currentPatientId,
    this.activeFilters,
  });

  @override
  List<Object?> get props => [
    wounds,
    selectedWound,
    currentPatientId,
    activeFilters,
  ];

  WoundLoadedState copyWith({
    List<WoundManual>? wounds,
    WoundManual? selectedWound,
    String? currentPatientId,
    Map<String, dynamic>? activeFilters,
    bool clearSelectedWound = false,
    bool clearFilters = false,
  }) {
    return WoundLoadedState(
      wounds: wounds ?? this.wounds,
      selectedWound: clearSelectedWound
          ? null
          : (selectedWound ?? this.selectedWound),
      currentPatientId: currentPatientId ?? this.currentPatientId,
      activeFilters: clearFilters
          ? null
          : (activeFilters ?? this.activeFilters),
    );
  }
}

/// Erro ao carregar/manipular feridas
class WoundErrorState extends WoundState {
  final String message;
  final List<WoundManual> wounds;
  final WoundManual? selectedWound;
  final String? currentPatientId;

  const WoundErrorState({
    required this.message,
    this.wounds = const [],
    this.selectedWound,
    this.currentPatientId,
  });

  @override
  List<Object?> get props => [message, wounds, selectedWound, currentPatientId];
}

/// Operação de criação/atualização em progresso
class WoundOperationInProgressState extends WoundState {
  final List<WoundManual> wounds;
  final WoundManual? selectedWound;
  final String
  operation; // 'creating', 'updating', 'deleting', 'updating_status'
  final String? currentPatientId;

  const WoundOperationInProgressState({
    required this.wounds,
    required this.operation,
    this.selectedWound,
    this.currentPatientId,
  });

  @override
  List<Object?> get props => [
    wounds,
    selectedWound,
    operation,
    currentPatientId,
  ];
}

/// Operação concluída com sucesso
class WoundOperationSuccessState extends WoundState {
  final List<WoundManual> wounds;
  final WoundManual? selectedWound;
  final String message;
  final String? currentPatientId;

  const WoundOperationSuccessState({
    required this.wounds,
    required this.message,
    this.selectedWound,
    this.currentPatientId,
  });

  @override
  List<Object?> get props => [wounds, selectedWound, message, currentPatientId];
}
