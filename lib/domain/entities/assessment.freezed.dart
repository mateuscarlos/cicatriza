// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Assessment _$AssessmentFromJson(Map<String, dynamic> json) {
  return _Assessment.fromJson(json);
}

/// @nodoc
mixin _$Assessment {
  String get id => throw _privateConstructorUsedError;
  String get woundId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get pain => throw _privateConstructorUsedError;
  double get lengthCm => throw _privateConstructorUsedError;
  double get widthCm => throw _privateConstructorUsedError;
  double get depthCm => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get exudate => throw _privateConstructorUsedError;
  String? get edgeAppearance => throw _privateConstructorUsedError;
  String? get woundBed => throw _privateConstructorUsedError;
  String? get periwoundSkin => throw _privateConstructorUsedError;
  String? get odor => throw _privateConstructorUsedError;
  String? get treatmentPlan => throw _privateConstructorUsedError;

  /// Serializes this Assessment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssessmentCopyWith<Assessment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssessmentCopyWith<$Res> {
  factory $AssessmentCopyWith(
    Assessment value,
    $Res Function(Assessment) then,
  ) = _$AssessmentCopyWithImpl<$Res, Assessment>;
  @useResult
  $Res call({
    String id,
    String woundId,
    DateTime date,
    int pain,
    double lengthCm,
    double widthCm,
    double depthCm,
    DateTime createdAt,
    DateTime updatedAt,
    String? notes,
    String? exudate,
    String? edgeAppearance,
    String? woundBed,
    String? periwoundSkin,
    String? odor,
    String? treatmentPlan,
  });
}

/// @nodoc
class _$AssessmentCopyWithImpl<$Res, $Val extends Assessment>
    implements $AssessmentCopyWith<$Res> {
  _$AssessmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? woundId = null,
    Object? date = null,
    Object? pain = null,
    Object? lengthCm = null,
    Object? widthCm = null,
    Object? depthCm = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? notes = freezed,
    Object? exudate = freezed,
    Object? edgeAppearance = freezed,
    Object? woundBed = freezed,
    Object? periwoundSkin = freezed,
    Object? odor = freezed,
    Object? treatmentPlan = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            woundId: null == woundId
                ? _value.woundId
                : woundId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            pain: null == pain
                ? _value.pain
                : pain // ignore: cast_nullable_to_non_nullable
                      as int,
            lengthCm: null == lengthCm
                ? _value.lengthCm
                : lengthCm // ignore: cast_nullable_to_non_nullable
                      as double,
            widthCm: null == widthCm
                ? _value.widthCm
                : widthCm // ignore: cast_nullable_to_non_nullable
                      as double,
            depthCm: null == depthCm
                ? _value.depthCm
                : depthCm // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            exudate: freezed == exudate
                ? _value.exudate
                : exudate // ignore: cast_nullable_to_non_nullable
                      as String?,
            edgeAppearance: freezed == edgeAppearance
                ? _value.edgeAppearance
                : edgeAppearance // ignore: cast_nullable_to_non_nullable
                      as String?,
            woundBed: freezed == woundBed
                ? _value.woundBed
                : woundBed // ignore: cast_nullable_to_non_nullable
                      as String?,
            periwoundSkin: freezed == periwoundSkin
                ? _value.periwoundSkin
                : periwoundSkin // ignore: cast_nullable_to_non_nullable
                      as String?,
            odor: freezed == odor
                ? _value.odor
                : odor // ignore: cast_nullable_to_non_nullable
                      as String?,
            treatmentPlan: freezed == treatmentPlan
                ? _value.treatmentPlan
                : treatmentPlan // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssessmentImplCopyWith<$Res>
    implements $AssessmentCopyWith<$Res> {
  factory _$$AssessmentImplCopyWith(
    _$AssessmentImpl value,
    $Res Function(_$AssessmentImpl) then,
  ) = __$$AssessmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String woundId,
    DateTime date,
    int pain,
    double lengthCm,
    double widthCm,
    double depthCm,
    DateTime createdAt,
    DateTime updatedAt,
    String? notes,
    String? exudate,
    String? edgeAppearance,
    String? woundBed,
    String? periwoundSkin,
    String? odor,
    String? treatmentPlan,
  });
}

