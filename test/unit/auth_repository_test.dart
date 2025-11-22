import 'package:cicatriza/data/repositories/auth_repository_impl.dart';
import 'package:cicatriza/domain/entities/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockDocumentReference mockUserDocRef;
  late MockDocumentSnapshot mockUserDocSnapshot;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockUserDocRef = MockDocumentReference();
    mockUserDocSnapshot = MockDocumentSnapshot();

    authRepository = AuthRepositoryImpl(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
      googleSignIn: mockGoogleSignIn,
    );

    // Setup default mocks
    when(() => mockUser.uid).thenReturn('test_uid');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.photoURL).thenReturn('http://photo.url');

    when(() => mockFirestore.doc(any())).thenReturn(mockUserDocRef);
    when(
      () => mockUserDocRef.get(),
    ).thenAnswer((_) async => mockUserDocSnapshot);
    when(() => mockUserDocRef.set(any(), any())).thenAnswer((_) async => {});
  });

  group('AuthRepositoryImpl', () {
    const email = 'test@example.com';
    const password = 'password123';

    group('signInWithEmailAndPassword', () {
      test(
        'should return UserProfile when login is successful and profile exists',
        () async {
          // Arrange
          when(
            () => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          when(() => mockUserCredential.user).thenReturn(mockUser);

          when(() => mockUserDocSnapshot.data()).thenReturn({
            'uid': 'test_uid',
            'email': email,
            'displayName': 'Test User',
            'photoURL': 'http://photo.url',
            'createdAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
          });

          // Act
          final result = await authRepository.signInWithEmailAndPassword(
            email,
            password,
          );

          // Assert
          expect(result, isA<UserProfile>());
          expect(result?.uid, 'test_uid');
          expect(result?.email, email);
          verify(
            () => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).called(1);
        },
      );

      test(
        'should create basic profile when login is successful but profile does not exist',
        () async {
          // Arrange
          when(
            () => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          when(() => mockUserCredential.user).thenReturn(mockUser);
          when(() => mockUserDocSnapshot.data()).thenReturn(null); // No profile

          // Act
          final result = await authRepository.signInWithEmailAndPassword(
            email,
            password,
          );

          // Assert
          expect(result, isA<UserProfile>());
          expect(result?.uid, 'test_uid');
          verify(() => mockUserDocRef.set(any(), any())).called(1);
        },
      );

      test(
        'should throw Exception when FirebaseAuthException occurs',
        () async {
          // Arrange
          when(
            () => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

          // Act & Assert
          expect(
            () => authRepository.signInWithEmailAndPassword(email, password),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('signUpWithEmailAndPassword', () {
      test(
        'should return UserProfile and create doc when signup is successful',
        () async {
          // Arrange
          when(
            () => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          when(() => mockUserCredential.user).thenReturn(mockUser);

          // Act
          final result = await authRepository.signUpWithEmailAndPassword(
            email,
            password,
          );

          // Assert
          expect(result, isA<UserProfile>());
          expect(result?.uid, 'test_uid');
          verify(
            () => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).called(1);
          verify(() => mockUserDocRef.set(any(), any())).called(1);
        },
      );

      test(
        'should throw Exception when FirebaseAuthException occurs',
        () async {
          // Arrange
          when(
            () => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

          // Act & Assert
          expect(
            () => authRepository.signUpWithEmailAndPassword(email, password),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
