// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Media _$MediaFromJson(Map<String, dynamic> json) {
  return _Media.fromJson(json);
}

/// @nodoc
mixin _$Media {
  String get id => throw _privateConstructorUsedError;
  String get assessmentId => throw _privateConstructorUsedError;
  MediaType get type => throw _privateConstructorUsedError;
  UploadStatus get uploadStatus => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get localPath => throw _privateConstructorUsedError;
  String? get storagePath => throw _privateConstructorUsedError;
  String? get downloadUrl => throw _privateConstructorUsedError;
  String? get thumbUrl => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  double get uploadProgress => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this Media to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaCopyWith<Media> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaCopyWith<$Res> {
  factory $MediaCopyWith(Media value, $Res Function(Media) then) =
      _$MediaCopyWithImpl<$Res, Media>;
  @useResult
  $Res call({
    String id,
    String assessmentId,
    MediaType type,
    UploadStatus uploadStatus,
    DateTime createdAt,
    DateTime updatedAt,
    String? localPath,
    String? storagePath,
    String? downloadUrl,
    String? thumbUrl,
    int? width,
    int? height,
    int? fileSize,
    String? mimeType,
    double uploadProgress,
    int retryCount,
    String? errorMessage,
  });
}

/// @nodoc
class _$MediaCopyWithImpl<$Res, $Val extends Media>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assessmentId = null,
    Object? type = null,
    Object? uploadStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? localPath = freezed,
    Object? storagePath = freezed,
    Object? downloadUrl = freezed,
    Object? thumbUrl = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? fileSize = freezed,
    Object? mimeType = freezed,
    Object? uploadProgress = null,
    Object? retryCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            assessmentId: null == assessmentId
                ? _value.assessmentId
                : assessmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MediaType,
            uploadStatus: null == uploadStatus
                ? _value.uploadStatus
                : uploadStatus // ignore: cast_nullable_to_non_nullable
                      as UploadStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            localPath: freezed == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            storagePath: freezed == storagePath
                ? _value.storagePath
                : storagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            downloadUrl: freezed == downloadUrl
                ? _value.downloadUrl
                : downloadUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbUrl: freezed == thumbUrl
                ? _value.thumbUrl
                : thumbUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            fileSize: freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            mimeType: freezed == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String?,
            uploadProgress: null == uploadProgress
                ? _value.uploadProgress
                : uploadProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            retryCount: null == retryCount
                ? _value.retryCount
                : retryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MediaImplCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$$MediaImplCopyWith(
    _$MediaImpl value,
    $Res Function(_$MediaImpl) then,
  ) = __$$MediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String assessmentId,
    MediaType type,
    UploadStatus uploadStatus,
    DateTime createdAt,
    DateTime updatedAt,
    String? localPath,
    String? storagePath,
    String? downloadUrl,
    String? thumbUrl,
    int? width,
    int? height,
    int? fileSize,
    String? mimeType,
    double uploadProgress,
    int retryCount,
    String? errorMessage,
  });
}

