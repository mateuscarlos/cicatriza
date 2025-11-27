// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exsudato_ferida.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExsudatoFerida _$ExsudatoFeridaFromJson(Map<String, dynamic> json) {
  return _ExsudatoFerida.fromJson(json);
}

/// @nodoc
mixin _$ExsudatoFerida {
  ExsudatoTipo get tipo => throw _privateConstructorUsedError;
  ExsudatoQuantidade get quantidade => throw _privateConstructorUsedError;
  ExsudatoAspecto get aspecto => throw _privateConstructorUsedError;
  bool get odor => throw _privateConstructorUsedError;

  /// Serializes this ExsudatoFerida to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExsudatoFerida
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExsudatoFeridaCopyWith<ExsudatoFerida> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExsudatoFeridaCopyWith<$Res> {
  factory $ExsudatoFeridaCopyWith(
    ExsudatoFerida value,
    $Res Function(ExsudatoFerida) then,
  ) = _$ExsudatoFeridaCopyWithImpl<$Res, ExsudatoFerida>;
  @useResult
  $Res call({
    ExsudatoTipo tipo,
    ExsudatoQuantidade quantidade,
    ExsudatoAspecto aspecto,
    bool odor,
  });
}

/// @nodoc
class _$ExsudatoFeridaCopyWithImpl<$Res, $Val extends ExsudatoFerida>
    implements $ExsudatoFeridaCopyWith<$Res> {
  _$ExsudatoFeridaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExsudatoFerida
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tipo = null,
    Object? quantidade = null,
    Object? aspecto = null,
    Object? odor = null,
  }) {
    return _then(
      _value.copyWith(
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as ExsudatoTipo,
            quantidade: null == quantidade
                ? _value.quantidade
                : quantidade // ignore: cast_nullable_to_non_nullable
                      as ExsudatoQuantidade,
            aspecto: null == aspecto
                ? _value.aspecto
                : aspecto // ignore: cast_nullable_to_non_nullable
                      as ExsudatoAspecto,
            odor: null == odor
                ? _value.odor
                : odor // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExsudatoFeridaImplCopyWith<$Res>
    implements $ExsudatoFeridaCopyWith<$Res> {
  factory _$$ExsudatoFeridaImplCopyWith(
    _$ExsudatoFeridaImpl value,
    $Res Function(_$ExsudatoFeridaImpl) then,
  ) = __$$ExsudatoFeridaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ExsudatoTipo tipo,
    ExsudatoQuantidade quantidade,
    ExsudatoAspecto aspecto,
    bool odor,
  });
}

/// @nodoc
class __$$ExsudatoFeridaImplCopyWithImpl<$Res>
    extends _$ExsudatoFeridaCopyWithImpl<$Res, _$ExsudatoFeridaImpl>
    implements _$$ExsudatoFeridaImplCopyWith<$Res> {
  __$$ExsudatoFeridaImplCopyWithImpl(
    _$ExsudatoFeridaImpl _value,
    $Res Function(_$ExsudatoFeridaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExsudatoFerida
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tipo = null,
    Object? quantidade = null,
    Object? aspecto = null,
    Object? odor = null,
  }) {
    return _then(
      _$ExsudatoFeridaImpl(
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as ExsudatoTipo,
        quantidade: null == quantidade
            ? _value.quantidade
            : quantidade // ignore: cast_nullable_to_non_nullable
                  as ExsudatoQuantidade,
        aspecto: null == aspecto
            ? _value.aspecto
            : aspecto // ignore: cast_nullable_to_non_nullable
                  as ExsudatoAspecto,
        odor: null == odor
            ? _value.odor
            : odor // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExsudatoFeridaImpl implements _ExsudatoFerida {
  const _$ExsudatoFeridaImpl({
    this.tipo = ExsudatoTipo.seroso,
    this.quantidade = ExsudatoQuantidade.ausente,
    this.aspecto = ExsudatoAspecto.claro,
    this.odor = false,
  });

  factory _$ExsudatoFeridaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExsudatoFeridaImplFromJson(json);

  @override
  @JsonKey()
  final ExsudatoTipo tipo;
  @override
  @JsonKey()
  final ExsudatoQuantidade quantidade;
  @override
  @JsonKey()
  final ExsudatoAspecto aspecto;
  @override
  @JsonKey()
  final bool odor;

  @override
  String toString() {
    return 'ExsudatoFerida(tipo: $tipo, quantidade: $quantidade, aspecto: $aspecto, odor: $odor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExsudatoFeridaImpl &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.quantidade, quantidade) ||
                other.quantidade == quantidade) &&
            (identical(other.aspecto, aspecto) || other.aspecto == aspecto) &&
            (identical(other.odor, odor) || other.odor == odor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tipo, quantidade, aspecto, odor);

  /// Create a copy of ExsudatoFerida
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExsudatoFeridaImplCopyWith<_$ExsudatoFeridaImpl> get copyWith =>
      __$$ExsudatoFeridaImplCopyWithImpl<_$ExsudatoFeridaImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExsudatoFeridaImplToJson(this);
  }
}

abstract class _ExsudatoFerida implements ExsudatoFerida {
  const factory _ExsudatoFerida({
    final ExsudatoTipo tipo,
    final ExsudatoQuantidade quantidade,
    final ExsudatoAspecto aspecto,
    final bool odor,
  }) = _$ExsudatoFeridaImpl;

  factory _ExsudatoFerida.fromJson(Map<String, dynamic> json) =
      _$ExsudatoFeridaImpl.fromJson;

  @override
  ExsudatoTipo get tipo;
  @override
  ExsudatoQuantidade get quantidade;
  @override
  ExsudatoAspecto get aspecto;
  @override
  bool get odor;

  /// Create a copy of ExsudatoFerida
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExsudatoFeridaImplCopyWith<_$ExsudatoFeridaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
