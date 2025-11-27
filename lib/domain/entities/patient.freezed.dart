// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return _Patient.fromJson(json);
}

/// @nodoc
mixin _$Patient {
  // Campos básicos obrigatórios
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get pacienteId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get birthDate => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get nameLowercase => throw _privateConstructorUsedError;
  Consentimentos get consentimentos => throw _privateConstructorUsedError;
  StatusPaciente get status => throw _privateConstructorUsedError;
  int get versao =>
      throw _privateConstructorUsedError; // Campos básicos opcionais
  bool get archived => throw _privateConstructorUsedError;
  String? get identificador => throw _privateConstructorUsedError;
  String? get nomeSocial => throw _privateConstructorUsedError;
  int? get idade => throw _privateConstructorUsedError;
  Sexo? get sexo => throw _privateConstructorUsedError;
  String? get genero => throw _privateConstructorUsedError;
  String? get cpfOuId => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // Dados de contato e endereço
  ContatoEmergencia? get contatoEmergencia =>
      throw _privateConstructorUsedError;
  Endereco? get endereco =>
      throw _privateConstructorUsedError; // Dados clínicos
  List<String> get alergias => throw _privateConstructorUsedError;
  List<MedicacaoAtual> get medicacoesAtuais =>
      throw _privateConstructorUsedError;
  List<String> get comorbidades => throw _privateConstructorUsedError;
  List<CirurgiaPrevias> get cirurgiasPrevias =>
      throw _privateConstructorUsedError;
  List<Vacina> get vacinas => throw _privateConstructorUsedError;
  EstadoNutricional? get estadoNutricional =>
      throw _privateConstructorUsedError;
  Habitos? get habitos => throw _privateConstructorUsedError;
  Mobilidade? get mobilidade => throw _privateConstructorUsedError;
  List<String> get tags =>
      throw _privateConstructorUsedError; // Dados de risco e avaliações clínicas (opcionais)
  RiscoPressao? get riscoPressao => throw _privateConstructorUsedError;
  RiscoInfeccao? get riscosInfeccao => throw _privateConstructorUsedError;
  DorCronica? get dorCronica => throw _privateConstructorUsedError;
  PerfilPele? get pele => throw _privateConstructorUsedError;
  PerfilVascular? get vascular => throw _privateConstructorUsedError;
  ResponsavelLegal? get responsavelLegal => throw _privateConstructorUsedError;
  PreferenciasComunicacao? get preferenciasComunicacao =>
      throw _privateConstructorUsedError; // Metadados
  List<FotoPerfil> get fotosPerfil => throw _privateConstructorUsedError;

  /// Serializes this Patient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientCopyWith<Patient> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientCopyWith<$Res> {
  factory $PatientCopyWith(Patient value, $Res Function(Patient) then) =
      _$PatientCopyWithImpl<$Res, Patient>;
  @useResult
  $Res call({
    String id,
    String ownerId,
    String pacienteId,
    String name,
    @TimestampConverter() DateTime birthDate,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    String nameLowercase,
    Consentimentos consentimentos,
    StatusPaciente status,
    int versao,
    bool archived,
    String? identificador,
    String? nomeSocial,
    int? idade,
    Sexo? sexo,
    String? genero,
    String? cpfOuId,
    String? email,
    String? phone,
    String? notes,
    ContatoEmergencia? contatoEmergencia,
    Endereco? endereco,
    List<String> alergias,
    List<MedicacaoAtual> medicacoesAtuais,
    List<String> comorbidades,
    List<CirurgiaPrevias> cirurgiasPrevias,
    List<Vacina> vacinas,
    EstadoNutricional? estadoNutricional,
    Habitos? habitos,
    Mobilidade? mobilidade,
    List<String> tags,
    RiscoPressao? riscoPressao,
    RiscoInfeccao? riscosInfeccao,
    DorCronica? dorCronica,
    PerfilPele? pele,
    PerfilVascular? vascular,
    ResponsavelLegal? responsavelLegal,
    PreferenciasComunicacao? preferenciasComunicacao,
    List<FotoPerfil> fotosPerfil,
  });
}