/// @nodoc
class __$$MediaImplCopyWithImpl<$Res>
    extends _$MediaCopyWithImpl<$Res, _$MediaImpl>
    implements _$$MediaImplCopyWith<$Res> {
  __$$MediaImplCopyWithImpl(
    _$MediaImpl _value,
    $Res Function(_$MediaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assessmentId = null,
    Object? type = null,
    Object? uploadStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? localPath = freezed,
    Object? storagePath = freezed,
    Object? downloadUrl = freezed,
    Object? thumbUrl = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? fileSize = freezed,
    Object? mimeType = freezed,
    Object? uploadProgress = null,
    Object? retryCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$MediaImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        assessmentId: null == assessmentId
            ? _value.assessmentId
            : assessmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MediaType,
        uploadStatus: null == uploadStatus
            ? _value.uploadStatus
            : uploadStatus // ignore: cast_nullable_to_non_nullable
                  as UploadStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        localPath: freezed == localPath
            ? _value.localPath
            : localPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        storagePath: freezed == storagePath
            ? _value.storagePath
            : storagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        downloadUrl: freezed == downloadUrl
            ? _value.downloadUrl
            : downloadUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbUrl: freezed == thumbUrl
            ? _value.thumbUrl
            : thumbUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        fileSize: freezed == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        mimeType: freezed == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String?,
        uploadProgress: null == uploadProgress
            ? _value.uploadProgress
            : uploadProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        retryCount: null == retryCount
            ? _value.retryCount
            : retryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaImpl implements _Media {
  const _$MediaImpl({
    required this.id,
    required this.assessmentId,
    required this.type,
    required this.uploadStatus,
    required this.createdAt,
    required this.updatedAt,
    this.localPath,
    this.storagePath,
    this.downloadUrl,
    this.thumbUrl,
    this.width,
    this.height,
    this.fileSize,
    this.mimeType,
    this.uploadProgress = 0.0,
    this.retryCount = 0,
    this.errorMessage,
  });

  factory _$MediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaImplFromJson(json);

  @override
  final String id;
  @override
  final String assessmentId;
  @override
  final MediaType type;
  @override
  final UploadStatus uploadStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? localPath;
  @override
  final String? storagePath;
  @override
  final String? downloadUrl;
  @override
  final String? thumbUrl;
  @override
  final int? width;
  @override
  final int? height;
  @override
  final int? fileSize;
  @override
  final String? mimeType;
  @override
  @JsonKey()
  final double uploadProgress;
  @override
  @JsonKey()
  final int retryCount;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'Media(id: $id, assessmentId: $assessmentId, type: $type, uploadStatus: $uploadStatus, createdAt: $createdAt, updatedAt: $updatedAt, localPath: $localPath, storagePath: $storagePath, downloadUrl: $downloadUrl, thumbUrl: $thumbUrl, width: $width, height: $height, fileSize: $fileSize, mimeType: $mimeType, uploadProgress: $uploadProgress, retryCount: $retryCount, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assessmentId, assessmentId) ||
                other.assessmentId == assessmentId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.uploadStatus, uploadStatus) ||
                other.uploadStatus == uploadStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.uploadProgress, uploadProgress) ||
                other.uploadProgress == uploadProgress) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    assessmentId,
    type,
    uploadStatus,
    createdAt,
    updatedAt,
    localPath,
    storagePath,
    downloadUrl,
    thumbUrl,
    width,
    height,
    fileSize,
    mimeType,
    uploadProgress,
    retryCount,
    errorMessage,
  );

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaImplCopyWith<_$MediaImpl> get copyWith =>
      __$$MediaImplCopyWithImpl<_$MediaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaImplToJson(this);
  }
}

abstract class _Media implements Media {
  const factory _Media({
    required final String id,
    required final String assessmentId,
    required final MediaType type,
    required final UploadStatus uploadStatus,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? localPath,
    final String? storagePath,
    final String? downloadUrl,
    final String? thumbUrl,
    final int? width,
    final int? height,
    final int? fileSize,
    final String? mimeType,
    final double uploadProgress,
    final int retryCount,
    final String? errorMessage,
  }) = _$MediaImpl;

  factory _Media.fromJson(Map<String, dynamic> json) = _$MediaImpl.fromJson;

  @override
  String get id;
  @override
  String get assessmentId;
  @override
  MediaType get type;
  @override
  UploadStatus get uploadStatus;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get localPath;
  @override
  String? get storagePath;
  @override
  String? get downloadUrl;
  @override
  String? get thumbUrl;
  @override
  int? get width;
  @override
  int? get height;
  @override
  int? get fileSize;
  @override
  String? get mimeType;
  @override
  double get uploadProgress;
  @override
  int get retryCount;
  @override
  String? get errorMessage;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaImplCopyWith<_$MediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
