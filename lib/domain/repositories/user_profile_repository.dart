import '../../core/base/base_repository.dart';
import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  /// Criar ou atualizar perfil do usuário no Firestore
  Future<Result<void>> createOrUpdateProfile(UserProfile profile);

  /// Buscar perfil por UID
  Future<Result<UserProfile?>> getProfile(String uid);

  /// Stream do perfil do usuário atual
  Stream<UserProfile?> watchProfile(String uid);

  /// Verificar se é primeiro login (criar documento users/{uid})
  Future<Result<bool>> isFirstLogin(String uid);

  /// Atualizar campos específicos do perfil
  Future<Result<void>> updateProfile(String uid, Map<String, dynamic> updates);
}