/// @nodoc
class _$PatientCopyWithImpl<$Res, $Val extends Patient>
    implements $PatientCopyWith<$Res> {
  _$PatientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? pacienteId = null,
    Object? name = null,
    Object? birthDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? nameLowercase = null,
    Object? consentimentos = null,
    Object? status = null,
    Object? versao = null,
    Object? archived = null,
    Object? identificador = freezed,
    Object? nomeSocial = freezed,
    Object? idade = freezed,
    Object? sexo = freezed,
    Object? genero = freezed,
    Object? cpfOuId = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? notes = freezed,
    Object? contatoEmergencia = freezed,
    Object? endereco = freezed,
    Object? alergias = null,
    Object? medicacoesAtuais = null,
    Object? comorbidades = null,
    Object? cirurgiasPrevias = null,
    Object? vacinas = null,
    Object? estadoNutricional = freezed,
    Object? habitos = freezed,
    Object? mobilidade = freezed,
    Object? tags = null,
    Object? riscoPressao = freezed,
    Object? riscosInfeccao = freezed,
    Object? dorCronica = freezed,
    Object? pele = freezed,
    Object? vascular = freezed,
    Object? responsavelLegal = freezed,
    Object? preferenciasComunicacao = freezed,
    Object? fotosPerfil = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            pacienteId: null == pacienteId
                ? _value.pacienteId
                : pacienteId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            birthDate: null == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            nameLowercase: null == nameLowercase
                ? _value.nameLowercase
                : nameLowercase // ignore: cast_nullable_to_non_nullable
                      as String,
            consentimentos: null == consentimentos
                ? _value.consentimentos
                : consentimentos // ignore: cast_nullable_to_non_nullable
                      as Consentimentos,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as StatusPaciente,
            versao: null == versao
                ? _value.versao
                : versao // ignore: cast_nullable_to_non_nullable
                      as int,
            archived: null == archived
                ? _value.archived
                : archived // ignore: cast_nullable_to_non_nullable
                      as bool,
            identificador: freezed == identificador
                ? _value.identificador
                : identificador // ignore: cast_nullable_to_non_nullable
                      as String?,
            nomeSocial: freezed == nomeSocial
                ? _value.nomeSocial
                : nomeSocial // ignore: cast_nullable_to_non_nullable
                      as String?,
            idade: freezed == idade
                ? _value.idade
                : idade // ignore: cast_nullable_to_non_nullable
                      as int?,
            sexo: freezed == sexo
                ? _value.sexo
                : sexo // ignore: cast_nullable_to_non_nullable
                      as Sexo?,
            genero: freezed == genero
                ? _value.genero
                : genero // ignore: cast_nullable_to_non_nullable
                      as String?,
            cpfOuId: freezed == cpfOuId
                ? _value.cpfOuId
                : cpfOuId // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            contatoEmergencia: freezed == contatoEmergencia
                ? _value.contatoEmergencia
                : contatoEmergencia // ignore: cast_nullable_to_non_nullable
                      as ContatoEmergencia?,
            endereco: freezed == endereco
                ? _value.endereco
                : endereco // ignore: cast_nullable_to_non_nullable
                      as Endereco?,
            alergias: null == alergias
                ? _value.alergias
                : alergias // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            medicacoesAtuais: null == medicacoesAtuais
                ? _value.medicacoesAtuais
                : medicacoesAtuais // ignore: cast_nullable_to_non_nullable
                      as List<MedicacaoAtual>,
            comorbidades: null == comorbidades
                ? _value.comorbidades
                : comorbidades // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            cirurgiasPrevias: null == cirurgiasPrevias
                ? _value.cirurgiasPrevias
                : cirurgiasPrevias // ignore: cast_nullable_to_non_nullable
                      as List<CirurgiaPrevias>,
            vacinas: null == vacinas
                ? _value.vacinas
                : vacinas // ignore: cast_nullable_to_non_nullable
                      as List<Vacina>,
            estadoNutricional: freezed == estadoNutricional
                ? _value.estadoNutricional
                : estadoNutricional // ignore: cast_nullable_to_non_nullable
                      as EstadoNutricional?,
            habitos: freezed == habitos
                ? _value.habitos
                : habitos // ignore: cast_nullable_to_non_nullable
                      as Habitos?,
            mobilidade: freezed == mobilidade
                ? _value.mobilidade
                : mobilidade // ignore: cast_nullable_to_non_nullable
                      as Mobilidade?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            riscoPressao: freezed == riscoPressao
                ? _value.riscoPressao
                : riscoPressao // ignore: cast_nullable_to_non_nullable
                      as RiscoPressao?,
            riscosInfeccao: freezed == riscosInfeccao
                ? _value.riscosInfeccao
                : riscosInfeccao // ignore: cast_nullable_to_non_nullable
                      as RiscoInfeccao?,
            dorCronica: freezed == dorCronica
                ? _value.dorCronica
                : dorCronica // ignore: cast_nullable_to_non_nullable
                      as DorCronica?,
            pele: freezed == pele
                ? _value.pele
                : pele // ignore: cast_nullable_to_non_nullable
                      as PerfilPele?,
            vascular: freezed == vascular
                ? _value.vascular
                : vascular // ignore: cast_nullable_to_non_nullable
                      as PerfilVascular?,
            responsavelLegal: freezed == responsavelLegal
                ? _value.responsavelLegal
                : responsavelLegal // ignore: cast_nullable_to_non_nullable
                      as ResponsavelLegal?,
            preferenciasComunicacao: freezed == preferenciasComunicacao
                ? _value.preferenciasComunicacao
                : preferenciasComunicacao // ignore: cast_nullable_to_non_nullable
                      as PreferenciasComunicacao?,
            fotosPerfil: null == fotosPerfil
                ? _value.fotosPerfil
                : fotosPerfil // ignore: cast_nullable_to_non_nullable
                      as List<FotoPerfil>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PatientImplCopyWith<$Res> implements $PatientCopyWith<$Res> {
  factory _$$PatientImplCopyWith(
    _$PatientImpl value,
    $Res Function(_$PatientImpl) then,
  ) = __$$PatientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ownerId,
    String pacienteId,
    String name,
    @TimestampConverter() DateTime birthDate,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    String nameLowercase,
    Consentimentos consentimentos,
    StatusPaciente status,
    int versao,
    bool archived,
    String? identificador,
    String? nomeSocial,
    int? idade,
    Sexo? sexo,
    String? genero,
    String? cpfOuId,
    String? email,
    String? phone,
    String? notes,
    ContatoEmergencia? contatoEmergencia,
    Endereco? endereco,
    List<String> alergias,
    List<MedicacaoAtual> medicacoesAtuais,
    List<String> comorbidades,
    List<CirurgiaPrevias> cirurgiasPrevias,
    List<Vacina> vacinas,
    EstadoNutricional? estadoNutricional,
    Habitos? habitos,
    Mobilidade? mobilidade,
    List<String> tags,
    RiscoPressao? riscoPressao,
    RiscoInfeccao? riscosInfeccao,
    DorCronica? dorCronica,
    PerfilPele? pele,
    PerfilVascular? vascular,
    ResponsavelLegal? responsavelLegal,
    PreferenciasComunicacao? preferenciasComunicacao,
    List<FotoPerfil> fotosPerfil,
  });
}

