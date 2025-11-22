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

      // Ensure timestamps are server timestamps for updates if needed,
      // but profile.toJson() has strings.
      // Actually, we should probably let Firestore handle it or convert back to Timestamp?
      // For now, let's use toJson() which returns Map<String, dynamic> with Strings for dates.
      // But wait, if we want ServerTimestamp, we should use FieldValue.
      // The original code used manual map construction.
      // Let's stick to manual map to control what we send, or use toJson and override.

      // Using toJson is safer for new fields.
      final data = profile.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();

      // If it's first time, include createdAt
      final doc = await userRef.get();
      if (!doc.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      await userRef.set(data, SetOptions(merge: true));
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

      return _mapUserProfile(uid, data);
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

      return _mapUserProfile(uid, data);
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
