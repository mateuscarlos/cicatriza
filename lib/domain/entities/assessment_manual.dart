import '../exceptions/domain_exceptions.dart';

/// Versão manual da entidade Assessment para M1 - Entidade Rica
class AssessmentManual {
  static const List<int> painScaleValues = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  static const List<String> edgeAppearanceOptions = [
    'Regular',
    'Irregular',
    'Bem definida',
    'Mal definida',
    'Elevada',
    'Necrótica',
  ];

  static const List<String> woundBedOptions = [
    'Limpo',
    'Granulação',
    'Fibrina',
    'Necrose',
    'Misto',
  ];

  static const List<String> exudateTypeOptions = [
    'Ausente',
    'Seroso',
    'Sanguinolento',
    'Purulento',
    'Seropurulento',
  ];

  static const List<String> exudateAmountOptions = [
    'Ausente',
    'Pequena',
    'Moderada',
    'Grande',
  ];

  final String id;
  final String woundId;
  final DateTime date;
  final double? lengthCm;
  final double? widthCm;
  final double? depthCm;
  final int? painScale;
  final String? edgeAppearance;
  final String? woundBed;
  final String? exudateType;
  final String? exudateAmount;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssessmentManual({
    required this.id,
    required this.woundId,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.lengthCm,
    this.widthCm,
    this.depthCm,
    this.painScale,
    this.edgeAppearance,
    this.woundBed,
    this.exudateType,
    this.exudateAmount,
    this.notes,
  });

