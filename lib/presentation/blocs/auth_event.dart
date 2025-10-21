import 'package:equatable/equatable.dart';

/// Eventos de autenticação
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Verificar estado atual de autenticação
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Login com Google
class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

/// Login com Microsoft
class AuthMicrosoftSignInRequested extends AuthEvent {
  const AuthMicrosoftSignInRequested();
}

/// Logout
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
