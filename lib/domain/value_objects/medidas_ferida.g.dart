// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medidas_ferida.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedidasFeridaImpl _$$MedidasFeridaImplFromJson(Map<String, dynamic> json) =>
    _$MedidasFeridaImpl(
      comprimento: (json['comprimento'] as num).toDouble(),
      largura: (json['largura'] as num).toDouble(),
      profundidade: (json['profundidade'] as num?)?.toDouble(),
      area: (json['area'] as num?)?.toDouble(),
      volume: (json['volume'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MedidasFeridaImplToJson(_$MedidasFeridaImpl instance) =>
    <String, dynamic>{
      'comprimento': instance.comprimento,
      'largura': instance.largura,
      'profundidade': instance.profundidade,
      'area': instance.area,
      'volume': instance.volume,
    };
