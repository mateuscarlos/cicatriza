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
  String get description => throw _privateConstructorUsedError;
  WoundType get type => throw _privateConstructorUsedError;
  WoundLocation get location => throw _privateConstructorUsedError;
  WoundStatus get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get identificationDate => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
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
    String id,
    String patientId,
    String description,
    WoundType type,
    WoundLocation location,
    WoundStatus status,
    @TimestampConverter() DateTime identificationDate,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
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
    Object? id = null,
    Object? patientId = null,
    Object? description = null,
    Object? type = null,
    Object? location = null,
    Object? status = null,
    Object? identificationDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? healedDate = freezed,
    Object? notes = freezed,
    Object? archived = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as WoundType,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as WoundLocation,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as WoundStatus,
            identificationDate: null == identificationDate
                ? _value.identificationDate
                : identificationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
    String id,
    String patientId,
    String description,
    WoundType type,
    WoundLocation location,
    WoundStatus status,
    @TimestampConverter() DateTime identificationDate,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
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
    Object? id = null,
    Object? patientId = null,
    Object? description = null,
    Object? type = null,
    Object? location = null,
    Object? status = null,
    Object? identificationDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? healedDate = freezed,
    Object? notes = freezed,
    Object? archived = null,
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
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as WoundType,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as WoundLocation,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as WoundStatus,
        identificationDate: null == identificationDate
            ? _value.identificationDate
            : identificationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
    required this.id,
    required this.patientId,
    required this.description,
    required this.type,
    required this.location,
    required this.status,
    @TimestampConverter() required this.identificationDate,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
    this.healedDate,
    this.notes,
    this.archived = false,
  }) : super._();

  factory _$WoundImpl.fromJson(Map<String, dynamic> json) =>
      _$$WoundImplFromJson(json);

  @override
  final String id;
  @override
  final String patientId;
  @override
  final String description;
  @override
  final WoundType type;
  @override
  final WoundLocation location;
  @override
  final WoundStatus status;
  @override
  @TimestampConverter()
  final DateTime identificationDate;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  final DateTime? healedDate;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool archived;

  @override
  String toString() {
    return 'Wound(id: $id, patientId: $patientId, description: $description, type: $type, location: $location, status: $status, identificationDate: $identificationDate, createdAt: $createdAt, updatedAt: $updatedAt, healedDate: $healedDate, notes: $notes, archived: $archived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WoundImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.identificationDate, identificationDate) ||
                other.identificationDate == identificationDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.healedDate, healedDate) ||
                other.healedDate == healedDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.archived, archived) ||
                other.archived == archived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    patientId,
    description,
    type,
    location,
    status,
    identificationDate,
    createdAt,
    updatedAt,
    healedDate,
    notes,
    archived,
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

abstract class _Wound extends Wound {
  const factory _Wound({
    required final String id,
    required final String patientId,
    required final String description,
    required final WoundType type,
    required final WoundLocation location,
    required final WoundStatus status,
    @TimestampConverter() required final DateTime identificationDate,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
    final DateTime? healedDate,
    final String? notes,
    final bool archived,
  }) = _$WoundImpl;
  const _Wound._() : super._();

  factory _Wound.fromJson(Map<String, dynamic> json) = _$WoundImpl.fromJson;

  @override
  String get id;
  @override
  String get patientId;
  @override
  String get description;
  @override
  WoundType get type;
  @override
  WoundLocation get location;
  @override
  WoundStatus get status;
  @override
  @TimestampConverter()
  DateTime get identificationDate;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
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
