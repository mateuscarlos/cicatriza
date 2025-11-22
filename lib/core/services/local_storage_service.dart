import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/app_logger.dart';

/// Serviço para gerenciar armazenamento local de imagens offline-first
class LocalStorageService {
  LocalStorageService();

  static const String _imagesFolder = 'wound_images';

  /// Solicita permissão de armazenamento no dispositivo
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 13+ não precisa de permissão de storage para app-specific directory
      if (await _isAndroid13OrHigher()) {
        AppLogger.info('[LocalStorage] Android 13+, permissão não necessária');
        return true;
      }

      // Android 12 e anterior
      final status = await Permission.storage.status;

      if (status.isGranted) {
        AppLogger.info(
          '[LocalStorage] Permissão de armazenamento já concedida',
        );
        return true;
      }

      if (status.isDenied) {
        AppLogger.info('[LocalStorage] Solicitando permissão de armazenamento');
        final result = await Permission.storage.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        AppLogger.warning(
          '[LocalStorage] Permissão permanentemente negada, abrindo configurações',
        );
        await Permission.storage.shouldShowRequestRationale;
        return false;
      }

      return false;
    }

    // iOS não precisa de permissão explícita para app directory
    if (Platform.isIOS) {
      AppLogger.info('[LocalStorage] iOS, permissão não necessária');
      return true;
    }

    return true;
  }

  /// Verifica se é Android 13 ou superior
  Future<bool> _isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;

    try {
      // Android 13 = API level 33
      final androidInfo = await Permission.storage.status;
      return androidInfo.isLimited || androidInfo.isGranted;
    } catch (e) {
      AppLogger.error(
        '[LocalStorage] Erro ao verificar versão Android',
        error: e,
      );
      return false;
    }
  }

  /// Obtém o diretório para armazenar imagens localmente
  Future<Directory> getImagesDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, _imagesFolder));

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
      AppLogger.info(
        '[LocalStorage] Diretório de imagens criado: ${imagesDir.path}',
      );
    }

    return imagesDir;
  }

  /// Salva uma imagem localmente e retorna o caminho local
  Future<String> saveImageLocally(String sourcePath, String fileName) async {
    try {
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Permissão de armazenamento negada');
      }

      final imagesDir = await getImagesDirectory();
      final localFile = File(p.join(imagesDir.path, fileName));

      // Copiar arquivo para o diretório local
      final sourceFile = File(sourcePath);
      await sourceFile.copy(localFile.path);

      AppLogger.info(
        '[LocalStorage] Imagem salva localmente: ${localFile.path}',
      );
      return localFile.path;
    } catch (e, stackTrace) {
      AppLogger.error(
        '[LocalStorage] Erro ao salvar imagem localmente',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Verifica se uma imagem existe localmente
  Future<bool> imageExists(String localPath) async {
    try {
      final file = File(localPath);
      return await file.exists();
    } catch (e) {
      AppLogger.error(
        '[LocalStorage] Erro ao verificar existência de imagem',
        error: e,
      );
      return false;
    }
  }

  /// Deleta uma imagem local
  Future<void> deleteImage(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        await file.delete();
        AppLogger.info('[LocalStorage] Imagem deletada: $localPath');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        '[LocalStorage] Erro ao deletar imagem',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Obtém o tamanho de uma imagem em bytes
  Future<int?> getImageSize(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      AppLogger.error(
        '[LocalStorage] Erro ao obter tamanho da imagem',
        error: e,
      );
      return null;
    }
  }

  /// Limpa todas as imagens armazenadas localmente
  Future<void> clearAllImages() async {
    try {
      final imagesDir = await getImagesDirectory();
      if (await imagesDir.exists()) {
        await imagesDir.delete(recursive: true);
        AppLogger.info(
          '[LocalStorage] Todas as imagens locais foram deletadas',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        '[LocalStorage] Erro ao limpar imagens',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Obtém informações sobre o armazenamento usado
  Future<StorageInfo> getStorageInfo() async {
    try {
      final imagesDir = await getImagesDirectory();

      if (!await imagesDir.exists()) {
        return StorageInfo(totalImages: 0, totalSizeBytes: 0);
      }

      final files = await imagesDir
          .list()
          .where((entity) => entity is File)
          .toList();
      int totalSize = 0;

      for (final file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return StorageInfo(totalImages: files.length, totalSizeBytes: totalSize);
    } catch (e, stackTrace) {
      AppLogger.error(
        '[LocalStorage] Erro ao obter informações de armazenamento',
        error: e,
        stackTrace: stackTrace,
      );
      return StorageInfo(totalImages: 0, totalSizeBytes: 0);
    }
  }

  /// Gera um nome de arquivo único para uma imagem
  String generateFileName(String extension) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = extension.startsWith('.') ? extension : '.$extension';
    return 'wound_$timestamp$ext';
  }
}

/// Informações sobre o armazenamento local
class StorageInfo {
  final int totalImages;
  final int totalSizeBytes;

  StorageInfo({required this.totalImages, required this.totalSizeBytes});

  double get totalSizeMB => totalSizeBytes / (1024 * 1024);

  @override
  String toString() {
    return 'StorageInfo(images: $totalImages, size: ${totalSizeMB.toStringAsFixed(2)}MB)';
  }
}
