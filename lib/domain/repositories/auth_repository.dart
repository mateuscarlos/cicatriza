import '../entities/user_profile.dart';

abstract class AuthRepository {
  /// Stream que monitora mudanças no estado de autenticação
  Stream<UserProfile?> get authStateChanges;

  /// Usuário atual autenticado
  UserProfile? get currentUser;

  /// Login com Google
  Future<UserProfile?> signInWithGoogle();

  /// Login com Email e Senha
  Future<UserProfile?> signInWithEmailAndPassword(
    String email,
    String password,
  );

  /// Cadastro com Email e Senha
  Future<UserProfile?> signUpWithEmailAndPassword(
    String email,
    String password, {
    bool termsAccepted,
    bool privacyPolicyAccepted,
  });

  /// Logout
  Future<void> signOut();

  /// Atualizar perfil
  Future<void> updateProfile(UserProfile profile);

  /// Verificar se usuário está autenticado
  bool get isAuthenticated;
}
