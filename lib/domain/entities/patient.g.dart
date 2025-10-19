// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Patient _$PatientFromJson(Map<String, dynamic> json) => _Patient(
  id: json['id'] as String,
  name: json['name'] as String,
  birthDate: const TimestampConverter().fromJson(json['birthDate'] as Object),
  archived: json['archived'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
  nameLowercase: json['nameLowercase'] as String,
  notes: json['notes'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$PatientToJson(_Patient instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'birthDate': const TimestampConverter().toJson(instance.birthDate),
  'archived': instance.archived,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'nameLowercase': instance.nameLowercase,
  'notes': instance.notes,
  'phone': instance.phone,
  'email': instance.email,
};
