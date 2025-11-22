import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  /// Criar ou atualizar perfil do usuário no Firestore
  Future<void> createOrUpdateProfile(UserProfile profile);

  /// Buscar perfil por UID
  Future<UserProfile?> getProfile(String uid);

  /// Stream do perfil do usuário atual
  Stream<UserProfile?> watchProfile(String uid);

  /// Verificar se é primeiro login (criar documento users/{uid})
  Future<bool> isFirstLogin(String uid);

  /// Atualizar campos específicos do perfil
  Future<void> updateProfile(String uid, Map<String, dynamic> updates);
}
