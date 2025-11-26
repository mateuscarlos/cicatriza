// ignore_for_file: non_abstract_class_inherits_abstract_member
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';
import '../exceptions/domain_exceptions.dart';

part 'wound.freezed.dart';
part 'wound.g.dart';

/// Tipos de ferida baseado na etiologia
enum WoundType {
  @JsonValue('ULCERA_PRESSAO')
  ulceraPressao('Úlcera por Pressão'),

  @JsonValue('ULCERA_VENOSA')
  ulceraVenosa('Úlcera Venosa'),

  @JsonValue('ULCERA_ARTERIAL')
  ulceraArterial('Úlcera Arterial'),

  @JsonValue('PE_DIABETICO')
  peDiabetico('Pé Diabético'),

  @JsonValue('QUEIMADURA')
  queimadura('Queimadura'),

  @JsonValue('FERIDA_CIRURGICA')
  feridaCirurgica('Ferida Cirúrgica'),

  @JsonValue('TRAUMATICA')
  traumatica('Traumática'),

  @JsonValue('OUTRAS')
  outras('Outras');

  const WoundType(this.displayName);
  final String displayName;

  /// Indica se o tipo de ferida tende a ter cicatrização mais lenta
  bool get hasSlowHealingTendency {
    switch (this) {
      case WoundType.ulceraPressao:
      case WoundType.ulceraVenosa:
      case WoundType.ulceraArterial:
      case WoundType.peDiabetico:
        return true;
      case WoundType.queimadura:
      case WoundType.feridaCirurgica:
      case WoundType.traumatica:
      case WoundType.outras:
        return false;
    }
  }

  /// Indica se o tipo de ferida requer monitoramento especial
  bool get requiresSpecialMonitoring {
    switch (this) {
      case WoundType.peDiabetico:
      case WoundType.queimadura:
      case WoundType.ulceraArterial:
        return true;
      case WoundType.ulceraPressao:
      case WoundType.ulceraVenosa:
      case WoundType.feridaCirurgica:
      case WoundType.traumatica:
      case WoundType.outras:
        return false;
    }
  }
}

/// Localização anatômica da ferida
enum WoundLocation {
  @JsonValue('CABECA_PESCOCO')
  cabecaPescoco('Cabeça/Pescoço'),

  @JsonValue('TORAX')
  torax('Tórax'),

  @JsonValue('ABDOMEN')
  abdomen('Abdômen'),

  @JsonValue('BRACOS')
  bracos('Braços'),

  @JsonValue('MAOS')
  maos('Mãos'),

  @JsonValue('COSTAS')
  costas('Costas'),

  @JsonValue('QUADRIS_NADEGAS')
  quadrisNadegas('Quadris/Nádegas'),

  @JsonValue('GENITAIS')
  genitais('Genitais'),

  @JsonValue('COXAS')
  coxas('Coxas'),

  @JsonValue('JOELHOS')
  joelhos('Joelhos'),

  @JsonValue('PERNAS')
  pernas('Pernas'),

  @JsonValue('TORNOZELOS')
  tornozelos('Tornozelos'),

  @JsonValue('PES')
  pes('Pés'),

  @JsonValue('CALCANHARES')
  calcanhares('Calcanhares'),

  @JsonValue('SACRO')
  sacro('Sacro'),

  @JsonValue('OUTRAS')
  outras('Outras');

  const WoundLocation(this.displayName);
  final String displayName;

  /// Indica se a localização é de alto risco para infecção
  bool get isHighRiskForInfection {
    switch (this) {
      case WoundLocation.genitais:
      case WoundLocation.abdomen:
      case WoundLocation.sacro:
      case WoundLocation.quadrisNadegas:
        return true;
      case WoundLocation.cabecaPescoco:
      case WoundLocation.torax:
      case WoundLocation.bracos:
      case WoundLocation.maos:
      case WoundLocation.costas:
      case WoundLocation.coxas:
      case WoundLocation.joelhos:
      case WoundLocation.pernas:
      case WoundLocation.tornozelos:
      case WoundLocation.pes:
      case WoundLocation.calcanhares:
      case WoundLocation.outras:
        return false;
    }
  }

  /// Indica se a localização é suscetível à pressão
  bool get isPressureProne {
    switch (this) {
      case WoundLocation.sacro:
      case WoundLocation.quadrisNadegas:
      case WoundLocation.calcanhares:
      case WoundLocation.costas:
        return true;
      case WoundLocation.cabecaPescoco:
      case WoundLocation.torax:
      case WoundLocation.abdomen:
      case WoundLocation.bracos:
      case WoundLocation.maos:
      case WoundLocation.genitais:
      case WoundLocation.coxas:
      case WoundLocation.joelhos:
      case WoundLocation.pernas:
      case WoundLocation.tornozelos:
      case WoundLocation.pes:
      case WoundLocation.outras:
        return false;
    }
  }
}

