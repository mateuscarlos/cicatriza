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
  Future<UserProfile?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Usuário não encontrado.');
      }

      final userDoc = await _firestore.doc('users/${user.uid}').get();
      final data = userDoc.data();

      if (data != null) {
        return _mapUserProfile(user, data);
      }

      // Se não tiver perfil (caso raro), cria um básico
      final profile = _createProfileFromFirebaseUser(user);
      await _createUserProfile(profile);
      return profile;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuário não encontrado.';
          break;
        case 'wrong-password':
          message = 'Senha incorreta.';
          break;
        case 'invalid-email':
          message = 'Email inválido.';
          break;
        case 'user-disabled':
          message = 'Usuário desativado.';
          break;
        default:
          message = 'Erro no login: ${e.message ?? e.code}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Erro no login: $e');
    }
  }

  @override
  Future<UserProfile?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Falha ao criar usuário.');
      }

      final profile = _createProfileFromFirebaseUser(user);
      await _createUserProfile(profile);
      return profile;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Este email já está em uso.';
          break;
        case 'invalid-email':
          message = 'Email inválido.';
          break;
        case 'weak-password':
          message = 'A senha é muito fraca.';
          break;
        case 'operation-not-allowed':
          message = 'Operação não permitida.';
          break;
        default:
          message = 'Erro no cadastro: ${e.message ?? e.code}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Erro no cadastro: $e');
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
    } catch (e, stackTrace) {
      AppLogger.error(
        'Erro ao criar perfil do usuário',
        error: e,
        stackTrace: stackTrace,
      );
      // Não relançamos o erro para não bloquear o login,
      // mas o erro fica registrado para monitoramento.
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
