// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wound.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Wound {

 String get id; String get patientId; WoundType get type; WoundLocation get locationSimple; int get onsetDays; WoundStatus get status;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt; String? get locationDescription; String? get notes; String? get causeDescription;
/// Create a copy of Wound
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WoundCopyWith<Wound> get copyWith => _$WoundCopyWithImpl<Wound>(this as Wound, _$identity);

  /// Serializes this Wound to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wound&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.type, type) || other.type == type)&&(identical(other.locationSimple, locationSimple) || other.locationSimple == locationSimple)&&(identical(other.onsetDays, onsetDays) || other.onsetDays == onsetDays)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.locationDescription, locationDescription) || other.locationDescription == locationDescription)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.causeDescription, causeDescription) || other.causeDescription == causeDescription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,type,locationSimple,onsetDays,status,createdAt,updatedAt,locationDescription,notes,causeDescription);

@override
String toString() {
  return 'Wound(id: $id, patientId: $patientId, type: $type, locationSimple: $locationSimple, onsetDays: $onsetDays, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, locationDescription: $locationDescription, notes: $notes, causeDescription: $causeDescription)';
}


}

/// @nodoc
abstract mixin class $WoundCopyWith<$Res>  {
  factory $WoundCopyWith(Wound value, $Res Function(Wound) _then) = _$WoundCopyWithImpl;
@useResult
$Res call({
 String id, String patientId, WoundType type, WoundLocation locationSimple, int onsetDays, WoundStatus status,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String? locationDescription, String? notes, String? causeDescription
});




}
/// @nodoc
class _$WoundCopyWithImpl<$Res>
    implements $WoundCopyWith<$Res> {
  _$WoundCopyWithImpl(this._self, this._then);

  final Wound _self;
  final $Res Function(Wound) _then;

/// Create a copy of Wound
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = null,Object? type = null,Object? locationSimple = null,Object? onsetDays = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? locationDescription = freezed,Object? notes = freezed,Object? causeDescription = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WoundType,locationSimple: null == locationSimple ? _self.locationSimple : locationSimple // ignore: cast_nullable_to_non_nullable
as WoundLocation,onsetDays: null == onsetDays ? _self.onsetDays : onsetDays // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WoundStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationDescription: freezed == locationDescription ? _self.locationDescription : locationDescription // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,causeDescription: freezed == causeDescription ? _self.causeDescription : causeDescription // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Wound].
extension WoundPatterns on Wound {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wound value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wound() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wound value)  $default,){
final _that = this;
switch (_that) {
case _Wound():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wound value)?  $default,){
final _that = this;
switch (_that) {
case _Wound() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String patientId,  WoundType type,  WoundLocation locationSimple,  int onsetDays,  WoundStatus status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String? locationDescription,  String? notes,  String? causeDescription)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wound() when $default != null:
return $default(_that.id,_that.patientId,_that.type,_that.locationSimple,_that.onsetDays,_that.status,_that.createdAt,_that.updatedAt,_that.locationDescription,_that.notes,_that.causeDescription);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String patientId,  WoundType type,  WoundLocation locationSimple,  int onsetDays,  WoundStatus status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String? locationDescription,  String? notes,  String? causeDescription)  $default,) {final _that = this;
switch (_that) {
case _Wound():
return $default(_that.id,_that.patientId,_that.type,_that.locationSimple,_that.onsetDays,_that.status,_that.createdAt,_that.updatedAt,_that.locationDescription,_that.notes,_that.causeDescription);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String patientId,  WoundType type,  WoundLocation locationSimple,  int onsetDays,  WoundStatus status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String? locationDescription,  String? notes,  String? causeDescription)?  $default,) {final _that = this;
switch (_that) {
case _Wound() when $default != null:
return $default(_that.id,_that.patientId,_that.type,_that.locationSimple,_that.onsetDays,_that.status,_that.createdAt,_that.updatedAt,_that.locationDescription,_that.notes,_that.causeDescription);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Wound implements Wound {
  const _Wound({required this.id, required this.patientId, required this.type, required this.locationSimple, required this.onsetDays, this.status = WoundStatus.active, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, this.locationDescription, this.notes, this.causeDescription});
  factory _Wound.fromJson(Map<String, dynamic> json) => _$WoundFromJson(json);

@override final  String id;
@override final  String patientId;
@override final  WoundType type;
@override final  WoundLocation locationSimple;
@override final  int onsetDays;
@override@JsonKey() final  WoundStatus status;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;
@override final  String? locationDescription;
@override final  String? notes;
@override final  String? causeDescription;

/// Create a copy of Wound
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WoundCopyWith<_Wound> get copyWith => __$WoundCopyWithImpl<_Wound>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WoundToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wound&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.type, type) || other.type == type)&&(identical(other.locationSimple, locationSimple) || other.locationSimple == locationSimple)&&(identical(other.onsetDays, onsetDays) || other.onsetDays == onsetDays)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.locationDescription, locationDescription) || other.locationDescription == locationDescription)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.causeDescription, causeDescription) || other.causeDescription == causeDescription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,type,locationSimple,onsetDays,status,createdAt,updatedAt,locationDescription,notes,causeDescription);

@override
String toString() {
  return 'Wound(id: $id, patientId: $patientId, type: $type, locationSimple: $locationSimple, onsetDays: $onsetDays, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, locationDescription: $locationDescription, notes: $notes, causeDescription: $causeDescription)';
}


}

/// @nodoc
abstract mixin class _$WoundCopyWith<$Res> implements $WoundCopyWith<$Res> {
  factory _$WoundCopyWith(_Wound value, $Res Function(_Wound) _then) = __$WoundCopyWithImpl;
@override @useResult
$Res call({
 String id, String patientId, WoundType type, WoundLocation locationSimple, int onsetDays, WoundStatus status,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String? locationDescription, String? notes, String? causeDescription
});




}
/// @nodoc
class __$WoundCopyWithImpl<$Res>
    implements _$WoundCopyWith<$Res> {
  __$WoundCopyWithImpl(this._self, this._then);

  final _Wound _self;
  final $Res Function(_Wound) _then;

/// Create a copy of Wound
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = null,Object? type = null,Object? locationSimple = null,Object? onsetDays = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? locationDescription = freezed,Object? notes = freezed,Object? causeDescription = freezed,}) {
  return _then(_Wound(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WoundType,locationSimple: null == locationSimple ? _self.locationSimple : locationSimple // ignore: cast_nullable_to_non_nullable
as WoundLocation,onsetDays: null == onsetDays ? _self.onsetDays : onsetDays // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WoundStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationDescription: freezed == locationDescription ? _self.locationDescription : locationDescription // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,causeDescription: freezed == causeDescription ? _self.causeDescription : causeDescription // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
