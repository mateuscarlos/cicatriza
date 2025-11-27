// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tecido_ferida.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TecidoFerida _$TecidoFeridaFromJson(Map<String, dynamic> json) {
  return _TecidoFerida.fromJson(json);
}

/// @nodoc
mixin _$TecidoFerida {
  int get granulacao => throw _privateConstructorUsedError;
  int get fibrina => throw _privateConstructorUsedError;
  int get necrose => throw _privateConstructorUsedError;
  int get epitelizacao => throw _privateConstructorUsedError;
  int get outros => throw _privateConstructorUsedError;

  /// Serializes this TecidoFerida to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TecidoFerida
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TecidoFeridaCopyWith<TecidoFerida> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TecidoFeridaCopyWith<$Res> {
  factory $TecidoFeridaCopyWith(
    TecidoFerida value,
    $Res Function(TecidoFerida) then,
  ) = _$TecidoFeridaCopyWithImpl<$Res, TecidoFerida>;
  @useResult
  $Res call({
    int granulacao,
    int fibrina,
    int necrose,
    int epitelizacao,
    int outros,
  });
}

/// @nodoc
class _$TecidoFeridaCopyWithImpl<$Res, $Val extends TecidoFerida>
    implements $TecidoFeridaCopyWith<$Res> {
  _$TecidoFeridaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TecidoFerida
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? granulacao = null,
    Object? fibrina = null,
    Object? necrose = null,
    Object? epitelizacao = null,
    Object? outros = null,
  }) {
    return _then(
      _value.copyWith(
            granulacao: null == granulacao
                ? _value.granulacao
                : granulacao // ignore: cast_nullable_to_non_nullable
                      as int,
            fibrina: null == fibrina
                ? _value.fibrina
                : fibrina // ignore: cast_nullable_to_non_nullable
                      as int,
            necrose: null == necrose
                ? _value.necrose
                : necrose // ignore: cast_nullable_to_non_nullable
                      as int,
            epitelizacao: null == epitelizacao
                ? _value.epitelizacao
                : epitelizacao // ignore: cast_nullable_to_non_nullable
                      as int,
            outros: null == outros
                ? _value.outros
                : outros // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TecidoFeridaImplCopyWith<$Res>
    implements $TecidoFeridaCopyWith<$Res> {
  factory _$$TecidoFeridaImplCopyWith(
    _$TecidoFeridaImpl value,
    $Res Function(_$TecidoFeridaImpl) then,
  ) = __$$TecidoFeridaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int granulacao,
    int fibrina,
    int necrose,
    int epitelizacao,
    int outros,
  });
}

/// @nodoc
class __$$TecidoFeridaImplCopyWithImpl<$Res>
    extends _$TecidoFeridaCopyWithImpl<$Res, _$TecidoFeridaImpl>
    implements _$$TecidoFeridaImplCopyWith<$Res> {
  __$$TecidoFeridaImplCopyWithImpl(
    _$TecidoFeridaImpl _value,
    $Res Function(_$TecidoFeridaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TecidoFerida
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? granulacao = null,
    Object? fibrina = null,
    Object? necrose = null,
    Object? epitelizacao = null,
    Object? outros = null,
  }) {
    return _then(
      _$TecidoFeridaImpl(
        granulacao: null == granulacao
            ? _value.granulacao
            : granulacao // ignore: cast_nullable_to_non_nullable
                  as int,
        fibrina: null == fibrina
            ? _value.fibrina
            : fibrina // ignore: cast_nullable_to_non_nullable
                  as int,
        necrose: null == necrose
            ? _value.necrose
            : necrose // ignore: cast_nullable_to_non_nullable
                  as int,
        epitelizacao: null == epitelizacao
            ? _value.epitelizacao
            : epitelizacao // ignore: cast_nullable_to_non_nullable
                  as int,
        outros: null == outros
            ? _value.outros
            : outros // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TecidoFeridaImpl implements _TecidoFerida {
  const _$TecidoFeridaImpl({
    this.granulacao = 0,
    this.fibrina = 0,
    this.necrose = 0,
    this.epitelizacao = 0,
    this.outros = 0,
  });

  factory _$TecidoFeridaImpl.fromJson(Map<String, dynamic> json) =>
      _$$TecidoFeridaImplFromJson(json);

  @override
  @JsonKey()
  final int granulacao;
  @override
  @JsonKey()
  final int fibrina;
  @override
  @JsonKey()
  final int necrose;
  @override
  @JsonKey()
  final int epitelizacao;
  @override
  @JsonKey()
  final int outros;

  @override
  String toString() {
    return 'TecidoFerida(granulacao: $granulacao, fibrina: $fibrina, necrose: $necrose, epitelizacao: $epitelizacao, outros: $outros)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TecidoFeridaImpl &&
            (identical(other.granulacao, granulacao) ||
                other.granulacao == granulacao) &&
            (identical(other.fibrina, fibrina) || other.fibrina == fibrina) &&
            (identical(other.necrose, necrose) || other.necrose == necrose) &&
            (identical(other.epitelizacao, epitelizacao) ||
                other.epitelizacao == epitelizacao) &&
            (identical(other.outros, outros) || other.outros == outros));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    granulacao,
    fibrina,
    necrose,
    epitelizacao,
    outros,
  );

  /// Create a copy of TecidoFerida
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TecidoFeridaImplCopyWith<_$TecidoFeridaImpl> get copyWith =>
      __$$TecidoFeridaImplCopyWithImpl<_$TecidoFeridaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TecidoFeridaImplToJson(this);
  }
}

abstract class _TecidoFerida implements TecidoFerida {
  const factory _TecidoFerida({
    final int granulacao,
    final int fibrina,
    final int necrose,
    final int epitelizacao,
    final int outros,
  }) = _$TecidoFeridaImpl;

  factory _TecidoFerida.fromJson(Map<String, dynamic> json) =
      _$TecidoFeridaImpl.fromJson;

  @override
  int get granulacao;
  @override
  int get fibrina;
  @override
  int get necrose;
  @override
  int get epitelizacao;
  @override
  int get outros;

  /// Create a copy of TecidoFerida
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TecidoFeridaImplCopyWith<_$TecidoFeridaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
