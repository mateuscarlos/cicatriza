// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exsudato_ferida.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExsudatoFeridaImpl _$$ExsudatoFeridaImplFromJson(Map<String, dynamic> json) =>
    _$ExsudatoFeridaImpl(
      tipo:
          $enumDecodeNullable(_$ExsudatoTipoEnumMap, json['tipo']) ??
          ExsudatoTipo.seroso,
      quantidade:
          $enumDecodeNullable(
            _$ExsudatoQuantidadeEnumMap,
            json['quantidade'],
          ) ??
          ExsudatoQuantidade.ausente,
      aspecto:
          $enumDecodeNullable(_$ExsudatoAspectoEnumMap, json['aspecto']) ??
          ExsudatoAspecto.claro,
      odor: json['odor'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExsudatoFeridaImplToJson(
  _$ExsudatoFeridaImpl instance,
) => <String, dynamic>{
  'tipo': _$ExsudatoTipoEnumMap[instance.tipo]!,
  'quantidade': _$ExsudatoQuantidadeEnumMap[instance.quantidade]!,
  'aspecto': _$ExsudatoAspectoEnumMap[instance.aspecto]!,
  'odor': instance.odor,
};

const _$ExsudatoTipoEnumMap = {
  ExsudatoTipo.seroso: 'SEROSO',
  ExsudatoTipo.seropurulento: 'SEROPURULENTO',
  ExsudatoTipo.purulento: 'PURULENTO',
  ExsudatoTipo.sanguinolento: 'SANGUINOLENTO',
  ExsudatoTipo.outro: 'OUTRO',
};

const _$ExsudatoQuantidadeEnumMap = {
  ExsudatoQuantidade.ausente: 'AUSENTE',
  ExsudatoQuantidade.pequena: 'PEQUENA',
  ExsudatoQuantidade.moderada: 'MODERADA',
  ExsudatoQuantidade.grande: 'GRANDE',
};

const _$ExsudatoAspectoEnumMap = {
  ExsudatoAspecto.claro: 'CLARO',
  ExsudatoAspecto.turvo: 'TURVO',
  ExsudatoAspecto.espesso: 'ESPESSO',
  ExsudatoAspecto.viscoso: 'VISCOSO',
};
