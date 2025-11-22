import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/patient_manual.dart';
import '../blocs/patient_bloc.dart';
import '../blocs/patient_state.dart';
import '../blocs/patient_event.dart';

class PacientesListPage extends StatefulWidget {
  const PacientesListPage({super.key});

  @override
  State<PacientesListPage> createState() => _PacientesListPageState();
}

class _PacientesListPageState extends State<PacientesListPage> {
  final _searchController = TextEditingController();
  bool _showArchived = false;

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(const LoadPatientsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreatePatientDialog() {
    showDialog(
      context: context,
      builder: (context) => const _CreatePatientDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
      listenWhen: (previous, current) =>
          current is PatientOperationSuccessState ||
          current is PatientErrorState,
      listener: (context, state) {
        if (state is PatientOperationSuccessState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<PatientBloc>().add(const LoadPatientsEvent());
        } else if (state is PatientErrorState && state.patients.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final isOperationInProgress = state is PatientOperationInProgressState;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Pacientes'),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            actions: [
              IconButton(
                icon: Icon(
                  _showArchived ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _showArchived = !_showArchived;
                  });
                },
                tooltip: _showArchived
                    ? 'Ocultar arquivados'
                    : 'Mostrar arquivados',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<PatientBloc>().add(const LoadPatientsEvent());
                },
                tooltip: 'Atualizar lista',
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar pacientes...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<PatientBloc>().add(
                                const LoadPatientsEvent(),
                              );
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    if (query.trim().isNotEmpty) {
                      context.read<PatientBloc>().add(
                        SearchPatientsEvent(query),
                      );
                    } else {
                      context.read<PatientBloc>().add(
                        const LoadPatientsEvent(),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    _buildPatientsContent(context, theme, state),
                    if (isOperationInProgress)
                      Container(
                        color: Colors.black.withValues(alpha: 0.1),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showCreatePatientDialog,
            tooltip: 'Adicionar paciente',
            child: const Icon(Icons.person_add),
          ),
        );
      },
    );
  }

  Widget _buildPatientsContent(
    BuildContext context,
    ThemeData theme,
    PatientState state,
  ) {
    if (state is PatientLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PatientErrorState && state.patients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar pacientes',
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
                context.read<PatientBloc>().add(const LoadPatientsEvent());
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final patients = _extractPatients(state);
    if (patients == null) {
      return const SizedBox();
    }

    final visiblePatients = _showArchived
        ? patients
        : patients.where((p) => !p.archived).toList();

    if (visiblePatients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Nenhum paciente encontrado'
                  : 'Nenhum paciente cadastrado',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Tente ajustar os termos de busca'
                  : 'Cadastre o primeiro paciente',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PatientBloc>().add(const LoadPatientsEvent());
      },
      child: ListView.builder(
        itemCount: visiblePatients.length,
        itemBuilder: (context, index) {
          final patient = visiblePatients[index];
          return _PatientListTile(
            patient: patient,
            onTap: () {
              Navigator.pushNamed(context, '/wounds', arguments: patient);
            },
            onArchive: () {
              context.read<PatientBloc>().add(ArchivePatientEvent(patient.id));
            },
          );
        },
      ),
    );
  }

  List<PatientManual>? _extractPatients(PatientState state) {
    if (state is PatientLoadedState) {
      return state.patients;
    }
    if (state is PatientOperationInProgressState) {
      return state.patients;
    }
    if (state is PatientOperationSuccessState) {
      return state.patients;
    }
    if (state is PatientErrorState && state.patients.isNotEmpty) {
      return state.patients;
    }

    return null;
  }
}

class _PatientListTile extends StatelessWidget {
  final PatientManual patient;
  final VoidCallback onTap;
  final VoidCallback onArchive;

  const _PatientListTile({
    required this.patient,
    required this.onTap,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: patient.archived
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            color: patient.archived
                ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          patient.name,
          style: TextStyle(
            decoration: patient.archived ? TextDecoration.lineThrough : null,
            color: patient.archived
                ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                : null,
          ),
        ),
        subtitle: Text(
          'Idade: ${_calculateAge(patient.birthDate)} anos',
          style: theme.textTheme.bodySmall,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'archive':
                onArchive();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'archive',
              child: Row(
                children: [
                  Icon(patient.archived ? Icons.unarchive : Icons.archive),
                  const SizedBox(width: 8),
                  Text(patient.archived ? 'Desarquivar' : 'Arquivar'),
                ],
              ),
            ),
          ],
        ),
        onTap: patient.archived ? null : onTap,
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

class _CreatePatientDialog extends StatefulWidget {
  const _CreatePatientDialog();

  @override
  State<_CreatePatientDialog> createState() => _CreatePatientDialogState();
}

class _CreatePatientDialogState extends State<_CreatePatientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _birthDate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _selectBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 120)),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _birthDate = date;
      });
    }
  }

  void _createPatient() {
    if (_formKey.currentState!.validate()) {
      context.read<PatientBloc>().add(
        CreatePatientEvent(
          name: _nameController.text.trim(),
          birthDate:
              _birthDate ??
              DateTime.now().subtract(const Duration(days: 365 * 30)),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Paciente'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome completo *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nome é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: _selectBirthDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _birthDate == null
                      ? 'Selecionar data'
                      : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _createPatient, child: const Text('Criar')),
      ],
    );
  }
}
