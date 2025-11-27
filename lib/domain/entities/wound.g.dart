// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wound.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WoundImpl _$$WoundImplFromJson(Map<String, dynamic> json) => _$WoundImpl(
  feridaId: json['feridaId'] as String,
  patientId: json['patientId'] as String,
  ownerId: json['ownerId'] as String,
  type: $enumDecode(_$WoundTypeEnumMap, json['type']),
  localizacao: json['localizacao'] as String,
  status: $enumDecode(_$WoundStatusEnumMap, json['status']),
  criadoEm: const TimestampConverter().fromJson(json['criadoEm'] as Object),
  atualizadoEm: const TimestampConverter().fromJson(
    json['atualizadoEm'] as Object,
  ),
  inicio: _$JsonConverterFromJson<Object, DateTime>(
    json['inicio'],
    const TimestampConverter().fromJson,
  ),
  etiologia: json['etiologia'] as String?,
  ultimaAvaliacaoEm: _$JsonConverterFromJson<Object, DateTime>(
    json['ultimaAvaliacaoEm'],
    const TimestampConverter().fromJson,
  ),
  contagemAvaliacoes: (json['contagemAvaliacoes'] as num?)?.toInt() ?? 0,
  id: json['id'] as String?,
  location: $enumDecodeNullable(_$WoundLocationEnumMap, json['location']),
  identificationDate: json['identificationDate'] == null
      ? null
      : DateTime.parse(json['identificationDate'] as String),
  description: json['description'] as String?,
  healedDate: json['healedDate'] == null
      ? null
      : DateTime.parse(json['healedDate'] as String),
  notes: json['notes'] as String?,
  archived: json['archived'] as bool? ?? false,
);

Map<String, dynamic> _$$WoundImplToJson(_$WoundImpl instance) =>
    <String, dynamic>{
      'feridaId': instance.feridaId,
      'patientId': instance.patientId,
      'ownerId': instance.ownerId,
      'type': _$WoundTypeEnumMap[instance.type]!,
      'localizacao': instance.localizacao,
      'status': _$WoundStatusEnumMap[instance.status]!,
      'criadoEm': const TimestampConverter().toJson(instance.criadoEm),
      'atualizadoEm': const TimestampConverter().toJson(instance.atualizadoEm),
      'inicio': _$JsonConverterToJson<Object, DateTime>(
        instance.inicio,
        const TimestampConverter().toJson,
      ),
      'etiologia': instance.etiologia,
      'ultimaAvaliacaoEm': _$JsonConverterToJson<Object, DateTime>(
        instance.ultimaAvaliacaoEm,
        const TimestampConverter().toJson,
      ),
      'contagemAvaliacoes': instance.contagemAvaliacoes,
      'id': instance.id,
      'location': _$WoundLocationEnumMap[instance.location],
      'identificationDate': instance.identificationDate?.toIso8601String(),
      'description': instance.description,
      'healedDate': instance.healedDate?.toIso8601String(),
      'notes': instance.notes,
      'archived': instance.archived,
    };

const _$WoundTypeEnumMap = {
  WoundType.ulceraPressao: 'ULCERA_PRESSAO',
  WoundType.ulceraVenosa: 'ULCERA_VENOSA',
  WoundType.ulceraArterial: 'ULCERA_ARTERIAL',
  WoundType.peDiabetico: 'PE_DIABETICO',
  WoundType.queimadura: 'QUEIMADURA',
  WoundType.feridaCirurgica: 'FERIDA_CIRURGICA',
  WoundType.traumatica: 'TRAUMATICA',
  WoundType.outras: 'OUTRAS',
};

const _$WoundStatusEnumMap = {
  WoundStatus.ativa: 'ATIVA',
  WoundStatus.emCicatrizacao: 'EM_CICATRIZACAO',
  WoundStatus.cicatrizada: 'CICATRIZADA',
  WoundStatus.infectada: 'INFECTADA',
  WoundStatus.complicada: 'COMPLICADA',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$WoundLocationEnumMap = {
  WoundLocation.cabecaPescoco: 'CABECA_PESCOCO',
  WoundLocation.torax: 'TORAX',
  WoundLocation.abdomen: 'ABDOMEN',
  WoundLocation.bracos: 'BRACOS',
  WoundLocation.maos: 'MAOS',
  WoundLocation.costas: 'COSTAS',
  WoundLocation.quadrisNadegas: 'QUADRIS_NADEGAS',
  WoundLocation.genitais: 'GENITAIS',
  WoundLocation.coxas: 'COXAS',
  WoundLocation.joelhos: 'JOELHOS',
  WoundLocation.pernas: 'PERNAS',
  WoundLocation.tornozelos: 'TORNOZELOS',
  WoundLocation.pes: 'PES',
  WoundLocation.calcanhares: 'CALCANHARES',
  WoundLocation.sacro: 'SACRO',
  WoundLocation.outras: 'OUTRAS',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
