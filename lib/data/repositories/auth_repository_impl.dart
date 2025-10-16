import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementação do AuthRepository usando Firebase
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;
  @override
  Stream<UserProfile?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        // Buscar perfil completo do usuário no Firestore
        final userDoc = await _firestore.doc('users/${user.uid}').get();

        if (userDoc.exists) {
          return UserProfile.fromJson({...userDoc.data()!, 'uid': user.uid});
        } else {
          // Criar perfil básico se não existir
          final profile = _createProfileFromFirebaseUser(user);
          await _createUserProfile(profile);
          return profile;
        }
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
    // TODO: Implementar login Google em M1
    throw UnimplementedError(
      'Login com Google será implementado em M1 com configuração completa.',
    );
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
      await _firebaseAuth.signOut();
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
}
