import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/patients_page.dart';
import '../../presentation/pages/splash_page.dart';

/// Rotas da aplicação usando GoRouter
class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String patients = '/patients';

  /// Configuração das rotas
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Login
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Home
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Patients
      GoRoute(
        path: patients,
        name: 'patients',
        builder: (context, state) => const PatientsPage(),
      ),
    ],

    // Redirecionamento baseado em autenticação
    redirect: (context, state) {
      // TODO: Implementar lógica de redirecionamento baseada em AuthBloc
      // Por enquanto, permitir todas as rotas
      return null;
    },

    // Página de erro
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Erro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Rota: ${state.fullPath}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Extensões para navegação mais simples
extension AppRouterExtension on BuildContext {
  void goToLogin() => go(AppRouter.login);
  void goToHome() => go(AppRouter.home);
  void goToPatients() => go(AppRouter.patients);
}
