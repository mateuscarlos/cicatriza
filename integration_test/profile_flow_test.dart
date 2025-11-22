import 'package:cicatriza/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Teste de integração end-to-end para o fluxo de perfil do usuário.
///
/// Este teste cobre:
/// - Login com credenciais válidas
/// - Navegação para a página de perfil
/// - Visualização dos dados do perfil
/// - Edição de campos do perfil
/// - Salvamento das alterações
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Flow Integration Tests', () {
    testWidgets(
      'should navigate to profile page and display user information',
      (WidgetTester tester) async {
        // 1. Iniciar o app
        await tester.pumpWidget(const CicatrizaApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // 2. Verificar que estamos na tela de login
        expect(find.text('Entrar'), findsOneWidget);

        // 3. Fazer login com credenciais de teste
        // NOTA: Configure um usuário de teste no Firebase Authentication
        const testEmail = 'teste@cicatriza.com';
        const testPassword = 'Teste123!';

        final emailField = find.byType(TextField).first;
        final passwordField = find.byType(TextField).last;

        await tester.enterText(emailField, testEmail);
        await tester.pumpAndSettle();

        await tester.enterText(passwordField, testPassword);
        await tester.pumpAndSettle();

        // 4. Tocar no botão de login
        final loginButton = find.widgetWithText(ElevatedButton, 'Entrar');
        await tester.tap(loginButton);

        // Aguardar autenticação e navegação
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // 5. Verificar que navegou para a home (procurar pelo drawer)
        expect(find.byIcon(Icons.menu), findsOneWidget);

        // 6. Abrir o drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // 7. Navegar para o perfil
        await tester.tap(find.text('Meu Perfil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // 8. Verificar que estamos na página de perfil
        expect(find.text('Meu Perfil'), findsAtLeastNWidgets(1));

        // 9. Verificar elementos da página de perfil
        expect(find.text('Identificação'), findsOneWidget);
        expect(find.text('Contato'), findsOneWidget);

        // 10. Verificar botões da AppBar
        expect(find.byIcon(Icons.share), findsOneWidget);
        expect(find.byIcon(Icons.qr_code), findsOneWidget);
        expect(find.byIcon(Icons.save), findsOneWidget);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    testWidgets(
      'should edit profile name and save changes',
      (WidgetTester tester) async {
        await tester.pumpWidget(const CicatrizaApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Login (mesmo fluxo anterior)
        const testEmail = 'teste@cicatriza.com';
        const testPassword = 'Teste123!';

        await tester.enterText(find.byType(TextField).first, testEmail);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).last, testPassword);
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Navegar para perfil
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Meu Perfil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Encontrar campo de nome e editar
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.tap(textFields.first);
          await tester.pumpAndSettle();

          // Adicionar texto ao nome existente
          await tester.enterText(
            textFields.first,
            'Dr. Teste Integração Atualizado',
          );
          await tester.pumpAndSettle();

          // Salvar mudanças
          await tester.tap(find.byIcon(Icons.save));
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Verificar que algum feedback foi dado (SnackBar ou similar)
          // Nota: Ajuste conforme a implementação real
          expect(find.byType(SnackBar), findsOneWidget);
        }
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    testWidgets(
      'should switch between profile tabs',
      (WidgetTester tester) async {
        await tester.pumpWidget(const CicatrizaApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Login
        const testEmail = 'teste@cicatriza.com';
        const testPassword = 'Teste123!';

        await tester.enterText(find.byType(TextField).first, testEmail);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).last, testPassword);
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Navegar para perfil
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Meu Perfil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verificar tab inicial
        expect(find.text('Identificação'), findsOneWidget);
        expect(find.text('Contato'), findsOneWidget);

        // Trocar para tab de Contato
        await tester.tap(find.text('Contato'));
        await tester.pumpAndSettle();

        // Voltar para Identificação
        await tester.tap(find.text('Identificação'));
        await tester.pumpAndSettle();

        // Verificar que está na tab de Identificação
        expect(find.text('Identificação'), findsOneWidget);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    testWidgets(
      'should display QR code when button is tapped',
      (WidgetTester tester) async {
        await tester.pumpWidget(const CicatrizaApp());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Login
        const testEmail = 'teste@cicatriza.com';
        const testPassword = 'Teste123!';

        await tester.enterText(find.byType(TextField).first, testEmail);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).last, testPassword);
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Navegar para perfil
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Meu Perfil'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Tocar no botão de QR code
        await tester.tap(find.byIcon(Icons.qr_code));
        await tester.pumpAndSettle();

        // Verificar que algo foi exibido (dialog, bottom sheet, etc.)
        // Ajuste conforme implementação
        expect(
          find.byType(AlertDialog),
          findsOneWidget,
          reason: 'QR code dialog should be displayed',
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
