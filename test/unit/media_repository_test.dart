import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/media.dart';
import 'package:cicatriza/domain/repositories/media_repository.dart';

/// Mock implementation of MediaRepository for testing
class MockMediaRepository implements MediaRepository {
  final Map<String, Media> _storage = {};
  final Map<String, List<Media>> _byAssessment = {};

  @override
  Future<Media> createMedia(Media media) async {
    final id = media.id.isEmpty ? 'media-${_storage.length + 1}' : media.id;
    final created = media.copyWith(
      id: id,
      createdAt: media.createdAt,
      updatedAt: DateTime.now(),
    );
    _storage[id] = created;

    // Organize by assessment
    _byAssessment.putIfAbsent(created.assessmentId, () => []);
    _byAssessment[created.assessmentId]!.add(created);

    return created;
  }

  @override
  Future<Media> updateMedia(Media media) async {
    if (!_storage.containsKey(media.id)) {
      throw Exception('Media not found: ${media.id}');
    }
    final updated = media.copyWith(updatedAt: DateTime.now());
    _storage[media.id] = updated;

    // Update in assessment list
    final assessmentMedia = _byAssessment[media.assessmentId];
    if (assessmentMedia != null) {
      final index = assessmentMedia.indexWhere((m) => m.id == media.id);
      if (index != -1) {
        assessmentMedia[index] = updated;
      }
    }

    return updated;
  }

  @override
  Future<void> deleteMedia(String mediaId) async {
    final media = _storage.remove(mediaId);
    if (media != null) {
      _byAssessment[media.assessmentId]?.removeWhere((m) => m.id == mediaId);
    }
  }

  @override
  Future<Media?> getMediaById(String mediaId) async {
    return _storage[mediaId];
  }

  @override
  Future<List<Media>> getMediaByAssessment(String assessmentId) async {
    return List.unmodifiable(_byAssessment[assessmentId] ?? []);
  }

  @override
  Future<List<Media>> getMediaByUploadStatus(UploadStatus status) async {
    return _storage.values.where((m) => m.uploadStatus == status).toList();
  }

  @override
  Future<List<Media>> getPendingUploads() async {
    return getMediaByUploadStatus(UploadStatus.pending);
  }

  @override
  Future<List<Media>> getFailedUploads() async {
    return getMediaByUploadStatus(UploadStatus.failed);
  }

  @override
  Future<Media> updateUploadProgress(String mediaId, double progress) async {
    final media = _storage[mediaId];
    if (media == null) throw Exception('Media not found');
    return updateMedia(
      media.copyWith(
        uploadProgress: progress,
        uploadStatus: UploadStatus.uploading,
      ),
    );
  }

  @override
  Future<Media> completeUpload(
    String mediaId,
    String storagePath,
    String downloadUrl, {
    String? thumbUrl,
  }) async {
    final media = _storage[mediaId];
    if (media == null) throw Exception('Media not found');
    return updateMedia(
      media.copyWith(
        uploadStatus: UploadStatus.completed,
        uploadProgress: 1.0,
        storagePath: storagePath,
        downloadUrl: downloadUrl,
        thumbUrl: thumbUrl,
        errorMessage: null,
      ),
    );
  }

  @override
  Future<Media> failUpload(String mediaId, String errorMessage) async {
    final media = _storage[mediaId];
    if (media == null) throw Exception('Media not found');
    return updateMedia(
      media.copyWith(
        uploadStatus: UploadStatus.failed,
        errorMessage: errorMessage,
        retryCount: media.retryCount + 1,
      ),
    );
  }

  @override
  Stream<List<Media>> watchMediaByAssessment(String assessmentId) {
    return Stream.value(_byAssessment[assessmentId] ?? []);
  }

  @override
  Stream<Media?> watchMedia(String mediaId) {
    return Stream.value(_storage[mediaId]);
  }

  void clear() {
    _storage.clear();
    _byAssessment.clear();
  }
}

