import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/utils/app_logger.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementação do AuthRepository usando Firebase
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;
  @override
  Stream<UserProfile?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        // Buscar perfil completo do usuário no Firestore
        final userDoc = await _firestore.doc('users/${user.uid}').get();
        final data = userDoc.data();

        if (data != null) {
          return _mapUserProfile(user, data);
        }

        // Criar perfil básico se não existir
        final profile = _createProfileFromFirebaseUser(user);
        await _createUserProfile(profile);
        return profile;
      } catch (e) {
        // Em caso de erro, retornar perfil básico do Firebase Auth
        return _createProfileFromFirebaseUser(user);
      }
    });
  }

  @override
  UserProfile? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return _createProfileFromFirebaseUser(user);
  }

  @override
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  @override
  Future<UserProfile?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception('Fluxo de autenticação do Google não suportado.');
      }

      final googleUser = await _googleSignIn.authenticate(
        scopeHint: const ['email', 'profile'],
      );

      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception('Token de identificação do Google não disponível.');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Usuário do Firebase não retornado.');
      }

      final userDoc = await _firestore.doc('users/${firebaseUser.uid}').get();
      final data = userDoc.data();

      if (data != null) {
        return _mapUserProfile(firebaseUser, data);
      }

      final profile = _createProfileFromFirebaseUser(firebaseUser);
      await _createUserProfile(profile);
      return profile;
    } on GoogleSignInException catch (e, stackTrace) {
      AppLogger.error(
        'Google Sign-In falhou',
        error: e,
        stackTrace: stackTrace,
      );

      final description = e.description?.trim();
      final isUserCancellation =
          e.code == GoogleSignInExceptionCode.canceled &&
          (description == null || description.isEmpty);

      if (isUserCancellation) {
        return null;
      }

      throw Exception(
        'Erro no login com Google: ${description ?? e.code.name}',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Erro no login com Google: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Erro no login com Google: $e');
    }
  }

  @override
  Future<UserProfile?> signInWithMicrosoft() async {
    try {
      // TODO: Implementar login Microsoft em M1
      // Por enquanto, jogar exceção informativa
      throw UnimplementedError(
        'Login com Microsoft será implementado em M1. '
        'Requer configuração Azure AD + provider personalizado.',
      );
    } catch (e) {
      throw Exception('Erro no login com Microsoft: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw Exception('Erro no logout: $e');
    }
  }

  /// Criar UserProfile a partir do Firebase User
  UserProfile _createProfileFromFirebaseUser(User user) {
    return UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      crmCofen: null,
      specialty: 'Estomaterapia',
      timezone: 'America/Sao_Paulo',
      ownerId: user.uid,
      acl: {
        'roles': {user.uid: 'owner'},
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Criar documento de perfil no Firestore
  Future<void> _createUserProfile(UserProfile profile) async {
    try {
      final userRef = _firestore.doc('users/${profile.uid}');

      await userRef.set({
        'uid': profile.uid,
        'email': profile.email,
        'displayName': profile.displayName,
        'photoURL': profile.photoURL,
        'crmCofen': profile.crmCofen,
        'specialty': profile.specialty,
        'timezone': profile.timezone,
        'ownerId': profile.ownerId,
        'acl': profile.acl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // Log do erro, mas não falhar o login
      // TODO: Implementar logger adequado em M1
      // print('Erro ao criar perfil do usuário: $e');
    }
  }

  UserProfile _mapUserProfile(User user, Map<String, dynamic> data) {
    return UserProfile(
      uid: user.uid,
      email: (data['email'] as String?) ?? user.email ?? '',
      displayName: data['displayName'] as String? ?? user.displayName,
      photoURL: data['photoURL'] as String? ?? user.photoURL,
      crmCofen: data['crmCofen'] as String?,
      specialty: data['specialty'] as String? ?? 'Estomaterapia',
      timezone: data['timezone'] as String? ?? 'America/Sao_Paulo',
      ownerId: data['ownerId'] as String? ?? user.uid,
      acl: Map<String, dynamic>.from(data['acl'] as Map? ?? {}),
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
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
