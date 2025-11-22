import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cicatriza/core/services/analytics_service.dart';
import 'package:cicatriza/domain/entities/user_profile.dart';
import 'package:cicatriza/domain/repositories/auth_repository.dart';
import 'package:cicatriza/presentation/blocs/auth_bloc.dart';
import 'package:cicatriza/presentation/blocs/auth_event.dart';
import 'package:cicatriza/presentation/blocs/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockAnalyticsService mockAnalyticsService;
  late StreamController<UserProfile?> authStateController;

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
    mockAnalyticsService = MockAnalyticsService();
    authStateController = StreamController<UserProfile?>();

    // Setup default stubs
    when(
      () => mockAuthRepository.authStateChanges,
    ).thenAnswer((_) => authStateController.stream);
    when(
      () => mockAnalyticsService.logLoginSuccess(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockAnalyticsService.logSignUpSuccess(any()),
    ).thenAnswer((_) async {});
    when(() => mockAnalyticsService.setUserId(any())).thenAnswer((_) async {});

    authBloc = AuthBloc(
      authRepository: mockAuthRepository,
      analytics: mockAnalyticsService,
    );
  });

  tearDown(() {
    authStateController.close();
    authBloc.close();
  });

  group('AuthBloc', () {
    const email = 'test@example.com';
    const password = 'password123';

    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AuthEmailSignInRequested succeeds',
      build: () {
        when(
          () => mockAuthRepository.signInWithEmailAndPassword(email, password),
        ).thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthEmailSignInRequested(email: email, password: password),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()
            .having((state) => state.uid, 'uid', testUser.uid)
            .having((state) => state.email, 'email', testUser.email),
      ],
      verify: (_) {
        verify(
          () => mockAuthRepository.signInWithEmailAndPassword(email, password),
        ).called(1);
        verify(() => mockAnalyticsService.logLoginSuccess('email')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when AuthEmailSignInRequested fails',
      build: () {
        when(
          () => mockAuthRepository.signInWithEmailAndPassword(email, password),
        ).thenThrow(Exception('Login failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthEmailSignInRequested(email: email, password: password),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (state) => state.message,
          'message',
          'Login failed',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AuthEmailSignUpRequested succeeds',
      build: () {
        when(
          () => mockAuthRepository.signUpWithEmailAndPassword(email, password),
        ).thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthEmailSignUpRequested(email: email, password: password),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>().having(
          (state) => state.uid,
          'uid',
          testUser.uid,
        ),
      ],
      verify: (_) {
        verify(
          () => mockAuthRepository.signUpWithEmailAndPassword(email, password),
        ).called(1);
        verify(() => mockAnalyticsService.logSignUpSuccess('email')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when AuthEmailSignUpRequested fails',
      build: () {
        when(
          () => mockAuthRepository.signUpWithEmailAndPassword(email, password),
        ).thenThrow(Exception('Signup failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthEmailSignUpRequested(email: email, password: password),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (state) => state.message,
          'message',
          'Signup failed',
        ),
      ],
    );
  });
}
