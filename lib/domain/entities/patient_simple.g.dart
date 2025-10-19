// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientSimple _$PatientSimpleFromJson(Map<String, dynamic> json) =>
    _PatientSimple(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      archived: json['archived'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      nameLowercase: json['nameLowercase'] as String,
      notes: json['notes'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$PatientSimpleToJson(_PatientSimple instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthDate': instance.birthDate.toIso8601String(),
      'archived': instance.archived,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'nameLowercase': instance.nameLowercase,
      'notes': instance.notes,
      'phone': instance.phone,
      'email': instance.email,
    };
