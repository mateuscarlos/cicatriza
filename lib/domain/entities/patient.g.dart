// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientImpl _$$PatientImplFromJson(
  Map<String, dynamic> json,
) => _$PatientImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  birthDate: const TimestampConverter().fromJson(json['birthDate'] as Object),
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
  nameLowercase: json['nameLowercase'] as String,
  archived: json['archived'] as bool? ?? false,
  notes: json['notes'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$$PatientImplToJson(_$PatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthDate': const TimestampConverter().toJson(instance.birthDate),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'nameLowercase': instance.nameLowercase,
      'archived': instance.archived,
      'notes': instance.notes,
      'phone': instance.phone,
      'email': instance.email,
    };
