import 'package:equatable/equatable.dart';
import '../../domain/entities/assessment_manual.dart';

/// Estados do AssessmentBloc
abstract class AssessmentState extends Equatable {
  const AssessmentState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AssessmentInitialState extends AssessmentState {
  const AssessmentInitialState();
}

/// Carregando avaliações
class AssessmentLoadingState extends AssessmentState {
  const AssessmentLoadingState();
}

/// Avaliações carregadas com sucesso
class AssessmentLoadedState extends AssessmentState {
  final List<AssessmentManual> assessments;
  final AssessmentManual? selectedAssessment;
  final AssessmentManual? latestAssessment;
  final String? currentWoundId;
  final Map<String, dynamic>? activeFilters;

  const AssessmentLoadedState({
    required this.assessments,
    this.selectedAssessment,
    this.latestAssessment,
    this.currentWoundId,
    this.activeFilters,
  });

  @override
  List<Object?> get props => [
    assessments,
    selectedAssessment,
    latestAssessment,
    currentWoundId,
    activeFilters,
  ];

  AssessmentLoadedState copyWith({
    List<AssessmentManual>? assessments,
    AssessmentManual? selectedAssessment,
    AssessmentManual? latestAssessment,
    String? currentWoundId,
    Map<String, dynamic>? activeFilters,
    bool clearSelectedAssessment = false,
    bool clearLatestAssessment = false,
    bool clearFilters = false,
  }) {
    return AssessmentLoadedState(
      assessments: assessments ?? this.assessments,
      selectedAssessment: clearSelectedAssessment
          ? null
          : (selectedAssessment ?? this.selectedAssessment),
      latestAssessment: clearLatestAssessment
          ? null
          : (latestAssessment ?? this.latestAssessment),
      currentWoundId: currentWoundId ?? this.currentWoundId,
      activeFilters: clearFilters
          ? null
          : (activeFilters ?? this.activeFilters),
    );
  }
}

/// Erro ao carregar/manipular avaliações
class AssessmentErrorState extends AssessmentState {
  final String message;
  final List<AssessmentManual> assessments;
  final AssessmentManual? selectedAssessment;
  final String? currentWoundId;

  const AssessmentErrorState({
    required this.message,
    this.assessments = const [],
    this.selectedAssessment,
    this.currentWoundId,
  });

  @override
  List<Object?> get props => [
    message,
    assessments,
    selectedAssessment,
    currentWoundId,
  ];
}

/// Operação de criação/atualização em progresso
class AssessmentOperationInProgressState extends AssessmentState {
  final List<AssessmentManual> assessments;
  final AssessmentManual? selectedAssessment;
  final String operation; // 'creating', 'updating', 'deleting', 'validating'
  final String? currentWoundId;

  const AssessmentOperationInProgressState({
    required this.assessments,
    required this.operation,
    this.selectedAssessment,
    this.currentWoundId,
  });

  @override
  List<Object?> get props => [
    assessments,
    selectedAssessment,
    operation,
    currentWoundId,
  ];
}

/// Operação concluída com sucesso
class AssessmentOperationSuccessState extends AssessmentState {
  final List<AssessmentManual> assessments;
  final AssessmentManual? selectedAssessment;
  final String message;
  final String? currentWoundId;

  const AssessmentOperationSuccessState({
    required this.assessments,
    required this.message,
    this.selectedAssessment,
    this.currentWoundId,
  });

  @override
  List<Object?> get props => [
    assessments,
    selectedAssessment,
    message,
    currentWoundId,
  ];
}

/// Estado de validação
class AssessmentValidationState extends AssessmentState {
  final Map<String, String> errors;
  final bool isValid;

  const AssessmentValidationState({
    required this.errors,
    required this.isValid,
  });

  @override
  List<Object?> get props => [errors, isValid];
}
