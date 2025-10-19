// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Assessment {

 String get id; String get woundId; DateTime get date; int get pain; double get lengthCm; double get widthCm; double get depthCm; DateTime get createdAt; DateTime get updatedAt; String? get notes; String? get exudate; String? get edgeAppearance; String? get woundBed; String? get periwoundSkin; String? get odor; String? get treatmentPlan;
/// Create a copy of Assessment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentCopyWith<Assessment> get copyWith => _$AssessmentCopyWithImpl<Assessment>(this as Assessment, _$identity);

  /// Serializes this Assessment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Assessment&&(identical(other.id, id) || other.id == id)&&(identical(other.woundId, woundId) || other.woundId == woundId)&&(identical(other.date, date) || other.date == date)&&(identical(other.pain, pain) || other.pain == pain)&&(identical(other.lengthCm, lengthCm) || other.lengthCm == lengthCm)&&(identical(other.widthCm, widthCm) || other.widthCm == widthCm)&&(identical(other.depthCm, depthCm) || other.depthCm == depthCm)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.exudate, exudate) || other.exudate == exudate)&&(identical(other.edgeAppearance, edgeAppearance) || other.edgeAppearance == edgeAppearance)&&(identical(other.woundBed, woundBed) || other.woundBed == woundBed)&&(identical(other.periwoundSkin, periwoundSkin) || other.periwoundSkin == periwoundSkin)&&(identical(other.odor, odor) || other.odor == odor)&&(identical(other.treatmentPlan, treatmentPlan) || other.treatmentPlan == treatmentPlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,woundId,date,pain,lengthCm,widthCm,depthCm,createdAt,updatedAt,notes,exudate,edgeAppearance,woundBed,periwoundSkin,odor,treatmentPlan);

@override
String toString() {
  return 'Assessment(id: $id, woundId: $woundId, date: $date, pain: $pain, lengthCm: $lengthCm, widthCm: $widthCm, depthCm: $depthCm, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes, exudate: $exudate, edgeAppearance: $edgeAppearance, woundBed: $woundBed, periwoundSkin: $periwoundSkin, odor: $odor, treatmentPlan: $treatmentPlan)';
}


}