void main() {
  group('MediaRepository CRUD Operations', () {
    late MockMediaRepository repository;
    final testCreatedAt = DateTime.now();
    final testUpdatedAt = DateTime.now();

    setUp(() {
      repository = MockMediaRepository();
    });

    tearDown(() {
      repository.clear();
    });

    test('should create media with generated ID', () async {
      final media = Media(
        id: '',
        assessmentId: 'assessment-123',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      final created = await repository.createMedia(media);

      expect(created.id, isNotEmpty);
      expect(created.assessmentId, 'assessment-123');
      expect(created.uploadStatus, UploadStatus.pending);
    });

    test('should create media with provided ID', () async {
      final media = Media(
        id: 'media-custom-id',
        assessmentId: 'assessment-123',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      final created = await repository.createMedia(media);

      expect(created.id, 'media-custom-id');
    });

    test('should retrieve media by ID', () async {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      await repository.createMedia(media);
      final retrieved = await repository.getMediaById('media-123');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'media-123');
      expect(retrieved.assessmentId, 'assessment-456');
    });

    test('should return null when media not found', () async {
      final retrieved = await repository.getMediaById('nonexistent');

      expect(retrieved, isNull);
    });

    test('should update media', () async {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      await repository.createMedia(media);

      final updated = await repository.updateMedia(
        media.copyWith(uploadProgress: 0.5),
      );

      expect(updated.uploadProgress, 0.5);
    });

    test('should delete media', () async {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      await repository.createMedia(media);
      await repository.deleteMedia('media-123');

      final retrieved = await repository.getMediaById('media-123');
      expect(retrieved, isNull);
    });

    test('should get media by assessment', () async {
      final media1 = Media(
        id: 'media-1',
        assessmentId: 'assessment-123',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      final media2 = Media(
        id: 'media-2',
        assessmentId: 'assessment-123',
        type: MediaType.image,
        uploadStatus: UploadStatus.completed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 1.0,
        retryCount: 0,
      );

      final media3 = Media(
        id: 'media-3',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      await repository.createMedia(media1);
      await repository.createMedia(media2);
      await repository.createMedia(media3);

      final mediaList = await repository.getMediaByAssessment('assessment-123');

      expect(mediaList.length, 2);
      expect(mediaList.map((m) => m.id), containsAll(['media-1', 'media-2']));
    });
  });

  group('MediaRepository Upload Management', () {
    late MockMediaRepository repository;
    final testCreatedAt = DateTime.now();
    final testUpdatedAt = DateTime.now();

    setUp(() {
      repository = MockMediaRepository();
    });

    tearDown(() {
      repository.clear();
    });

    test('should update upload progress', () async {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      await repository.createMedia(media);
      final updated = await repository.updateUploadProgress('media-123', 0.75);

      expect(updated.uploadProgress, 0.75);
      expect(updated.uploadStatus, UploadStatus.uploading);
    });

    test('should complete upload', () async {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.uploading,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.8,
        retryCount: 0,
      );

      await repository.createMedia(media);

      final completed = await repository.completeUpload(
        'media-123',
        'storage/path/image.jpg',
        'https://example.com/image.jpg',
        thumbUrl: 'https://example.com/thumb.jpg',
      );

      expect(completed.uploadStatus, UploadStatus.completed);
      expect(completed.uploadProgress, 1.0);
      expect(completed.storagePath, 'storage/path/image.jpg');
      expect(completed.downloadUrl, 'https://example.com/image.jpg');
      expect(completed.thumbUrl, 'https://example.com/thumb.jpg');
    });

    test('should fail upload with error message', () async {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.uploading,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.3,
        retryCount: 0,
      );

      await repository.createMedia(media);

      final failed = await repository.failUpload(
        'media-123',
        'Network connection lost',
      );

      expect(failed.uploadStatus, UploadStatus.failed);
      expect(failed.errorMessage, 'Network connection lost');
      expect(failed.retryCount, 1);
    });

    test('should get pending uploads', () async {
      final pending1 = Media(
        id: 'media-1',
        assessmentId: 'assessment-123',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      final completed = Media(
        id: 'media-2',
        assessmentId: 'assessment-123',
        type: MediaType.image,
        uploadStatus: UploadStatus.completed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 1.0,
        retryCount: 0,
      );

      final pending2 = Media(
        id: 'media-3',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.pending,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 0,
      );

      await repository.createMedia(pending1);
      await repository.createMedia(completed);
      await repository.createMedia(pending2);

      final pendingList = await repository.getPendingUploads();

      expect(pendingList.length, 2);
      expect(pendingList.map((m) => m.id), containsAll(['media-1', 'media-3']));
    });

    test('should get failed uploads', () async {
      final failed1 = Media(
        id: 'media-1',
        assessmentId: 'assessment-123',
        type: MediaType.image,
        uploadStatus: UploadStatus.failed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.0,
        retryCount: 1,
        errorMessage: 'Error 1',
      );

      final completed = Media(
        id: 'media-2',
        assessmentId: 'assessment-123',
        type: MediaType.image,
        uploadStatus: UploadStatus.completed,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 1.0,
        retryCount: 0,
      );

      await repository.createMedia(failed1);
      await repository.createMedia(completed);

      final failedList = await repository.getFailedUploads();

      expect(failedList.length, 1);
      expect(failedList.first.id, 'media-1');
      expect(failedList.first.errorMessage, 'Error 1');
    });

    test('should increment retry count on failed upload', () async {
      final media = Media(
        id: 'media-123',
        assessmentId: 'assessment-456',
        type: MediaType.image,
        uploadStatus: UploadStatus.uploading,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        uploadProgress: 0.5,
        retryCount: 2,
      );

      await repository.createMedia(media);
      final failed = await repository.failUpload('media-123', 'Timeout');

      expect(failed.retryCount, 3);
    });
  });

  group('MediaRepository Query Operations', () {
    late MockMediaRepository repository;
    final testCreatedAt = DateTime.now();
    final testUpdatedAt = DateTime.now();

    setUp(() {
      repository = MockMediaRepository();
    });

    tearDown(() {
      repository.clear();
    });

    test('should get media by upload status', () async {
      final statuses = [
        UploadStatus.pending,
        UploadStatus.uploading,
        UploadStatus.completed,
        UploadStatus.failed,
      ];

      for (var i = 0; i < statuses.length; i++) {
        await repository.createMedia(
          Media(
            id: 'media-$i',
            assessmentId: 'assessment-123',
            type: MediaType.image,
            uploadStatus: statuses[i],
            createdAt: testCreatedAt,
            updatedAt: testUpdatedAt,
            uploadProgress: i == 2 ? 1.0 : 0.0,
            retryCount: 0,
          ),
        );
      }

      final pending = await repository.getMediaByUploadStatus(
        UploadStatus.pending,
      );
      final uploading = await repository.getMediaByUploadStatus(
        UploadStatus.uploading,
      );
      final completed = await repository.getMediaByUploadStatus(
        UploadStatus.completed,
      );
      final failed = await repository.getMediaByUploadStatus(
        UploadStatus.failed,
      );

      expect(pending.length, 1);
      expect(uploading.length, 1);
      expect(completed.length, 1);
      expect(failed.length, 1);
    });

    test('should return empty list when no media found', () async {
      final mediaList = await repository.getMediaByAssessment('nonexistent');

      expect(mediaList, isEmpty);
    });

    test('should handle multiple assessments independently', () async {
      await repository.createMedia(
        Media(
          id: 'media-1',
          assessmentId: 'assessment-A',
          type: MediaType.image,
          uploadStatus: UploadStatus.completed,
          createdAt: testCreatedAt,
          updatedAt: testUpdatedAt,
          uploadProgress: 1.0,
          retryCount: 0,
        ),
      );

      await repository.createMedia(
        Media(
          id: 'media-2',
          assessmentId: 'assessment-B',
          type: MediaType.image,
          uploadStatus: UploadStatus.pending,
          createdAt: testCreatedAt,
          updatedAt: testUpdatedAt,
          uploadProgress: 0.0,
          retryCount: 0,
        ),
      );

      final mediaA = await repository.getMediaByAssessment('assessment-A');
      final mediaB = await repository.getMediaByAssessment('assessment-B');

      expect(mediaA.length, 1);
      expect(mediaB.length, 1);
      expect(mediaA.first.id, 'media-1');
      expect(mediaB.first.id, 'media-2');
    });
  });
}