  factory AssessmentManual.create({
    required String woundId,
    DateTime? date,
    double? lengthCm,
    double? widthCm,
    double? depthCm,
    int? painScale,
    String? edgeAppearance,
    String? woundBed,
    String? exudateType,
    String? exudateAmount,
    String? notes,
  }) {
    // Validações de domínio
    _validateWoundId(woundId);
    _validateDate(date);
    _validateDimensions(lengthCm, widthCm, depthCm);
    _validatePainScale(painScale);
    _validateOptions(edgeAppearance, woundBed, exudateType, exudateAmount);

    final now = DateTime.now();
    return AssessmentManual(
      id: '',
      woundId: woundId.trim(),
      date: date ?? now,
      lengthCm: lengthCm,
      widthCm: widthCm,
      depthCm: depthCm,
      painScale: painScale,
      edgeAppearance: edgeAppearance?.trim(),
      woundBed: woundBed?.trim(),
      exudateType: exudateType?.trim(),
      exudateAmount: exudateAmount?.trim(),
      notes: notes?.trim(),
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'woundId': woundId,
      'date': date.toIso8601String(),
      'lengthCm': lengthCm,
      'widthCm': widthCm,
      'depthCm': depthCm,
      'painScale': painScale,
      'edgeAppearance': edgeAppearance,
      'woundBed': woundBed,
      'exudateType': exudateType,
      'exudateAmount': exudateAmount,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AssessmentManual.fromJson(Map<String, dynamic> json) {
    return AssessmentManual(
      id: json['id'] as String,
      woundId: json['woundId'] as String,
      date: DateTime.parse(json['date'] as String),
      lengthCm: (json['lengthCm'] as num?)?.toDouble(),
      widthCm: (json['widthCm'] as num?)?.toDouble(),
      depthCm: (json['depthCm'] as num?)?.toDouble(),
      painScale: json['painScale'] as int?,
      edgeAppearance: json['edgeAppearance'] as String?,
      woundBed: json['woundBed'] as String?,
      exudateType: json['exudateType'] as String?,
      exudateAmount: json['exudateAmount'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  AssessmentManual copyWith({
    String? id,
    String? woundId,
    DateTime? date,
    double? lengthCm,
    double? widthCm,
    double? depthCm,
    int? painScale,
    String? edgeAppearance,
    String? woundBed,
    String? exudateType,
    String? exudateAmount,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssessmentManual(
      id: id ?? this.id,
      woundId: woundId ?? this.woundId,
      date: date ?? this.date,
      lengthCm: lengthCm ?? this.lengthCm,
      widthCm: widthCm ?? this.widthCm,
      depthCm: depthCm ?? this.depthCm,
      painScale: painScale ?? this.painScale,
      edgeAppearance: edgeAppearance ?? this.edgeAppearance,
      woundBed: woundBed ?? this.woundBed,
      exudateType: exudateType ?? this.exudateType,
      exudateAmount: exudateAmount ?? this.exudateAmount,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Calcula a área da ferida se as dimensões estiverem disponíveis
  double? get area =>
      (lengthCm != null && widthCm != null) ? lengthCm! * widthCm! : null;

  /// Calcula o volume da ferida se todas as dimensões estiverem disponíveis
  double? get volume => (lengthCm != null && widthCm != null && depthCm != null)
      ? lengthCm! * widthCm! * depthCm!
      : null;

  /// Verifica se a avaliação tem medidas completas
  bool get hasCompleteMeasurements =>
      lengthCm != null && widthCm != null && depthCm != null;

  /// Verifica se há dor significativa (> 3 na escala)
  bool get hasSignificantPain => painScale != null && painScale! > 3;

  /// Verifica se há dor severa (> 7 na escala)
  bool get hasSeverePain => painScale != null && painScale! > 7;

  /// Verifica se há exudato presente
  bool get hasExudate => exudateType != null && exudateType != 'Ausente';

  /// Verifica se há sinais de infecção baseado no exudato
  bool get hasInfectionSigns {
    if (exudateType == null) return false;
    return exudateType == 'Purulento' || exudateType == 'Seropurulento';
  }

  /// Verifica se a ferida tem sinais de cicatrização positiva
  bool get hasPositiveHealingSigns {
    if (woundBed == null) return false;
    return woundBed == 'Limpo' || woundBed == 'Granulação';
  }

  /// Verifica se há tecido necrótico
  bool get hasNecroticTissue {
    if (woundBed == null && edgeAppearance == null) return false;
    return woundBed == 'Necrose' || edgeAppearance == 'Necrótica';
  }

  /// Calcula score de gravidade (0-10)
  int get severityScore {
    int score = 0;

    // Dor contribui para gravidade
    if (painScale != null) {
      score += (painScale! * 0.5).round();
    }

    // Sinais de infecção aumentam gravidade
    if (hasInfectionSigns) score += 3;

    // Tecido necrótico aumenta gravidade
    if (hasNecroticTissue) score += 2;

    // Exudato abundante aumenta gravidade
    if (exudateAmount == 'Grande') score += 1;

    return score.clamp(0, 10);
  }

  /// Gera descrição do nível de gravidade
  String get severityDescription {
    switch (severityScore) {
      case 0:
      case 1:
      case 2:
        return 'Leve';
      case 3:
      case 4:
      case 5:
        return 'Moderada';
      case 6:
      case 7:
        return 'Grave';
      case 8:
      case 9:
      case 10:
        return 'Muito Grave';
      default:
        return 'Indeterminada';
    }
  }

  /// Atualiza a avaliação com novas informações
  AssessmentManual updateInfo({
    double? lengthCm,
    double? widthCm,
    double? depthCm,
    int? painScale,
    String? edgeAppearance,
    String? woundBed,
    String? exudateType,
    String? exudateAmount,
    String? notes,
  }) {
    _validateDimensions(lengthCm, widthCm, depthCm);
    _validatePainScale(painScale);
    _validateOptions(edgeAppearance, woundBed, exudateType, exudateAmount);

    return copyWith(
      lengthCm: lengthCm ?? this.lengthCm,
      widthCm: widthCm ?? this.widthCm,
      depthCm: depthCm ?? this.depthCm,
      painScale: painScale ?? this.painScale,
      edgeAppearance: edgeAppearance?.trim() ?? this.edgeAppearance,
      woundBed: woundBed?.trim() ?? this.woundBed,
      exudateType: exudateType?.trim() ?? this.exudateType,
      exudateAmount: exudateAmount?.trim() ?? this.exudateAmount,
      notes: notes?.trim() ?? this.notes,
      updatedAt: DateTime.now(),
    );
  }

  /// Gera resumo da avaliação
  String get summary {
    final measurements = hasCompleteMeasurements
        ? '${lengthCm}x${widthCm}x$depthCm cm'
        : area != null
        ? '${lengthCm}x$widthCm cm (área: ${area!.toStringAsFixed(2)} cm²)'
        : 'Sem medidas';

    final painInfo = painScale != null ? 'Dor: $painScale/10' : 'Dor: N/I';
    final exudateInfo = hasExudate
        ? 'Exudato: $exudateType ($exudateAmount)'
        : 'Sem exudato';

    return '$measurements | $painInfo | $exudateInfo | Gravidade: $severityDescription';
  }

  /// Validações privadas
  static void _validateWoundId(String woundId) {
    if (woundId.trim().isEmpty) {
      throw const ValidationException('ID da ferida é obrigatório');
    }
  }

  static void _validateDate(DateTime? date) {
    if (date == null) return;

    final today = DateTime.now();
    if (date.isAfter(today)) {
      throw const ValidationException(
        'Data da avaliação não pode ser no futuro',
      );
    }

    // Não pode ser muito antiga (1 ano)
    final maxPast = today.subtract(const Duration(days: 365));
    if (date.isBefore(maxPast)) {
      throw const ValidationException(
        'Data da avaliação não pode ser anterior a 1 ano',
      );
    }
  }

  static void _validateDimensions(
    double? length,
    double? width,
    double? depth,
  ) {
    if (length != null && (length < 0 || length > 100)) {
      throw const ValidationException(
        'Comprimento deve estar entre 0 e 100 cm',
      );
    }
    if (width != null && (width < 0 || width > 100)) {
      throw const ValidationException('Largura deve estar entre 0 e 100 cm');
    }
    if (depth != null && (depth < 0 || depth > 50)) {
      throw const ValidationException(
        'Profundidade deve estar entre 0 e 50 cm',
      );
    }

    // Se apenas uma dimensão for informada, deve ser comprimento
    if ((width != null || depth != null) && length == null) {
      throw const ValidationException(
        'Comprimento é obrigatório quando outras dimensões são informadas',
      );
    }
  }

  static void _validatePainScale(int? painScale) {
    if (painScale != null && !painScaleValues.contains(painScale)) {
      throw ValidationException(
        'Escala de dor deve ser entre 0 e 10, valor informado: $painScale',
      );
    }
  }

  static void _validateOptions(
    String? edgeAppearance,
    String? woundBed,
    String? exudateType,
    String? exudateAmount,
  ) {
    if (edgeAppearance != null &&
        !edgeAppearanceOptions.contains(edgeAppearance.trim())) {
      throw ValidationException('Aparência da borda inválida: $edgeAppearance');
    }

    if (woundBed != null && !woundBedOptions.contains(woundBed.trim())) {
      throw ValidationException('Leito da ferida inválido: $woundBed');
    }

    if (exudateType != null &&
        !exudateTypeOptions.contains(exudateType.trim())) {
      throw ValidationException('Tipo de exudato inválido: $exudateType');
    }

    if (exudateAmount != null &&
        !exudateAmountOptions.contains(exudateAmount.trim())) {
      throw ValidationException(
        'Quantidade de exudato inválida: $exudateAmount',
      );
    }

    // Se o tipo de exudato é "Ausente", a quantidade deve ser "Ausente" ou null
    if (exudateType == 'Ausente' &&
        exudateAmount != null &&
        exudateAmount != 'Ausente') {
      throw const ValidationException(
        'Se o exudato é ausente, a quantidade deve ser ausente',
      );
    }

    // Se há quantidade de exudato mas não há tipo, é inválido
    if (exudateAmount != null &&
        exudateAmount != 'Ausente' &&
        (exudateType == null || exudateType == 'Ausente')) {
      throw const ValidationException(
        'Tipo de exudato deve ser informado quando há quantidade',
      );
    }
  }

  @override
  String toString() {
    return 'AssessmentManual(id: $id, woundId: $woundId, date: $date, painScale: $painScale)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssessmentManual &&
        other.id == id &&
        other.woundId == woundId &&
        other.date == date &&
        other.lengthCm == lengthCm &&
        other.widthCm == widthCm &&
        other.depthCm == depthCm &&
        other.painScale == painScale &&
        other.edgeAppearance == edgeAppearance &&
        other.woundBed == woundBed &&
        other.exudateType == exudateType &&
        other.exudateAmount == exudateAmount &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      woundId,
      date,
      lengthCm,
      widthCm,
      depthCm,
      painScale,
      edgeAppearance,
      woundBed,
      exudateType,
      exudateAmount,
      notes,
      createdAt,
      updatedAt,
    );
  }
}