/// @nodoc
class __$$PatientImplCopyWithImpl<$Res>
    extends _$PatientCopyWithImpl<$Res, _$PatientImpl>
    implements _$$PatientImplCopyWith<$Res> {
  __$$PatientImplCopyWithImpl(
    _$PatientImpl _value,
    $Res Function(_$PatientImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? pacienteId = null,
    Object? name = null,
    Object? birthDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? nameLowercase = null,
    Object? consentimentos = null,
    Object? status = null,
    Object? versao = null,
    Object? archived = null,
    Object? identificador = freezed,
    Object? nomeSocial = freezed,
    Object? idade = freezed,
    Object? sexo = freezed,
    Object? genero = freezed,
    Object? cpfOuId = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? notes = freezed,
    Object? contatoEmergencia = freezed,
    Object? endereco = freezed,
    Object? alergias = null,
    Object? medicacoesAtuais = null,
    Object? comorbidades = null,
    Object? cirurgiasPrevias = null,
    Object? vacinas = null,
    Object? estadoNutricional = freezed,
    Object? habitos = freezed,
    Object? mobilidade = freezed,
    Object? tags = null,
    Object? riscoPressao = freezed,
    Object? riscosInfeccao = freezed,
    Object? dorCronica = freezed,
    Object? pele = freezed,
    Object? vascular = freezed,
    Object? responsavelLegal = freezed,
    Object? preferenciasComunicacao = freezed,
    Object? fotosPerfil = null,
  }) {
    return _then(
      _$PatientImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        pacienteId: null == pacienteId
            ? _value.pacienteId
            : pacienteId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        birthDate: null == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        nameLowercase: null == nameLowercase
            ? _value.nameLowercase
            : nameLowercase // ignore: cast_nullable_to_non_nullable
                  as String,
        consentimentos: null == consentimentos
            ? _value.consentimentos
            : consentimentos // ignore: cast_nullable_to_non_nullable
                  as Consentimentos,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as StatusPaciente,
        versao: null == versao
            ? _value.versao
            : versao // ignore: cast_nullable_to_non_nullable
                  as int,
        archived: null == archived
            ? _value.archived
            : archived // ignore: cast_nullable_to_non_nullable
                  as bool,
        identificador: freezed == identificador
            ? _value.identificador
            : identificador // ignore: cast_nullable_to_non_nullable
                  as String?,
        nomeSocial: freezed == nomeSocial
            ? _value.nomeSocial
            : nomeSocial // ignore: cast_nullable_to_non_nullable
                  as String?,
        idade: freezed == idade
            ? _value.idade
            : idade // ignore: cast_nullable_to_non_nullable
                  as int?,
        sexo: freezed == sexo
            ? _value.sexo
            : sexo // ignore: cast_nullable_to_non_nullable
                  as Sexo?,
        genero: freezed == genero
            ? _value.genero
            : genero // ignore: cast_nullable_to_non_nullable
                  as String?,
        cpfOuId: freezed == cpfOuId
            ? _value.cpfOuId
            : cpfOuId // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        contatoEmergencia: freezed == contatoEmergencia
            ? _value.contatoEmergencia
            : contatoEmergencia // ignore: cast_nullable_to_non_nullable
                  as ContatoEmergencia?,
        endereco: freezed == endereco
            ? _value.endereco
            : endereco // ignore: cast_nullable_to_non_nullable
                  as Endereco?,
        alergias: null == alergias
            ? _value._alergias
            : alergias // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        medicacoesAtuais: null == medicacoesAtuais
            ? _value._medicacoesAtuais
            : medicacoesAtuais // ignore: cast_nullable_to_non_nullable
                  as List<MedicacaoAtual>,
        comorbidades: null == comorbidades
            ? _value._comorbidades
            : comorbidades // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        cirurgiasPrevias: null == cirurgiasPrevias
            ? _value._cirurgiasPrevias
            : cirurgiasPrevias // ignore: cast_nullable_to_non_nullable
                  as List<CirurgiaPrevias>,
        vacinas: null == vacinas
            ? _value._vacinas
            : vacinas // ignore: cast_nullable_to_non_nullable
                  as List<Vacina>,
        estadoNutricional: freezed == estadoNutricional
            ? _value.estadoNutricional
            : estadoNutricional // ignore: cast_nullable_to_non_nullable
                  as EstadoNutricional?,
        habitos: freezed == habitos
            ? _value.habitos
            : habitos // ignore: cast_nullable_to_non_nullable
                  as Habitos?,
        mobilidade: freezed == mobilidade
            ? _value.mobilidade
            : mobilidade // ignore: cast_nullable_to_non_nullable
                  as Mobilidade?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        riscoPressao: freezed == riscoPressao
            ? _value.riscoPressao
            : riscoPressao // ignore: cast_nullable_to_non_nullable
                  as RiscoPressao?,
        riscosInfeccao: freezed == riscosInfeccao
            ? _value.riscosInfeccao
            : riscosInfeccao // ignore: cast_nullable_to_non_nullable
                  as RiscoInfeccao?,
        dorCronica: freezed == dorCronica
            ? _value.dorCronica
            : dorCronica // ignore: cast_nullable_to_non_nullable
                  as DorCronica?,
        pele: freezed == pele
            ? _value.pele
            : pele // ignore: cast_nullable_to_non_nullable
                  as PerfilPele?,
        vascular: freezed == vascular
            ? _value.vascular
            : vascular // ignore: cast_nullable_to_non_nullable
                  as PerfilVascular?,
        responsavelLegal: freezed == responsavelLegal
            ? _value.responsavelLegal
            : responsavelLegal // ignore: cast_nullable_to_non_nullable
                  as ResponsavelLegal?,
        preferenciasComunicacao: freezed == preferenciasComunicacao
            ? _value.preferenciasComunicacao
            : preferenciasComunicacao // ignore: cast_nullable_to_non_nullable
                  as PreferenciasComunicacao?,
        fotosPerfil: null == fotosPerfil
            ? _value._fotosPerfil
            : fotosPerfil // ignore: cast_nullable_to_non_nullable
                  as List<FotoPerfil>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientImpl extends _Patient {
  const _$PatientImpl({
    required this.id,
    required this.ownerId,
    required this.pacienteId,
    required this.name,
    @TimestampConverter() required this.birthDate,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
    required this.nameLowercase,
    required this.consentimentos,
    required this.status,
    required this.versao,
    this.archived = false,
    this.identificador,
    this.nomeSocial,
    this.idade,
    this.sexo,
    this.genero,
    this.cpfOuId,
    this.email,
    this.phone,
    this.notes,
    this.contatoEmergencia,
    this.endereco,
    final List<String> alergias = const [],
    final List<MedicacaoAtual> medicacoesAtuais = const [],
    final List<String> comorbidades = const [],
    final List<CirurgiaPrevias> cirurgiasPrevias = const [],
    final List<Vacina> vacinas = const [],
    this.estadoNutricional,
    this.habitos,
    this.mobilidade,
    final List<String> tags = const [],
    this.riscoPressao,
    this.riscosInfeccao,
    this.dorCronica,
    this.pele,
    this.vascular,
    this.responsavelLegal,
    this.preferenciasComunicacao,
    final List<FotoPerfil> fotosPerfil = const [],
  }) : _alergias = alergias,
       _medicacoesAtuais = medicacoesAtuais,
       _comorbidades = comorbidades,
       _cirurgiasPrevias = cirurgiasPrevias,
       _vacinas = vacinas,
       _tags = tags,
       _fotosPerfil = fotosPerfil,
       super._();

  factory _$PatientImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientImplFromJson(json);

  // Campos básicos obrigatórios
  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String pacienteId;
  @override
  final String name;
  @override
  @TimestampConverter()
  final DateTime birthDate;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  final String nameLowercase;
  @override
  final Consentimentos consentimentos;
  @override
  final StatusPaciente status;
  @override
  final int versao;
  // Campos básicos opcionais
  @override
  @JsonKey()
  final bool archived;
  @override
  final String? identificador;
  @override
  final String? nomeSocial;
  @override
  final int? idade;
  @override
  final Sexo? sexo;
  @override
  final String? genero;
  @override
  final String? cpfOuId;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? notes;
  // Dados de contato e endereço
  @override
  final ContatoEmergencia? contatoEmergencia;
  @override
  final Endereco? endereco;
  // Dados clínicos
  final List<String> _alergias;
  // Dados clínicos
  @override
  @JsonKey()
  List<String> get alergias {
    if (_alergias is EqualUnmodifiableListView) return _alergias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alergias);
  }

  final List<MedicacaoAtual> _medicacoesAtuais;
  @override
  @JsonKey()
  List<MedicacaoAtual> get medicacoesAtuais {
    if (_medicacoesAtuais is EqualUnmodifiableListView)
      return _medicacoesAtuais;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicacoesAtuais);
  }

  final List<String> _comorbidades;
  @override
  @JsonKey()
  List<String> get comorbidades {
    if (_comorbidades is EqualUnmodifiableListView) return _comorbidades;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comorbidades);
  }

  final List<CirurgiaPrevias> _cirurgiasPrevias;
  @override
  @JsonKey()
  List<CirurgiaPrevias> get cirurgiasPrevias {
    if (_cirurgiasPrevias is EqualUnmodifiableListView)
      return _cirurgiasPrevias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cirurgiasPrevias);
  }

  final List<Vacina> _vacinas;
  @override
  @JsonKey()
  List<Vacina> get vacinas {
    if (_vacinas is EqualUnmodifiableListView) return _vacinas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vacinas);
  }

  @override
  final EstadoNutricional? estadoNutricional;
  @override
  final Habitos? habitos;
  @override
  final Mobilidade? mobilidade;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  // Dados de risco e avaliações clínicas (opcionais)
  @override
  final RiscoPressao? riscoPressao;
  @override
  final RiscoInfeccao? riscosInfeccao;
  @override
  final DorCronica? dorCronica;
  @override
  final PerfilPele? pele;
  @override
  final PerfilVascular? vascular;
  @override
  final ResponsavelLegal? responsavelLegal;
  @override
  final PreferenciasComunicacao? preferenciasComunicacao;
  // Metadados
  final List<FotoPerfil> _fotosPerfil;
  // Metadados
  @override
  @JsonKey()
  List<FotoPerfil> get fotosPerfil {
    if (_fotosPerfil is EqualUnmodifiableListView) return _fotosPerfil;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotosPerfil);
  }

  @override
  String toString() {
    return 'Patient(id: $id, ownerId: $ownerId, pacienteId: $pacienteId, name: $name, birthDate: $birthDate, createdAt: $createdAt, updatedAt: $updatedAt, nameLowercase: $nameLowercase, consentimentos: $consentimentos, status: $status, versao: $versao, archived: $archived, identificador: $identificador, nomeSocial: $nomeSocial, idade: $idade, sexo: $sexo, genero: $genero, cpfOuId: $cpfOuId, email: $email, phone: $phone, notes: $notes, contatoEmergencia: $contatoEmergencia, endereco: $endereco, alergias: $alergias, medicacoesAtuais: $medicacoesAtuais, comorbidades: $comorbidades, cirurgiasPrevias: $cirurgiasPrevias, vacinas: $vacinas, estadoNutricional: $estadoNutricional, habitos: $habitos, mobilidade: $mobilidade, tags: $tags, riscoPressao: $riscoPressao, riscosInfeccao: $riscosInfeccao, dorCronica: $dorCronica, pele: $pele, vascular: $vascular, responsavelLegal: $responsavelLegal, preferenciasComunicacao: $preferenciasComunicacao, fotosPerfil: $fotosPerfil)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.pacienteId, pacienteId) ||
                other.pacienteId == pacienteId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.nameLowercase, nameLowercase) ||
                other.nameLowercase == nameLowercase) &&
            (identical(other.consentimentos, consentimentos) ||
                other.consentimentos == consentimentos) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.versao, versao) || other.versao == versao) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            (identical(other.identificador, identificador) ||
                other.identificador == identificador) &&
            (identical(other.nomeSocial, nomeSocial) ||
                other.nomeSocial == nomeSocial) &&
            (identical(other.idade, idade) || other.idade == idade) &&
            (identical(other.sexo, sexo) || other.sexo == sexo) &&
            (identical(other.genero, genero) || other.genero == genero) &&
            (identical(other.cpfOuId, cpfOuId) || other.cpfOuId == cpfOuId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.contatoEmergencia, contatoEmergencia) ||
                other.contatoEmergencia == contatoEmergencia) &&
            (identical(other.endereco, endereco) ||
                other.endereco == endereco) &&
            const DeepCollectionEquality().equals(other._alergias, _alergias) &&
            const DeepCollectionEquality().equals(
              other._medicacoesAtuais,
              _medicacoesAtuais,
            ) &&
            const DeepCollectionEquality().equals(
              other._comorbidades,
              _comorbidades,
            ) &&
            const DeepCollectionEquality().equals(
              other._cirurgiasPrevias,
              _cirurgiasPrevias,
            ) &&
            const DeepCollectionEquality().equals(other._vacinas, _vacinas) &&
            (identical(other.estadoNutricional, estadoNutricional) ||
                other.estadoNutricional == estadoNutricional) &&
            (identical(other.habitos, habitos) || other.habitos == habitos) &&
            (identical(other.mobilidade, mobilidade) ||
                other.mobilidade == mobilidade) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.riscoPressao, riscoPressao) ||
                other.riscoPressao == riscoPressao) &&
            (identical(other.riscosInfeccao, riscosInfeccao) ||
                other.riscosInfeccao == riscosInfeccao) &&
            (identical(other.dorCronica, dorCronica) ||
                other.dorCronica == dorCronica) &&
            (identical(other.pele, pele) || other.pele == pele) &&
            (identical(other.vascular, vascular) ||
                other.vascular == vascular) &&
            (identical(other.responsavelLegal, responsavelLegal) ||
                other.responsavelLegal == responsavelLegal) &&
            (identical(
                  other.preferenciasComunicacao,
                  preferenciasComunicacao,
                ) ||
                other.preferenciasComunicacao == preferenciasComunicacao) &&
            const DeepCollectionEquality().equals(
              other._fotosPerfil,
              _fotosPerfil,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    ownerId,
    pacienteId,
    name,
    birthDate,
    createdAt,
    updatedAt,
    nameLowercase,
    consentimentos,
    status,
    versao,
    archived,
    identificador,
    nomeSocial,
    idade,
    sexo,
    genero,
    cpfOuId,
    email,
    phone,
    notes,
    contatoEmergencia,
    endereco,
    const DeepCollectionEquality().hash(_alergias),
    const DeepCollectionEquality().hash(_medicacoesAtuais),
    const DeepCollectionEquality().hash(_comorbidades),
    const DeepCollectionEquality().hash(_cirurgiasPrevias),
    const DeepCollectionEquality().hash(_vacinas),
    estadoNutricional,
    habitos,
    mobilidade,
    const DeepCollectionEquality().hash(_tags),
    riscoPressao,
    riscosInfeccao,
    dorCronica,
    pele,
    vascular,
    responsavelLegal,
    preferenciasComunicacao,
    const DeepCollectionEquality().hash(_fotosPerfil),
  ]);

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      __$$PatientImplCopyWithImpl<_$PatientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientImplToJson(this);
  }
}

