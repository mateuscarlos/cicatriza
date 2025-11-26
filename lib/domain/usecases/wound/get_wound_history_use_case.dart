import '../../entities/wound.dart';
import '../../repositories/wound_repository.dart';
import '../base/use_case.dart';

/// Input para obter histórico de feridas
class GetWoundHistoryInput {
  final String patientId;
  final String?
  woundId; // Se especificado, retorna histórico de uma ferida específica
  final WoundStatus? filterByStatus; // Filtro por status
  final bool includeArchived; // Incluir feridas arquivadas
  final int limit; // Limite de resultados
  final int offset; // Offset para paginação

  const GetWoundHistoryInput({
    required this.patientId,
    this.woundId,
    this.filterByStatus,
    this.includeArchived = false,
    this.limit = 50,
    this.offset = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetWoundHistoryInput &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          woundId == other.woundId &&
          filterByStatus == other.filterByStatus &&
          includeArchived == other.includeArchived &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode =>
      patientId.hashCode ^
      woundId.hashCode ^
      filterByStatus.hashCode ^
      includeArchived.hashCode ^
      limit.hashCode ^
      offset.hashCode;
}

/// Saída do histórico de feridas com metadados
class WoundHistoryOutput {
  final List<Wound> wounds;
  final int totalCount;
  final bool hasMore;
  final String summary;

  const WoundHistoryOutput({
    required this.wounds,
    required this.totalCount,
    required this.hasMore,
    required this.summary,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WoundHistoryOutput &&
          runtimeType == other.runtimeType &&
          wounds == other.wounds &&
          totalCount == other.totalCount &&
          hasMore == other.hasMore &&
          summary == other.summary;

  @override
  int get hashCode =>
      wounds.hashCode ^
      totalCount.hashCode ^
      hasMore.hashCode ^
      summary.hashCode;
}

/// Caso de uso para obter histórico de feridas de um paciente.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Buscar feridas do paciente com filtros aplicados
/// - Organizar feridas por data de criação (mais recentes primeiro)
/// - Aplicar paginação
/// - Gerar estatísticas e resumo
/// - Retornar histórico completo
class GetWoundHistoryUseCase
    implements UseCase<GetWoundHistoryInput, WoundHistoryOutput> {
  final WoundRepository _woundRepository;

  const GetWoundHistoryUseCase(this._woundRepository);

  @override
  Future<Result<WoundHistoryOutput>> execute(GetWoundHistoryInput input) async {
    try {
      // Validar entrada
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      List<Wound> wounds;

      // Se especificado woundId, buscar ferida específica
      if (input.woundId != null) {
        final wound = await _woundRepository.getWoundById(input.woundId!);
        if (wound == null) {
          return Failure(NotFoundError.withId('Wound', input.woundId!));
        }

        // Verificar se ferida pertence ao paciente
        if (wound.patientId != input.patientId) {
          return const Failure(
            ConflictError(
              'Ferida não pertence ao paciente especificado',
              code: 'WOUND_PATIENT_MISMATCH',
            ),
          );
        }

        wounds = [wound];
      } else {
        // Buscar todas as feridas do paciente
        wounds = await _woundRepository.getWoundsByPatient(input.patientId);
      }

      // Aplicar filtros
      List<Wound> filteredWounds = wounds;

      // Filtrar por status se especificado
      if (input.filterByStatus != null) {
        filteredWounds = filteredWounds
            .where((wound) => wound.status == input.filterByStatus)
            .toList();
      }

      // Filtrar arquivadas se não incluir
      if (!input.includeArchived) {
        filteredWounds = filteredWounds
            .where((wound) => !wound.archived)
            .toList();
      }

      // Ordenar por data de criação (mais recentes primeiro)
      filteredWounds.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Calcular totais para paginação
      final totalCount = filteredWounds.length;
      final hasMore = (input.offset + input.limit) < totalCount;

      // Aplicar paginação
      final startIndex = input.offset;
      final endIndex = (startIndex + input.limit).clamp(0, totalCount);
      final paginatedWounds = filteredWounds.sublist(
        startIndex.clamp(0, totalCount),
        endIndex,
      );

      // Gerar resumo
      final summary = _generateSummary(filteredWounds, input);

      final output = WoundHistoryOutput(
        wounds: paginatedWounds,
        totalCount: totalCount,
        hasMore: hasMore,
        summary: summary,
      );

      return Success(output);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao obter histórico de feridas: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada
  ValidationError? _validateInput(GetWoundHistoryInput input) {
    if (input.patientId.trim().isEmpty) {
      return const ValidationError(
        'ID do paciente é obrigatório',
        field: 'patientId',
      );
    }

    if (input.limit <= 0 || input.limit > 200) {
      return const ValidationError(
        'Limite deve ser entre 1 e 200',
        field: 'limit',
      );
    }

    if (input.offset < 0) {
      return const ValidationError(
        'Offset não pode ser negativo',
        field: 'offset',
      );
    }

    return null;
  }

  /// Gera resumo do histórico de feridas
  String _generateSummary(List<Wound> wounds, GetWoundHistoryInput input) {
    if (wounds.isEmpty) {
      return 'Nenhuma ferida encontrada para este paciente.';
    }

    final activeWounds = wounds.where((w) => w.isActive).length;
    final healedWounds = wounds
        .where((w) => w.status == WoundStatus.cicatrizada)
        .length;
    final chronicWounds = wounds.where((w) => w.isChronicWound).length;
    final urgentWounds = wounds.where((w) => w.requiresUrgentCare).length;

    final parts = <String>[];

    if (input.woundId != null) {
      final wound = wounds.first;
      parts.add('Ferida: ${wound.summary}');
      parts.add('${wound.daysSinceIdentification} dias desde identificação');

      if (wound.healedDate != null) {
        parts.add('Cicatrizada em ${wound.daysSinceHealed} dias');
      }
    } else {
      parts.add(
        '${wounds.length} ferida${wounds.length != 1 ? 's' : ''} total',
      );

      if (activeWounds > 0) {
        parts.add('$activeWounds ativa${activeWounds != 1 ? 's' : ''}');
      }

      if (healedWounds > 0) {
        parts.add('$healedWounds cicatrizada${healedWounds != 1 ? 's' : ''}');
      }

      if (chronicWounds > 0) {
        parts.add('$chronicWounds crônica${chronicWounds != 1 ? 's' : ''}');
      }

      if (urgentWounds > 0) {
        parts.add(
          '$urgentWounds requer${urgentWounds == 1 ? '' : 'em'} atenção urgente',
        );
      }
    }

    return parts.join(', ') + '.';
  }
}
