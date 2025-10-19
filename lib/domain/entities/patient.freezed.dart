// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Patient {

 String get id; String get name;@TimestampConverter() DateTime get birthDate; bool get archived;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt; String get nameLowercase; String? get notes; String? get phone; String? get email;
/// Create a copy of Patient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientCopyWith<Patient> get copyWith => _$PatientCopyWithImpl<Patient>(this as Patient, _$identity);

  /// Serializes this Patient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Patient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.nameLowercase, nameLowercase) || other.nameLowercase == nameLowercase)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,birthDate,archived,createdAt,updatedAt,nameLowercase,notes,phone,email);

@override
String toString() {
  return 'Patient(id: $id, name: $name, birthDate: $birthDate, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt, nameLowercase: $nameLowercase, notes: $notes, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class $PatientCopyWith<$Res>  {
  factory $PatientCopyWith(Patient value, $Res Function(Patient) _then) = _$PatientCopyWithImpl;
@useResult
$Res call({
 String id, String name,@TimestampConverter() DateTime birthDate, bool archived,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String nameLowercase, String? notes, String? phone, String? email
});




}
/// @nodoc
class _$PatientCopyWithImpl<$Res>
    implements $PatientCopyWith<$Res> {
  _$PatientCopyWithImpl(this._self, this._then);

  final Patient _self;
  final $Res Function(Patient) _then;

/// Create a copy of Patient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? birthDate = null,Object? archived = null,Object? createdAt = null,Object? updatedAt = null,Object? nameLowercase = null,Object? notes = freezed,Object? phone = freezed,Object? email = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,nameLowercase: null == nameLowercase ? _self.nameLowercase : nameLowercase // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Patient].
extension PatientPatterns on Patient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Patient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Patient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Patient value)  $default,){
final _that = this;
switch (_that) {
case _Patient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Patient value)?  $default,){
final _that = this;
switch (_that) {
case _Patient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @TimestampConverter()  DateTime birthDate,  bool archived, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String nameLowercase,  String? notes,  String? phone,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Patient() when $default != null:
return $default(_that.id,_that.name,_that.birthDate,_that.archived,_that.createdAt,_that.updatedAt,_that.nameLowercase,_that.notes,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @TimestampConverter()  DateTime birthDate,  bool archived, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String nameLowercase,  String? notes,  String? phone,  String? email)  $default,) {final _that = this;
switch (_that) {
case _Patient():
return $default(_that.id,_that.name,_that.birthDate,_that.archived,_that.createdAt,_that.updatedAt,_that.nameLowercase,_that.notes,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @TimestampConverter()  DateTime birthDate,  bool archived, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String nameLowercase,  String? notes,  String? phone,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _Patient() when $default != null:
return $default(_that.id,_that.name,_that.birthDate,_that.archived,_that.createdAt,_that.updatedAt,_that.nameLowercase,_that.notes,_that.phone,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Patient implements Patient {
  const _Patient({required this.id, required this.name, @TimestampConverter() required this.birthDate, this.archived = false, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, required this.nameLowercase, this.notes, this.phone, this.email});
  factory _Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);

@override final  String id;
@override final  String name;
@override@TimestampConverter() final  DateTime birthDate;
@override@JsonKey() final  bool archived;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;
@override final  String nameLowercase;
@override final  String? notes;
@override final  String? phone;
@override final  String? email;

/// Create a copy of Patient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientCopyWith<_Patient> get copyWith => __$PatientCopyWithImpl<_Patient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Patient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.nameLowercase, nameLowercase) || other.nameLowercase == nameLowercase)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,birthDate,archived,createdAt,updatedAt,nameLowercase,notes,phone,email);

@override
String toString() {
  return 'Patient(id: $id, name: $name, birthDate: $birthDate, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt, nameLowercase: $nameLowercase, notes: $notes, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class _$PatientCopyWith<$Res> implements $PatientCopyWith<$Res> {
  factory _$PatientCopyWith(_Patient value, $Res Function(_Patient) _then) = __$PatientCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@TimestampConverter() DateTime birthDate, bool archived,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String nameLowercase, String? notes, String? phone, String? email
});




}
/// @nodoc
class __$PatientCopyWithImpl<$Res>
    implements _$PatientCopyWith<$Res> {
  __$PatientCopyWithImpl(this._self, this._then);

  final _Patient _self;
  final $Res Function(_Patient) _then;

/// Create a copy of Patient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? birthDate = null,Object? archived = null,Object? createdAt = null,Object? updatedAt = null,Object? nameLowercase = null,Object? notes = freezed,Object? phone = freezed,Object? email = freezed,}) {
  return _then(_Patient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,nameLowercase: null == nameLowercase ? _self.nameLowercase : nameLowercase // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
