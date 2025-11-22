import 'package:equatable/equatable.dart';
import '../../domain/entities/patient_manual.dart';

/// Estados do PatientBloc
abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class PatientInitialState extends PatientState {
  const PatientInitialState();
}

/// Carregando pacientes
class PatientLoadingState extends PatientState {
  const PatientLoadingState();
}

/// Pacientes carregados com sucesso
class PatientLoadedState extends PatientState {
  final List<PatientManual> patients;
  final PatientManual? selectedPatient;
  final String? searchQuery;
  final bool isSearching;

  const PatientLoadedState({
    required this.patients,
    this.selectedPatient,
    this.searchQuery,
    this.isSearching = false,
  });

  @override
  List<Object?> get props => [
    patients,
    selectedPatient,
    searchQuery,
    isSearching,
  ];

  PatientLoadedState copyWith({
    List<PatientManual>? patients,
    PatientManual? selectedPatient,
    String? searchQuery,
    bool? isSearching,
    bool clearSelectedPatient = false,
    bool clearSearchQuery = false,
  }) {
    return PatientLoadedState(
      patients: patients ?? this.patients,
      selectedPatient: clearSelectedPatient
          ? null
          : (selectedPatient ?? this.selectedPatient),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

/// Erro ao carregar/manipular pacientes
class PatientErrorState extends PatientState {
  final String message;
  final List<PatientManual> patients;
  final PatientManual? selectedPatient;

  const PatientErrorState({
    required this.message,
    this.patients = const [],
    this.selectedPatient,
  });

  @override
  List<Object?> get props => [message, patients, selectedPatient];
}

/// Operação de criação/atualização em progresso
class PatientOperationInProgressState extends PatientState {
  final List<PatientManual> patients;
  final PatientManual? selectedPatient;
  final String operation; // 'creating', 'updating', 'archiving'

  const PatientOperationInProgressState({
    required this.patients,
    required this.operation,
    this.selectedPatient,
  });

  @override
  List<Object?> get props => [patients, selectedPatient, operation];
}

/// Operação concluída com sucesso
class PatientOperationSuccessState extends PatientState {
  final List<PatientManual> patients;
  final PatientManual? selectedPatient;
  final String message;

  const PatientOperationSuccessState({
    required this.patients,
    required this.message,
    this.selectedPatient,
  });

  @override
  List<Object?> get props => [patients, selectedPatient, message];
}
