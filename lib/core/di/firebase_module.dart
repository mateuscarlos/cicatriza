import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/firebase_environment_config.dart';
import '../config/google_sign_in_config.dart';
import '../utils/app_logger.dart';

/// Módulo de configuração para serviços Firebase
class FirebaseModule {
  /// Registra todos os serviços Firebase no service locator
  static Future<void> register(GetIt sl) async {
    try {
      // Validar configuração antes de registrar serviços
      if (!FirebaseEnvironmentConfig.validateConfiguration()) {
        throw Exception(
          'Configuração Firebase inválida para ambiente: '
          '${FirebaseEnvironmentConfig.isDevelopment ? "dev" : "prod"}',
        );
      }

      // Log do ambiente atual
      AppLogger.info(
        'Registrando Firebase services para ambiente: '
        '${FirebaseEnvironmentConfig.isDevelopment ? "desenvolvimento" : "produção"}',
      );

      // Firebase Auth com configurações específicas do ambiente
      final auth = FirebaseAuth.instance;
      sl.registerLazySingleton<FirebaseAuth>(() => auth);

      // Firestore com configurações de ambiente
      final firestore = FirebaseFirestore.instance;

      // Configurações específicas por ambiente
      if (FirebaseEnvironmentConfig.isDevelopment) {
        // Em desenvolvimento, pode usar emulador local se configurado
        AppLogger.info('Firestore configurado para desenvolvimento');
      } else {
        // Em produção, garantir configurações otimizadas
        firestore.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        AppLogger.info('Firestore configurado para produção');
      }

      sl.registerLazySingleton<FirebaseFirestore>(() => firestore);

      // Firebase Storage
      sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

      // Firebase Analytics - sempre registrar, mas controlar coleta por ambiente
      sl.registerLazySingleton<FirebaseAnalytics>(
        () => FirebaseAnalytics.instance,
      );

      final analyticsConfig =
          FirebaseEnvironmentConfig.getConfigForCurrentEnvironment(
            FirebaseEnvironmentConfig.loggingConfig,
          );

      if (analyticsConfig['enableAnalytics'] as bool) {
        AppLogger.info('Firebase Analytics habilitado');
      } else {
        AppLogger.info(
          'Firebase Analytics registrado mas coleta desabilitada em desenvolvimento',
        );
      }

      // Google Sign In com configuração de ambiente
      await _registerGoogleSignIn(sl);

      // Log de configuração aplicada
      final debugInfo = FirebaseEnvironmentConfig.debugInfo;
      AppLogger.info(
        'Firebase services registrados com sucesso - '
        'Projeto: ${debugInfo['projectId']}, '
        'Ambiente: ${debugInfo['environment']}',
      );
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Erro ao registrar Firebase services',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Configura Google Sign In baseado na plataforma
  static Future<void> _registerGoogleSignIn(GetIt sl) async {
    final googleSignIn = GoogleSignIn.instance;

    if (kIsWeb) {
      await googleSignIn.initialize();
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          await googleSignIn.initialize(
            serverClientId: GoogleSignInConfig.serverClientId,
          );
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          await googleSignIn.initialize(
            clientId: GoogleSignInConfig.iosClientId,
            serverClientId: GoogleSignInConfig.serverClientId,
          );
        default:
          await googleSignIn.initialize();
      }
    }

    sl.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
  }
}