/// Status da ferida
enum WoundStatus {
  @JsonValue('ATIVA')
  ativa('Ativa'),

  @JsonValue('EM_CICATRIZACAO')
  emCicatrizacao('Em Cicatrização'),

  @JsonValue('CICATRIZADA')
  cicatrizada('Cicatrizada'),

  @JsonValue('INFECTADA')
  infectada('Infectada'),

  @JsonValue('COMPLICADA')
  complicada('Complicada');

  const WoundStatus(this.displayName);
  final String displayName;

  /// Indica se o status permite novas avaliações
  bool get allowsNewAssessments {
    switch (this) {
      case WoundStatus.ativa:
      case WoundStatus.emCicatrizacao:
      case WoundStatus.infectada:
      case WoundStatus.complicada:
        return true;
      case WoundStatus.cicatrizada:
        return false;
    }
  }

  /// Indica se o status requer atenção médica urgente
  bool get requiresUrgentAttention {
    switch (this) {
      case WoundStatus.infectada:
      case WoundStatus.complicada:
        return true;
      case WoundStatus.ativa:
      case WoundStatus.emCicatrizacao:
      case WoundStatus.cicatrizada:
        return false;
    }
  }

  /// Indica se o status representa progresso positivo
  bool get isPositiveProgress {
    switch (this) {
      case WoundStatus.emCicatrizacao:
      case WoundStatus.cicatrizada:
        return true;
      case WoundStatus.ativa:
      case WoundStatus.infectada:
      case WoundStatus.complicada:
        return false;
    }
  }
}

@freezed
class Wound with _$Wound {
  const factory Wound({
    required String id,
    required String patientId,
    required String description,
    required WoundType type,
    required WoundLocation location,
    required WoundStatus status,
    @TimestampConverter() required DateTime identificationDate,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    DateTime? healedDate,
    String? notes,
    @Default(false) bool archived,
  }) = _Wound;

  const Wound._();

  factory Wound.fromJson(Map<String, dynamic> json) => _$WoundFromJson(json);

