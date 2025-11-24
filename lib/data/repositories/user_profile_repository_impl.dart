import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/base/base_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

/// Implementação do UserProfileRepository usando Firestore
final class UserProfileRepositoryImpl extends BaseRepository
    implements UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  String get repositoryName => 'UserProfileRepository';

  @override
  Future<Result<void>> createOrUpdateProfile(UserProfile profile) async {
    return executeOperation(() async {
      validateRequired({'profile': profile, 'uid': profile.uid});

      final userRef = _firestore.doc('users/${profile.uid}');
      final data = profile.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();

      // Se é a primeira vez, incluir createdAt
      final doc = await userRef.get();
      if (!doc.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      await userRef.set(data, SetOptions(merge: true));
    }, operationName: 'createOrUpdateProfile');
  }

  @override
  Future<Result<UserProfile?>> getProfile(String uid) async {
    return executeOperation(() async {
      validateNotEmpty(uid, 'uid');

      final doc = await _firestore.doc('users/$uid').get();

      if (!doc.exists) return null;

      final data = doc.data()!;

      // Não retornar perfis soft-deleted
      if (data.containsKey('deletedAt') && data['deletedAt'] != null) {
        return null;
      }

      return _mapUserProfile(uid, data);
    }, operationName: 'getProfile');
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

      return _mapUserProfile(uid, data);
    });
  }

  @override
  Future<Result<bool>> isFirstLogin(String uid) async {
    return executeOperation(() async {
      validateNotEmpty(uid, 'uid');

      final doc = await _firestore.doc('users/$uid').get();
      return !doc.exists;
    }, operationName: 'isFirstLogin');
  }

  @override
  Future<Result<void>> updateProfile(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    return executeOperation(() async {
      validateNotEmpty(uid, 'uid');
      validateRequired({'updates': updates});

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
    }, operationName: 'updateProfile');
  }

  UserProfile _mapUserProfile(String uid, Map<String, dynamic> data) {
    return UserProfile.fromJson({
      ...data,
      'uid': uid,
      'createdAt': _parseDate(data['createdAt']).toIso8601String(),
      'updatedAt': _parseDate(data['updatedAt']).toIso8601String(),
      'lastAccess': data['lastAccess'] != null
          ? _parseDate(data['lastAccess']).toIso8601String()
          : null,
    });
  }

  DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
