import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

/// Implementação do UserProfileRepository usando Firestore
class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<void> createOrUpdateProfile(UserProfile profile) async {
    try {
      final userRef = _firestore.doc('users/${profile.uid}');

      final profileData = {
        'uid': profile.uid,
        'email': profile.email,
        'displayName': profile.displayName,
        'photoURL': profile.photoURL,
        'crmCofen': profile.crmCofen,
        'specialty': profile.specialty,
        'timezone': profile.timezone,
        'ownerId': profile.ownerId,
        'acl': profile.acl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Se é primeira vez, incluir createdAt
      final doc = await userRef.get();
      if (!doc.exists) {
        profileData['createdAt'] = FieldValue.serverTimestamp();
      }

      await userRef.set(profileData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Erro ao criar/atualizar perfil do usuário: $e');
    }
  }

  @override
  Future<UserProfile?> getProfile(String uid) async {
    try {
      final doc = await _firestore.doc('users/$uid').get();

      if (!doc.exists) return null;

      final data = doc.data()!;

      // Não retornar perfis soft-deleted
      if (data.containsKey('deletedAt') && data['deletedAt'] != null) {
        return null;
      }

      return UserProfile.fromJson({...data, 'uid': uid});
    } catch (e) {
      throw Exception('Erro ao buscar perfil do usuário: $e');
    }
  }

  @override
  Stream<UserProfile?> watchProfile(String uid) {
    return _firestore.doc('users/$uid').snapshots().map((doc) {
      if (!doc.exists) return null;

      final data = doc.data()!;

      // Não retornar perfis soft-deleted
      if (data.containsKey('deletedAt') && data['deletedAt'] != null) {
        return null;
      }

      return UserProfile.fromJson({...data, 'uid': uid});
    });
  }

  @override
  Future<bool> isFirstLogin(String uid) async {
    try {
      final doc = await _firestore.doc('users/$uid').get();
      return !doc.exists;
    } catch (e) {
      // Em caso de erro, assumir que é primeiro login
      return true;
    }
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> updates) async {
    try {
      final userRef = _firestore.doc('users/$uid');

      // Verificar se o documento existe
      final doc = await userRef.get();
      if (!doc.exists) {
        throw Exception('Perfil do usuário não encontrado');
      }

      // Adicionar timestamp de atualização
      final updateData = {
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await userRef.update(updateData);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil do usuário: $e');
    }
  }
}
