import 'package:bloc_test/bloc_test.dart';
import 'package:cicatriza/domain/entities/user_profile.dart';
import 'package:cicatriza/domain/repositories/auth_repository.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_bloc.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_event.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProfileBloc profileBloc;
  late MockAuthRepository mockAuthRepository;

  final testUser = UserProfile(
    uid: 'test_uid',
    email: 'test@example.com',
    displayName: 'Test User',
    ownerId: 'test_uid',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    profileBloc = ProfileBloc(authRepository: mockAuthRepository);
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
        ).thenAnswer((_) async {});
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
        ).thenThrow(Exception('Update failed'));
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
  });
}
