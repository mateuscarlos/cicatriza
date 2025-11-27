// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medidas_ferida.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MedidasFerida _$MedidasFeridaFromJson(Map<String, dynamic> json) {
  return _MedidasFerida.fromJson(json);
}

/// @nodoc
mixin _$MedidasFerida {
  double get comprimento => throw _privateConstructorUsedError;
  double get largura => throw _privateConstructorUsedError;
  double? get profundidade => throw _privateConstructorUsedError;
  double? get area => throw _privateConstructorUsedError;
  double? get volume => throw _privateConstructorUsedError;

  /// Serializes this MedidasFerida to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedidasFerida
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedidasFeridaCopyWith<MedidasFerida> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedidasFeridaCopyWith<$Res> {
  factory $MedidasFeridaCopyWith(
    MedidasFerida value,
    $Res Function(MedidasFerida) then,
  ) = _$MedidasFeridaCopyWithImpl<$Res, MedidasFerida>;
  @useResult
  $Res call({
    double comprimento,
    double largura,
    double? profundidade,
    double? area,
    double? volume,
  });
}

/// @nodoc
class _$MedidasFeridaCopyWithImpl<$Res, $Val extends MedidasFerida>
    implements $MedidasFeridaCopyWith<$Res> {
  _$MedidasFeridaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedidasFerida
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comprimento = null,
    Object? largura = null,
    Object? profundidade = freezed,
    Object? area = freezed,
    Object? volume = freezed,
  }) {
    return _then(
      _value.copyWith(
            comprimento: null == comprimento
                ? _value.comprimento
                : comprimento // ignore: cast_nullable_to_non_nullable
                      as double,
            largura: null == largura
                ? _value.largura
                : largura // ignore: cast_nullable_to_non_nullable
                      as double,
            profundidade: freezed == profundidade
                ? _value.profundidade
                : profundidade // ignore: cast_nullable_to_non_nullable
                      as double?,
            area: freezed == area
                ? _value.area
                : area // ignore: cast_nullable_to_non_nullable
                      as double?,
            volume: freezed == volume
                ? _value.volume
                : volume // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MedidasFeridaImplCopyWith<$Res>
    implements $MedidasFeridaCopyWith<$Res> {
  factory _$$MedidasFeridaImplCopyWith(
    _$MedidasFeridaImpl value,
    $Res Function(_$MedidasFeridaImpl) then,
  ) = __$$MedidasFeridaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double comprimento,
    double largura,
    double? profundidade,
    double? area,
    double? volume,
  });
}

/// @nodoc
class __$$MedidasFeridaImplCopyWithImpl<$Res>
    extends _$MedidasFeridaCopyWithImpl<$Res, _$MedidasFeridaImpl>
    implements _$$MedidasFeridaImplCopyWith<$Res> {
  __$$MedidasFeridaImplCopyWithImpl(
    _$MedidasFeridaImpl _value,
    $Res Function(_$MedidasFeridaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedidasFerida
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comprimento = null,
    Object? largura = null,
    Object? profundidade = freezed,
    Object? area = freezed,
    Object? volume = freezed,
  }) {
    return _then(
      _$MedidasFeridaImpl(
        comprimento: null == comprimento
            ? _value.comprimento
            : comprimento // ignore: cast_nullable_to_non_nullable
                  as double,
        largura: null == largura
            ? _value.largura
            : largura // ignore: cast_nullable_to_non_nullable
                  as double,
        profundidade: freezed == profundidade
            ? _value.profundidade
            : profundidade // ignore: cast_nullable_to_non_nullable
                  as double?,
        area: freezed == area
            ? _value.area
            : area // ignore: cast_nullable_to_non_nullable
                  as double?,
        volume: freezed == volume
            ? _value.volume
            : volume // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedidasFeridaImpl implements _MedidasFerida {
  const _$MedidasFeridaImpl({
    required this.comprimento,
    required this.largura,
    this.profundidade,
    this.area,
    this.volume,
  });

  factory _$MedidasFeridaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedidasFeridaImplFromJson(json);

  @override
  final double comprimento;
  @override
  final double largura;
  @override
  final double? profundidade;
  @override
  final double? area;
  @override
  final double? volume;

  @override
  String toString() {
    return 'MedidasFerida(comprimento: $comprimento, largura: $largura, profundidade: $profundidade, area: $area, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedidasFeridaImpl &&
            (identical(other.comprimento, comprimento) ||
                other.comprimento == comprimento) &&
            (identical(other.largura, largura) || other.largura == largura) &&
            (identical(other.profundidade, profundidade) ||
                other.profundidade == profundidade) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    comprimento,
    largura,
    profundidade,
    area,
    volume,
  );

  /// Create a copy of MedidasFerida
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedidasFeridaImplCopyWith<_$MedidasFeridaImpl> get copyWith =>
      __$$MedidasFeridaImplCopyWithImpl<_$MedidasFeridaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedidasFeridaImplToJson(this);
  }
}

abstract class _MedidasFerida implements MedidasFerida {
  const factory _MedidasFerida({
    required final double comprimento,
    required final double largura,
    final double? profundidade,
    final double? area,
    final double? volume,
  }) = _$MedidasFeridaImpl;

  factory _MedidasFerida.fromJson(Map<String, dynamic> json) =
      _$MedidasFeridaImpl.fromJson;

  @override
  double get comprimento;
  @override
  double get largura;
  @override
  double? get profundidade;
  @override
  double? get area;
  @override
  double? get volume;

  /// Create a copy of MedidasFerida
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedidasFeridaImplCopyWith<_$MedidasFeridaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
