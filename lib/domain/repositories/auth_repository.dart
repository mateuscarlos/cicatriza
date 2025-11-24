import '../../core/base/base_repository.dart';
import '../entities/user_profile.dart';

abstract class AuthRepository {
  /// Stream que monitora mudanças no estado de autenticação
  Stream<UserProfile?> get authStateChanges;

  /// Usuário atual autenticado
  UserProfile? get currentUser;

  /// Verificar se usuário está autenticado
  bool get isAuthenticated;

  /// Login com Google
  Future<Result<UserProfile?>> signInWithGoogle();

  /// Login com Email e Senha
  Future<Result<UserProfile?>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  /// Cadastro com Email e Senha
  Future<Result<UserProfile?>> signUpWithEmailAndPassword(
    String email,
    String password, {
    bool termsAccepted,
    bool privacyPolicyAccepted,
  });

  /// Logout
  Future<Result<void>> signOut();

  /// Atualizar perfil
  Future<Result<void>> updateProfile(UserProfile profile);

  /// Enviar email de recuperação de senha
  Future<Result<void>> sendPasswordResetEmail(String email);
}