  /// Factory para criar uma nova ferida com validações de domínio
  factory Wound.create({
    required String patientId,
    required String description,
    required WoundType type,
    required WoundLocation location,
    DateTime? identificationDate,
    String? notes,
  }) {
    // Validações de domínio
    _validatePatientId(patientId);
    _validateDescription(description);
    _validateIdentificationDate(identificationDate);

    final now = DateTime.now();
    return Wound(
      id: '',
      patientId: patientId.trim(),
      description: description.trim(),
      type: type,
      location: location,
      status: WoundStatus.ativa,
      identificationDate: identificationDate ?? now,
      notes: notes?.trim(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Calcula há quantos dias a ferida foi identificada
  int get daysSinceIdentification {
    final today = DateTime.now();
    return today.difference(identificationDate).inDays;
  }

  /// Calcula há quantos dias a ferida foi cicatrizada (se aplicável)
  int? get daysSinceHealed {
    if (healedDate == null) return null;
    final today = DateTime.now();
    return today.difference(healedDate!).inDays;
  }

  /// Calcula o tempo total de cicatrização (se aplicável)
  int? get healingDurationInDays {
    if (healedDate == null) return null;
    return healedDate!.difference(identificationDate).inDays;
  }

  /// Verifica se a ferida é considerada crônica (> 30 dias)
  bool get isChronicWound => daysSinceIdentification > 30;

  /// Verifica se a ferida está ativa (não cicatrizada)
  bool get isActive => status != WoundStatus.cicatrizada;

  /// Verifica se a ferida requer atenção urgente
  bool get requiresUrgentCare =>
      status.requiresUrgentAttention ||
      (type.requiresSpecialMonitoring && daysSinceIdentification > 14);

  /// Verifica se a ferida está progredindo bem
  bool get isProgressing => status.isPositiveProgress;

  /// Calcula o nível de risco geral da ferida (1-5)
  int get riskLevel {
    int risk = 1; // Risco base

    // Aumenta risco baseado no tipo
    if (type.hasSlowHealingTendency) risk += 1;
    if (type.requiresSpecialMonitoring) risk += 1;

    // Aumenta risco baseado na localização
    if (location.isHighRiskForInfection) risk += 1;
    if (location.isPressureProne) risk += 1;

    // Aumenta risco baseado no status
    if (status.requiresUrgentAttention) risk += 1;

    // Aumenta risco se for crônica
    if (isChronicWound) risk += 1;

    return risk.clamp(1, 5);
  }

  /// Gera descrição do risco
  String get riskDescription {
    switch (riskLevel) {
      case 1:
        return 'Baixo risco';
      case 2:
        return 'Risco moderado-baixo';
      case 3:
        return 'Risco moderado';
      case 4:
        return 'Risco moderado-alto';
      case 5:
        return 'Alto risco';
      default:
        return 'Risco indeterminado';
    }
  }

  /// Atualiza o status da ferida com validações
  Wound updateStatus(WoundStatus newStatus, {DateTime? healedDate}) {
    // Validações de transição de status
    _validateStatusTransition(status, newStatus);

    // Se marcar como cicatrizada, deve informar data de cicatrização
    DateTime? finalHealedDate = this.healedDate;
    if (newStatus == WoundStatus.cicatrizada) {
      if (healedDate == null && this.healedDate == null) {
        finalHealedDate = DateTime.now();
      } else if (healedDate != null) {
        _validateHealedDate(healedDate);
        finalHealedDate = healedDate;
      }
    } else if (newStatus != WoundStatus.cicatrizada) {
      // Remove data de cicatrização se não estiver mais cicatrizada
      finalHealedDate = null;
    }

    return copyWith(
      status: newStatus,
      healedDate: finalHealedDate,
      updatedAt: DateTime.now(),
    );
  }

  /// Atualiza informações da ferida
  Wound updateInfo({
    String? description,
    WoundType? type,
    WoundLocation? location,
    DateTime? identificationDate,
    String? notes,
  }) {
    if (description != null) {
      _validateDescription(description);
    }

    if (identificationDate != null) {
      _validateIdentificationDate(identificationDate);
    }

    return copyWith(
      description: description?.trim() ?? this.description,
      type: type ?? this.type,
      location: location ?? this.location,
      identificationDate: identificationDate ?? this.identificationDate,
      notes: notes?.trim() ?? this.notes,
      updatedAt: DateTime.now(),
    );
  }

  /// Arquiva a ferida
  Wound archive() => copyWith(archived: true, updatedAt: DateTime.now());

  /// Desarquiva a ferida
  Wound unarchive() => copyWith(archived: false, updatedAt: DateTime.now());

  /// Gera resumo da ferida
  String get summary {
    final chronic = isChronicWound ? ' (Crônica)' : '';
    final urgent = requiresUrgentCare ? ' ⚠️' : '';
    return '${type.displayName} - ${location.displayName} - ${status.displayName}$chronic$urgent';
  }

  /// Validações privadas
  static void _validatePatientId(String patientId) {
    if (patientId.trim().isEmpty) {
      throw const ValidationException('ID do paciente é obrigatório');
    }
  }

  static void _validateDescription(String description) {
    if (description.trim().isEmpty) {
      throw const ValidationException('Descrição da ferida é obrigatória');
    }
    if (description.trim().length < 3) {
      throw const ValidationException(
        'Descrição deve ter pelo menos 3 caracteres',
      );
    }
    if (description.trim().length > 500) {
      throw const ValidationException(
        'Descrição não pode ter mais de 500 caracteres',
      );
    }
  }

  static void _validateIdentificationDate(DateTime? identificationDate) {
    if (identificationDate == null) return;

    final today = DateTime.now();
    if (identificationDate.isAfter(today)) {
      throw const ValidationException(
        'Data de identificação não pode ser no futuro',
      );
    }

    // Não pode ser muito antiga (10 anos)
    final maxPast = today.subtract(const Duration(days: 365 * 10));
    if (identificationDate.isBefore(maxPast)) {
      throw const ValidationException(
        'Data de identificação não pode ser anterior a 10 anos',
      );
    }
  }

  static void _validateHealedDate(DateTime healedDate) {
    final today = DateTime.now();
    if (healedDate.isAfter(today)) {
      throw const ValidationException(
        'Data de cicatrização não pode ser no futuro',
      );
    }
  }

  static void _validateStatusTransition(
    WoundStatus current,
    WoundStatus target,
  ) {
    // Regras de transição de status
    switch (current) {
      case WoundStatus.ativa:
        // De ativa pode ir para qualquer status
        break;
      case WoundStatus.emCicatrizacao:
        // De cicatrização pode voltar para ativa ou ir para cicatrizada
        if (target != WoundStatus.ativa &&
            target != WoundStatus.cicatrizada &&
            target != WoundStatus.infectada &&
            target != WoundStatus.complicada) {
          throw const BusinessRuleException(
            'Transição de status inválida: ferida em cicatrização pode apenas voltar para ativa, ficar infectada/complicada ou ser marcada como cicatrizada',
          );
        }
        break;
      case WoundStatus.cicatrizada:
        // De cicatrizada pode voltar apenas para ativa (recidiva)
        if (target != WoundStatus.ativa) {
          throw const BusinessRuleException(
            'Transição de status inválida: ferida cicatrizada pode apenas reabrir (voltar para ativa)',
          );
        }
        break;
      case WoundStatus.infectada:
      case WoundStatus.complicada:
        // De infectada/complicada pode ir para qualquer status exceto cicatrizada diretamente
        if (target == WoundStatus.cicatrizada) {
          throw const BusinessRuleException(
            'Transição de status inválida: ferida infectada/complicada deve passar por cicatrização antes de ser marcada como cicatrizada',
          );
        }
        break;
    }
  }
}
