import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/routing/app_routes.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';

/// Página inicial após login
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final displayName = authState is AuthAuthenticated
        ? authState.displayName ?? authState.email
        : 'Profissional';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CICATRIZA'),
            Text(
              displayName,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _showProfileMenu(context, authState);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Boas-vindas
            Text(
              'Bem-vindo!',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              'Gerencie seus pacientes e avaliações de feridas',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 32),

            // Cards de ações rápidas
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionCard(
                    context,
                    icon: Icons.people,
                    title: 'Pacientes',
                    subtitle: 'Gerenciar pacientes',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.patients);
                    },
                  ),

                  _buildActionCard(
                    context,
                    icon: Icons.assessment,
                    title: 'Avaliações',
                    subtitle: 'Nova avaliação',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.patients);
                    },
                  ),

                  _buildActionCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Agenda',
                    subtitle: 'Agendamentos',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Agenda em desenvolvimento'),
                        ),
                      );
                    },
                  ),

                  _buildActionCard(
                    context,
                    icon: Icons.analytics,
                    title: 'Relatórios',
                    subtitle: 'Análises e dados',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Relatórios em desenvolvimento'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),

              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context, AuthState authState) {
    final displayName = authState is AuthAuthenticated
        ? authState.displayName ?? authState.email
        : null;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (displayName != null) ...[
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(displayName),
                subtitle: const Text('Conta autenticada'),
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar para perfil
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar para configurações
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(const AuthSignOutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}
