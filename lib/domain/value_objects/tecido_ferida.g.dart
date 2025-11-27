// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tecido_ferida.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TecidoFeridaImpl _$$TecidoFeridaImplFromJson(Map<String, dynamic> json) =>
    _$TecidoFeridaImpl(
      granulacao: (json['granulacao'] as num?)?.toInt() ?? 0,
      fibrina: (json['fibrina'] as num?)?.toInt() ?? 0,
      necrose: (json['necrose'] as num?)?.toInt() ?? 0,
      epitelizacao: (json['epitelizacao'] as num?)?.toInt() ?? 0,
      outros: (json['outros'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TecidoFeridaImplToJson(_$TecidoFeridaImpl instance) =>
    <String, dynamic>{
      'granulacao': instance.granulacao,
      'fibrina': instance.fibrina,
      'necrose': instance.necrose,
      'epitelizacao': instance.epitelizacao,
      'outros': instance.outros,
    };
