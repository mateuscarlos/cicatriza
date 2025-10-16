import 'package:equatable/equatable.dart';

/// Eventos de autenticação
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Verificar estado atual de autenticação
class AuthCheckRequested extends AuthEvent {}

/// Login com Google
class AuthGoogleSignInRequested extends AuthEvent {}

/// Login com Microsoft
class AuthMicrosoftSignInRequested extends AuthEvent {}

/// Logout
class AuthSignOutRequested extends AuthEvent {}
