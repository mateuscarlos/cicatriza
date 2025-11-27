// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wound.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Wound _$WoundFromJson(Map<String, dynamic> json) {
  return _Wound.fromJson(json);
}

/// @nodoc
mixin _$Wound {
  // Campos obrigatórios conforme nova estrutura
  String get feridaId => throw _privateConstructorUsedError;
  String get patientId => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  WoundType get type => throw _privateConstructorUsedError;
  String get localizacao => throw _privateConstructorUsedError;
  WoundStatus get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get criadoEm => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get atualizadoEm => throw _privateConstructorUsedError; // Campos opcionais
  @TimestampConverter()
  DateTime? get inicio => throw _privateConstructorUsedError;
  String? get etiologia => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get ultimaAvaliacaoEm => throw _privateConstructorUsedError;
  int get contagemAvaliacoes =>
      throw _privateConstructorUsedError; // Campos de compatibilidade com estrutura anterior (deprecated)
  @Deprecated('Use feridaId instead')
  String? get id => throw _privateConstructorUsedError;
  @Deprecated('Use localizacao instead')
  WoundLocation? get location => throw _privateConstructorUsedError;
  @Deprecated('Use inicio instead')
  DateTime? get identificationDate => throw _privateConstructorUsedError;
  @Deprecated('Use etiologia instead')
  String? get description => throw _privateConstructorUsedError;
  DateTime? get healedDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get archived => throw _privateConstructorUsedError;

  /// Serializes this Wound to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Wound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WoundCopyWith<Wound> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WoundCopyWith<$Res> {
  factory $WoundCopyWith(Wound value, $Res Function(Wound) then) =
      _$WoundCopyWithImpl<$Res, Wound>;
  @useResult
  $Res call({
    String feridaId,
    String patientId,
    String ownerId,
    WoundType type,
    String localizacao,
    WoundStatus status,
    @TimestampConverter() DateTime criadoEm,
    @TimestampConverter() DateTime atualizadoEm,
    @TimestampConverter() DateTime? inicio,
    String? etiologia,
    @TimestampConverter() DateTime? ultimaAvaliacaoEm,
    int contagemAvaliacoes,
    @Deprecated('Use feridaId instead') String? id,
    @Deprecated('Use localizacao instead') WoundLocation? location,
    @Deprecated('Use inicio instead') DateTime? identificationDate,
    @Deprecated('Use etiologia instead') String? description,
    DateTime? healedDate,
    String? notes,
    bool archived,
  });
}

/// @nodoc
class _$WoundCopyWithImpl<$Res, $Val extends Wound>
    implements $WoundCopyWith<$Res> {
  _$WoundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Wound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feridaId = null,
    Object? patientId = null,
    Object? ownerId = null,
    Object? type = null,
    Object? localizacao = null,
    Object? status = null,
    Object? criadoEm = null,
    Object? atualizadoEm = null,
    Object? inicio = freezed,
    Object? etiologia = freezed,
    Object? ultimaAvaliacaoEm = freezed,
    Object? contagemAvaliacoes = null,
    Object? id = freezed,
    Object? location = freezed,
    Object? identificationDate = freezed,
    Object? description = freezed,
    Object? healedDate = freezed,
    Object? notes = freezed,
    Object? archived = null,
  }) {
    return _then(
      _value.copyWith(
            feridaId: null == feridaId
                ? _value.feridaId
                : feridaId // ignore: cast_nullable_to_non_nullable
                      as String,
            patientId: null == patientId
                ? _value.patientId
                : patientId // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as WoundType,
            localizacao: null == localizacao
                ? _value.localizacao
                : localizacao // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as WoundStatus,
            criadoEm: null == criadoEm
                ? _value.criadoEm
                : criadoEm // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            atualizadoEm: null == atualizadoEm
                ? _value.atualizadoEm
                : atualizadoEm // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            inicio: freezed == inicio
                ? _value.inicio
                : inicio // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            etiologia: freezed == etiologia
                ? _value.etiologia
                : etiologia // ignore: cast_nullable_to_non_nullable
                      as String?,
            ultimaAvaliacaoEm: freezed == ultimaAvaliacaoEm
                ? _value.ultimaAvaliacaoEm
                : ultimaAvaliacaoEm // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            contagemAvaliacoes: null == contagemAvaliacoes
                ? _value.contagemAvaliacoes
                : contagemAvaliacoes // ignore: cast_nullable_to_non_nullable
                      as int,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as WoundLocation?,
            identificationDate: freezed == identificationDate
                ? _value.identificationDate
                : identificationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            healedDate: freezed == healedDate
                ? _value.healedDate
                : healedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            archived: null == archived
                ? _value.archived
                : archived // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WoundImplCopyWith<$Res> implements $WoundCopyWith<$Res> {
  factory _$$WoundImplCopyWith(
    _$WoundImpl value,
    $Res Function(_$WoundImpl) then,
  ) = __$$WoundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String feridaId,
    String patientId,
    String ownerId,
    WoundType type,
    String localizacao,
    WoundStatus status,
    @TimestampConverter() DateTime criadoEm,
    @TimestampConverter() DateTime atualizadoEm,
    @TimestampConverter() DateTime? inicio,
    String? etiologia,
    @TimestampConverter() DateTime? ultimaAvaliacaoEm,
    int contagemAvaliacoes,
    @Deprecated('Use feridaId instead') String? id,
    @Deprecated('Use localizacao instead') WoundLocation? location,
    @Deprecated('Use inicio instead') DateTime? identificationDate,
    @Deprecated('Use etiologia instead') String? description,
    DateTime? healedDate,
    String? notes,
    bool archived,
  });
}

