/// Versão manual da entidade Assessment para M1
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
    this.lengthCm,
    this.widthCm,
    this.depthCm,
    this.painScale,
    this.edgeAppearance,
    this.woundBed,
    this.exudateType,
    this.exudateAmount,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
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
    final now = DateTime.now();
    return AssessmentManual(
      id: '',
      woundId: woundId,
      date: date ?? now,
      lengthCm: lengthCm,
      widthCm: widthCm,
      depthCm: depthCm,
      painScale: painScale,
      edgeAppearance: edgeAppearance,
      woundBed: woundBed,
      exudateType: exudateType,
      exudateAmount: exudateAmount,
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

  double? get area =>
      (lengthCm != null && widthCm != null) ? lengthCm! * widthCm! : null;

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
