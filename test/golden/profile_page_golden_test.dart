import 'package:cicatriza/domain/entities/user_profile.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_bloc.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_state.dart';
import 'package:cicatriza/presentation/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

/// Golden tests para ProfilePage
///
/// Testa a renderização visual em diferentes:
/// - Estados (loading, loaded, error)
/// - Temas (light, dark)
/// - Tamanhos de tela (mobile, tablet)
/// - Dados (perfil completo, parcial, vazio)
class MockProfileBloc extends Mock implements ProfileBloc {}

void main() {
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockProfileBloc = MockProfileBloc();
  });

  UserProfile createTestProfile({
    String? displayName,
    String? photoURL,
    String? specialty,
    String? institution,
  }) {
    return UserProfile(
      uid: 'test-uid',
      email: 'test@example.com',
      displayName: displayName ?? 'Dr. Test Silva',
      specialty: specialty ?? 'Enfermagem',
      role: 'Enfermeiro',
      crmCofen: 'CRM 12345',
      phone: '11987654321',
      photoURL: photoURL,
      institution: institution ?? 'Hospital Test',
      address: 'Rua Test, 123',
      ownerId: 'test-uid',
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );
  }

  Widget createProfileWidget(ProfileState state, {ThemeMode? themeMode}) {
    when(() => mockProfileBloc.state).thenReturn(state);
    when(() => mockProfileBloc.stream).thenAnswer((_) => Stream.value(state));

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode ?? ThemeMode.light,
      home: BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: const ProfileView(),
      ),
    );
  }

  group('ProfilePage Golden Tests - Light Theme', () {
    testGoldens('should render profile page with complete data - light theme', (
      tester,
    ) async {
      final profile = createTestProfile();

      await tester.pumpWidgetBuilder(
        createProfileWidget(ProfileLoaded(profile)),
        surfaceSize: const Size(375, 667), // iPhone SE
      );

      await screenMatchesGolden(tester, 'profile_page_complete_light');
    });

    testGoldens('should render profile page with partial data - light theme', (
      tester,
    ) async {
      final profile = createTestProfile(
        displayName: 'Dr. Test',
      );

      await tester.pumpWidgetBuilder(
        createProfileWidget(ProfileLoaded(profile)),
        surfaceSize: const Size(375, 667),
      );

      await screenMatchesGolden(tester, 'profile_page_partial_light');
    });

    testGoldens('should render error state - light theme', (tester) async {
      await tester.pumpWidgetBuilder(
        createProfileWidget(const ProfileError('Erro ao carregar perfil')),
        surfaceSize: const Size(375, 667),
      );

      await screenMatchesGolden(tester, 'profile_page_error_light');
    });
  });

  group('ProfilePage Golden Tests - Dark Theme', () {
    testGoldens('should render profile page with complete data - dark theme', (
      tester,
    ) async {
      final profile = createTestProfile();

      await tester.pumpWidgetBuilder(
        createProfileWidget(ProfileLoaded(profile), themeMode: ThemeMode.dark),
        surfaceSize: const Size(375, 667),
      );

      await screenMatchesGolden(tester, 'profile_page_complete_dark');
    });

    testGoldens('should render loading state - dark theme', (tester) async {
      await tester.pumpWidgetBuilder(
        createProfileWidget(const ProfileLoading(), themeMode: ThemeMode.dark),
        surfaceSize: const Size(375, 667),
      );

      await screenMatchesGolden(
        tester,
        'profile_page_loading_dark',
        customPump: (tester) async {
          await tester.pump(const Duration(milliseconds: 100));
        },
      );
    });

    testGoldens('should render error state - dark theme', (tester) async {
      await tester.pumpWidgetBuilder(
        createProfileWidget(
          const ProfileError('Erro ao carregar perfil'),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: const Size(375, 667),
      );

      await screenMatchesGolden(tester, 'profile_page_error_dark');
    });
  });

  group('ProfilePage Golden Tests - Different Screen Sizes', () {
    testGoldens('should render on small phone (iPhone SE)', (tester) async {
      final profile = createTestProfile();

      await tester.pumpWidgetBuilder(
        createProfileWidget(ProfileLoaded(profile)),
        surfaceSize: const Size(375, 667), // iPhone SE
      );

      await screenMatchesGolden(tester, 'profile_page_iphone_se');
    });

    testGoldens('should render on large phone (iPhone Pro Max)', (
      tester,
    ) async {
      final profile = createTestProfile();

      await tester.pumpWidgetBuilder(
        createProfileWidget(ProfileLoaded(profile)),
        surfaceSize: const Size(428, 926), // iPhone 14 Pro Max
      );

      await screenMatchesGolden(tester, 'profile_page_iphone_pro_max');
    });

    testGoldens('should render on tablet (iPad)', (tester) async {
      final profile = createTestProfile();

      await tester.pumpWidgetBuilder(
        createProfileWidget(ProfileLoaded(profile)),
        surfaceSize: const Size(768, 1024), // iPad
      );

      await screenMatchesGolden(tester, 'profile_page_ipad');
    });
  });

  group('ProfilePage Golden Tests - Tabs', () {
    testGoldens('should render contact tab', (tester) async {
      final profile = createTestProfile();

      await tester.pumpWidgetBuilder(
        createProfileWidget(ProfileLoaded(profile)),
        surfaceSize: const Size(375, 667),
      );

      // Trocar para a tab de contato
      await tester.tap(find.text('Contato'));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'profile_page_contact_tab');
    });
  });

  group('ProfilePage Golden Tests - Long Names', () {
    testGoldens('should handle very long display name', (tester) async {
      final profile = createTestProfile(
        displayName: 'Dr. João Pedro Alves da Silva Santos Oliveira Junior',
        specialty: 'Enfermagem com Especialização em Tratamento de Feridas',
        institution: 'Hospital Universitário São Paulo - HUSP',
      );

      await tester.pumpWidgetBuilder(
        createProfileWidget(ProfileLoaded(profile)),
        surfaceSize: const Size(375, 667),
      );

      await screenMatchesGolden(tester, 'profile_page_long_text');
    });
  });

  group('ProfilePage Golden Tests - Multi-device Comparison', () {
    testGoldens('should render consistently across multiple devices', (
      tester,
    ) async {
      final profile = createTestProfile();
      final widget = createProfileWidget(ProfileLoaded(profile));

      await tester.pumpWidgetBuilder(widget);

      await multiScreenGolden(
        tester,
        'profile_page_multi_device',
        devices: [
          Device.phone,
          Device.iphone11,
          Device.tabletPortrait,
          Device.tabletLandscape,
        ],
      );
    });

    testGoldens('should render loading state across multiple devices', (
      tester,
    ) async {
      final widget = createProfileWidget(const ProfileLoading());

      await tester.pumpWidgetBuilder(widget);

      await multiScreenGolden(
        tester,
        'profile_page_loading_multi_device',
        devices: [Device.phone, Device.iphone11, Device.tabletPortrait],
        customPump: (tester) async {
          await tester.pump(const Duration(milliseconds: 100));
        },
      );
    });
  });

  group('ProfilePage Golden Tests - Accessibility', () {
    testGoldens('should render with large text scale', (tester) async {
      final profile = createTestProfile();

      await tester.pumpWidgetBuilder(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: createProfileWidget(ProfileLoaded(profile)),
        ),
        surfaceSize: const Size(375, 667),
      );

      await screenMatchesGolden(tester, 'profile_page_large_text');
    });

    testGoldens('should render with extra large text scale', (tester) async {
      final profile = createTestProfile();

      await tester.pumpWidgetBuilder(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3.0)),
          child: createProfileWidget(ProfileLoaded(profile)),
        ),
        surfaceSize: const Size(375, 667),
      );

      await screenMatchesGolden(tester, 'profile_page_extra_large_text');
    });
  });
}
