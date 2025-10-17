import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Página de login com Google e Microsoft
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),

              // Logo e título
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/logos/logo_cicatriza.svg',
                  width: 76,
                  height: 76,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'CICATRIZA',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Entre com sua conta para continuar',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Botão Login Google
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar login Google via AuthBloc
                    _showSnackBar(context, 'Login Google será implementado');
                  },
                  icon: Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    child: SvgPicture.asset(
                      'assets/logos/google-logo.svg',
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                  label: const Text(
                    'Entrar com Google',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão Login Microsoft
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar login Microsoft via AuthBloc
                    _showSnackBar(context, 'Login Microsoft será implementado');
                  },
                  icon: Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    child: SvgPicture.asset(
                      'assets/logos/microsoft.svg',
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                  label: const Text(
                    'Entrar com Microsoft',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),

              const Spacer(),

              // Informações adicionais
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Ao continuar, você concorda com nossos Termos de Uso e Política de Privacidade',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
