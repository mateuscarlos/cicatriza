import '../../entities/patient.dart';
import '../../repositories/patient_repository.dart';
import '../base/use_case.dart';

/// Input para listagem de pacientes
class ListPatientsInput {
  final bool?
  includeArchived; // null = todos, true = só arquivados, false = só ativos
  final String? searchQuery; // busca por nome
  final int? limit;
  final int? offset;

  const ListPatientsInput({
    this.includeArchived,
    this.searchQuery,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListPatientsInput &&
          runtimeType == other.runtimeType &&
          includeArchived == other.includeArchived &&
          searchQuery == other.searchQuery &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode =>
      includeArchived.hashCode ^
      searchQuery.hashCode ^
      limit.hashCode ^
      offset.hashCode;
}

/// Resultado da listagem de pacientes
class ListPatientsOutput {
  final List<Patient> patients;
  final int totalCount; // Total de pacientes (para paginação)
  final bool hasMore; // Indica se há mais resultados

  const ListPatientsOutput({
    required this.patients,
    required this.totalCount,
    required this.hasMore,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListPatientsOutput &&
          runtimeType == other.runtimeType &&
          patients == other.patients &&
          totalCount == other.totalCount &&
          hasMore == other.hasMore;

  @override
  int get hashCode =>
      patients.hashCode ^ totalCount.hashCode ^ hasMore.hashCode;
}

/// Caso de uso para listar pacientes com filtros.
///
/// Responsabilidades:
/// - Validar parâmetros de entrada
/// - Aplicar filtros de busca e arquivamento
/// - Implementar paginação
/// - Retornar lista de pacientes com metadados
class ListPatientsUseCase
    implements UseCase<ListPatientsInput, ListPatientsOutput> {
  final PatientRepository _patientRepository;

  const ListPatientsUseCase(this._patientRepository);

  @override
  Future<Result<ListPatientsOutput>> execute(ListPatientsInput input) async {
    try {
      // Validar parâmetros
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      List<Patient> patients;

      // Se há busca por nome, usar searchPatients
      if (input.searchQuery != null && input.searchQuery!.trim().isNotEmpty) {
        patients = await _patientRepository.searchPatients(input.searchQuery!);

        // Filtrar por status de arquivamento se especificado
        if (input.includeArchived != null) {
          patients = patients
              .where((p) => p.archived == input.includeArchived)
              .toList();
        }
      } else {
        // Usar getPatients e filtrar se necessário
        patients = await _patientRepository.getPatients();

        // Filtrar por status de arquivamento se especificado
        if (input.includeArchived == false) {
          patients = patients.where((p) => !p.archived).toList();
        } else if (input.includeArchived == true) {
          patients = patients.where((p) => p.archived).toList();
        }
      }

      // Ordenar por nome (case insensitive)
      patients.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      final totalCount = patients.length;

      // Aplicar paginação se especificada
      if (input.offset != null || input.limit != null) {
        final offset = input.offset ?? 0;
        final limit = input.limit ?? totalCount;

        final endIndex = (offset + limit).clamp(0, totalCount);
        patients = patients.sublist(offset.clamp(0, totalCount), endIndex);
      }

      final hasMore =
          input.limit != null &&
          (input.offset ?? 0) + patients.length < totalCount;

      final output = ListPatientsOutput(
        patients: patients,
        totalCount: totalCount,
        hasMore: hasMore,
      );

      return Success(output);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao listar pacientes: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os parâmetros de entrada
  ValidationError? _validateInput(ListPatientsInput input) {
    if (input.limit != null && input.limit! < 0) {
      return const ValidationError(
        'Limite deve ser maior ou igual a zero',
        field: 'limit',
      );
    }

    if (input.offset != null && input.offset! < 0) {
      return const ValidationError(
        'Offset deve ser maior ou igual a zero',
        field: 'offset',
      );
    }

    if (input.limit != null && input.limit! > 1000) {
      return const ValidationError(
        'Limite não pode ser maior que 1000',
        field: 'limit',
      );
    }

    return null;
  }
}
