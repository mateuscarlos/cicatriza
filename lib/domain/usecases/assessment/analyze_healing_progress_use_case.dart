import '../../entities/assessment_manual.dart';
import '../../entities/wound.dart';
import '../../entities/patient.dart';
import '../../repositories/assessment_repository_manual.dart';
import '../../repositories/wound_repository.dart';
import '../../repositories/patient_repository.dart';
import '../base/use_case.dart';

/// Input para análise de progresso de cicatrização
class AnalyzeHealingProgressInput {
  final String woundId;
  final int daysToAnalyze; // Período para análise (ex: últimos 30 dias)
  final bool includeRecommendations; // Incluir recomendações no resultado

  const AnalyzeHealingProgressInput({
    required this.woundId,
    this.daysToAnalyze = 30,
    this.includeRecommendations = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyzeHealingProgressInput &&
          runtimeType == other.runtimeType &&
          woundId == other.woundId &&
          daysToAnalyze == other.daysToAnalyze &&
          includeRecommendations == other.includeRecommendations;

  @override
  int get hashCode =>
      woundId.hashCode ^
      daysToAnalyze.hashCode ^
      includeRecommendations.hashCode;
}

/// Tendência de progresso
enum HealingTrend {
  improving('Melhorando'),
  stable('Estável'),
  declining('Piorando'),
  insufficient('Dados insuficientes');

  const HealingTrend(this.displayName);
  final String displayName;
}

/// Resultado da análise de progresso de cicatrização
class HealingProgressAnalysis {
  final String woundId;
  final HealingTrend overallTrend;
  final Map<String, HealingTrend> parameterTrends; // Tendência por parâmetro
  final List<String> insights; // Insights da análise
  final List<String> recommendations; // Recomendações
  final DateTime analyzedAt;
  final int assessmentsAnalyzed; // Número de avaliações analisadas
  final Map<String, dynamic> metrics; // Métricas detalhadas

  const HealingProgressAnalysis({
    required this.woundId,
    required this.overallTrend,
    required this.parameterTrends,
    required this.insights,
    required this.recommendations,
    required this.analyzedAt,
    required this.assessmentsAnalyzed,
    required this.metrics,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealingProgressAnalysis &&
          runtimeType == other.runtimeType &&
          woundId == other.woundId &&
          overallTrend == other.overallTrend;

  @override
  int get hashCode => woundId.hashCode ^ overallTrend.hashCode;
}

/// Caso de uso para análise de progresso de cicatrização.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Buscar ferida e avaliações do período
/// - Analisar tendências de cada parâmetro
/// - Calcular métricas de progresso
/// - Gerar insights e recomendações
/// - Retornar análise completa
class AnalyzeHealingProgressUseCase
    implements UseCase<AnalyzeHealingProgressInput, HealingProgressAnalysis> {
  final AssessmentRepository _assessmentRepository;
  final WoundRepository _woundRepository;
  final PatientRepository _patientRepository;

  const AnalyzeHealingProgressUseCase(
    this._assessmentRepository,
    this._woundRepository,
    this._patientRepository,
  );

  @override
  Future<Result<HealingProgressAnalysis>> execute(
    AnalyzeHealingProgressInput input,
  ) async {
    try {
      // Validar entrada
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      // Buscar ferida
      final wound = await _woundRepository.getWoundById(input.woundId);
      if (wound == null) {
        return Failure(NotFoundError.withId('Wound', input.woundId));
      }

      // Buscar avaliações do período
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: input.daysToAnalyze));

      final assessments = await _assessmentRepository.getAssessmentsWithFilters(
        woundId: input.woundId,
        fromDate: startDate,
        toDate: endDate,
      );

      if (assessments.length < 2) {
        return Success(
          HealingProgressAnalysis(
            woundId: input.woundId,
            overallTrend: HealingTrend.insufficient,
            parameterTrends: {},
            insights: [
              'Dados insuficientes para análise (mínimo 2 avaliações necessárias)',
            ],
            recommendations: [
              'Realizar avaliações mais frequentes para permitir análise de progresso',
            ],
            analyzedAt: DateTime.now(),
            assessmentsAnalyzed: assessments.length,
            metrics: {},
          ),
        );
      }

      // Ordenar avaliações por data
      assessments.sort((a, b) => a.date.compareTo(b.date));

      // Analisar tendências por parâmetro
      final parameterTrends = <String, HealingTrend>{};
      final insights = <String>[];
      final metrics = <String, dynamic>{};

      // Análise de dimensões
      _analyzeDimensions(assessments, parameterTrends, insights, metrics);

      // Análise de dor
      _analyzePain(assessments, parameterTrends, insights, metrics);

      // Análise qualitativa (leito da ferida, exsudato, etc.)
      _analyzeQualitativeFactors(
        assessments,
        parameterTrends,
        insights,
        metrics,
      );

      // Determinar tendência geral
      final overallTrend = _calculateOverallTrend(parameterTrends);

      // Gerar recomendações
      final recommendations = input.includeRecommendations
          ? _generateRecommendations(
              wound,
              assessments,
              parameterTrends,
              overallTrend,
            )
          : <String>[];

      // Buscar informações do paciente para contexto
      final patient = await _patientRepository.getPatientById(wound.patientId);
      if (patient != null) {
        _addPatientContextInsights(patient, wound, insights, recommendations);
      }

      final analysis = HealingProgressAnalysis(
        woundId: input.woundId,
        overallTrend: overallTrend,
        parameterTrends: parameterTrends,
        insights: insights,
        recommendations: recommendations,
        analyzedAt: DateTime.now(),
        assessmentsAnalyzed: assessments.length,
        metrics: metrics,
      );

      return Success(analysis);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao analisar progresso: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada
  ValidationError? _validateInput(AnalyzeHealingProgressInput input) {
    if (input.woundId.trim().isEmpty) {
      return const ValidationError(
        'ID da ferida é obrigatório',
        field: 'woundId',
      );
    }

    if (input.daysToAnalyze <= 0 || input.daysToAnalyze > 365) {
      return const ValidationError(
        'Período de análise deve ser entre 1 e 365 dias',
        field: 'daysToAnalyze',
      );
    }

    return null;
  }

  /// Analisa tendências das dimensões da ferida
  void _analyzeDimensions(
    List<AssessmentManual> assessments,
    Map<String, HealingTrend> trends,
    List<String> insights,
    Map<String, dynamic> metrics,
  ) {
    final firstAssessment = assessments.first;
    final lastAssessment = assessments.last;

    // Análise de comprimento
    if (firstAssessment.lengthCm != null && lastAssessment.lengthCm != null) {
      final lengthChange = lastAssessment.lengthCm! - firstAssessment.lengthCm!;
      final lengthChangePercent =
          (lengthChange / firstAssessment.lengthCm!) * 100;

      metrics['lengthChange'] = lengthChange;
      metrics['lengthChangePercent'] = lengthChangePercent;

      if (lengthChangePercent < -10) {
        trends['comprimento'] = HealingTrend.improving;
        insights.add(
          'Redução significativa no comprimento da ferida (${lengthChangePercent.toStringAsFixed(1)}%)',
        );
      } else if (lengthChangePercent > 10) {
        trends['comprimento'] = HealingTrend.declining;
        insights.add(
          'Aumento preocupante no comprimento da ferida (${lengthChangePercent.toStringAsFixed(1)}%)',
        );
      } else {
        trends['comprimento'] = HealingTrend.stable;
        insights.add('Comprimento da ferida mantém-se estável');
      }
    }

    // Análise de largura
    if (firstAssessment.widthCm != null && lastAssessment.widthCm != null) {
      final widthChange = lastAssessment.widthCm! - firstAssessment.widthCm!;
      final widthChangePercent = (widthChange / firstAssessment.widthCm!) * 100;

      metrics['widthChange'] = widthChange;
      metrics['widthChangePercent'] = widthChangePercent;

      if (widthChangePercent < -10) {
        trends['largura'] = HealingTrend.improving;
        insights.add(
          'Redução significativa na largura da ferida (${widthChangePercent.toStringAsFixed(1)}%)',
        );
      } else if (widthChangePercent > 10) {
        trends['largura'] = HealingTrend.declining;
        insights.add(
          'Aumento preocupante na largura da ferida (${widthChangePercent.toStringAsFixed(1)}%)',
        );
      } else {
        trends['largura'] = HealingTrend.stable;
        insights.add('Largura da ferida mantém-se estável');
      }
    }

    // Análise de profundidade
    if (firstAssessment.depthCm != null && lastAssessment.depthCm != null) {
      final depthChange = lastAssessment.depthCm! - firstAssessment.depthCm!;
      final depthChangePercent = (depthChange / firstAssessment.depthCm!) * 100;

      metrics['depthChange'] = depthChange;
      metrics['depthChangePercent'] = depthChangePercent;

      if (depthChangePercent < -15) {
        trends['profundidade'] = HealingTrend.improving;
        insights.add(
          'Redução significativa na profundidade da ferida (${depthChangePercent.toStringAsFixed(1)}%)',
        );
      } else if (depthChangePercent > 15) {
        trends['profundidade'] = HealingTrend.declining;
        insights.add(
          'Aumento preocupante na profundidade da ferida (${depthChangePercent.toStringAsFixed(1)}%)',
        );
      } else {
        trends['profundidade'] = HealingTrend.stable;
        insights.add('Profundidade da ferida mantém-se estável');
      }
    }
  }

  /// Analisa tendências da dor
  void _analyzePain(
    List<AssessmentManual> assessments,
    Map<String, HealingTrend> trends,
    List<String> insights,
    Map<String, dynamic> metrics,
  ) {
    final painScores = assessments
        .where((a) => a.painScale != null)
        .map((a) => a.painScale!)
        .toList();

    if (painScores.length >= 2) {
      final firstPain = painScores.first;
      final lastPain = painScores.last;
      final avgPain = painScores.reduce((a, b) => a + b) / painScores.length;

      metrics['painChange'] = lastPain - firstPain;
      metrics['averagePain'] = avgPain;

      if (lastPain < firstPain - 2) {
        trends['dor'] = HealingTrend.improving;
        insights.add(
          'Redução significativa da dor (de $firstPain para $lastPain)',
        );
      } else if (lastPain > firstPain + 2) {
        trends['dor'] = HealingTrend.declining;
        insights.add(
          'Aumento preocupante da dor (de $firstPain para $lastPain)',
        );
      } else {
        trends['dor'] = HealingTrend.stable;
        insights.add('Nível de dor mantém-se estável');
      }

      if (avgPain > 7) {
        insights.add(
          'Dor média alta no período (${avgPain.toStringAsFixed(1)}/10)',
        );
      }
    }
  }

  /// Analisa fatores qualitativos
  void _analyzeQualitativeFactors(
    List<AssessmentManual> assessments,
    Map<String, HealingTrend> trends,
    List<String> insights,
    Map<String, dynamic> metrics,
  ) {
    final firstAssessment = assessments.first;
    final lastAssessment = assessments.last;

    // Análise do leito da ferida
    if (firstAssessment.woundBed != null && lastAssessment.woundBed != null) {
      final positiveChanges = ['Granulação', 'Limpo'];
      final negativeChanges = ['Necrose'];

      final firstBed = firstAssessment.woundBed!;
      final lastBed = lastAssessment.woundBed!;

      if (positiveChanges.contains(lastBed) &&
          !positiveChanges.contains(firstBed)) {
        trends['leito'] = HealingTrend.improving;
        insights.add('Melhora no leito da ferida: de $firstBed para $lastBed');
      } else if (negativeChanges.contains(lastBed) &&
          !negativeChanges.contains(firstBed)) {
        trends['leito'] = HealingTrend.declining;
        insights.add('Piora no leito da ferida: de $firstBed para $lastBed');
      } else {
        trends['leito'] = HealingTrend.stable;
      }
    }

    // Análise do exsudato
    if (firstAssessment.exudateAmount != null &&
        lastAssessment.exudateAmount != null) {
      final exudateOrder = ['Ausente', 'Pequena', 'Moderada', 'Grande'];
      final firstIndex = exudateOrder.indexOf(firstAssessment.exudateAmount!);
      final lastIndex = exudateOrder.indexOf(lastAssessment.exudateAmount!);

      if (lastIndex < firstIndex) {
        trends['exsudato'] = HealingTrend.improving;
        insights.add(
          'Redução do exsudato: de ${firstAssessment.exudateAmount} para ${lastAssessment.exudateAmount}',
        );
      } else if (lastIndex > firstIndex) {
        trends['exsudato'] = HealingTrend.declining;
        insights.add(
          'Aumento do exsudato: de ${firstAssessment.exudateAmount} para ${lastAssessment.exudateAmount}',
        );
      } else {
        trends['exsudato'] = HealingTrend.stable;
      }
    }
  }

  /// Calcula tendência geral baseada nas tendências individuais
  HealingTrend _calculateOverallTrend(
    Map<String, HealingTrend> parameterTrends,
  ) {
    if (parameterTrends.isEmpty) {
      return HealingTrend.insufficient;
    }

    final improvingCount = parameterTrends.values
        .where((t) => t == HealingTrend.improving)
        .length;
    final decliningCount = parameterTrends.values
        .where((t) => t == HealingTrend.declining)
        .length;
    final stableCount = parameterTrends.values
        .where((t) => t == HealingTrend.stable)
        .length;

    if (improvingCount > decliningCount && improvingCount >= stableCount) {
      return HealingTrend.improving;
    } else if (decliningCount > improvingCount &&
        decliningCount >= stableCount) {
      return HealingTrend.declining;
    } else {
      return HealingTrend.stable;
    }
  }

  /// Gera recomendações baseadas na análise
  List<String> _generateRecommendations(
    Wound wound,
    List<AssessmentManual> assessments,
    Map<String, HealingTrend> trends,
    HealingTrend overallTrend,
  ) {
    final recommendations = <String>[];

    switch (overallTrend) {
      case HealingTrend.improving:
        recommendations.add(
          'Ferida apresenta progresso positivo - manter tratamento atual',
        );
        recommendations.add('Continuar monitoramento regular');
        break;

      case HealingTrend.stable:
        recommendations.add(
          'Progresso estável - considerar otimizações no tratamento',
        );
        recommendations.add(
          'Avaliar fatores que podem acelerar a cicatrização',
        );
        break;

      case HealingTrend.declining:
        recommendations.add(
          'Ferida apresenta piora - REVISAR TRATAMENTO URGENTEMENTE',
        );
        recommendations.add('Considerar avaliação médica especializada');
        recommendations.add('Investigar fatores que impedem a cicatrização');
        break;

      case HealingTrend.insufficient:
        recommendations.add(
          'Aumentar frequência das avaliações para melhor monitoramento',
        );
        break;
    }

    // Recomendações específicas por tendência
    trends.forEach((parameter, trend) {
      if (trend == HealingTrend.declining) {
        switch (parameter) {
          case 'dor':
            recommendations.add('Revisar protocolo de manejo da dor');
            break;
          case 'exsudato':
            recommendations.add(
              'Ajustar manejo do exsudato - considerar curativos mais absorventes',
            );
            break;
          case 'leito':
            recommendations.add(
              'Considerar desbridamento ou mudança na limpeza da ferida',
            );
            break;
        }
      }
    });

    return recommendations;
  }

  /// Adiciona insights baseados no contexto do paciente
  void _addPatientContextInsights(
    Patient patient,
    Wound wound,
    List<String> insights,
    List<String> recommendations,
  ) {
    if (patient.isHighRiskForHealing) {
      insights.add(
        'Paciente tem perfil de risco para cicatrização (idade: ${patient.currentAge} anos)',
      );
      recommendations.add(
        'Monitoramento intensificado devido ao perfil de risco do paciente',
      );
    }

    if (wound.isChronicWound) {
      insights.add(
        'Ferida crônica (${wound.daysSinceIdentification} dias) - esperado progresso mais lento',
      );
      recommendations.add(
        'Ferida crônica: revisar abordagem terapêutica periodicamente',
      );
    }

    if (wound.requiresUrgentCare) {
      insights.add('Ferida classificada como requerendo cuidado urgente');
      recommendations.add('Manter acompanhamento prioritário');
    }
  }
}