/// @nodoc
abstract mixin class $AssessmentCopyWith<$Res>  {
  factory $AssessmentCopyWith(Assessment value, $Res Function(Assessment) _then) = _$AssessmentCopyWithImpl;
@useResult
$Res call({
 String id, String woundId, DateTime date, int pain, double lengthCm, double widthCm, double depthCm, DateTime createdAt, DateTime updatedAt, String? notes, String? exudate, String? edgeAppearance, String? woundBed, String? periwoundSkin, String? odor, String? treatmentPlan
});




}
/// @nodoc
class _$AssessmentCopyWithImpl<$Res>
    implements $AssessmentCopyWith<$Res> {
  _$AssessmentCopyWithImpl(this._self, this._then);

  final Assessment _self;
  final $Res Function(Assessment) _then;

/// Create a copy of Assessment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? woundId = null,Object? date = null,Object? pain = null,Object? lengthCm = null,Object? widthCm = null,Object? depthCm = null,Object? createdAt = null,Object? updatedAt = null,Object? notes = freezed,Object? exudate = freezed,Object? edgeAppearance = freezed,Object? woundBed = freezed,Object? periwoundSkin = freezed,Object? odor = freezed,Object? treatmentPlan = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,woundId: null == woundId ? _self.woundId : woundId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,pain: null == pain ? _self.pain : pain // ignore: cast_nullable_to_non_nullable
as int,lengthCm: null == lengthCm ? _self.lengthCm : lengthCm // ignore: cast_nullable_to_non_nullable
as double,widthCm: null == widthCm ? _self.widthCm : widthCm // ignore: cast_nullable_to_non_nullable
as double,depthCm: null == depthCm ? _self.depthCm : depthCm // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,exudate: freezed == exudate ? _self.exudate : exudate // ignore: cast_nullable_to_non_nullable
as String?,edgeAppearance: freezed == edgeAppearance ? _self.edgeAppearance : edgeAppearance // ignore: cast_nullable_to_non_nullable
as String?,woundBed: freezed == woundBed ? _self.woundBed : woundBed // ignore: cast_nullable_to_non_nullable
as String?,periwoundSkin: freezed == periwoundSkin ? _self.periwoundSkin : periwoundSkin // ignore: cast_nullable_to_non_nullable
as String?,odor: freezed == odor ? _self.odor : odor // ignore: cast_nullable_to_non_nullable
as String?,treatmentPlan: freezed == treatmentPlan ? _self.treatmentPlan : treatmentPlan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Assessment].
extension AssessmentPatterns on Assessment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Assessment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Assessment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Assessment value)  $default,){
final _that = this;
switch (_that) {
case _Assessment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Assessment value)?  $default,){
final _that = this;
switch (_that) {
case _Assessment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String woundId,  DateTime date,  int pain,  double lengthCm,  double widthCm,  double depthCm,  DateTime createdAt,  DateTime updatedAt,  String? notes,  String? exudate,  String? edgeAppearance,  String? woundBed,  String? periwoundSkin,  String? odor,  String? treatmentPlan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Assessment() when $default != null:
return $default(_that.id,_that.woundId,_that.date,_that.pain,_that.lengthCm,_that.widthCm,_that.depthCm,_that.createdAt,_that.updatedAt,_that.notes,_that.exudate,_that.edgeAppearance,_that.woundBed,_that.periwoundSkin,_that.odor,_that.treatmentPlan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String woundId,  DateTime date,  int pain,  double lengthCm,  double widthCm,  double depthCm,  DateTime createdAt,  DateTime updatedAt,  String? notes,  String? exudate,  String? edgeAppearance,  String? woundBed,  String? periwoundSkin,  String? odor,  String? treatmentPlan)  $default,) {final _that = this;
switch (_that) {
case _Assessment():
return $default(_that.id,_that.woundId,_that.date,_that.pain,_that.lengthCm,_that.widthCm,_that.depthCm,_that.createdAt,_that.updatedAt,_that.notes,_that.exudate,_that.edgeAppearance,_that.woundBed,_that.periwoundSkin,_that.odor,_that.treatmentPlan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String woundId,  DateTime date,  int pain,  double lengthCm,  double widthCm,  double depthCm,  DateTime createdAt,  DateTime updatedAt,  String? notes,  String? exudate,  String? edgeAppearance,  String? woundBed,  String? periwoundSkin,  String? odor,  String? treatmentPlan)?  $default,) {final _that = this;
switch (_that) {
case _Assessment() when $default != null:
return $default(_that.id,_that.woundId,_that.date,_that.pain,_that.lengthCm,_that.widthCm,_that.depthCm,_that.createdAt,_that.updatedAt,_that.notes,_that.exudate,_that.edgeAppearance,_that.woundBed,_that.periwoundSkin,_that.odor,_that.treatmentPlan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Assessment implements Assessment {
  const _Assessment({required this.id, required this.woundId, required this.date, required this.pain, required this.lengthCm, required this.widthCm, required this.depthCm, required this.createdAt, required this.updatedAt, this.notes, this.exudate, this.edgeAppearance, this.woundBed, this.periwoundSkin, this.odor, this.treatmentPlan});
  factory _Assessment.fromJson(Map<String, dynamic> json) => _$AssessmentFromJson(json);

@override final  String id;
@override final  String woundId;
@override final  DateTime date;
@override final  int pain;
@override final  double lengthCm;
@override final  double widthCm;
@override final  double depthCm;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? notes;
@override final  String? exudate;
@override final  String? edgeAppearance;
@override final  String? woundBed;
@override final  String? periwoundSkin;
@override final  String? odor;
@override final  String? treatmentPlan;

/// Create a copy of Assessment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentCopyWith<_Assessment> get copyWith => __$AssessmentCopyWithImpl<_Assessment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Assessment&&(identical(other.id, id) || other.id == id)&&(identical(other.woundId, woundId) || other.woundId == woundId)&&(identical(other.date, date) || other.date == date)&&(identical(other.pain, pain) || other.pain == pain)&&(identical(other.lengthCm, lengthCm) || other.lengthCm == lengthCm)&&(identical(other.widthCm, widthCm) || other.widthCm == widthCm)&&(identical(other.depthCm, depthCm) || other.depthCm == depthCm)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.exudate, exudate) || other.exudate == exudate)&&(identical(other.edgeAppearance, edgeAppearance) || other.edgeAppearance == edgeAppearance)&&(identical(other.woundBed, woundBed) || other.woundBed == woundBed)&&(identical(other.periwoundSkin, periwoundSkin) || other.periwoundSkin == periwoundSkin)&&(identical(other.odor, odor) || other.odor == odor)&&(identical(other.treatmentPlan, treatmentPlan) || other.treatmentPlan == treatmentPlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,woundId,date,pain,lengthCm,widthCm,depthCm,createdAt,updatedAt,notes,exudate,edgeAppearance,woundBed,periwoundSkin,odor,treatmentPlan);

@override
String toString() {
  return 'Assessment(id: $id, woundId: $woundId, date: $date, pain: $pain, lengthCm: $lengthCm, widthCm: $widthCm, depthCm: $depthCm, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes, exudate: $exudate, edgeAppearance: $edgeAppearance, woundBed: $woundBed, periwoundSkin: $periwoundSkin, odor: $odor, treatmentPlan: $treatmentPlan)';
}


}

/// @nodoc
abstract mixin class _$AssessmentCopyWith<$Res> implements $AssessmentCopyWith<$Res> {
  factory _$AssessmentCopyWith(_Assessment value, $Res Function(_Assessment) _then) = __$AssessmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String woundId, DateTime date, int pain, double lengthCm, double widthCm, double depthCm, DateTime createdAt, DateTime updatedAt, String? notes, String? exudate, String? edgeAppearance, String? woundBed, String? periwoundSkin, String? odor, String? treatmentPlan
});




}
/// @nodoc
class __$AssessmentCopyWithImpl<$Res>
    implements _$AssessmentCopyWith<$Res> {
  __$AssessmentCopyWithImpl(this._self, this._then);

  final _Assessment _self;
  final $Res Function(_Assessment) _then;

/// Create a copy of Assessment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? woundId = null,Object? date = null,Object? pain = null,Object? lengthCm = null,Object? widthCm = null,Object? depthCm = null,Object? createdAt = null,Object? updatedAt = null,Object? notes = freezed,Object? exudate = freezed,Object? edgeAppearance = freezed,Object? woundBed = freezed,Object? periwoundSkin = freezed,Object? odor = freezed,Object? treatmentPlan = freezed,}) {
  return _then(_Assessment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,woundId: null == woundId ? _self.woundId : woundId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,pain: null == pain ? _self.pain : pain // ignore: cast_nullable_to_non_nullable
as int,lengthCm: null == lengthCm ? _self.lengthCm : lengthCm // ignore: cast_nullable_to_non_nullable
as double,widthCm: null == widthCm ? _self.widthCm : widthCm // ignore: cast_nullable_to_non_nullable
as double,depthCm: null == depthCm ? _self.depthCm : depthCm // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,exudate: freezed == exudate ? _self.exudate : exudate // ignore: cast_nullable_to_non_nullable
as String?,edgeAppearance: freezed == edgeAppearance ? _self.edgeAppearance : edgeAppearance // ignore: cast_nullable_to_non_nullable
as String?,woundBed: freezed == woundBed ? _self.woundBed : woundBed // ignore: cast_nullable_to_non_nullable
as String?,periwoundSkin: freezed == periwoundSkin ? _self.periwoundSkin : periwoundSkin // ignore: cast_nullable_to_non_nullable
as String?,odor: freezed == odor ? _self.odor : odor // ignore: cast_nullable_to_non_nullable
as String?,treatmentPlan: freezed == treatmentPlan ? _self.treatmentPlan : treatmentPlan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
