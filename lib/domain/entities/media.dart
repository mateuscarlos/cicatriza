// ignore_for_file: non_abstract_class_inherits_abstract_member
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

enum MediaType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('document')
  document,
}

enum UploadStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('uploading')
  uploading,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

@freezed
class Media with _$Media {
  const factory Media({
    required String id,
    required String assessmentId,
    required MediaType type,
    required UploadStatus uploadStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? localPath,
    String? storagePath,
    String? downloadUrl,
    String? thumbUrl,
    int? width,
    int? height,
    int? fileSize,
    String? mimeType,
    @Default(0.0) double uploadProgress,
    @Default(0) int retryCount,
    String? errorMessage,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  factory Media.createLocal({
    required String assessmentId,
    required MediaType type,
    required String localPath,
    int? width,
    int? height,
    int? fileSize,
    String? mimeType,
  }) {
    final now = DateTime.now();
    return Media(
      id: '',
      assessmentId: assessmentId,
      type: type,
      uploadStatus: UploadStatus.pending,
      createdAt: now,
      updatedAt: now,
      localPath: localPath,
      width: width,
      height: height,
      fileSize: fileSize,
      mimeType: mimeType,
    );
  }
}
