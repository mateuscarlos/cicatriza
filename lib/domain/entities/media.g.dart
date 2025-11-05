// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaImpl _$$MediaImplFromJson(Map<String, dynamic> json) => _$MediaImpl(
  id: json['id'] as String,
  assessmentId: json['assessmentId'] as String,
  type: $enumDecode(_$MediaTypeEnumMap, json['type']),
  uploadStatus: $enumDecode(_$UploadStatusEnumMap, json['uploadStatus']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  localPath: json['localPath'] as String?,
  storagePath: json['storagePath'] as String?,
  downloadUrl: json['downloadUrl'] as String?,
  thumbUrl: json['thumbUrl'] as String?,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  fileSize: (json['fileSize'] as num?)?.toInt(),
  mimeType: json['mimeType'] as String?,
  uploadProgress: (json['uploadProgress'] as num?)?.toDouble() ?? 0.0,
  retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$$MediaImplToJson(_$MediaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assessmentId': instance.assessmentId,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'uploadStatus': _$UploadStatusEnumMap[instance.uploadStatus]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'localPath': instance.localPath,
      'storagePath': instance.storagePath,
      'downloadUrl': instance.downloadUrl,
      'thumbUrl': instance.thumbUrl,
      'width': instance.width,
      'height': instance.height,
      'fileSize': instance.fileSize,
      'mimeType': instance.mimeType,
      'uploadProgress': instance.uploadProgress,
      'retryCount': instance.retryCount,
      'errorMessage': instance.errorMessage,
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.document: 'document',
};

const _$UploadStatusEnumMap = {
  UploadStatus.pending: 'pending',
  UploadStatus.uploading: 'uploading',
  UploadStatus.completed: 'completed',
  UploadStatus.failed: 'failed',
};
