// ignore_for_file: non_abstract_class_inherits_abstract_member
import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_simple.freezed.dart';
part 'patient_simple.g.dart';

@freezed
class PatientSimple with _$PatientSimple {
  const factory PatientSimple({
    required String id,
    required String name,
    required DateTime birthDate,
    @Default(false) bool archived,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String nameLowercase,
    String? notes,
    String? phone,
    String? email,
  }) = _PatientSimple;

  factory PatientSimple.fromJson(Map<String, dynamic> json) =>
      _$PatientSimpleFromJson(json);

  factory PatientSimple.create({
    required String name,
    required DateTime birthDate,
    String? notes,
    String? phone,
    String? email,
  }) {
    final now = DateTime.now();
    return PatientSimple(
      id: '',
      name: name.trim(),
      birthDate: birthDate,
      nameLowercase: name.trim().toLowerCase(),
      createdAt: now,
      updatedAt: now,
      notes: notes?.trim(),
      phone: phone?.trim(),
      email: email?.trim(),
    );
  }
}
