// ignore_for_file: non_abstract_class_inherits_abstract_member
import 'package:freezed_annotation/freezed_annotation.dart';

part 'assessment.freezed.dart';
part 'assessment.g.dart';

@freezed
class Assessment with _$Assessment {
  const factory Assessment({
    required String id,
    required String woundId,
    required DateTime date,
    required int pain,
    required double lengthCm,
    required double widthCm,
    required double depthCm,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? notes,
    String? exudate,
    String? edgeAppearance,
    String? woundBed,
    String? periwoundSkin,
    String? odor,
    String? treatmentPlan,
  }) = _Assessment;

  factory Assessment.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFromJson(json);

  factory Assessment.create({
    required String woundId,
    required DateTime date,
    required int pain,
    required double lengthCm,
    required double widthCm,
    required double depthCm,
    String? notes,
    String? exudate,
    String? edgeAppearance,
    String? woundBed,
    String? periwoundSkin,
    String? odor,
    String? treatmentPlan,
  }) {
    final now = DateTime.now();
    return Assessment(
      id: '',
      woundId: woundId,
      date: date,
      pain: pain,
      lengthCm: lengthCm,
      widthCm: widthCm,
      depthCm: depthCm,
      createdAt: now,
      updatedAt: now,
      notes: notes?.trim(),
      exudate: exudate?.trim(),
      edgeAppearance: edgeAppearance?.trim(),
      woundBed: woundBed?.trim(),
      periwoundSkin: periwoundSkin?.trim(),
      odor: odor?.trim(),
      treatmentPlan: treatmentPlan?.trim(),
    );
  }
}
