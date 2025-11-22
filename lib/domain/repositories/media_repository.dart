import '../entities/media.dart';

/// Interface para repositório de mídias
abstract class MediaRepository {
  /// Lista todas as mídias de uma avaliação
  Future<List<Media>> getMediaByAssessment(String assessmentId);

  /// Busca uma mídia por ID
  Future<Media?> getMediaById(String mediaId);

  /// Cria uma nova mídia
  Future<Media> createMedia(Media media);

  /// Atualiza uma mídia existente
  Future<Media> updateMedia(Media media);

  /// Deleta uma mídia
  Future<void> deleteMedia(String mediaId);

  /// Atualiza o progresso de upload
  Future<Media> updateUploadProgress(String mediaId, double progress);

  /// Marca upload como concluído
  Future<Media> completeUpload(
    String mediaId,
    String storagePath,
    String downloadUrl, {
    String? thumbUrl,
  });

  /// Marca upload como falhado
  Future<Media> failUpload(String mediaId, String errorMessage);

  /// Stream de mídias de uma avaliação para atualizações em tempo real
  Stream<List<Media>> watchMediaByAssessment(String assessmentId);

  /// Stream de uma mídia específica
  Stream<Media?> watchMedia(String mediaId);

  /// Lista mídias por status de upload
  Future<List<Media>> getMediaByUploadStatus(UploadStatus status);

  /// Lista mídias pendentes de upload
  Future<List<Media>> getPendingUploads();

  /// Lista mídias que falharam no upload
  Future<List<Media>> getFailedUploads();
}
