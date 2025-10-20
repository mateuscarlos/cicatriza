import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/patient_manual.dart';
import '../../domain/entities/wound_manual.dart';
import '../blocs/wound_bloc.dart';
import '../blocs/wound_state.dart';
import '../blocs/wound_event.dart';

class WoundsListPage extends StatefulWidget {
  final PatientManual patient;

  const WoundsListPage({super.key, required this.patient});

  @override
  State<WoundsListPage> createState() => _WoundsListPageState();
}

class _WoundsListPageState extends State<WoundsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<WoundBloc>().add(LoadWoundsByPatientEvent(widget.patient.id));
  }

  void _showCreateWoundDialog() {
    showDialog(
      context: context,
      builder: (context) => _CreateWoundDialog(patient: widget.patient),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Feridas - ${widget.patient.name}'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WoundBloc>().add(
                LoadWoundsByPatientEvent(widget.patient.id),
              );
            },
            tooltip: 'Atualizar lista',
          ),
        ],
      ),

      body: Column(
        children: [
          // Informações do paciente
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.patient.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Idade: ${_calculateAge(widget.patient.birthDate)} anos',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de feridas
          Expanded(
            child: BlocConsumer<WoundBloc, WoundState>(
              listener: (context, state) {
                if (state is WoundOperationSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Recarregar lista após operação bem-sucedida
                  context.read<WoundBloc>().add(
                    LoadWoundsByPatientEvent(widget.patient.id),
                  );
                }
              },
              builder: (context, state) {
                if (state is WoundLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is WoundErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erro ao carregar feridas',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<WoundBloc>().add(
                              LoadWoundsByPatientEvent(widget.patient.id),
                            );
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is WoundLoadedState) {
                  if (state.wounds.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.healing_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma ferida cadastrada',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Cadastre a primeira ferida para este paciente',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<WoundBloc>().add(
                        LoadWoundsByPatientEvent(widget.patient.id),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.wounds.length,
                      itemBuilder: (context, index) {
                        final wound = state.wounds[index];
                        return _WoundListTile(
                          wound: wound,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/assessments/list',
                              arguments: {
                                'patient': widget.patient,
                                'wound': wound,
                              },
                            );
                          },
                          onUpdateStatus: (status) {
                            context.read<WoundBloc>().add(
                              UpdateWoundStatusEvent(
                                woundId: wound.id,
                                newStatus: status,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateWoundDialog,
        tooltip: 'Adicionar ferida',
        child: const Icon(Icons.add),
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class _WoundListTile extends StatelessWidget {
  final WoundManual wound;
  final VoidCallback onTap;
  final ValueChanged<String> onUpdateStatus;

  const _WoundListTile({
    required this.wound,
    required this.onTap,
    required this.onUpdateStatus,
  });

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'ativa':
        return Colors.red.shade400;
      case 'melhorando':
        return Colors.orange.shade400;
      case 'cicatrizada':
        return Colors.green.shade400;
      default:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'ativa':
        return Icons.warning;
      case 'melhorando':
        return Icons.trending_up;
      case 'cicatrizada':
        return Icons.check_circle;
      default:
        return Icons.healing;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(context, wound.status);
    final statusIcon = _getStatusIcon(wound.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wound.location,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          wound.type,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: onUpdateStatus,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'ativa',
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Ativa'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'melhorando',
                        child: Row(
                          children: [
                            Icon(Icons.trending_up, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Melhorando'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'cicatrizada',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Cicatrizada'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Status atual
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  wound.status.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Informações adicionais
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Criada em ${_formatDate(wound.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.assessment,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Avaliar',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _CreateWoundDialog extends StatefulWidget {
  final PatientManual patient;

  const _CreateWoundDialog({required this.patient});

  @override
  State<_CreateWoundDialog> createState() => _CreateWoundDialogState();
}

class _CreateWoundDialogState extends State<_CreateWoundDialog> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _typeController = TextEditingController();
  String _selectedStatus = 'ativa';

  @override
  void dispose() {
    _locationController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _createWound() {
    if (_formKey.currentState!.validate()) {
      context.read<WoundBloc>().add(
        CreateWoundEvent(
          patientId: widget.patient.id,
          location: _locationController.text.trim(),
          type: _typeController.text.trim(),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova Ferida'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Localização *',
                hintText: 'Ex: Pé direito, Perna esquerda...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Localização é obrigatória';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Tipo *',
                hintText: 'Ex: Úlcera venosa, Ferida cirúrgica...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tipo é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status inicial',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'ativa', child: Text('Ativa')),
                DropdownMenuItem(
                  value: 'melhorando',
                  child: Text('Melhorando'),
                ),
                DropdownMenuItem(
                  value: 'cicatrizada',
                  child: Text('Cicatrizada'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _createWound, child: const Text('Criar')),
      ],
    );
  }
}
