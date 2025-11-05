import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

import '../utils/app_logger.dart';

/// Serviço para gerenciar upload de fotos para Firebase Storage com compressão
class StorageService {
  StorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  // Configurações de compressão
  static const int maxWidth = 1600;
  static const int maxHeight = 1200;
  static const int quality = 80;
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB

  /// Comprime uma imagem para otimizar o upload
  /// Retorna os bytes comprimidos e informações sobre o arquivo
  Future<CompressedImage> compressImage(String localPath) async {
    try {
      final file = File(localPath);

      if (!await file.exists()) {
        throw Exception('Arquivo não encontrado: $localPath');
      }

      final fileSize = await file.length();
      if (fileSize > maxFileSizeBytes) {
        throw Exception(
          'Arquivo muito grande: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB. Máximo: 10MB',
        );
      }

      // Comprimir imagem
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        throw Exception('Falha ao comprimir imagem');
      }

      // Dimensões serão obtidas do image_picker quando disponível
      int? width;
      int? height;

      AppLogger.info(
        'Imagem comprimida: ${file.path.split('/').last} - '
        'Original: ${(fileSize / 1024).toStringAsFixed(2)}KB, '
        'Comprimida: ${(result.length / 1024).toStringAsFixed(2)}KB',
      );

      return CompressedImage(
        bytes: result,
        originalSize: fileSize,
        compressedSize: result.length,
        width: width,
        height: height,
        mimeType: 'image/jpeg',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Erro ao comprimir imagem: $localPath',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Faz upload de uma foto para Firebase Storage
  /// Retorna o storage path, download URL e informações do upload
  Future<UploadResult> uploadPhoto({
    required String ownerId,
    required String patientId,
    required String woundId,
    required String assessmentId,
    required String localPath,
    required Uint8List compressedBytes,
    required String mimeType,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final fileName = _generateFileName(localPath);
      final storagePath =
          'users/$ownerId/patients/$patientId/wounds/$woundId/'
          'assessments/$assessmentId/$fileName';

      final ref = _storage.ref().child(storagePath);

      final metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'patientId': patientId,
          'woundId': woundId,
          'assessmentId': assessmentId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Iniciar upload
      final uploadTask = ref.putData(compressedBytes, metadata);

      // Monitorar progresso
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Aguardar conclusão
      final snapshot = await uploadTask;

      if (snapshot.state != TaskState.success) {
        throw Exception('Upload falhou com status: ${snapshot.state}');
      }

      // Obter URL de download
      final downloadUrl = await ref.getDownloadURL();

      AppLogger.info(
        'Upload concluído: $fileName - ${(compressedBytes.length / 1024).toStringAsFixed(2)}KB',
      );

      return UploadResult(
        storagePath: storagePath,
        downloadUrl: downloadUrl,
        fileName: fileName,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Erro ao fazer upload: $localPath',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Obtém a URL de download de um arquivo no Storage
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Erro ao obter URL de download: $storagePath',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Deleta uma foto do Storage
  Future<void> deletePhoto(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.delete();
      AppLogger.info('Foto deletada: $storagePath');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Erro ao deletar foto: $storagePath',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Gera um nome de arquivo único baseado no timestamp
  String _generateFileName(String localPath) {
    final extension = p.extension(localPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'photo_$timestamp$extension';
  }

  /// Verifica se um arquivo existe no Storage
  Future<bool> fileExists(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Resultado da compressão de imagem
class CompressedImage {
  final Uint8List bytes;
  final int originalSize;
  final int compressedSize;
  final int? width;
  final int? height;
  final String mimeType;

  CompressedImage({
    required this.bytes,
    required this.originalSize,
    required this.compressedSize,
    this.width,
    this.height,
    required this.mimeType,
  });

  double get compressionRatio =>
      originalSize > 0 ? (compressedSize / originalSize) : 1.0;
}

/// Resultado do upload
class UploadResult {
  final String storagePath;
  final String downloadUrl;
  final String fileName;

  UploadResult({
    required this.storagePath,
    required this.downloadUrl,
    required this.fileName,
  });
}
