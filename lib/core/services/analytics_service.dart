import 'package:firebase_analytics/firebase_analytics.dart';

import '../utils/app_logger.dart';

/// Serviço centralizado para Firebase Analytics
/// Registra eventos importantes do ciclo de vida do app
class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  /// Observer para navegação (se necessário no futuro)
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // =========================================================================
  // Eventos de Autenticação
  // =========================================================================

  /// Registra login bem-sucedido
  Future<void> logLoginSuccess(String method) async {
    try {
      await _analytics.logLogin(loginMethod: method);
      AppLogger.info('[Analytics] Login success: $method');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao registrar login', error: e);
    }
  }

  /// Registra cadastro bem-sucedido
  Future<void> logSignUpSuccess(String method) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
      AppLogger.info('[Analytics] Sign up success: $method');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao registrar cadastro', error: e);
    }
  }

  /// Registra logout
  Future<void> logLogout() async {
    try {
      await _analytics.logEvent(name: 'logout');
      AppLogger.info('[Analytics] Logout registrado');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao registrar logout', error: e);
    }
  }

  // =========================================================================
  // Eventos do Módulo Clínico
  // =========================================================================

  /// Registra criação de paciente
  Future<void> logPatientCreated() async {
    try {
      await _analytics.logEvent(
        name: 'patient_create',
        parameters: {'timestamp': DateTime.now().toIso8601String()},
      );
      AppLogger.info('[Analytics] patient_create');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao registrar patient_create', error: e);
    }
  }

  /// Registra criação de ferida
  Future<void> logWoundCreated(String woundType) async {
    try {
      await _analytics.logEvent(
        name: 'wound_create',
        parameters: {
          'wound_type': woundType,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      AppLogger.info('[Analytics] wound_create: $woundType');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao registrar wound_create', error: e);
    }
  }

  /// Registra criação de avaliação
  Future<void> logAssessmentCreated({
    required int painLevel,
    required bool hasPhotos,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'assessment_create',
        parameters: {
          'pain_level': painLevel,
          'has_photos': hasPhotos,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      AppLogger.info('[Analytics] assessment_create: pain=$painLevel');
    } catch (e) {
      AppLogger.error(
        '[Analytics] Erro ao registrar assessment_create',
        error: e,
      );
    }
  }

  /// Registra upload de foto
  Future<void> logPhotoUploaded({required int photoCount}) async {
    try {
      await _analytics.logEvent(
        name: 'photo_upload',
        parameters: {
          'photo_count': photoCount,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      AppLogger.info('[Analytics] photo_upload: count=$photoCount');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao registrar photo_upload', error: e);
    }
  }

  // =========================================================================
  // Eventos de Navegação
  // =========================================================================

  /// Registra visualização de tela
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
      AppLogger.info('[Analytics] screen_view: $screenName');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao registrar screen_view', error: e);
    }
  }

  // =========================================================================
  // Propriedades do Usuário
  // =========================================================================

  /// Define o ID do usuário para tracking
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      AppLogger.info('[Analytics] User ID definido: $userId');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao definir user ID', error: e);
    }
  }

  /// Define propriedades personalizadas do usuário
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      AppLogger.info('[Analytics] User property: $name = $value');
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao definir user property', error: e);
    }
  }

  // =========================================================================
  // Configurações
  // =========================================================================

  /// Habilita/desabilita coleta de analytics
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
      AppLogger.info(
        '[Analytics] Coleta ${enabled ? "habilitada" : "desabilitada"}',
      );
    } catch (e) {
      AppLogger.error('[Analytics] Erro ao configurar coleta', error: e);
    }
  }
}
