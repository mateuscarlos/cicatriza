import 'package:flutter/material.dart';

/// Página inicial após login
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CICATRIZA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Mostrar menu de perfil/logout
              _showProfileMenu(context);
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                      // TODO: Navegar para página de pacientes
                      // context.goToPatients();
                    },
                  ),

                  _buildActionCard(
                    context,
                    icon: Icons.assessment,
                    title: 'Avaliações',
                    subtitle: 'Nova avaliação',
                    onTap: () {
                      // TODO: Navegar para nova avaliação
                    },
                  ),

                  _buildActionCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Agenda',
                    subtitle: 'Agendamentos',
                    onTap: () {
                      // TODO: Navegar para agenda
                    },
                  ),

                  _buildActionCard(
                    context,
                    icon: Icons.analytics,
                    title: 'Relatórios',
                    subtitle: 'Análises e dados',
                    onTap: () {
                      // TODO: Navegar para relatórios
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // FAB para nova avaliação rápida
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar para nova avaliação rápida
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nova avaliação - Em desenvolvimento'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Avaliação'),
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
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                // TODO: Implementar logout via AuthBloc
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout será implementado')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
