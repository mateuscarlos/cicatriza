// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientSimpleImpl _$$PatientSimpleImplFromJson(Map<String, dynamic> json) =>
    _$PatientSimpleImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      nameLowercase: json['nameLowercase'] as String,
      archived: json['archived'] as bool? ?? false,
      notes: json['notes'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$PatientSimpleImplToJson(_$PatientSimpleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthDate': instance.birthDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'nameLowercase': instance.nameLowercase,
      'archived': instance.archived,
      'notes': instance.notes,
      'phone': instance.phone,
      'email': instance.email,
    };