/// @nodoc
class __$$AssessmentImplCopyWithImpl<$Res>
    extends _$AssessmentCopyWithImpl<$Res, _$AssessmentImpl>
    implements _$$AssessmentImplCopyWith<$Res> {
  __$$AssessmentImplCopyWithImpl(
    _$AssessmentImpl _value,
    $Res Function(_$AssessmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? woundId = null,
    Object? date = null,
    Object? pain = null,
    Object? lengthCm = null,
    Object? widthCm = null,
    Object? depthCm = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? notes = freezed,
    Object? exudate = freezed,
    Object? edgeAppearance = freezed,
    Object? woundBed = freezed,
    Object? periwoundSkin = freezed,
    Object? odor = freezed,
    Object? treatmentPlan = freezed,
  }) {
    return _then(
      _$AssessmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        woundId: null == woundId
            ? _value.woundId
            : woundId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        pain: null == pain
            ? _value.pain
            : pain // ignore: cast_nullable_to_non_nullable
                  as int,
        lengthCm: null == lengthCm
            ? _value.lengthCm
            : lengthCm // ignore: cast_nullable_to_non_nullable
                  as double,
        widthCm: null == widthCm
            ? _value.widthCm
            : widthCm // ignore: cast_nullable_to_non_nullable
                  as double,
        depthCm: null == depthCm
            ? _value.depthCm
            : depthCm // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        exudate: freezed == exudate
            ? _value.exudate
            : exudate // ignore: cast_nullable_to_non_nullable
                  as String?,
        edgeAppearance: freezed == edgeAppearance
            ? _value.edgeAppearance
            : edgeAppearance // ignore: cast_nullable_to_non_nullable
                  as String?,
        woundBed: freezed == woundBed
            ? _value.woundBed
            : woundBed // ignore: cast_nullable_to_non_nullable
                  as String?,
        periwoundSkin: freezed == periwoundSkin
            ? _value.periwoundSkin
            : periwoundSkin // ignore: cast_nullable_to_non_nullable
                  as String?,
        odor: freezed == odor
            ? _value.odor
            : odor // ignore: cast_nullable_to_non_nullable
                  as String?,
        treatmentPlan: freezed == treatmentPlan
            ? _value.treatmentPlan
            : treatmentPlan // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssessmentImpl implements _Assessment {
  const _$AssessmentImpl({
    required this.id,
    required this.woundId,
    required this.date,
    required this.pain,
    required this.lengthCm,
    required this.widthCm,
    required this.depthCm,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.exudate,
    this.edgeAppearance,
    this.woundBed,
    this.periwoundSkin,
    this.odor,
    this.treatmentPlan,
  });

  factory _$AssessmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssessmentImplFromJson(json);

  @override
  final String id;
  @override
  final String woundId;
  @override
  final DateTime date;
  @override
  final int pain;
  @override
  final double lengthCm;
  @override
  final double widthCm;
  @override
  final double depthCm;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? notes;
  @override
  final String? exudate;
  @override
  final String? edgeAppearance;
  @override
  final String? woundBed;
  @override
  final String? periwoundSkin;
  @override
  final String? odor;
  @override
  final String? treatmentPlan;

  @override
  String toString() {
    return 'Assessment(id: $id, woundId: $woundId, date: $date, pain: $pain, lengthCm: $lengthCm, widthCm: $widthCm, depthCm: $depthCm, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes, exudate: $exudate, edgeAppearance: $edgeAppearance, woundBed: $woundBed, periwoundSkin: $periwoundSkin, odor: $odor, treatmentPlan: $treatmentPlan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.woundId, woundId) || other.woundId == woundId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.pain, pain) || other.pain == pain) &&
            (identical(other.lengthCm, lengthCm) ||
                other.lengthCm == lengthCm) &&
            (identical(other.widthCm, widthCm) || other.widthCm == widthCm) &&
            (identical(other.depthCm, depthCm) || other.depthCm == depthCm) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.exudate, exudate) || other.exudate == exudate) &&
            (identical(other.edgeAppearance, edgeAppearance) ||
                other.edgeAppearance == edgeAppearance) &&
            (identical(other.woundBed, woundBed) ||
                other.woundBed == woundBed) &&
            (identical(other.periwoundSkin, periwoundSkin) ||
                other.periwoundSkin == periwoundSkin) &&
            (identical(other.odor, odor) || other.odor == odor) &&
            (identical(other.treatmentPlan, treatmentPlan) ||
                other.treatmentPlan == treatmentPlan));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    woundId,
    date,
    pain,
    lengthCm,
    widthCm,
    depthCm,
    createdAt,
    updatedAt,
    notes,
    exudate,
    edgeAppearance,
    woundBed,
    periwoundSkin,
    odor,
    treatmentPlan,
  );

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentImplCopyWith<_$AssessmentImpl> get copyWith =>
      __$$AssessmentImplCopyWithImpl<_$AssessmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssessmentImplToJson(this);
  }
}

abstract class _Assessment implements Assessment {
  const factory _Assessment({
    required final String id,
    required final String woundId,
    required final DateTime date,
    required final int pain,
    required final double lengthCm,
    required final double widthCm,
    required final double depthCm,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? notes,
    final String? exudate,
    final String? edgeAppearance,
    final String? woundBed,
    final String? periwoundSkin,
    final String? odor,
    final String? treatmentPlan,
  }) = _$AssessmentImpl;

  factory _Assessment.fromJson(Map<String, dynamic> json) =
      _$AssessmentImpl.fromJson;

  @override
  String get id;
  @override
  String get woundId;
  @override
  DateTime get date;
  @override
  int get pain;
  @override
  double get lengthCm;
  @override
  double get widthCm;
  @override
  double get depthCm;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get notes;
  @override
  String? get exudate;
  @override
  String? get edgeAppearance;
  @override
  String? get woundBed;
  @override
  String? get periwoundSkin;
  @override
  String? get odor;
  @override
  String? get treatmentPlan;

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssessmentImplCopyWith<_$AssessmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
