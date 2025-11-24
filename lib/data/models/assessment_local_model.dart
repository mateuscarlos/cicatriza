class AssessmentLocalModel {
  final String id;
  final String woundId;
  final DateTime date;
  final int painScale;
  final double lengthCm;
  final double widthCm;
  final double? depthCm;
  final String woundBed;
  final String exudateType;
  final String edgeAppearance;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssessmentLocalModel({
    required this.id,
    required this.woundId,
    required this.date,
    required this.painScale,
    required this.lengthCm,
    required this.widthCm,
    required this.woundBed, required this.exudateType, required this.edgeAppearance, required this.createdAt, required this.updatedAt, this.depthCm,
    this.notes,
    this.isSynced = false,
  });

  AssessmentLocalModel copyWith({
    String? id,
    String? woundId,
    DateTime? date,
    int? painScale,
    double? lengthCm,
    double? widthCm,
    double? depthCm,
    String? woundBed,
    String? exudateType,
    String? edgeAppearance,
    String? notes,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssessmentLocalModel(
      id: id ?? this.id,
      woundId: woundId ?? this.woundId,
      date: date ?? this.date,
      painScale: painScale ?? this.painScale,
      lengthCm: lengthCm ?? this.lengthCm,
      widthCm: widthCm ?? this.widthCm,
      depthCm: depthCm ?? this.depthCm,
      woundBed: woundBed ?? this.woundBed,
      exudateType: exudateType ?? this.exudateType,
      edgeAppearance: edgeAppearance ?? this.edgeAppearance,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'woundId': woundId,
      'date': date.toIso8601String(),
      'painScale': painScale,
      'lengthCm': lengthCm,
      'widthCm': widthCm,
      'depthCm': depthCm,
      'woundBed': woundBed,
      'exudateType': exudateType,
      'edgeAppearance': edgeAppearance,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AssessmentLocalModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return AssessmentLocalModel(
      id: id,
      woundId: data['woundId'] as String,
      date: DateTime.parse(data['date'] as String),
      painScale: data['painScale'] as int,
      lengthCm: (data['lengthCm'] as num).toDouble(),
      widthCm: (data['widthCm'] as num).toDouble(),
      depthCm: data['depthCm'] != null
          ? (data['depthCm'] as num).toDouble()
          : null,
      woundBed: data['woundBed'] as String,
      exudateType: data['exudateType'] as String,
      edgeAppearance: data['edgeAppearance'] as String,
      notes: data['notes'] as String?,
      isSynced: true,
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
  }
}
