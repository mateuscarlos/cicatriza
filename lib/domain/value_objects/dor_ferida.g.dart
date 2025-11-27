// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dor_ferida.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DorFeridaImpl _$$DorFeridaImplFromJson(
  Map<String, dynamic> json,
) => _$DorFeridaImpl(
  intensidade: (json['intensidade'] as num?)?.toInt() ?? 0,
  tipo: $enumDecodeNullable(_$DorTipoEnumMap, json['tipo']) ?? DorTipo.ausente,
  localizacao: json['localizacao'] as String?,
);

Map<String, dynamic> _$$DorFeridaImplToJson(_$DorFeridaImpl instance) =>
    <String, dynamic>{
      'intensidade': instance.intensidade,
      'tipo': _$DorTipoEnumMap[instance.tipo]!,
      'localizacao': instance.localizacao,
    };

const _$DorTipoEnumMap = {
  DorTipo.ausente: 'AUSENTE',
  DorTipo.leve: 'LEVE',
  DorTipo.moderada: 'MODERADA',
  DorTipo.intensa: 'INTENSA',
  DorTipo.insuportavel: 'INSUPORTAVEL',
};
