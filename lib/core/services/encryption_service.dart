import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';

/// Serviço para criptografia de dados sensíveis
class EncryptionService {
  static const String _keyString =
      'cicatriza_encryption_key_2025_v1'; // 32 caracteres
  late final enc.Key _key;
  late final enc.IV _iv;
  late final enc.Encrypter _encrypter;

  EncryptionService() {
    // Gera chave de 256 bits a partir da string
    _key = enc.Key.fromUtf8(_keyString.padRight(32).substring(0, 32));
    // IV fixo para simplificar (em produção, use IV por registro)
    _iv = enc.IV.fromLength(16);
    _encrypter = enc.Encrypter(enc.AES(_key));
  }

  /// Criptografa um valor de texto
  String encrypt(String plainText) {
    try {
      if (plainText.isEmpty) return plainText;
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      debugPrint('Erro ao criptografar: $e');
      return plainText; // Retorna original em caso de erro
    }
  }

  /// Descriptografa um valor criptografado
  String decrypt(String encryptedText) {
    try {
      if (encryptedText.isEmpty) return encryptedText;
      final encrypted = enc.Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      debugPrint('Erro ao descriptografar: $e');
      return encryptedText; // Retorna original em caso de erro
    }
  }

  /// Verifica se um texto está criptografado
  bool isEncrypted(String text) {
    if (text.isEmpty) return false;
    try {
      // Tenta decodificar como base64
      enc.Encrypted.fromBase64(text);
      return true;
    } catch (e) {
      return false;
    }
  }
}
