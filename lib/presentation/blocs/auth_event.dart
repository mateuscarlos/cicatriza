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

/// Login com Email e Senha
class AuthEmailSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthEmailSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

/// Cadastro com Email e Senha
class AuthEmailSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthEmailSignUpRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

/// Logout
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
