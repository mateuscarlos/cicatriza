// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientImpl _$$PatientImplFromJson(
  Map<String, dynamic> json,
) => _$PatientImpl(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  pacienteId: json['pacienteId'] as String,
  name: json['name'] as String,
  birthDate: const TimestampConverter().fromJson(json['birthDate'] as Object),
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
  nameLowercase: json['nameLowercase'] as String,
  consentimentos: Consentimentos.fromJson(
    json['consentimentos'] as Map<String, dynamic>,
  ),
  status: $enumDecode(_$StatusPacienteEnumMap, json['status']),
  versao: (json['versao'] as num).toInt(),
  archived: json['archived'] as bool? ?? false,
  identificador: json['identificador'] as String?,
  nomeSocial: json['nomeSocial'] as String?,
  idade: (json['idade'] as num?)?.toInt(),
  sexo: $enumDecodeNullable(_$SexoEnumMap, json['sexo']),
  genero: json['genero'] as String?,
  cpfOuId: json['cpfOuId'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  notes: json['notes'] as String?,
  contatoEmergencia: json['contatoEmergencia'] == null
      ? null
      : ContatoEmergencia.fromJson(
          json['contatoEmergencia'] as Map<String, dynamic>,
        ),
  endereco: json['endereco'] == null
      ? null
      : Endereco.fromJson(json['endereco'] as Map<String, dynamic>),
  alergias:
      (json['alergias'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  medicacoesAtuais:
      (json['medicacoesAtuais'] as List<dynamic>?)
          ?.map((e) => MedicacaoAtual.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  comorbidades:
      (json['comorbidades'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  cirurgiasPrevias:
      (json['cirurgiasPrevias'] as List<dynamic>?)
          ?.map((e) => CirurgiaPrevias.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  vacinas:
      (json['vacinas'] as List<dynamic>?)
          ?.map((e) => Vacina.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  estadoNutricional: json['estadoNutricional'] == null
      ? null
      : EstadoNutricional.fromJson(
          json['estadoNutricional'] as Map<String, dynamic>,
        ),
  habitos: json['habitos'] == null
      ? null
      : Habitos.fromJson(json['habitos'] as Map<String, dynamic>),
  mobilidade: $enumDecodeNullable(_$MobilidadeEnumMap, json['mobilidade']),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  riscoPressao: json['riscoPressao'] == null
      ? null
      : RiscoPressao.fromJson(json['riscoPressao'] as Map<String, dynamic>),
  riscosInfeccao: json['riscosInfeccao'] == null
      ? null
      : RiscoInfeccao.fromJson(json['riscosInfeccao'] as Map<String, dynamic>),
  dorCronica: json['dorCronica'] == null
      ? null
      : DorCronica.fromJson(json['dorCronica'] as Map<String, dynamic>),
  pele: json['pele'] == null
      ? null
      : PerfilPele.fromJson(json['pele'] as Map<String, dynamic>),
  vascular: json['vascular'] == null
      ? null
      : PerfilVascular.fromJson(json['vascular'] as Map<String, dynamic>),
  responsavelLegal: json['responsavelLegal'] == null
      ? null
      : ResponsavelLegal.fromJson(
          json['responsavelLegal'] as Map<String, dynamic>,
        ),
  preferenciasComunicacao: json['preferenciasComunicacao'] == null
      ? null
      : PreferenciasComunicacao.fromJson(
          json['preferenciasComunicacao'] as Map<String, dynamic>,
        ),
  fotosPerfil:
      (json['fotosPerfil'] as List<dynamic>?)
          ?.map((e) => FotoPerfil.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PatientImplToJson(_$PatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'pacienteId': instance.pacienteId,
      'name': instance.name,
      'birthDate': const TimestampConverter().toJson(instance.birthDate),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'nameLowercase': instance.nameLowercase,
      'consentimentos': instance.consentimentos,
      'status': _$StatusPacienteEnumMap[instance.status]!,
      'versao': instance.versao,
      'archived': instance.archived,
      'identificador': instance.identificador,
      'nomeSocial': instance.nomeSocial,
      'idade': instance.idade,
      'sexo': _$SexoEnumMap[instance.sexo],
      'genero': instance.genero,
      'cpfOuId': instance.cpfOuId,
      'email': instance.email,
      'phone': instance.phone,
      'notes': instance.notes,
      'contatoEmergencia': instance.contatoEmergencia,
      'endereco': instance.endereco,
      'alergias': instance.alergias,
      'medicacoesAtuais': instance.medicacoesAtuais,
      'comorbidades': instance.comorbidades,
      'cirurgiasPrevias': instance.cirurgiasPrevias,
      'vacinas': instance.vacinas,
      'estadoNutricional': instance.estadoNutricional,
      'habitos': instance.habitos,
      'mobilidade': _$MobilidadeEnumMap[instance.mobilidade],
      'tags': instance.tags,
      'riscoPressao': instance.riscoPressao,
      'riscosInfeccao': instance.riscosInfeccao,
      'dorCronica': instance.dorCronica,
      'pele': instance.pele,
      'vascular': instance.vascular,
      'responsavelLegal': instance.responsavelLegal,
      'preferenciasComunicacao': instance.preferenciasComunicacao,
      'fotosPerfil': instance.fotosPerfil,
    };

const _$StatusPacienteEnumMap = {
  StatusPaciente.ativo: 'ativo',
  StatusPaciente.inativo: 'inativo',
  StatusPaciente.transferido: 'transferido',
};

const _$SexoEnumMap = {
  Sexo.feminino: 'feminino',
  Sexo.masculino: 'masculino',
  Sexo.intersexo: 'intersexo',
  Sexo.naoInformado: 'naoInformado',
};

const _$MobilidadeEnumMap = {
  Mobilidade.independente: 'independente',
  Mobilidade.assistida: 'assistida',
  Mobilidade.restrita: 'restrita',
};
