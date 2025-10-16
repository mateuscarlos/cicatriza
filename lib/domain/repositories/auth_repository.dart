import '../entities/user_profile.dart';

abstract class AuthRepository {
  /// Stream que monitora mudanças no estado de autenticação
  Stream<UserProfile?> get authStateChanges;

  /// Usuário atual autenticado
  UserProfile? get currentUser;

  /// Login com Google
  Future<UserProfile?> signInWithGoogle();

  /// Login com Microsoft
  Future<UserProfile?> signInWithMicrosoft();

  /// Logout
  Future<void> signOut();

  /// Verificar se usuário está autenticado
  bool get isAuthenticated;
}
