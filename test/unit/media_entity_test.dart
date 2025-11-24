import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/media.dart';

void main() {
  group('Media Entity', () {
    final testCreatedAt = DateTime.now();
    final testUpdatedAt = DateTime.now();

    test('should create Media with required fields', () {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(media.id, 'media-123');
      expect(media.assessmentId, 'assessment-456');
      expect(media.type, MediaType.image);
      expect(media.uploadStatus, UploadStatus.pending);
      expect(media.uploadProgress, 0.0);
      expect(media.retryCount, 0);
      expect(media.localPath, null);
      expect(media.storagePath, null);
    });

    test('should create Media with all fields', () {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.completed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        localPath: '/local/path/image.jpg',
        storagePath: 'assessments/media-123.jpg',
        downloadUrl: 'https://storage.example.com/image.jpg',
        thumbUrl: 'https://storage.example.com/thumb.jpg',
        width: 1920,
        height: 1080,
        fileSize: 524288,
        mimeType: 'image/jpeg',
        uploadProgress: 1.0,
      );

      expect(media.localPath, '/local/path/image.jpg');
      expect(media.storagePath, 'assessments/media-123.jpg');
      expect(media.downloadUrl, 'https://storage.example.com/image.jpg');
      expect(media.thumbUrl, 'https://storage.example.com/thumb.jpg');
      expect(media.width, 1920);
      expect(media.height, 1080);
      expect(media.fileSize, 524288);
      expect(media.mimeType, 'image/jpeg');
    });

    test('should create copy with modified upload progress', () {
      final original = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.uploading,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.5,
      );

      final modified = original.copyWith(uploadProgress: 0.75);

      expect(modified.id, original.id);
      expect(modified.uploadProgress, 0.75);
      expect(modified.uploadStatus, original.uploadStatus);
    });

    test('should update upload status to completed', () {
      final original = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.uploading,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.8,
      );

      final completed = original.copyWith(
        uploadStatus: UploadStatus.completed,
        uploadProgress: 1.0,
        downloadUrl: 'https://storage.example.com/media-123.jpg',
      );

      expect(completed.uploadStatus, UploadStatus.completed);
      expect(completed.uploadProgress, 1.0);
      expect(
        completed.downloadUrl,
        'https://storage.example.com/media-123.jpg',
      );
    });

    test('should handle failed upload with error message', () {
      final original = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.uploading,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.3,
      );

      final failed = original.copyWith(
        uploadStatus: UploadStatus.failed,
        errorMessage: 'Network connection lost',
        retryCount: 1,
      );

      expect(failed.uploadStatus, UploadStatus.failed);
      expect(failed.errorMessage, 'Network connection lost');
      expect(failed.retryCount, 1);
    });

    test('should serialize to JSON correctly', () {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.completed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        localPath: '/local/image.jpg',
        uploadProgress: 1.0,
      );

      final json = media.toJson();

      expect(json['id'], 'media-123');
      expect(json['assessmentId'], 'assessment-456');
      expect(json['type'], 'image');
      expect(json['uploadStatus'], 'completed');
      expect(json['localPath'], '/local/image.jpg');
      expect(json['uploadProgress'], 1.0);
      expect(json['retryCount'], 0);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'media-123',
        'assessmentId': 'assessment-456',
        'type': 'image',
        'uploadStatus': 'completed',
        'createdAt': testCreatedAt.toIso8601String(),
        'updatedAt': testUpdatedAt.toIso8601String(),
        'localPath': '/local/image.jpg',
        'downloadUrl': 'https://storage.example.com/media-123.jpg',
        'uploadProgress': 1.0,
        'retryCount': 0,
      };

      final media = Media.fromJson(json);

      expect(media.id, 'media-123');
      expect(media.assessmentId, 'assessment-456');
      expect(media.type, MediaType.image);
      expect(media.uploadStatus, UploadStatus.completed);
      expect(media.localPath, '/local/image.jpg');
      expect(media.downloadUrl, 'https://storage.example.com/media-123.jpg');
    });

    test('should handle equality correctly', () {
      final media1 = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.completed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 1.0,
      );

      final media2 = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.completed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 1.0,
      );

      final media3 = Media(
        id: 'media-789',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(media1, media2);
      expect(media1, isNot(media3));
    });

    test('should handle video MediaType', () {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.video,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(media.type, MediaType.video);
    });

    test('should increment retry count on failure', () {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.failed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        retryCount: 2,
      );

      final retried = media.copyWith(
        uploadStatus: UploadStatus.uploading,
        retryCount: 3,
      );

      expect(retried.retryCount, 3);
      expect(retried.uploadStatus, UploadStatus.uploading);
    });
  });
}
