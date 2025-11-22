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

    // Escutar mudanças de autenticação
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(AuthCheckRequested());
      } else {
        if (state is! AuthUnauthenticated) {
          add(AuthCheckRequested());
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
    } catch (e) {
      emit(AuthError('Erro ao verificar autenticação: $e'));
    }
  }

  /// Login com Google
  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signInWithGoogle();

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
        emit(const AuthError('Falha no login com Google'));
      }
    } catch (e) {
      emit(AuthError('Erro no login com Google: $e'));
    }
  }

  /// Login com Email e Senha
  Future<void> _onEmailSignInRequested(
    AuthEmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );

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
    } catch (e) {
      // Remove "Exception: " prefix if present
      final message = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(message));
    }
  }

  /// Cadastro com Email e Senha
  Future<void> _onEmailSignUpRequested(
    AuthEmailSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        event.email,
        event.password,
        termsAccepted: event.termsAccepted,
        privacyPolicyAccepted: event.privacyPolicyAccepted,
      );

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
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(message));
    }
  }

  /// Logout
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.signOut();
      await _analytics.logLogout();
      await _analytics.setUserId(null);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Erro no logout: $e'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
