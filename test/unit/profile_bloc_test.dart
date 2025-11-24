import 'dart:async';
import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:cicatriza/core/base/base_repository.dart';
import 'package:cicatriza/domain/entities/user_profile.dart';
import 'package:cicatriza/domain/repositories/auth_repository.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_bloc.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_event.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class FakeUploadTask extends Fake implements UploadTask {
  final TaskSnapshot _snapshot;
  FakeUploadTask(this._snapshot);

  @override
  Future<S> then<S>(
    FutureOr<S> Function(TaskSnapshot value) onValue, {
    Function? onError,
  }) async {
    return onValue(_snapshot);
  }
}

class FakeFile extends Fake implements File {}

class FakeUserProfile extends Fake implements UserProfile {}

void main() {
  late ProfileBloc profileBloc;
  late MockAuthRepository mockAuthRepository;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockReference mockReference;
  late MockTaskSnapshot mockTaskSnapshot;

  final testUser = UserProfile(
    uid: 'test_uid',
    email: 'test@example.com',
    displayName: 'Test User',
    ownerId: 'test_uid',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(FakeFile());
    registerFallbackValue(FakeUserProfile());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockFirebaseStorage = MockFirebaseStorage();
    mockReference = MockReference();
    mockTaskSnapshot = MockTaskSnapshot();

    profileBloc = ProfileBloc(
      authRepository: mockAuthRepository,
      firebaseStorage: mockFirebaseStorage,
    );
  });

  tearDown(() {
    profileBloc.close();
  });

  group('ProfileBloc', () {
    test('initial state is ProfileInitial', () {
      expect(profileBloc.state, const ProfileInitial());
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when ProfileLoadRequested succeeds',
      build: () {
        when(() => mockAuthRepository.currentUser).thenReturn(testUser);
        return profileBloc;
      },
      act: (bloc) => bloc.add(const ProfileLoadRequested()),
      expect: () => [const ProfileLoading(), ProfileLoaded(testUser)],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when ProfileLoadRequested fails (no user)',
      build: () {
        when(() => mockAuthRepository.currentUser).thenReturn(null);
        return profileBloc;
      },
      act: (bloc) => bloc.add(const ProfileLoadRequested()),
      expect: () => [
        const ProfileLoading(),
        const ProfileError('Usuário não autenticado'),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileUpdateSuccess, ProfileLoaded] when ProfileUpdateRequested succeeds',
      build: () {
        when(
          () => mockAuthRepository.updateProfile(testUser),
        ).thenAnswer((_) async => const Result.success(null));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileUpdateRequested(testUser)),
      expect: () => [
        const ProfileLoading(),
        ProfileUpdateSuccess(testUser),
        ProfileLoaded(testUser),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when ProfileUpdateRequested fails',
      build: () {
        when(
          () => mockAuthRepository.updateProfile(testUser),
        ).thenAnswer((_) async => const Result.failure('Update failed'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileUpdateRequested(testUser)),
      expect: () => [
        const ProfileLoading(),
        isA<ProfileError>().having(
          (state) => state.message,
          'message',
          contains('Update failed'),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileUpdateSuccess, ProfileLoaded] when ProfileImageUploadRequested succeeds',
      build: () {
        when(() => mockAuthRepository.currentUser).thenReturn(testUser);
        when(() => mockFirebaseStorage.ref()).thenReturn(mockReference);
        when(() => mockReference.child(any())).thenReturn(mockReference);

        final fakeTask = FakeUploadTask(mockTaskSnapshot);
        when(() => mockReference.putFile(any())).thenAnswer((_) => fakeTask);

        when(() => mockTaskSnapshot.ref).thenReturn(mockReference);
        when(
          () => mockReference.getDownloadURL(),
        ).thenAnswer((_) async => 'https://example.com/photo.jpg');

        when(
          () => mockAuthRepository.updateProfile(any()),
        ).thenAnswer((_) async => const Result.success(null));

        return profileBloc;
      },
      act: (bloc) =>
          bloc.add(const ProfileImageUploadRequested('path/to/image.jpg')),
      expect: () => [
        const ProfileLoading(),
        isA<ProfileUpdateSuccess>(),
        isA<ProfileLoaded>(),
      ],
    );
  });
}
