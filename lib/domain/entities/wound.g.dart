// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wound.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WoundImpl _$$WoundImplFromJson(Map<String, dynamic> json) => _$WoundImpl(
  id: json['id'] as String,
  patientId: json['patientId'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$WoundTypeEnumMap, json['type']),
  location: $enumDecode(_$WoundLocationEnumMap, json['location']),
  status: $enumDecode(_$WoundStatusEnumMap, json['status']),
  identificationDate: const TimestampConverter().fromJson(
    json['identificationDate'] as Object,
  ),
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
  healedDate: json['healedDate'] == null
      ? null
      : DateTime.parse(json['healedDate'] as String),
  notes: json['notes'] as String?,
  archived: json['archived'] as bool? ?? false,
);

Map<String, dynamic> _$$WoundImplToJson(_$WoundImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'description': instance.description,
      'type': _$WoundTypeEnumMap[instance.type]!,
      'location': _$WoundLocationEnumMap[instance.location]!,
      'status': _$WoundStatusEnumMap[instance.status]!,
      'identificationDate': const TimestampConverter().toJson(
        instance.identificationDate,
      ),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
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

const _$WoundStatusEnumMap = {
  WoundStatus.ativa: 'ATIVA',
  WoundStatus.emCicatrizacao: 'EM_CICATRIZACAO',
  WoundStatus.cicatrizada: 'CICATRIZADA',
  WoundStatus.infectada: 'INFECTADA',
  WoundStatus.complicada: 'COMPLICADA',
};
