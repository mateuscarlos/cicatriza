import '../../entities/assessment_manual.dart';
import '../../entities/wound.dart';
import '../../entities/patient.dart';
import '../../repositories/assessment_repository_manual.dart';
import '../../repositories/wound_repository.dart';
import '../../repositories/patient_repository.dart';
import '../base/use_case.dart';

/// Input para geração de relatório de avaliação
class GenerateAssessmentReportInput {
  final String assessmentId;
  final bool includePatientInfo; // Incluir informações do paciente
  final bool includeWoundHistory; // Incluir histórico da ferida
  final bool includeRecommendations; // Incluir recomendações
  final String reportFormat; // 'detailed' ou 'summary'

  const GenerateAssessmentReportInput({
    required this.assessmentId,
    this.includePatientInfo = true,
    this.includeWoundHistory = false,
    this.includeRecommendations = true,
    this.reportFormat = 'detailed',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerateAssessmentReportInput &&
          runtimeType == other.runtimeType &&
          assessmentId == other.assessmentId &&
          includePatientInfo == other.includePatientInfo &&
          includeWoundHistory == other.includeWoundHistory &&
          includeRecommendations == other.includeRecommendations &&
          reportFormat == other.reportFormat;

  @override
  int get hashCode =>
      assessmentId.hashCode ^
      includePatientInfo.hashCode ^
      includeWoundHistory.hashCode ^
      includeRecommendations.hashCode ^
      reportFormat.hashCode;
}

/// Relatório de avaliação estruturado
class AssessmentReport {
  final String assessmentId;
  final String title;
  final String content;
  final Map<String, dynamic> metadata;
  final DateTime generatedAt;
  final List<String> recommendations;

  const AssessmentReport({
    required this.assessmentId,
    required this.title,
    required this.content,
    required this.metadata,
    required this.generatedAt,
    required this.recommendations,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentReport &&
          runtimeType == other.runtimeType &&
          assessmentId == other.assessmentId &&
          title == other.title &&
          content == other.content;

  @override
  int get hashCode => assessmentId.hashCode ^ title.hashCode ^ content.hashCode;
}

/// Caso de uso para geração de relatórios de avaliação.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Buscar avaliação e dados relacionados
/// - Compilar informações do relatório
/// - Gerar recomendações baseadas na avaliação
/// - Formatar relatório final
/// - Retornar relatório estruturado
class GenerateAssessmentReportUseCase
    implements UseCase<GenerateAssessmentReportInput, AssessmentReport> {
  final AssessmentRepository _assessmentRepository;
  final WoundRepository _woundRepository;
  final PatientRepository _patientRepository;

  const GenerateAssessmentReportUseCase(
    this._assessmentRepository,
    this._woundRepository,
    this._patientRepository,
  );

  @override
  Future<Result<AssessmentReport>> execute(
    GenerateAssessmentReportInput input,
  ) async {
    try {
      // Validar entrada
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      // Buscar avaliação
      final assessment = await _assessmentRepository.getAssessmentById(
        input.assessmentId,
      );
      if (assessment == null) {
        return Failure(NotFoundError.withId('Assessment', input.assessmentId));
      }

      // Buscar ferida relacionada
      final wound = await _woundRepository.getWoundById(assessment.woundId);
      if (wound == null) {
        return Failure(NotFoundError.withId('Wound', assessment.woundId));
      }

      // Buscar paciente se solicitado
      Patient? patient;
      if (input.includePatientInfo) {
        patient = await _patientRepository.getPatientById(wound.patientId);
      }

      // Buscar histórico da ferida se solicitado
      List<Wound>? woundHistory;
      if (input.includeWoundHistory) {
        woundHistory = await _woundRepository.getWoundsByPatient(
          wound.patientId,
        );
      }

      // Gerar recomendações
      final recommendations = input.includeRecommendations
          ? _generateRecommendations(assessment, wound, patient)
          : <String>[];

      // Gerar conteúdo do relatório
      final content = _generateReportContent(
        assessment,
        wound,
        patient,
        woundHistory,
        input,
        recommendations,
      );

      // Gerar título
      final title = _generateTitle(assessment, wound, patient);

      // Gerar metadados
      final metadata = _generateMetadata(assessment, wound, patient);

      final report = AssessmentReport(
        assessmentId: input.assessmentId,
        title: title,
        content: content,
        metadata: metadata,
        generatedAt: DateTime.now(),
        recommendations: recommendations,
      );

      return Success(report);
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao gerar relatório: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada
  ValidationError? _validateInput(GenerateAssessmentReportInput input) {
    if (input.assessmentId.trim().isEmpty) {
      return const ValidationError(
        'ID da avaliação é obrigatório',
        field: 'assessmentId',
      );
    }

    if (!['detailed', 'summary'].contains(input.reportFormat)) {
      return const ValidationError(
        'Formato do relatório deve ser "detailed" ou "summary"',
        field: 'reportFormat',
      );
    }

    return null;
  }

  /// Gera título do relatório
  String _generateTitle(
    AssessmentManual assessment,
    Wound wound,
    Patient? patient,
  ) {
    final patientName = patient?.name ?? 'Paciente';
    final assessmentDate = assessment.date.toIso8601String().split('T')[0];

    return 'Relatório de Avaliação - $patientName - $assessmentDate';
  }

  /// Gera conteúdo do relatório
  String _generateReportContent(
    AssessmentManual assessment,
    Wound wound,
    Patient? patient,
    List<Wound>? woundHistory,
    GenerateAssessmentReportInput input,
    List<String> recommendations,
  ) {
    final buffer = StringBuffer();

    // Cabeçalho
    buffer.writeln('=== RELATÓRIO DE AVALIAÇÃO DE FERIDA ===\n');

    // Informações da avaliação
    buffer.writeln('DATA DA AVALIAÇÃO: ${assessment.date}');
    buffer.writeln('REALIZADA POR: Sistema Cicatriza');
    buffer.writeln('ID DA AVALIAÇÃO: ${assessment.id}');
    buffer.writeln();

    // Informações do paciente
    if (input.includePatientInfo && patient != null) {
      buffer.writeln('=== DADOS DO PACIENTE ===');
      buffer.writeln('NOME: ${patient.name}');
      buffer.writeln('IDADE: ${patient.currentAge} anos');
      if (patient.phone != null) buffer.writeln('TELEFONE: ${patient.phone}');
      if (patient.email != null) buffer.writeln('EMAIL: ${patient.email}');
      buffer.writeln();
    }

    // Informações da ferida
    buffer.writeln('=== DADOS DA FERIDA ===');
    buffer.writeln('TIPO: ${wound.type.displayName}');
    buffer.writeln('LOCALIZAÇÃO: ${wound.location.displayName}');
    buffer.writeln('STATUS: ${wound.status.displayName}');
    buffer.writeln('DESCRIÇÃO: ${wound.description}');
    buffer.writeln(
      'DIAS DESDE IDENTIFICAÇÃO: ${wound.daysSinceIdentification}',
    );
    buffer.writeln('NÍVEL DE RISCO: ${wound.riskDescription}');
    if (wound.notes != null) buffer.writeln('OBSERVAÇÕES: ${wound.notes}');
    buffer.writeln();

    // Dados da avaliação
    buffer.writeln('=== DADOS DA AVALIAÇÃO ===');
    if (input.reportFormat == 'detailed') {
      // Exibir todos os dados da avaliação
      buffer.writeln('COMPRIMENTO: ${assessment.lengthCm ?? "N/A"} cm');
      buffer.writeln('LARGURA: ${assessment.widthCm ?? "N/A"} cm');
      buffer.writeln('PROFUNDIDADE: ${assessment.depthCm ?? "N/A"} cm');
      buffer.writeln('DOR (0-10): ${assessment.painScale ?? "N/A"}');
      if (assessment.edgeAppearance != null)
        buffer.writeln('BORDA: ${assessment.edgeAppearance}');
      if (assessment.woundBed != null)
        buffer.writeln('LEITO: ${assessment.woundBed}');
      if (assessment.exudateType != null)
        buffer.writeln('EXSUDATO: ${assessment.exudateType}');
      if (assessment.exudateAmount != null)
        buffer.writeln('QUANTIDADE: ${assessment.exudateAmount}');
    } else {
      // Exibir resumo
      final volume =
          (assessment.lengthCm ?? 0) *
          (assessment.widthCm ?? 0) *
          (assessment.depthCm ?? 0);
      final severityScore = volume > 100
          ? 8
          : volume > 50
          ? 6
          : volume > 10
          ? 4
          : 2;
      buffer.writeln('SCORE DE GRAVIDADE: $severityScore/10');
      // Análise de infecção baseada em exsudato
      final hasInfectionSigns =
          assessment.exudateType?.contains('purulento') == true ||
          assessment.exudateAmount == 'Abundante';
      buffer.writeln(
        'SINAIS DE INFECÇÃO: ${hasInfectionSigns ? "SIM" : "NÃO"}',
      );
      buffer.writeln(
        'TECIDO NECRÓTICO: ${assessment.hasNecroticTissue ? "SIM" : "NÃO"}',
      );
      final hasSeverePain = (assessment.painScale ?? 0) >= 7;
      final hasPositiveHealingSigns =
          assessment.woundBed?.contains('Granulação') == true;
      buffer.writeln('DOR SEVERA: ${hasSeverePain ? "SIM" : "NÃO"}');
      buffer.writeln(
        'SINAIS POSITIVOS: ${hasPositiveHealingSigns ? "SIM" : "NÃO"}',
      );
    }

    if (assessment.notes != null && assessment.notes!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('OBSERVAÇÕES: ${assessment.notes}');
    }
    buffer.writeln();

    // Histórico da ferida
    if (input.includeWoundHistory && woundHistory != null) {
      buffer.writeln('=== HISTÓRICO DE FERIDAS ===');
      final activeWounds = woundHistory.where((w) => w.isActive).length;
      final healedWounds = woundHistory
          .where((w) => w.status == WoundStatus.cicatrizada)
          .length;
      buffer.writeln('TOTAL DE FERIDAS: ${woundHistory.length}');
      buffer.writeln('FERIDAS ATIVAS: $activeWounds');
      buffer.writeln('FERIDAS CICATRIZADAS: $healedWounds');
      buffer.writeln();
    }

    // Incluir recomendações se solicitadas
    if (input.includeRecommendations && recommendations.isNotEmpty) {
      buffer.writeln('=== RECOMENDAÇÕES ===');
      for (int i = 0; i < recommendations.length; i++) {
        buffer.writeln('${i + 1}. ${recommendations[i]}');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Gera recomendações baseadas na avaliação
  List<String> _generateRecommendations(
    AssessmentManual assessment,
    Wound wound,
    Patient? patient,
  ) {
    final recommendations = <String>[];

    // Recomendações baseadas na avaliação
    // Análise de infecção baseada em exsudato
    final hasInfectionSigns =
        assessment.exudateType?.contains('purulento') == true ||
        assessment.exudateAmount == 'Abundante';
    if (hasInfectionSigns) {
      recommendations.add(
        'Solicitar avaliação médica urgente para sinais de infecção',
      );
      recommendations.add('Considerar coleta de material para cultura');
    }

    // Verificar se há menção de tecido necrótico nos campos disponíveis
    final hasNecroticTissue =
        assessment.woundBed?.contains('Necrótico') == true ||
        assessment.notes?.toLowerCase().contains('necrótico') == true ||
        assessment.notes?.toLowerCase().contains('necrose') == true;
    if (hasNecroticTissue) {
      recommendations.add('Avaliar necessidade de desbridamento');
    }

    // Dor severa baseada na escala
    final hasSeverePain = (assessment.painScale ?? 0) >= 7;
    if (hasSeverePain) {
      recommendations.add('Revisar protocolo de manejo da dor');
      recommendations.add('Investigar causas da dor excessiva');
    }

    // Sinais positivos de cicatrização
    final hasPositiveHealingSigns =
        assessment.woundBed?.contains('Granulação') == true;
    if (!hasPositiveHealingSigns) {
      recommendations.add('Revisar plano de tratamento atual');
      recommendations.add('Considerar ajustes na abordagem terapêutica');
    }

    // Cálculo de gravidade baseado no volume
    final volume =
        (assessment.lengthCm ?? 0) *
        (assessment.widthCm ?? 0) *
        (assessment.depthCm ?? 0);
    final severityScore = volume > 100
        ? 8
        : volume > 50
        ? 6
        : volume > 10
        ? 4
        : 2;
    if (severityScore >= 7) {
      recommendations.add('Monitoramento mais frequente devido à gravidade');
      recommendations.add('Considerar acompanhamento especializado');
    }

    // Recomendações baseadas na ferida
    // Ferida crônica se identificada há mais de 30 dias
    final daysSinceIdentification = DateTime.now()
        .difference(wound.identificationDate)
        .inDays;
    if (daysSinceIdentification > 30) {
      recommendations.add(
        'Ferida crônica: avaliar fatores que impedem a cicatrização',
      );
    }

    // Feridas com status que requer atenção
    if (wound.status == WoundStatus.infectada ||
        wound.status == WoundStatus.complicada) {
      recommendations.add('Ferida requer atenção prioritária');
    }

    // Recomendações baseadas no paciente
    if (patient != null) {
      // Paciente idoso (acima de 65 anos)
      final age = patient.currentAge;
      if (age >= 65) {
        recommendations.add('Paciente com alto risco: monitoramento reforçado');
        recommendations.add(
          'Paciente idoso: atenção especial à nutrição e mobilidade',
        );
      }
    }

    // Recomendações gerais se nenhuma específica
    if (recommendations.isEmpty) {
      recommendations.add('Continuar cuidados de rotina');
      recommendations.add('Manter monitoramento regular');
    }

    return recommendations;
  }

  /// Gera metadados do relatório
  Map<String, dynamic> _generateMetadata(
    AssessmentManual assessment,
    Wound wound,
    Patient? patient,
  ) {
    return {
      'assessmentId': assessment.id,
      'woundId': wound.id,
      'patientId': patient?.id,
      'patientName': patient?.name,
      'woundType': wound.type.name,
      'woundStatus': wound.status.name,
      'volume':
          (assessment.lengthCm ?? 0) *
          (assessment.widthCm ?? 0) *
          (assessment.depthCm ?? 0),
      'hasInfection': assessment.exudateType?.contains('purulento') == true,
      'isChronicWound': wound.isChronicWound,
      'requiresUrgentCare': wound.requiresUrgentCare,
      'assessedAt': assessment.date.toIso8601String(),
      'performedBy': 'Sistema Cicatriza',
    };
  }
}
