// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Assessment _$AssessmentFromJson(Map<String, dynamic> json) => _Assessment(
  id: json['id'] as String,
  woundId: json['woundId'] as String,
  date: DateTime.parse(json['date'] as String),
  pain: (json['pain'] as num).toInt(),
  lengthCm: (json['lengthCm'] as num).toDouble(),
  widthCm: (json['widthCm'] as num).toDouble(),
  depthCm: (json['depthCm'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  notes: json['notes'] as String?,
  exudate: json['exudate'] as String?,
  edgeAppearance: json['edgeAppearance'] as String?,
  woundBed: json['woundBed'] as String?,
  periwoundSkin: json['periwoundSkin'] as String?,
  odor: json['odor'] as String?,
  treatmentPlan: json['treatmentPlan'] as String?,
);

Map<String, dynamic> _$AssessmentToJson(_Assessment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'woundId': instance.woundId,
      'date': instance.date.toIso8601String(),
      'pain': instance.pain,
      'lengthCm': instance.lengthCm,
      'widthCm': instance.widthCm,
      'depthCm': instance.depthCm,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'notes': instance.notes,
      'exudate': instance.exudate,
      'edgeAppearance': instance.edgeAppearance,
      'woundBed': instance.woundBed,
      'periwoundSkin': instance.periwoundSkin,
      'odor': instance.odor,
      'treatmentPlan': instance.treatmentPlan,
    };
