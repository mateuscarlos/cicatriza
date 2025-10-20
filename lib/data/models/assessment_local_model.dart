import 'package:hive/hive.dart';

part 'assessment_local_model.g.dart';

@HiveType(typeId: 0)
class AssessmentLocalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String woundId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final int painScale;

  @HiveField(4)
  final double lengthCm;

  @HiveField(5)
  final double widthCm;

  @HiveField(6)
  final double? depthCm;

  @HiveField(7)
  final String woundBed;

  @HiveField(8)
  final String exudateType;

  @HiveField(9)
  final String edgeAppearance;

  @HiveField(10)
  final String? notes;

  @HiveField(11)
  final bool isSynced;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  final DateTime updatedAt;

  AssessmentLocalModel({
    required this.id,
    required this.woundId,
    required this.date,
    required this.painScale,
    required this.lengthCm,
    required this.widthCm,
    this.depthCm,
    required this.woundBed,
    required this.exudateType,
    required this.edgeAppearance,
    this.notes,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
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
