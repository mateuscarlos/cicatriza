// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Media {

 String get id; String get assessmentId; MediaType get type; UploadStatus get uploadStatus; DateTime get createdAt; DateTime get updatedAt; String? get localPath; String? get storagePath; String? get downloadUrl; String? get thumbUrl; int? get width; int? get height; int? get fileSize; String? get mimeType; double get uploadProgress; int get retryCount; String? get errorMessage;
/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaCopyWith<Media> get copyWith => _$MediaCopyWithImpl<Media>(this as Media, _$identity);

  /// Serializes this Media to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Media&&(identical(other.id, id) || other.id == id)&&(identical(other.assessmentId, assessmentId) || other.assessmentId == assessmentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.uploadStatus, uploadStatus) || other.uploadStatus == uploadStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assessmentId,type,uploadStatus,createdAt,updatedAt,localPath,storagePath,downloadUrl,thumbUrl,width,height,fileSize,mimeType,uploadProgress,retryCount,errorMessage);

@override
String toString() {
  return 'Media(id: $id, assessmentId: $assessmentId, type: $type, uploadStatus: $uploadStatus, createdAt: $createdAt, updatedAt: $updatedAt, localPath: $localPath, storagePath: $storagePath, downloadUrl: $downloadUrl, thumbUrl: $thumbUrl, width: $width, height: $height, fileSize: $fileSize, mimeType: $mimeType, uploadProgress: $uploadProgress, retryCount: $retryCount, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $MediaCopyWith<$Res>  {
  factory $MediaCopyWith(Media value, $Res Function(Media) _then) = _$MediaCopyWithImpl;
@useResult
$Res call({
 String id, String assessmentId, MediaType type, UploadStatus uploadStatus, DateTime createdAt, DateTime updatedAt, String? localPath, String? storagePath, String? downloadUrl, String? thumbUrl, int? width, int? height, int? fileSize, String? mimeType, double uploadProgress, int retryCount, String? errorMessage
});




}
/// @nodoc
class _$MediaCopyWithImpl<$Res>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._self, this._then);

  final Media _self;
  final $Res Function(Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assessmentId = null,Object? type = null,Object? uploadStatus = null,Object? createdAt = null,Object? updatedAt = null,Object? localPath = freezed,Object? storagePath = freezed,Object? downloadUrl = freezed,Object? thumbUrl = freezed,Object? width = freezed,Object? height = freezed,Object? fileSize = freezed,Object? mimeType = freezed,Object? uploadProgress = null,Object? retryCount = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assessmentId: null == assessmentId ? _self.assessmentId : assessmentId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MediaType,uploadStatus: null == uploadStatus ? _self.uploadStatus : uploadStatus // ignore: cast_nullable_to_non_nullable
as UploadStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,storagePath: freezed == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,uploadProgress: null == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Media].
extension MediaPatterns on Media {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Media value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Media() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Media value)  $default,){
final _that = this;
switch (_that) {
case _Media():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Media value)?  $default,){
final _that = this;
switch (_that) {
case _Media() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assessmentId,  MediaType type,  UploadStatus uploadStatus,  DateTime createdAt,  DateTime updatedAt,  String? localPath,  String? storagePath,  String? downloadUrl,  String? thumbUrl,  int? width,  int? height,  int? fileSize,  String? mimeType,  double uploadProgress,  int retryCount,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that.id,_that.assessmentId,_that.type,_that.uploadStatus,_that.createdAt,_that.updatedAt,_that.localPath,_that.storagePath,_that.downloadUrl,_that.thumbUrl,_that.width,_that.height,_that.fileSize,_that.mimeType,_that.uploadProgress,_that.retryCount,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assessmentId,  MediaType type,  UploadStatus uploadStatus,  DateTime createdAt,  DateTime updatedAt,  String? localPath,  String? storagePath,  String? downloadUrl,  String? thumbUrl,  int? width,  int? height,  int? fileSize,  String? mimeType,  double uploadProgress,  int retryCount,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _Media():
return $default(_that.id,_that.assessmentId,_that.type,_that.uploadStatus,_that.createdAt,_that.updatedAt,_that.localPath,_that.storagePath,_that.downloadUrl,_that.thumbUrl,_that.width,_that.height,_that.fileSize,_that.mimeType,_that.uploadProgress,_that.retryCount,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assessmentId,  MediaType type,  UploadStatus uploadStatus,  DateTime createdAt,  DateTime updatedAt,  String? localPath,  String? storagePath,  String? downloadUrl,  String? thumbUrl,  int? width,  int? height,  int? fileSize,  String? mimeType,  double uploadProgress,  int retryCount,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that.id,_that.assessmentId,_that.type,_that.uploadStatus,_that.createdAt,_that.updatedAt,_that.localPath,_that.storagePath,_that.downloadUrl,_that.thumbUrl,_that.width,_that.height,_that.fileSize,_that.mimeType,_that.uploadProgress,_that.retryCount,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Media implements Media {
  const _Media({required this.id, required this.assessmentId, required this.type, required this.uploadStatus, required this.createdAt, required this.updatedAt, this.localPath, this.storagePath, this.downloadUrl, this.thumbUrl, this.width, this.height, this.fileSize, this.mimeType, this.uploadProgress = 0.0, this.retryCount = 0, this.errorMessage});
  factory _Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

@override final  String id;
@override final  String assessmentId;
@override final  MediaType type;
@override final  UploadStatus uploadStatus;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? localPath;
@override final  String? storagePath;
@override final  String? downloadUrl;
@override final  String? thumbUrl;
@override final  int? width;
@override final  int? height;
@override final  int? fileSize;
@override final  String? mimeType;
@override@JsonKey() final  double uploadProgress;
@override@JsonKey() final  int retryCount;
@override final  String? errorMessage;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaCopyWith<_Media> get copyWith => __$MediaCopyWithImpl<_Media>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Media&&(identical(other.id, id) || other.id == id)&&(identical(other.assessmentId, assessmentId) || other.assessmentId == assessmentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.uploadStatus, uploadStatus) || other.uploadStatus == uploadStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assessmentId,type,uploadStatus,createdAt,updatedAt,localPath,storagePath,downloadUrl,thumbUrl,width,height,fileSize,mimeType,uploadProgress,retryCount,errorMessage);

@override
String toString() {
  return 'Media(id: $id, assessmentId: $assessmentId, type: $type, uploadStatus: $uploadStatus, createdAt: $createdAt, updatedAt: $updatedAt, localPath: $localPath, storagePath: $storagePath, downloadUrl: $downloadUrl, thumbUrl: $thumbUrl, width: $width, height: $height, fileSize: $fileSize, mimeType: $mimeType, uploadProgress: $uploadProgress, retryCount: $retryCount, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$MediaCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$MediaCopyWith(_Media value, $Res Function(_Media) _then) = __$MediaCopyWithImpl;
@override @useResult
$Res call({
 String id, String assessmentId, MediaType type, UploadStatus uploadStatus, DateTime createdAt, DateTime updatedAt, String? localPath, String? storagePath, String? downloadUrl, String? thumbUrl, int? width, int? height, int? fileSize, String? mimeType, double uploadProgress, int retryCount, String? errorMessage
});




}
/// @nodoc
class __$MediaCopyWithImpl<$Res>
    implements _$MediaCopyWith<$Res> {
  __$MediaCopyWithImpl(this._self, this._then);

  final _Media _self;
  final $Res Function(_Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assessmentId = null,Object? type = null,Object? uploadStatus = null,Object? createdAt = null,Object? updatedAt = null,Object? localPath = freezed,Object? storagePath = freezed,Object? downloadUrl = freezed,Object? thumbUrl = freezed,Object? width = freezed,Object? height = freezed,Object? fileSize = freezed,Object? mimeType = freezed,Object? uploadProgress = null,Object? retryCount = null,Object? errorMessage = freezed,}) {
  return _then(_Media(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assessmentId: null == assessmentId ? _self.assessmentId : assessmentId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MediaType,uploadStatus: null == uploadStatus ? _self.uploadStatus : uploadStatus // ignore: cast_nullable_to_non_nullable
as UploadStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,storagePath: freezed == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,uploadProgress: null == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
