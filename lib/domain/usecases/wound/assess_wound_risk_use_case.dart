import '../../entities/wound.dart';
import '../../entities/patient.dart';
import '../../repositories/wound_repository.dart';
import '../../repositories/patient_repository.dart';
import '../base/use_case.dart';

/// Níveis de risco para feridas
enum WoundRiskLevel {
  low('Baixo'),
  medium('Médio'),
  high('Alto');

  const WoundRiskLevel(this.displayName);
  final String displayName;
}

/// Input para avaliação de risco de ferida
class AssessWoundRiskInput {
  final String woundId;
  final bool includePatientFactors; // Considerar fatores do paciente no risco

  const AssessWoundRiskInput({
    required this.woundId,
    this.includePatientFactors = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessWoundRiskInput &&
          runtimeType == other.runtimeType &&
          woundId == other.woundId &&
          includePatientFactors == other.includePatientFactors;

  @override
  int get hashCode => woundId.hashCode ^ includePatientFactors.hashCode;
}

/// Resultado da avaliação de risco
class WoundRiskAssessment {
  final String woundId;
  final WoundRiskLevel riskLevel;
  final List<String> riskFactors;
  final List<String> recommendations;
  final DateTime assessedAt;

  const WoundRiskAssessment({
    required this.woundId,
    required this.riskLevel,
    required this.riskFactors,
    required this.recommendations,
    required this.assessedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WoundRiskAssessment &&
          runtimeType == other.runtimeType &&
          woundId == other.woundId &&
          riskLevel == other.riskLevel;

  @override
  int get hashCode => woundId.hashCode ^ riskLevel.hashCode;
}

/// Caso de uso para avaliação de risco de feridas.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Buscar ferida e dados relacionados
/// - Calcular risco baseado em múltiplos fatores
/// - Gerar recomendações clínicas
/// - Retornar avaliação completa de risco
class AssessWoundRiskUseCase
    implements UseCase<AssessWoundRiskInput, WoundRiskAssessment> {
  final WoundRepository _woundRepository;
  final PatientRepository _patientRepository;

  const AssessWoundRiskUseCase(this._woundRepository, this._patientRepository);

  @override
  Future<Result<WoundRiskAssessment>> execute(
    AssessWoundRiskInput input,
  ) async {
    try {
      // Validar entrada
      if (input.woundId.trim().isEmpty) {
        return const Failure(
          ValidationError('ID da ferida é obrigatório', field: 'woundId'),
        );
      }

      // Buscar ferida
      final wound = await _woundRepository.getWoundById(input.woundId);
      if (wound == null) {
        return Failure(NotFoundError.withId('Wound', input.woundId));
      }

      final riskFactors = <String>[];
      final recommendations = <String>[];

      // Avaliar risco base da ferida baseado no riskLevel numérico da entidade
      final baseRiskLevel = _mapNumericRiskToLevel(wound.riskLevel);
      riskFactors.add('Tipo de ferida: ${wound.type.displayName}');
      riskFactors.add('Localização: ${wound.location.displayName}');
      riskFactors.add('Status: ${wound.status.displayName}');
      riskFactors.add('Risco base da ferida: ${wound.riskDescription}');

      // Considerar fatores do paciente
      Patient? patient;
      if (input.includePatientFactors) {
        patient = await _patientRepository.getPatientById(wound.patientId);
        if (patient != null) {
          if (patient.isElderly) {
            riskFactors.add('Paciente idoso (${patient.currentAge} anos)');
          }

          if (patient.isHighRiskForHealing) {
            riskFactors.add('Alto risco para cicatrização baseado na idade');
            recommendations.add('Monitoramento mais frequente recomendado');
          }
        }
      }

      // Considerar características da ferida
      if (wound.isChronicWound) {
        riskFactors.add(
          'Ferida crônica (${wound.daysSinceIdentification} dias)',
        );
        recommendations.add('Considerar mudança na abordagem terapêutica');
      }

      if (wound.requiresUrgentCare) {
        riskFactors.add('Requer cuidado urgente');
        recommendations.add('Acompanhamento médico prioritário');
      }

      // Fatores de localização
      if (wound.location.isHighRiskForInfection) {
        riskFactors.add('Localização com alto risco de infecção');
        recommendations.add('Manter cuidados rigorosos de higiene');
      }

      if (wound.location.isPressureProne) {
        riskFactors.add('Localização sujeita à pressão');
        recommendations.add('Implementar medidas de alívio de pressão');
      }

      // Determinar nível de risco final
      final finalRiskLevel = _calculateFinalRisk(baseRiskLevel, riskFactors);

      // Adicionar recomendações baseadas no risco final
      _addRiskBasedRecommendations(finalRiskLevel, recommendations);

      final riskAssessment = WoundRiskAssessment(
        woundId: input.woundId,
        riskLevel: finalRiskLevel,
        riskFactors: riskFactors,
        recommendations: recommendations,
        assessedAt: DateTime.now(),
      );

      return Success(riskAssessment);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao avaliar risco da ferida: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Mapeia o risco numérico da entidade (1-5) para WoundRiskLevel
  WoundRiskLevel _mapNumericRiskToLevel(int numericRisk) {
    switch (numericRisk) {
      case 1:
      case 2:
        return WoundRiskLevel.low;
      case 3:
        return WoundRiskLevel.medium;
      case 4:
      case 5:
        return WoundRiskLevel.high;
      default:
        return WoundRiskLevel.medium;
    }
  }

  /// Calcula o nível de risco final baseado no risco base e fatores adicionais
  WoundRiskLevel _calculateFinalRisk(
    WoundRiskLevel baseRisk,
    List<String> riskFactors,
  ) {
    // Contar fatores de alto risco
    final highRiskKeywords = [
      'infecção',
      'necrótico',
      'dor severa',
      'score de gravidade alto',
      'idoso',
      'alto risco para cicatrização',
      'crônica',
      'urgente',
    ];

    final highRiskFactorCount = riskFactors
        .where(
          (factor) => highRiskKeywords.any(
            (keyword) => factor.toLowerCase().contains(keyword),
          ),
        )
        .length;

    // Elevar o risco se houver muitos fatores de alto risco
    switch (baseRisk) {
      case WoundRiskLevel.low:
        if (highRiskFactorCount >= 2) return WoundRiskLevel.medium;
        break;
      case WoundRiskLevel.medium:
        if (highRiskFactorCount >= 2) return WoundRiskLevel.high;
        break;
      case WoundRiskLevel.high:
        // Já é alto, mantém
        break;
    }

    return baseRisk;
  }

  /// Adiciona recomendações baseadas no nível de risco
  void _addRiskBasedRecommendations(
    WoundRiskLevel riskLevel,
    List<String> recommendations,
  ) {
    switch (riskLevel) {
      case WoundRiskLevel.low:
        recommendations.add('Continuar cuidados de rotina');
        recommendations.add('Monitorar sinais de complicações');
        break;
      case WoundRiskLevel.medium:
        recommendations.add('Aumentar frequência de avaliações');
        recommendations.add('Considerar ajustes no tratamento');
        break;
      case WoundRiskLevel.high:
        recommendations.add('Acompanhamento médico imediato');
        recommendations.add('Considerar hospitalização se necessário');
        recommendations.add('Revisar completamente o plano de cuidados');
        break;
    }
  }
}
