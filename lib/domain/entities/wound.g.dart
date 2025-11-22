// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wound.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WoundImpl _$$WoundImplFromJson(Map<String, dynamic> json) => _$WoundImpl(
  id: json['id'] as String,
  patientId: json['patientId'] as String,
  type: $enumDecode(_$WoundTypeEnumMap, json['type']),
  locationSimple: $enumDecode(_$WoundLocationEnumMap, json['locationSimple']),
  onsetDays: (json['onsetDays'] as num).toInt(),
  status:
      $enumDecodeNullable(_$WoundStatusEnumMap, json['status']) ??
      WoundStatus.active,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
  locationDescription: json['locationDescription'] as String?,
  notes: json['notes'] as String?,
  causeDescription: json['causeDescription'] as String?,
);

Map<String, dynamic> _$$WoundImplToJson(_$WoundImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'type': _$WoundTypeEnumMap[instance.type]!,
      'locationSimple': _$WoundLocationEnumMap[instance.locationSimple]!,
      'onsetDays': instance.onsetDays,
      'status': _$WoundStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'locationDescription': instance.locationDescription,
      'notes': instance.notes,
      'causeDescription': instance.causeDescription,
    };

const _$WoundTypeEnumMap = {
  WoundType.pressureUlcer: 'pressure_ulcer',
  WoundType.diabeticFoot: 'diabetic_foot',
  WoundType.venousUlcer: 'venous_ulcer',
  WoundType.arterialUlcer: 'arterial_ulcer',
  WoundType.surgical: 'surgical',
  WoundType.traumatic: 'traumatic',
  WoundType.burn: 'burn',
  WoundType.other: 'other',
};

const _$WoundLocationEnumMap = {
  WoundLocation.headNeck: 'head_neck',
  WoundLocation.upperLimbRight: 'upper_limb_right',
  WoundLocation.upperLimbLeft: 'upper_limb_left',
  WoundLocation.chest: 'chest',
  WoundLocation.abdomen: 'abdomen',
  WoundLocation.back: 'back',
  WoundLocation.lowerLimbRight: 'lower_limb_right',
  WoundLocation.lowerLimbLeft: 'lower_limb_left',
  WoundLocation.footRight: 'foot_right',
  WoundLocation.footLeft: 'foot_left',
  WoundLocation.other: 'other',
};

const _$WoundStatusEnumMap = {
  WoundStatus.active: 'active',
  WoundStatus.healing: 'healing',
  WoundStatus.healed: 'healed',
  WoundStatus.worsening: 'worsening',
  WoundStatus.inactive: 'inactive',
};
