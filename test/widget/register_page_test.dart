import 'package:cicatriza/presentation/blocs/auth_bloc.dart';
import 'package:cicatriza/presentation/blocs/auth_event.dart';
import 'package:cicatriza/presentation/blocs/auth_state.dart';
import 'package:cicatriza/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEmailSignUpRequested(email: '', password: ''),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Dummy Page')),
        );
      },
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const RegisterPage(),
      ),
    );
  }

  group('RegisterPage', () {
    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Crie sua conta'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // email, password, confirm
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Confirmar Senha'), findsOneWidget);
    });

    testWidgets('renders terms and privacy checkboxes', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Eu li e aceito os '), findsOneWidget);
      expect(find.text('Eu li e aceito a '), findsOneWidget);
      expect(find.text('Termos de Uso'), findsOneWidget);
      expect(find.text('Política de Privacidade'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNWidgets(2));
    });

    testWidgets('validates empty email', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final button = find.text('CADASTRAR');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Por favor, insira seu email'), findsOneWidget);
    });

    testWidgets('validates invalid email format', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalid-email',
      );
      final button = find.text('CADASTRAR');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Email inválido'), findsOneWidget);
    });

    testWidgets('validates empty password', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      final button = find.text('CADASTRAR');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Por favor, insira sua senha'), findsOneWidget);
    });

    testWidgets('validates password length', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'short',
      );
      final button = find.text('CADASTRAR');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.text('A senha deve ter pelo menos 8 caracteres'),
        findsOneWidget,
      );
    });

    testWidgets('validates password complexity', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'password',
      );
      final button = find.text('CADASTRAR');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.text('A senha deve conter pelo menos uma letra maiúscula'),
        findsOneWidget,
      );
    });

    testWidgets('validates password confirmation', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirmar Senha'),
        'DifferentPass123!',
      );
      final button = find.text('CADASTRAR');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('As senhas não coincidem'), findsOneWidget);
    });

    testWidgets('shows error when terms not accepted', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirmar Senha'),
        'Password123!',
      );

      // Check privacy but not terms
      // Tap the checkbox specifically to avoid hitting the link
      final privacyCheckbox = find.byType(Checkbox).last;
      await tester.ensureVisible(privacyCheckbox);
      await tester.tap(privacyCheckbox);
      await tester.pumpAndSettle();

      final button = find.text('CADASTRAR');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.text('Você deve aceitar os Termos de Uso para continuar'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when privacy policy not accepted', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirmar Senha'),
        'Password123!',
      );

      // Check terms but not privacy
      final termsCheckbox = find.byType(Checkbox).first;
      await tester.ensureVisible(termsCheckbox);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();

      final button = find.text('CADASTRAR');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.text('Você deve aceitar a Política de Privacidade para continuar'),
        findsOneWidget,
      );
    });

    testWidgets(
      'dispatches signup event when form is valid and terms accepted',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          'Password123!',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar Senha'),
          'Password123!',
        );

        // Accept both terms and privacy
        final termsCheckbox = find.byType(Checkbox).first;
        final privacyCheckbox = find.byType(Checkbox).last;

        await tester.ensureVisible(termsCheckbox);
        await tester.tap(termsCheckbox);
        await tester.pumpAndSettle();

        await tester.ensureVisible(privacyCheckbox);
        await tester.tap(privacyCheckbox);
        await tester.pumpAndSettle();

        final button = find.text('CADASTRAR');
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pumpAndSettle();

        verify(
          () => mockAuthBloc.add(any(that: isA<AuthEmailSignUpRequested>())),
        ).called(1);
      },
    );

    testWidgets('toggles password visibility', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final passwordField = find.widgetWithText(TextFormField, 'Senha');
      await tester.enterText(passwordField, 'Password123!');

      // Find visibility toggle button
      final visibilityButton = find.descendant(
        of: passwordField,
        matching: find.byIcon(Icons.visibility_off),
      );

      expect(visibilityButton, findsOneWidget);

      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