abstract class _Patient extends Patient {
  const factory _Patient({
    required final String id,
    required final String ownerId,
    required final String pacienteId,
    required final String name,
    @TimestampConverter() required final DateTime birthDate,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
    required final String nameLowercase,
    required final Consentimentos consentimentos,
    required final StatusPaciente status,
    required final int versao,
    final bool archived,
    final String? identificador,
    final String? nomeSocial,
    final int? idade,
    final Sexo? sexo,
    final String? genero,
    final String? cpfOuId,
    final String? email,
    final String? phone,
    final String? notes,
    final ContatoEmergencia? contatoEmergencia,
    final Endereco? endereco,
    final List<String> alergias,
    final List<MedicacaoAtual> medicacoesAtuais,
    final List<String> comorbidades,
    final List<CirurgiaPrevias> cirurgiasPrevias,
    final List<Vacina> vacinas,
    final EstadoNutricional? estadoNutricional,
    final Habitos? habitos,
    final Mobilidade? mobilidade,
    final List<String> tags,
    final RiscoPressao? riscoPressao,
    final RiscoInfeccao? riscosInfeccao,
    final DorCronica? dorCronica,
    final PerfilPele? pele,
    final PerfilVascular? vascular,
    final ResponsavelLegal? responsavelLegal,
    final PreferenciasComunicacao? preferenciasComunicacao,
    final List<FotoPerfil> fotosPerfil,
  }) = _$PatientImpl;
  const _Patient._() : super._();

