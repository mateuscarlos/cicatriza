import 'package:flutter/material.dart';

/// Página de gerenciamento de pacientes
class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar busca de pacientes
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estatísticas rápidas
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Total',
                    value: '0', // TODO: Carregar do BLoC
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Ativos',
                    value: '0', // TODO: Carregar do BLoC
                    icon: Icons.person,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Lista de pacientes
            Expanded(child: _buildPatientsList(context)),
          ],
        ),
      ),

      // FAB para adicionar paciente
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navegar para adicionar paciente
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adicionar paciente - Em desenvolvimento'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientsList(BuildContext context) {
    // TODO: Substituir por BlocBuilder<PatientsBloc, PatientsState>
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nenhum paciente cadastrado',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Toque no botão + para adicionar um paciente',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
