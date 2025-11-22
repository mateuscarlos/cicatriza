import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

/// Serviço para configurar e gerenciar Firebase App Check
class AppCheckService {
  static Future<void> initialize() async {
    try {
      AppLogger.info('🔒 Iniciando configuração do Firebase App Check...');

      await FirebaseAppCheck.instance.activate(
        // Para Android - usa Play Integrity em produção e debug token em desenvolvimento
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,

        // Para iOS - usa App Attest em produção e debug token em desenvolvimento
        appleProvider: kDebugMode
            ? AppleProvider.debug
            : AppleProvider.appAttest,

        // Para Web - configurar se necessário
        webProvider: kDebugMode
            ? ReCaptchaV3Provider(
                '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI',
              ) // Test key
            : ReCaptchaV3Provider('YOUR_RECAPTCHA_SITE_KEY'),
      );

      AppLogger.info('✅ Firebase App Check ativado com sucesso');

      // Em modo debug, obter token para configuração inicial
      if (kDebugMode) {
        AppLogger.info('🔍 Modo debug: obtendo token de debug...');
        try {
          final token = await FirebaseAppCheck.instance.getToken();
          if (token != null) {
            AppLogger.info('🎯 App Check Debug Token: $token');
            AppLogger.info(
              '📋 Copie este token e adicione no Firebase Console > App Check > Debug tokens',
            );
          } else {
            AppLogger.info('⚠️ Token de debug não obtido');
          }
        } catch (e) {
          AppLogger.error('❌ Erro ao obter App Check token em debug', error: e);
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Erro ao configurar Firebase App Check',
        error: e,
        stackTrace: stackTrace,
      );

      // Não fazer rethrow para não quebrar a aplicação
      AppLogger.info(
        '⚠️ Continuando sem App Check - configure no Firebase Console',
      );
    }
  }

  /// Obtém o token atual do App Check
  static Future<String?> getToken() async {
    try {
      final appCheckToken = await FirebaseAppCheck.instance.getToken();
      return appCheckToken;
    } catch (e) {
      AppLogger.error('Erro ao obter App Check token', error: e);
      return null;
    }
  }

  /// Força a renovação do token
  static Future<void> refreshToken() async {
    try {
      await FirebaseAppCheck.instance.getToken();
      AppLogger.info('App Check token renovado com sucesso');
    } catch (e) {
      AppLogger.error('Erro ao renovar App Check token', error: e);
    }
  }
}
