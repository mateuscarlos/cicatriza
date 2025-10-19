import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

@freezed
class Patient with _$Patient {
  const factory Patient({
    required String id,
    required String name,
    @TimestampConverter() required DateTime birthDate,
    @Default(false) bool archived,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required String nameLowercase,
    String? notes,
    String? phone,
    String? email,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  factory Patient.create({
    required String name,
    required DateTime birthDate,
    String? notes,
    String? phone,
    String? email,
  }) {
    final now = DateTime.now();
    return Patient(
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
