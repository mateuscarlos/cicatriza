import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/base/base_repository.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementação do AuthRepository usando Firebase
final class AuthRepositoryImpl extends BaseRepository
    implements AuthRepository {
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
  String get repositoryName => 'AuthRepository';
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
      } on Exception {
        // Em caso de erro, retornar perfil básico do Firebase Auth
        return _createProfileFromFirebaseUser(user);
      }
    });
  }

  @override
  UserProfile? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    // Retorna um perfil básico baseado no Firebase Auth
    // Para dados atualizados, use getCurrentUserAsync()
    return _createProfileFromFirebaseUser(user);
  }

  /// Busca o perfil completo do usuário atual do Firestore (assíncrono)
  Future<UserProfile?> getCurrentUserAsync() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.doc('users/${user.uid}').get();
      final data = userDoc.data();

      if (data != null) {
        return _mapUserProfile(user, data);
      }

      // Se não existe no Firestore, cria um perfil básico
      return _createProfileFromFirebaseUser(user);
    } catch (e) {
      AppLogger.error('Erro ao buscar perfil atual do usuário', error: e);
      return _createProfileFromFirebaseUser(user);
    }
  }

  @override
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  @override
  Future<Result<UserProfile?>> signInWithGoogle() async {
    return executeOperation(() async {
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
      } on GoogleSignInException catch (e) {
        final description = e.description?.trim();
        final isUserCancellation =
            e.code == GoogleSignInExceptionCode.canceled &&
            (description == null || description.isEmpty);

        if (isUserCancellation) {
          return null; // Usuário cancelou, retorna null
        }

        throw Exception(
          'Erro no login com Google: ${description ?? e.code.name}',
        );
      } on FirebaseAuthException catch (e) {
        throw Exception('Erro no login com Google: ${e.message ?? e.code}');
      }
    }, operationName: 'signInWithGoogle');
  }

  @override
  Future<Result<UserProfile?>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return executeOperation(() async {
      validateNotEmpty(email, 'email');
      validateNotEmpty(password, 'password');

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
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
    }, operationName: 'signInWithEmailAndPassword');
  }

  @override
  Future<Result<UserProfile?>> signUpWithEmailAndPassword(
    String email,
    String password, {
    bool termsAccepted = false,
    bool privacyPolicyAccepted = false,
  }) async {
    return executeOperation(() async {
      validateNotEmpty(email, 'email');
      validateNotEmpty(password, 'password');

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Falha ao criar usuário.');
      }

      final now = DateTime.now();
      final profile = _createProfileFromFirebaseUser(
        user,
        termsAccepted: termsAccepted,
        privacyPolicyAccepted: privacyPolicyAccepted,
        acceptedAt: now,
      );
      await _createUserProfile(profile);
      return profile;
    }, operationName: 'signUpWithEmailAndPassword');
  }

  @override
  Future<Result<void>> updateProfile(UserProfile profile) async {
    return executeOperation(() async {
      validateRequired({'profile': profile});
      await _createUserProfile(profile);
    }, operationName: 'updateProfile');
  }

  @override
  Future<Result<void>> signOut() async {
    return executeOperation(() async {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    }, operationName: 'signOut');
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    return executeOperation(() async {
      validateNotEmpty(email, 'email');
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    }, operationName: 'sendPasswordResetEmail');
  }

  /// Criar UserProfile a partir do Firebase User
  UserProfile _createProfileFromFirebaseUser(
    User user, {
    bool termsAccepted = false,
    bool privacyPolicyAccepted = false,
    DateTime? acceptedAt,
  }) {
    final now = acceptedAt ?? DateTime.now();
    return UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      ownerId: user.uid,
      createdAt: now,
      updatedAt: now,
      lgpdConsent: termsAccepted && privacyPolicyAccepted,
      termsAccepted: termsAccepted,
      termsAcceptedAt: termsAccepted ? now : null,
      privacyPolicyAccepted: privacyPolicyAccepted,
      privacyPolicyAcceptedAt: privacyPolicyAccepted ? now : null,
    );
  }

  /// Criar documento de perfil no Firestore
  Future<void> _createUserProfile(UserProfile profile) async {
    try {
      final userRef = _firestore.doc('users/${profile.uid}');

      await userRef.set(profile.toJson(), SetOptions(merge: true));
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Erro ao criar/atualizar perfil do usuário',
        error: e,
        stackTrace: stackTrace,
      );
      // Não relançamos o erro para não bloquear o login,
      // mas o erro fica registrado para monitoramento.
    }
  }

  UserProfile _mapUserProfile(User user, Map<String, dynamic> data) {
    return UserProfile.fromJson({
      ...data,
      'uid': user.uid,
      'email': (data['email'] as String?) ?? user.email ?? '',
      'displayName': data['displayName'] as String? ?? user.displayName,
      'photoURL': data['photoURL'] as String? ?? user.photoURL,
      'ownerId': (data['ownerId'] as String?) ?? user.uid,
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
