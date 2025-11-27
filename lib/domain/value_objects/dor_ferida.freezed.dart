// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dor_ferida.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DorFerida _$DorFeridaFromJson(Map<String, dynamic> json) {
  return _DorFerida.fromJson(json);
}

/// @nodoc
mixin _$DorFerida {
  int get intensidade => throw _privateConstructorUsedError;
  DorTipo get tipo => throw _privateConstructorUsedError;
  String? get localizacao => throw _privateConstructorUsedError;

  /// Serializes this DorFerida to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DorFerida
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DorFeridaCopyWith<DorFerida> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DorFeridaCopyWith<$Res> {
  factory $DorFeridaCopyWith(DorFerida value, $Res Function(DorFerida) then) =
      _$DorFeridaCopyWithImpl<$Res, DorFerida>;
  @useResult
  $Res call({int intensidade, DorTipo tipo, String? localizacao});
}

/// @nodoc
class _$DorFeridaCopyWithImpl<$Res, $Val extends DorFerida>
    implements $DorFeridaCopyWith<$Res> {
  _$DorFeridaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DorFerida
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensidade = null,
    Object? tipo = null,
    Object? localizacao = freezed,
  }) {
    return _then(
      _value.copyWith(
            intensidade: null == intensidade
                ? _value.intensidade
                : intensidade // ignore: cast_nullable_to_non_nullable
                      as int,
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as DorTipo,
            localizacao: freezed == localizacao
                ? _value.localizacao
                : localizacao // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DorFeridaImplCopyWith<$Res>
    implements $DorFeridaCopyWith<$Res> {
  factory _$$DorFeridaImplCopyWith(
    _$DorFeridaImpl value,
    $Res Function(_$DorFeridaImpl) then,
  ) = __$$DorFeridaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int intensidade, DorTipo tipo, String? localizacao});
}

/// @nodoc
class __$$DorFeridaImplCopyWithImpl<$Res>
    extends _$DorFeridaCopyWithImpl<$Res, _$DorFeridaImpl>
    implements _$$DorFeridaImplCopyWith<$Res> {
  __$$DorFeridaImplCopyWithImpl(
    _$DorFeridaImpl _value,
    $Res Function(_$DorFeridaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DorFerida
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensidade = null,
    Object? tipo = null,
    Object? localizacao = freezed,
  }) {
    return _then(
      _$DorFeridaImpl(
        intensidade: null == intensidade
            ? _value.intensidade
            : intensidade // ignore: cast_nullable_to_non_nullable
                  as int,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as DorTipo,
        localizacao: freezed == localizacao
            ? _value.localizacao
            : localizacao // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DorFeridaImpl implements _DorFerida {
  const _$DorFeridaImpl({
    this.intensidade = 0,
    this.tipo = DorTipo.ausente,
    this.localizacao,
  });

  factory _$DorFeridaImpl.fromJson(Map<String, dynamic> json) =>
      _$$DorFeridaImplFromJson(json);

  @override
  @JsonKey()
  final int intensidade;
  @override
  @JsonKey()
  final DorTipo tipo;
  @override
  final String? localizacao;

  @override
  String toString() {
    return 'DorFerida(intensidade: $intensidade, tipo: $tipo, localizacao: $localizacao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DorFeridaImpl &&
            (identical(other.intensidade, intensidade) ||
                other.intensidade == intensidade) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.localizacao, localizacao) ||
                other.localizacao == localizacao));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, intensidade, tipo, localizacao);

  /// Create a copy of DorFerida
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DorFeridaImplCopyWith<_$DorFeridaImpl> get copyWith =>
      __$$DorFeridaImplCopyWithImpl<_$DorFeridaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DorFeridaImplToJson(this);
  }
}

abstract class _DorFerida implements DorFerida {
  const factory _DorFerida({
    final int intensidade,
    final DorTipo tipo,
    final String? localizacao,
  }) = _$DorFeridaImpl;

  factory _DorFerida.fromJson(Map<String, dynamic> json) =
      _$DorFeridaImpl.fromJson;

  @override
  int get intensidade;
  @override
  DorTipo get tipo;
  @override
  String? get localizacao;

  /// Create a copy of DorFerida
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DorFeridaImplCopyWith<_$DorFeridaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
