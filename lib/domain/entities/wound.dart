// ignore_for_file: non_abstract_class_inherits_abstract_member
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'wound.freezed.dart';
part 'wound.g.dart';

enum WoundType {
  @JsonValue('pressure_ulcer')
  pressureUlcer,
  @JsonValue('diabetic_foot')
  diabeticFoot,
  @JsonValue('venous_ulcer')
  venousUlcer,
  @JsonValue('arterial_ulcer')
  arterialUlcer,
  @JsonValue('surgical')
  surgical,
  @JsonValue('traumatic')
  traumatic,
  @JsonValue('burn')
  burn,
  @JsonValue('other')
  other,
}

enum WoundLocation {
  @JsonValue('head_neck')
  headNeck,
  @JsonValue('upper_limb_right')
  upperLimbRight,
  @JsonValue('upper_limb_left')
  upperLimbLeft,
  @JsonValue('chest')
  chest,
  @JsonValue('abdomen')
  abdomen,
  @JsonValue('back')
  back,
  @JsonValue('lower_limb_right')
  lowerLimbRight,
  @JsonValue('lower_limb_left')
  lowerLimbLeft,
  @JsonValue('foot_right')
  footRight,
  @JsonValue('foot_left')
  footLeft,
  @JsonValue('other')
  other,
}

enum WoundStatus {
  @JsonValue('active')
  active,
  @JsonValue('healing')
  healing,
  @JsonValue('healed')
  healed,
  @JsonValue('worsening')
  worsening,
  @JsonValue('inactive')
  inactive,
}

@freezed
class Wound with _$Wound {
  const factory Wound({
    required String id,
    required String patientId,
    required WoundType type,
    required WoundLocation locationSimple,
    required int onsetDays,
    @Default(WoundStatus.active) WoundStatus status,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    String? locationDescription,
    String? notes,
    String? causeDescription,
  }) = _Wound;

  factory Wound.fromJson(Map<String, dynamic> json) => _$WoundFromJson(json);

  factory Wound.create({
    required String patientId,
    required WoundType type,
    required WoundLocation locationSimple,
    required int onsetDays,
    String? locationDescription,
    String? notes,
    String? causeDescription,
  }) {
    final now = DateTime.now();
    return Wound(
      id: '',
      patientId: patientId,
      type: type,
      locationSimple: locationSimple,
      onsetDays: onsetDays,
      createdAt: now,
      updatedAt: now,
      locationDescription: locationDescription?.trim(),
      notes: notes?.trim(),
      causeDescription: causeDescription?.trim(),
    );
  }
}