/// @nodoc
class __$$WoundImplCopyWithImpl<$Res>
    extends _$WoundCopyWithImpl<$Res, _$WoundImpl>
    implements _$$WoundImplCopyWith<$Res> {
  __$$WoundImplCopyWithImpl(
    _$WoundImpl _value,
    $Res Function(_$WoundImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Wound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feridaId = null,
    Object? patientId = null,
    Object? ownerId = null,
    Object? type = null,
    Object? localizacao = null,
    Object? status = null,
    Object? criadoEm = null,
    Object? atualizadoEm = null,
    Object? inicio = freezed,
    Object? etiologia = freezed,
    Object? ultimaAvaliacaoEm = freezed,
    Object? contagemAvaliacoes = null,
    Object? id = freezed,
    Object? location = freezed,
    Object? identificationDate = freezed,
    Object? description = freezed,
    Object? healedDate = freezed,
    Object? notes = freezed,
    Object? archived = null,
  }) {
    return _then(
      _$WoundImpl(
        feridaId: null == feridaId
            ? _value.feridaId
            : feridaId // ignore: cast_nullable_to_non_nullable
                  as String,
        patientId: null == patientId
            ? _value.patientId
            : patientId // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as WoundType,
        localizacao: null == localizacao
            ? _value.localizacao
            : localizacao // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as WoundStatus,
        criadoEm: null == criadoEm
            ? _value.criadoEm
            : criadoEm // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        atualizadoEm: null == atualizadoEm
            ? _value.atualizadoEm
            : atualizadoEm // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        inicio: freezed == inicio
            ? _value.inicio
            : inicio // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        etiologia: freezed == etiologia
            ? _value.etiologia
            : etiologia // ignore: cast_nullable_to_non_nullable
                  as String?,
        ultimaAvaliacaoEm: freezed == ultimaAvaliacaoEm
            ? _value.ultimaAvaliacaoEm
            : ultimaAvaliacaoEm // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        contagemAvaliacoes: null == contagemAvaliacoes
            ? _value.contagemAvaliacoes
            : contagemAvaliacoes // ignore: cast_nullable_to_non_nullable
                  as int,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as WoundLocation?,
        identificationDate: freezed == identificationDate
            ? _value.identificationDate
            : identificationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        healedDate: freezed == healedDate
            ? _value.healedDate
            : healedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        archived: null == archived
            ? _value.archived
            : archived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WoundImpl extends _Wound {
  const _$WoundImpl({
    required this.feridaId,
    required this.patientId,
    required this.ownerId,
    required this.type,
    required this.localizacao,
    required this.status,
    @TimestampConverter() required this.criadoEm,
    @TimestampConverter() required this.atualizadoEm,
    @TimestampConverter() this.inicio,
    this.etiologia,
    @TimestampConverter() this.ultimaAvaliacaoEm,
    this.contagemAvaliacoes = 0,
    @Deprecated('Use feridaId instead') this.id,
    @Deprecated('Use localizacao instead') this.location,
    @Deprecated('Use inicio instead') this.identificationDate,
    @Deprecated('Use etiologia instead') this.description,
    this.healedDate,
    this.notes,
    this.archived = false,
  }) : super._();

  factory _$WoundImpl.fromJson(Map<String, dynamic> json) =>
      _$$WoundImplFromJson(json);

  // Campos obrigatórios conforme nova estrutura
  @override
  final String feridaId;
  @override
  final String patientId;
  @override
  final String ownerId;
  @override
  final WoundType type;
  @override
  final String localizacao;
  @override
  final WoundStatus status;
  @override
  @TimestampConverter()
  final DateTime criadoEm;
  @override
  @TimestampConverter()
  final DateTime atualizadoEm;
  // Campos opcionais
  @override
  @TimestampConverter()
  final DateTime? inicio;
  @override
  final String? etiologia;
  @override
  @TimestampConverter()
  final DateTime? ultimaAvaliacaoEm;
  @override
  @JsonKey()
  final int contagemAvaliacoes;
  // Campos de compatibilidade com estrutura anterior (deprecated)
  @override
  @Deprecated('Use feridaId instead')
  final String? id;
  @override
  @Deprecated('Use localizacao instead')
  final WoundLocation? location;
  @override
  @Deprecated('Use inicio instead')
  final DateTime? identificationDate;
  @override
  @Deprecated('Use etiologia instead')
  final String? description;
  @override
  final DateTime? healedDate;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool archived;

  @override
  String toString() {
    return 'Wound(feridaId: $feridaId, patientId: $patientId, ownerId: $ownerId, type: $type, localizacao: $localizacao, status: $status, criadoEm: $criadoEm, atualizadoEm: $atualizadoEm, inicio: $inicio, etiologia: $etiologia, ultimaAvaliacaoEm: $ultimaAvaliacaoEm, contagemAvaliacoes: $contagemAvaliacoes, id: $id, location: $location, identificationDate: $identificationDate, description: $description, healedDate: $healedDate, notes: $notes, archived: $archived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WoundImpl &&
            (identical(other.feridaId, feridaId) ||
                other.feridaId == feridaId) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.localizacao, localizacao) ||
                other.localizacao == localizacao) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.criadoEm, criadoEm) ||
                other.criadoEm == criadoEm) &&
            (identical(other.atualizadoEm, atualizadoEm) ||
                other.atualizadoEm == atualizadoEm) &&
            (identical(other.inicio, inicio) || other.inicio == inicio) &&
            (identical(other.etiologia, etiologia) ||
                other.etiologia == etiologia) &&
            (identical(other.ultimaAvaliacaoEm, ultimaAvaliacaoEm) ||
                other.ultimaAvaliacaoEm == ultimaAvaliacaoEm) &&
            (identical(other.contagemAvaliacoes, contagemAvaliacoes) ||
                other.contagemAvaliacoes == contagemAvaliacoes) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.identificationDate, identificationDate) ||
                other.identificationDate == identificationDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.healedDate, healedDate) ||
                other.healedDate == healedDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.archived, archived) ||
                other.archived == archived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    feridaId,
    patientId,
    ownerId,
    type,
    localizacao,
    status,
    criadoEm,
    atualizadoEm,
    inicio,
    etiologia,
    ultimaAvaliacaoEm,
    contagemAvaliacoes,
    id,
    location,
    identificationDate,
    description,
    healedDate,
    notes,
    archived,
  ]);

  /// Create a copy of Wound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WoundImplCopyWith<_$WoundImpl> get copyWith =>
      __$$WoundImplCopyWithImpl<_$WoundImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WoundImplToJson(this);
  }
}

