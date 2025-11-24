import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/analytics_service.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC para gerenciar estado de autenticação
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final AnalyticsService _analytics;
  late StreamSubscription<UserProfile?> _authSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required AnalyticsService analytics,
  }) : _authRepository = authRepository,
       _analytics = analytics,
       super(AuthInitial()) {
    // Registrar handlers de eventos
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthEmailSignInRequested>(_onEmailSignInRequested);
    on<AuthEmailSignUpRequested>(_onEmailSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);

    // Escutar mudanças de autenticação
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(const AuthCheckRequested());
      } else {
        if (state is! AuthUnauthenticated) {
          add(const AuthCheckRequested());
        }
      }
    });
  }

  /// Verificar estado atual de autenticação
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = _authRepository.currentUser;

      if (user != null) {
        emit(
          AuthAuthenticated(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL,
          ),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    } on Exception catch (e) {
      emit(AuthError('Erro ao verificar autenticação: $e'));
    }
  }

  /// Login com Google
  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.signInWithGoogle();

    if (result.isSuccess) {
      final user = result.data;
      if (user != null) {
        // Registrar evento de login bem-sucedido
        await _analytics.logLoginSuccess('google');
        await _analytics.setUserId(user.uid);

        emit(
          AuthAuthenticated(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL,
          ),
        );
      } else {
        // Usuário cancelou o login
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthError(result.error ?? 'Erro no login com Google'));
    }
  }

  /// Login com Email e Senha
  Future<void> _onEmailSignInRequested(
    AuthEmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.signInWithEmailAndPassword(
      event.email,
      event.password,
    );

    if (result.isSuccess) {
      final user = result.data;
      if (user != null) {
        await _analytics.logLoginSuccess('email');
        await _analytics.setUserId(user.uid);

        emit(
          AuthAuthenticated(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL,
          ),
        );
      } else {
        emit(const AuthError('Falha no login com email'));
      }
    } else {
      emit(AuthError(result.error ?? 'Erro no login com email'));
    }
  }

  /// Cadastro com Email e Senha
  Future<void> _onEmailSignUpRequested(
    AuthEmailSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.signUpWithEmailAndPassword(
      event.email,
      event.password,
      termsAccepted: event.termsAccepted,
      privacyPolicyAccepted: event.privacyPolicyAccepted,
    );

    if (result.isSuccess) {
      final user = result.data;
      if (user != null) {
        await _analytics.logSignUpSuccess('email');
        await _analytics.setUserId(user.uid);

        emit(
          AuthAuthenticated(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL,
          ),
        );
      } else {
        emit(const AuthError('Falha no cadastro com email'));
      }
    } else {
      emit(AuthError(result.error ?? 'Erro no cadastro com email'));
    }
  }

  /// Logout
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.signOut();

    if (result.isSuccess) {
      await _analytics.logLogout();
      await _analytics.setUserId(null);
      emit(AuthUnauthenticated());
    } else {
      emit(AuthError(result.error ?? 'Erro no logout'));
    }
  }

  /// Recuperação de senha
  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.sendPasswordResetEmail(event.email);

    if (result.isSuccess) {
      emit(const AuthPasswordResetSent());
    } else {
      emit(AuthError(result.error ?? 'Erro ao enviar email de recuperação'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