  factory _Patient.fromJson(Map<String, dynamic> json) = _$PatientImpl.fromJson;

  // Campos básicos obrigatórios
  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get pacienteId;
  @override
  String get name;
  @override
  @TimestampConverter()
  DateTime get birthDate;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  String get nameLowercase;
  @override
  Consentimentos get consentimentos;
  @override
  StatusPaciente get status;
  @override
  int get versao; // Campos básicos opcionais
  @override
  bool get archived;
  @override
  String? get identificador;
  @override
  String? get nomeSocial;
  @override
  int? get idade;
  @override
  Sexo? get sexo;
  @override
  String? get genero;
  @override
  String? get cpfOuId;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get notes; // Dados de contato e endereço
  @override
  ContatoEmergencia? get contatoEmergencia;
  @override
  Endereco? get endereco; // Dados clínicos
  @override
  List<String> get alergias;
  @override
  List<MedicacaoAtual> get medicacoesAtuais;
  @override
  List<String> get comorbidades;
  @override
  List<CirurgiaPrevias> get cirurgiasPrevias;
  @override
  List<Vacina> get vacinas;
  @override
  EstadoNutricional? get estadoNutricional;
  @override
  Habitos? get habitos;
  @override
  Mobilidade? get mobilidade;
  @override
  List<String> get tags; // Dados de risco e avaliações clínicas (opcionais)
  @override
  RiscoPressao? get riscoPressao;
  @override
  RiscoInfeccao? get riscosInfeccao;
  @override
  DorCronica? get dorCronica;
  @override
  PerfilPele? get pele;
  @override
  PerfilVascular? get vascular;
  @override
  ResponsavelLegal? get responsavelLegal;
  @override
  PreferenciasComunicacao? get preferenciasComunicacao; // Metadados
  @override
  List<FotoPerfil> get fotosPerfil;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
