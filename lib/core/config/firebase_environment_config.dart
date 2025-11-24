/// Firebase Environment Configuration - Cicatriza
///
/// Gerencia configurações específicas por ambiente (dev/prod)
/// Substitui o firebase_options.dart com configuração dinâmica
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Configuração centralizada de ambiente do Firebase
class FirebaseEnvironmentConfig {
  static const String _environment = String.fromEnvironment(
    'FIREBASE_ENV',
    defaultValue: kDebugMode ? 'dev' : 'prod',
  );

  /// Determina se está em ambiente de desenvolvimento
  static bool get isDevelopment => _environment == 'dev';

  /// Determina se está em ambiente de produção
  static bool get isProduction => _environment == 'prod';

  /// Configurações específicas do projeto Firebase para desenvolvimento
  static const FirebaseOptions _developmentOptions = FirebaseOptions(
    apiKey: 'AIzaSyDKFBsxPCBM9Mxz1cAt_6q38789fFv8wDY',
    appId: '1:48729747381:android:57192ff1f79b281c93b3fc',
    messagingSenderId: '48729747381',
    projectId: 'cicatriza-dev-b1085',
    storageBucket: 'cicatriza-dev-b1085.firebasestorage.app',

    // Android específico
    androidClientId:
        '48729747381-ks0u6mee48skm9903to3oqhgokr4erhp.apps.googleusercontent.com',

    // iOS específico
    iosClientId:
        '48729747381-1qqkmh8vagrjevc4fbihpa42t13t3fp9.apps.googleusercontent.com',
    iosBundleId: 'com.example.cicatriza',
  );

  /// Configurações específicas do projeto Firebase para produção
  static const FirebaseOptions _productionOptions = FirebaseOptions(
    apiKey: 'AIzaSyProductionKey', // Substitua pela chave de prod
    appId: '1:prod-project:android:prod-app-id',
    messagingSenderId: 'prod-sender-id',
    projectId: 'cicatriza-prod',
    storageBucket: 'cicatriza-prod.appspot.com',

    // Android específico
    androidClientId: 'prod-android-client-id.apps.googleusercontent.com',

    // iOS específico
    iosClientId: 'prod-ios-client-id.apps.googleusercontent.com',
    iosBundleId: 'com.cicatriza.app',
  );

  /// Retorna as opções Firebase para o ambiente atual
  static FirebaseOptions get currentOptions {
    return isDevelopment ? _developmentOptions : _productionOptions;
  }

  /// Configurações de App Check por ambiente
  static Map<String, dynamic> get appCheckConfig {
    return {
      'dev': {
        'provider': 'debug',
        'debugToken':
            'debug-token-for-development', // Substitua pelo token de debug
      },
      'prod': {
        'provider': 'recaptcha',
        'siteKey':
            'prod-recaptcha-site-key', // Substitua pela chave do reCAPTCHA
      },
    };
  }

  /// Configurações de autenticação por ambiente
  static Map<String, dynamic> get authConfig {
    return {
      'dev': {
        'enablePersistence': true,
        'allowTestUsers': true,
        'requireEmailVerification': false, // Relaxado para desenvolvimento
      },
      'prod': {
        'enablePersistence': true,
        'allowTestUsers': false,
        'requireEmailVerification': true, // Obrigatório em produção
      },
    };
  }

  /// Configurações de logging por ambiente
  static Map<String, dynamic> get loggingConfig {
    return {
      'dev': {
        'level': 'debug',
        'enableCrashlytics': false,
        'enableAnalytics': false,
        'logToConsole': true,
      },
      'prod': {
        'level': 'info',
        'enableCrashlytics': true,
        'enableAnalytics': true,
        'logToConsole': false,
      },
    };
  }

  /// Configurações de performance por ambiente
  static Map<String, dynamic> get performanceConfig {
    return {
      'dev': {
        'enablePerformanceMonitoring': false,
        'enableNetworkMonitoring': true,
        'traceLength': 100, // Mais traces para debug
      },
      'prod': {
        'enablePerformanceMonitoring': true,
        'enableNetworkMonitoring': true,
        'traceLength': 50, // Menos traces para otimizar
      },
    };
  }

  /// Retorna configuração específica para o ambiente atual
  static T getConfigForCurrentEnvironment<T>(Map<String, T> configs) {
    final currentEnv = isDevelopment ? 'dev' : 'prod';
    return configs[currentEnv] ?? configs['prod']!;
  }

  /// Informações de debug sobre o ambiente atual
  static Map<String, dynamic> get debugInfo {
    return {
      'environment': _environment,
      'isDevelopment': isDevelopment,
      'isProduction': isProduction,
      'projectId': currentOptions.projectId,
      'appId': currentOptions.appId,
      'debugMode': kDebugMode,
      'releaseMode': kReleaseMode,
    };
  }

  /// Valida se a configuração está correta
  static bool validateConfiguration() {
    try {
      // Verificar se as opções básicas estão definidas
      final options = currentOptions;
      if (options.projectId.isEmpty ||
          options.apiKey.isEmpty ||
          options.appId.isEmpty) {
        return false;
      }

      // Em desenvolvimento, permitir valores placeholder para testes
      if (isDevelopment) {
        return true; // Aceitar qualquer configuração válida em dev
      }

      // Em produção, verificar se não está usando valores placeholder
      if (options.apiKey.contains('Development') ||
          options.apiKey.contains('Production') ||
          options.projectId.contains('dev')) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Extension para facilitar o uso das configurações
extension FirebaseConfigExtension on FirebaseApp {
  /// Verifica se a app está configurada para desenvolvimento
  bool get isDevelopmentApp {
    return FirebaseEnvironmentConfig.isDevelopment;
  }

  /// Verifica se a app está configurada para produção
  bool get isProductionApp {
    return FirebaseEnvironmentConfig.isProduction;
  }
}
