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
  String get id => throw _privateConstructorUsedError;
  String get patientId => throw _privateConstructorUsedError;
  WoundType get type => throw _privateConstructorUsedError;
  WoundLocation get locationSimple => throw _privateConstructorUsedError;
  int get onsetDays => throw _privateConstructorUsedError;
  WoundStatus get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get locationDescription => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get causeDescription => throw _privateConstructorUsedError;

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
    String id,
    String patientId,
    WoundType type,
    WoundLocation locationSimple,
    int onsetDays,
    WoundStatus status,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    String? locationDescription,
    String? notes,
    String? causeDescription,
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
    Object? id = null,
    Object? patientId = null,
    Object? type = null,
    Object? locationSimple = null,
    Object? onsetDays = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? locationDescription = freezed,
    Object? notes = freezed,
    Object? causeDescription = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            patientId: null == patientId
                ? _value.patientId
                : patientId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as WoundType,
            locationSimple: null == locationSimple
                ? _value.locationSimple
                : locationSimple // ignore: cast_nullable_to_non_nullable
                      as WoundLocation,
            onsetDays: null == onsetDays
                ? _value.onsetDays
                : onsetDays // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as WoundStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            locationDescription: freezed == locationDescription
                ? _value.locationDescription
                : locationDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            causeDescription: freezed == causeDescription
                ? _value.causeDescription
                : causeDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String id,
    String patientId,
    WoundType type,
    WoundLocation locationSimple,
    int onsetDays,
    WoundStatus status,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    String? locationDescription,
    String? notes,
    String? causeDescription,
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
    Object? id = null,
    Object? patientId = null,
    Object? type = null,
    Object? locationSimple = null,
    Object? onsetDays = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? locationDescription = freezed,
    Object? notes = freezed,
    Object? causeDescription = freezed,
  }) {
    return _then(
      _$WoundImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        patientId: null == patientId
            ? _value.patientId
            : patientId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as WoundType,
        locationSimple: null == locationSimple
            ? _value.locationSimple
            : locationSimple // ignore: cast_nullable_to_non_nullable
                  as WoundLocation,
        onsetDays: null == onsetDays
            ? _value.onsetDays
            : onsetDays // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as WoundStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        locationDescription: freezed == locationDescription
            ? _value.locationDescription
            : locationDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        causeDescription: freezed == causeDescription
            ? _value.causeDescription
            : causeDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WoundImpl implements _Wound {
  const _$WoundImpl({
    required this.id,
    required this.patientId,
    required this.type,
    required this.locationSimple,
    required this.onsetDays,
    this.status = WoundStatus.active,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
    this.locationDescription,
    this.notes,
    this.causeDescription,
  });

  factory _$WoundImpl.fromJson(Map<String, dynamic> json) =>
      _$$WoundImplFromJson(json);

  @override
  final String id;
  @override
  final String patientId;
  @override
  final WoundType type;
  @override
  final WoundLocation locationSimple;
  @override
  final int onsetDays;
  @override
  @JsonKey()
  final WoundStatus status;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  final String? locationDescription;
  @override
  final String? notes;
  @override
  final String? causeDescription;

  @override
  String toString() {
    return 'Wound(id: $id, patientId: $patientId, type: $type, locationSimple: $locationSimple, onsetDays: $onsetDays, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, locationDescription: $locationDescription, notes: $notes, causeDescription: $causeDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WoundImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.locationSimple, locationSimple) ||
                other.locationSimple == locationSimple) &&
            (identical(other.onsetDays, onsetDays) ||
                other.onsetDays == onsetDays) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.locationDescription, locationDescription) ||
                other.locationDescription == locationDescription) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.causeDescription, causeDescription) ||
                other.causeDescription == causeDescription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    patientId,
    type,
    locationSimple,
    onsetDays,
    status,
    createdAt,
    updatedAt,
    locationDescription,
    notes,
    causeDescription,
  );

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

abstract class _Wound implements Wound {
  const factory _Wound({
    required final String id,
    required final String patientId,
    required final WoundType type,
    required final WoundLocation locationSimple,
    required final int onsetDays,
    final WoundStatus status,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
    final String? locationDescription,
    final String? notes,
    final String? causeDescription,
  }) = _$WoundImpl;

  factory _Wound.fromJson(Map<String, dynamic> json) = _$WoundImpl.fromJson;

  @override
  String get id;
  @override
  String get patientId;
  @override
  WoundType get type;
  @override
  WoundLocation get locationSimple;
  @override
  int get onsetDays;
  @override
  WoundStatus get status;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  String? get locationDescription;
  @override
  String? get notes;
  @override
  String? get causeDescription;

  /// Create a copy of Wound
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WoundImplCopyWith<_$WoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
