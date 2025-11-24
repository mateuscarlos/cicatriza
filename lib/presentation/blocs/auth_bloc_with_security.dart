// ignore_for_file: unused_field, unused_element
// Este é um arquivo de EXEMPLO que demonstra como integrar os serviços de segurança.
// NÃO compile este arquivo diretamente - use-o como referência para modificar o auth_bloc.dart existente.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/encryption_service.dart';
import '../../core/services/rate_limiter_service.dart';
import '../../core/services/session_service.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// EXEMPLO: AuthBloc com funcionalidades de segurança integradas
///
/// Este é um exemplo de como integrar os serviços de segurança no AuthBloc.
/// Para usar este código:
/// 1. Registre os serviços no GetIt (dependency injection)
/// 2. Substitua o AuthBloc atual por este
/// 3. Configure o Firebase Cloud Messaging para notificações
class AuthBlocWithSecurity extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final AnalyticsService _analytics;
  final AuditRepository _auditRepository;
  final SessionService _sessionService;
  final RateLimiterService _rateLimiter;
  final EncryptionService _encryption;

  AuthBlocWithSecurity({
    required AuthRepository authRepository,
    required AnalyticsService analytics,
    required AuditRepository auditRepository,
    required SessionService sessionService,
    required RateLimiterService rateLimiter,
    required EncryptionService encryption,
  }) : _authRepository = authRepository,
       _analytics = analytics,
       _auditRepository = auditRepository,
       _sessionService = sessionService,
       _rateLimiter = rateLimiter,
       _encryption = encryption,
       super(AuthInitial()) {
    on<AuthEmailSignInRequested>(_onEmailSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
  }

  /// Login com Email e Senha (com todas as funcionalidades de segurança)
  Future<void> _onEmailSignInRequested(
    AuthEmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    // 1. RATE LIMITING: Verificar se pode tentar login
    final canAttempt = await _rateLimiter.canPerformAction(
      action: 'login',
      maxAttempts: RateLimits.loginMaxAttempts,
      windowSeconds: RateLimits.loginWindowSeconds,
    );

    if (!canAttempt) {
      final timeRemaining = await _rateLimiter.getTimeUntilNextAttempt(
        action: 'login',
        maxAttempts: RateLimits.loginMaxAttempts,
        windowSeconds: RateLimits.loginWindowSeconds,
      );

      // Registrar tentativa bloqueada no audit log
      await _auditRepository.logAction(
        userId: event.email, // Usa email pois ainda não temos uid
        action: AuditAction.loginFailed,
        metadata: {
          'reason': 'rate_limit_exceeded',
          'timeRemaining': timeRemaining?.inMinutes,
        },
      );

      emit(
        AuthError(
          'Muitas tentativas de login. '
          'Aguarde ${timeRemaining?.inMinutes ?? 0} minutos e tente novamente.',
        ),
      );
      return;
    }

    emit(AuthLoading());

    try {
      // 2. AUTENTICAÇÃO: Tentar fazer login
      final result = await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );

      if (result.isSuccess && result.data != null) {
        final user = result.data!;
        // ✅ LOGIN BEM-SUCEDIDO

        // 3. RATE LIMITING: Limpar tentativas após sucesso
        await _rateLimiter.clearAttempts('login');

        // 4. DETECÇÃO DE NOVO DISPOSITIVO: Verificar se é dispositivo conhecido
        if (await _sessionService.isNewDevice()) {
          // TODO: Enviar notificação push
          // await _fcm.sendNotification(
          //   userId: user.uid,
          //   title: 'Novo login detectado',
          //   body: 'Login de um novo dispositivo foi detectado',
          // );

          // Registrar dispositivo como conhecido
          await _sessionService.registerDevice();
        }

        // 5. GERENCIAMENTO DE SESSÕES: Criar nova sessão
        await _sessionService.createSession(user.uid);

        // 6. AUDITORIA: Registrar login bem-sucedido
        await _auditRepository.logAction(
          userId: user.uid,
          action: AuditAction.login,
          metadata: {
            'loginMethod': 'email',
            'newDevice': await _sessionService.isNewDevice(),
          },
        );

        // 7. ANALYTICS: Registrar evento
        await _analytics.logLoginSuccess('email');
        await _analytics.setUserId(user.uid);

        // Emitir estado autenticado
        emit(
          AuthAuthenticated(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL,
          ),
        );
      } else {
        throw Exception(result.error ?? 'Falha no login com email');
      }
    } on Exception catch (e) {
      // ❌ LOGIN FALHOU

      // 1. RATE LIMITING: Registrar tentativa falha
      await _rateLimiter.recordAttempt('login');

      // 2. AUDITORIA: Registrar falha de login
      await _auditRepository.logAction(
        userId: event.email, // Usa email pois não temos uid
        action: AuditAction.loginFailed,
        metadata: {
          'reason': e.toString(),
          'remainingAttempts': await _getRemainingAttempts('login'),
        },
      );

      // 3. Emitir estado de erro
      final message = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(message));
    }
  }

  /// Logout (com todas as funcionalidades de segurança)
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final currentUser = _authRepository.currentUser;

      // 1. AUDITORIA: Registrar logout
      if (currentUser != null) {
        await _auditRepository.logAction(
          userId: currentUser.uid,
          action: AuditAction.logout,
        );
      }

      // 2. GERENCIAMENTO DE SESSÕES: Encerrar sessão atual
      if (currentUser != null) {
        await _sessionService.endCurrentSession(currentUser.uid);
      }

      // 3. AUTENTICAÇÃO: Fazer logout
      final signOutResult = await _authRepository.signOut();
      if (signOutResult.isFailure) {
        throw Exception(signOutResult.error ?? 'Erro no logout');
      }

      // 4. ANALYTICS: Registrar evento
      await _analytics.logLogout();
      await _analytics.setUserId(null);

      emit(AuthUnauthenticated());
    } on Exception catch (e) {
      emit(AuthError('Erro no logout: $e'));
    }
  }

  /// Reset de senha (com rate limiting e auditoria)
  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    // 1. RATE LIMITING: Verificar se pode solicitar reset
    final canReset = await _rateLimiter.canPerformAction(
      action: 'password_reset',
      maxAttempts: RateLimits.passwordResetMaxAttempts,
      windowSeconds: RateLimits.passwordResetWindowSeconds,
    );

    if (!canReset) {
      final timeRemaining = await _rateLimiter.getTimeUntilNextAttempt(
        action: 'password_reset',
        maxAttempts: RateLimits.passwordResetMaxAttempts,
        windowSeconds: RateLimits.passwordResetWindowSeconds,
      );

      emit(
        AuthError(
          'Muitas solicitações de reset de senha. '
          'Aguarde ${timeRemaining?.inMinutes ?? 0} minutos e tente novamente.',
        ),
      );
      return;
    }

    emit(AuthLoading());

    try {
      // 2. Enviar email de reset
      final resetResult = await _authRepository.sendPasswordResetEmail(
        event.email,
      );
      if (resetResult.isFailure) {
        throw Exception(
          resetResult.error ?? 'Erro ao enviar email de recuperação',
        );
      }

      // 3. RATE LIMITING: Registrar tentativa
      await _rateLimiter.recordAttempt('password_reset');

      // 4. AUDITORIA: Registrar solicitação
      await _auditRepository.logAction(
        userId: event.email,
        action: AuditAction.passwordReset,
        metadata: {'email': event.email},
      );

      emit(const AuthPasswordResetSent());
    } on Exception catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(message));
    }
  }

  /// Helper: Calcula tentativas restantes
  Future<int> _getRemainingAttempts(String action) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'rate_limit_$action';
    final attemptsJson = prefs.getStringList(key) ?? [];

    int maxAttempts;
    int windowSeconds;

    switch (action) {
      case 'login':
        maxAttempts = RateLimits.loginMaxAttempts;
        windowSeconds = RateLimits.loginWindowSeconds;
        break;
      case 'password_reset':
        maxAttempts = RateLimits.passwordResetMaxAttempts;
        windowSeconds = RateLimits.passwordResetWindowSeconds;
        break;
      default:
        return 0;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final windowStart = now - (windowSeconds * 1000);

    final recentAttempts = attemptsJson
        .map((e) => int.parse(e))
        .where((timestamp) => timestamp > windowStart)
        .length;

    return maxAttempts - recentAttempts;
  }
}

/// EXEMPLO: Como registrar os serviços no GetIt
/// 
/// ```dart
/// // lib/core/di/service_locator.dart
/// import 'package:get_it/get_it.dart';
/// 
/// final sl = GetIt.instance;
/// 
/// Future<void> setupServiceLocator() async {
///   // Serviços de segurança
///   sl.registerLazySingleton(() => EncryptionService());
///   sl.registerLazySingleton(() => RateLimiterService());
///   
///   // SessionService precisa de SharedPreferences
///   final prefs = await SharedPreferences.getInstance();
///   sl.registerLazySingleton(() => SessionService(prefs: prefs));
///   
///   // AuditRepository
///   sl.registerLazySingleton<AuditRepository>(
///     () => AuditRepositoryImpl(),
///   );
///   
///   // AuthBloc com todas as dependências
///   sl.registerFactory(
///     () => AuthBlocWithSecurity(
///       authRepository: sl<AuthRepository>(),
///       analytics: sl<AnalyticsService>(),
///       auditRepository: sl<AuditRepository>(),
///       sessionService: sl<SessionService>(),
///       rateLimiter: sl<RateLimiterService>(),
///       encryption: sl<EncryptionService>(),
///     ),
///   );
/// }
/// ```
