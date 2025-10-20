import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/routing/app_routes.dart';

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
              SvgPicture.asset(
                'assets/logos/logo_cicatriza.svg',
                width: 100,
                height: 100,
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
                    // MVP: Navegar direto para pacientes
                    Navigator.pushReplacementNamed(context, AppRoutes.patients);
                  },
                  icon: SvgPicture.asset(
                    'assets/logos/google-logo.svg',
                    width: 24,
                    height: 24,
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

              // Divisor "ou"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ou',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 16),

              // Botão Login com E-mail
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // MVP: Navegar direto para pacientes
                    Navigator.pushReplacementNamed(context, AppRoutes.patients);
                  },
                  icon: const Icon(Icons.email_outlined),
                  label: const Text(
                    'Entrar com E-mail',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
}
