import 'package:equatable/equatable.dart';

/// Estados de autenticação
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial - verificando autenticação
class AuthInitial extends AuthState {}

/// Estado de carregamento
class AuthLoading extends AuthState {}

/// Usuário autenticado
class AuthAuthenticated extends AuthState {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  const AuthAuthenticated({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoURL];
}

/// Usuário não autenticado
class AuthUnauthenticated extends AuthState {}

/// Erro de autenticação
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