abstract class _Wound extends Wound {
  const factory _Wound({
    required final String feridaId,
    required final String patientId,
    required final String ownerId,
    required final WoundType type,
    required final String localizacao,
    required final WoundStatus status,
    @TimestampConverter() required final DateTime criadoEm,
    @TimestampConverter() required final DateTime atualizadoEm,
    @TimestampConverter() final DateTime? inicio,
    final String? etiologia,
    @TimestampConverter() final DateTime? ultimaAvaliacaoEm,
    final int contagemAvaliacoes,
    @Deprecated('Use feridaId instead') final String? id,
    @Deprecated('Use localizacao instead') final WoundLocation? location,
    @Deprecated('Use inicio instead') final DateTime? identificationDate,
    @Deprecated('Use etiologia instead') final String? description,
    final DateTime? healedDate,
    final String? notes,
    final bool archived,
  }) = _$WoundImpl;
  const _Wound._() : super._();

  factory _Wound.fromJson(Map<String, dynamic> json) = _$WoundImpl.fromJson;

  // Campos obrigatórios conforme nova estrutura
  @override
  String get feridaId;
  @override
  String get patientId;
  @override
  String get ownerId;
  @override
  WoundType get type;
  @override
  String get localizacao;
  @override
  WoundStatus get status;
  @override
  @TimestampConverter()
  DateTime get criadoEm;
  @override
  @TimestampConverter()
  DateTime get atualizadoEm; // Campos opcionais
  @override
  @TimestampConverter()
  DateTime? get inicio;
  @override
  String? get etiologia;
  @override
  @TimestampConverter()
  DateTime? get ultimaAvaliacaoEm;
  @override
  int get contagemAvaliacoes; // Campos de compatibilidade com estrutura anterior (deprecated)
  @override
  @Deprecated('Use feridaId instead')
  String? get id;
  @override
  @Deprecated('Use localizacao instead')
  WoundLocation? get location;
  @override
  @Deprecated('Use inicio instead')
  DateTime? get identificationDate;
  @override
  @Deprecated('Use etiologia instead')
  String? get description;
  @override
  DateTime? get healedDate;
  @override
  String? get notes;
  @override
  bool get archived;

  /// Create a copy of Wound
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WoundImplCopyWith<_$WoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
