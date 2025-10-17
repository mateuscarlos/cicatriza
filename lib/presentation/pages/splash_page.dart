import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Página de splash screen
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // TODO: Implementar inicialização
    // - Verificar autenticação
    // - Carregar configurações
    // - Conectar com Firebase

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // TODO: Navegar baseado no estado de autenticação
      // Por enquanto, sempre vai para login
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo da aplicação
            Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'assets/logos/logo_cicatriza.svg',
                width: 110,
                height: 110,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Nome da aplicação
            Text(
              'CICATRIZA',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),

            // Subtítulo
            Text(
              'Avaliação e Acompanhamento de Feridas',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Loading indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
