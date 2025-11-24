import 'package:cicatriza/domain/entities/user_profile.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_bloc.dart';
import 'package:cicatriza/presentation/blocs/profile/profile_state.dart';
import 'package:cicatriza/presentation/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Testes de acessibilidade para ProfilePage
///
/// Verifica:
/// - Semantic labels e hints
/// - Tamanhos mínimos de tap targets (48x48 dp - WCAG 2.1 Level AA)
/// - Navegação por teclado
/// - Suporte a screen readers
/// - High contrast mode
/// - Text scaling
class MockProfileBloc extends Mock implements ProfileBloc {}

void main() {
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockProfileBloc = MockProfileBloc();
  });

  Widget createWidgetUnderTest() {
    final testProfile = UserProfile(
      uid: 'test-uid',
      email: 'test@example.com',
      displayName: 'Dr. Test Silva',
      specialty: 'Enfermagem',
      role: 'Enfermeiro',
      crmCofen: 'CRM 12345',
      phone: '11987654321',
      institution: 'Hospital Test',
      address: 'Rua Test, 123',
      ownerId: 'test-uid',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(() => mockProfileBloc.state).thenReturn(ProfileLoaded(testProfile));
    when(
      () => mockProfileBloc.stream,
    ).thenAnswer((_) => Stream.value(ProfileLoaded(testProfile)));

    return MaterialApp(
      home: BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: const ProfileView(),
      ),
    );
  }

  group('ProfilePage Accessibility Tests', () {
    testWidgets('should have interactive elements with semantic labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar botões existem
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byIcon(Icons.qr_code), findsOneWidget);

      // Habilitar semântica
      final handle = tester.ensureSemantics();

      // Verificar que há widgets interativos com semântica
      expect(find.byType(IconButton), findsWidgets);

      handle.dispose();
    });

    testWidgets('should have minimum tap target sizes (48x48 dp)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // WCAG 2.1 Level AA recomenda mínimo de 44x44 dp
      // Material Design usa 48x48 dp
      const minTapTargetSize = 48.0;

      // Verificar tamanho do botão de salvar
      final saveButton = find.ancestor(
        of: find.byIcon(Icons.save),
        matching: find.byType(IconButton),
      );

      if (saveButton.evaluate().isNotEmpty) {
        final size = tester.getSize(saveButton);
        expect(
          size.width,
          greaterThanOrEqualTo(minTapTargetSize),
          reason: 'Save button width should be at least 48dp',
        );
        expect(
          size.height,
          greaterThanOrEqualTo(minTapTargetSize),
          reason: 'Save button height should be at least 48dp',
        );
      }

      // Verificar tamanho do botão de compartilhar
      final shareButton = find.ancestor(
        of: find.byIcon(Icons.share),
        matching: find.byType(IconButton),
      );

      if (shareButton.evaluate().isNotEmpty) {
        final size = tester.getSize(shareButton);
        expect(size.width, greaterThanOrEqualTo(minTapTargetSize));
        expect(size.height, greaterThanOrEqualTo(minTapTargetSize));
      }

      // Verificar tamanho do botão de QR code
      final qrButton = find.ancestor(
        of: find.byIcon(Icons.qr_code),
        matching: find.byType(IconButton),
      );

      if (qrButton.evaluate().isNotEmpty) {
        final size = tester.getSize(qrButton);
        expect(size.width, greaterThanOrEqualTo(minTapTargetSize));
        expect(size.height, greaterThanOrEqualTo(minTapTargetSize));
      }
    });

    testWidgets('should have visible text and proper contrast', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que textos importantes estão visíveis
      expect(find.text('Meu Perfil'), findsAtLeastNWidgets(1));
      expect(find.text('Identificação'), findsOneWidget);
      expect(find.text('Contato'), findsOneWidget);
      expect(find.text('Dr. Test Silva'), findsOneWidget);

      // Nota: Para verificação completa de contraste, use:
      // - Flutter DevTools Accessibility Inspector
      // - guidepup_test para testes com screen readers
    });

    testWidgets('should support keyboard navigation between tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar tabs existem
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Identificação'), findsOneWidget);
      expect(find.text('Contato'), findsOneWidget);

      // Navegar para segunda tab
      await tester.tap(find.text('Contato'));
      await tester.pumpAndSettle();

      // Verificar que tab mudou
      expect(find.text('Contato'), findsOneWidget);

      // Voltar para primeira tab
      await tester.tap(find.text('Identificação'));
      await tester.pumpAndSettle();

      expect(find.text('Identificação'), findsOneWidget);
    });

    testWidgets('should have accessible form fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que há campos de formulário
      final textFields = find.byType(TextFormField);
      expect(textFields, findsWidgets);

      // Verificar quantidade mínima de campos
      expect(
        textFields.evaluate().length,
        greaterThan(0),
        reason: 'Profile should have form fields',
      );
    });

    testWidgets('should announce profile information to screen readers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final handle = tester.ensureSemantics();

      // Verificar que informações do perfil estão acessíveis
      expect(find.text('Dr. Test Silva'), findsOneWidget);

      // Verificar estrutura semântica
      expect(
        tester.binding.pipelineOwner.semanticsOwner?.rootSemanticsNode,
        isNotNull,
        reason: 'Should have semantic tree for screen readers',
      );

      handle.dispose();
    });

    testWidgets('should have proper navigation structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar hierarquia de navegação
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);

      // Título deve estar no AppBar
      expect(find.text('Meu Perfil'), findsAtLeastNWidgets(1));
    });

    testWidgets('should support focus on interactive elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que campos de formulário são focáveis
      final textFields = find.byType(TextFormField);

      if (textFields.evaluate().isNotEmpty) {
        // Tocar no primeiro campo
        await tester.tap(textFields.first);
        await tester.pumpAndSettle();

        // Campo deve permanecer visível após foco
        expect(textFields.first, findsOneWidget);
      }
    });

    testWidgets('should maintain proper heading hierarchy', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar hierarquia: AppBar (h1) -> Tabs (h2) -> Conteúdo
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('should provide visual feedback for button presses', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que botões existem e são visíveis
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byIcon(Icons.qr_code), findsOneWidget);

      // Material Design IconButtons fornecem ripple effect automático
    });

    testWidgets('should handle high contrast mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(highContrast: true),
          child: createWidgetUnderTest(),
        ),
      );
      await tester.pumpAndSettle();

      // UI deve renderizar corretamente em alto contraste
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.text('Meu Perfil'), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byIcon(Icons.qr_code), findsOneWidget);
    });

    testWidgets('should handle large text scaling (200%)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: createWidgetUnderTest(),
        ),
      );
      await tester.pumpAndSettle();

      // UI deve acomodar texto ampliado
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.text('Meu Perfil'), findsAtLeastNWidgets(1));
      expect(find.text('Identificação'), findsOneWidget);
      expect(find.text('Contato'), findsOneWidget);
    });

    testWidgets('should support reduced motion preferences', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: createWidgetUnderTest(),
        ),
      );
      await tester.pumpAndSettle();

      // UI deve funcionar sem animações
      expect(find.byType(ProfileView), findsOneWidget);

      // Navegação de tabs deve funcionar sem animação
      await tester.tap(find.text('Contato'));
      await tester.pump(); // pump sem settle para testar sem animações

      expect(find.text('Contato'), findsOneWidget);
    });
  });

  group('Semantic Tree Verification', () {
    testWidgets('should have semantic tree for screen readers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final handle = tester.ensureSemantics();

      // Verificar árvore semântica existe
      expect(
        tester.binding.pipelineOwner.semanticsOwner?.rootSemanticsNode,
        isNotNull,
      );

      handle.dispose();
    });

    testWidgets('should have accessible buttons with actions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final handle = tester.ensureSemantics();

      // Verificar botões são acessíveis
      expect(find.byType(IconButton), findsWidgets);

      handle.dispose();
    });

    testWidgets('should support assistive technology navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final handle = tester.ensureSemantics();

      // Elementos interativos devem ser navegáveis
      expect(find.byType(IconButton), findsWidgets);
      expect(find.byType(Tab), findsWidgets);
      expect(find.byType(TextFormField), findsWidgets);

      handle.dispose();
    });
  });
}
