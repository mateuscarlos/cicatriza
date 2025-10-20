import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/patient_manual.dart';
import '../../domain/entities/wound_manual.dart';
import '../../domain/entities/assessment_manual.dart';
import '../blocs/assessment_bloc.dart';
import '../blocs/assessment_state.dart';
import '../blocs/assessment_event.dart';

class AssessmentsListPage extends StatefulWidget {
  final PatientManual patient;
  final WoundManual wound;

  const AssessmentsListPage({
    super.key,
    required this.patient,
    required this.wound,
  });

  @override
  State<AssessmentsListPage> createState() => _AssessmentsListPageState();
}

class _AssessmentsListPageState extends State<AssessmentsListPage> {
  @override
  void initState() {
    super.initState();
    // Carrega as avaliações da ferida
    context.read<AssessmentBloc>().add(
      LoadAssessmentsByWoundEvent(widget.wound.id),
    );
  }

  Future<void> _navigateToNewAssessment() async {
    final result = await Navigator.pushNamed(
      context,
      '/assessment/create',
      arguments: {'patient': widget.patient, 'wound': widget.wound},
    );

    if (result == true && mounted) {
      context.read<AssessmentBloc>().add(
        LoadAssessmentsByWoundEvent(widget.wound.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Avaliações'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AssessmentBloc>().add(
                LoadAssessmentsByWoundEvent(widget.wound.id),
              );
            },
            tooltip: 'Atualizar lista',
          ),
        ],
      ),
      body: Column(
        children: [
          // Card de informações da ferida
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.healing, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.wound.type,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.wound.location,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusChip(status: widget.wound.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Paciente: ${widget.patient.name}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // Lista de avaliações
          Expanded(
            child: BlocBuilder<AssessmentBloc, AssessmentState>(
              builder: (context, state) {
                if (state is AssessmentLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AssessmentErrorState) {
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
                          'Erro ao carregar avaliações',
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
                            context.read<AssessmentBloc>().add(
                              LoadAssessmentsByWoundEvent(widget.wound.id),
                            );
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AssessmentLoadedState) {
                  final assessments = state.assessments;

                  if (assessments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma avaliação registrada',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione a primeira avaliação desta ferida',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // Ordena as avaliações da mais recente para a mais antiga
                  final sortedAssessments = List<AssessmentManual>.from(
                    assessments,
                  )..sort((a, b) => b.date.compareTo(a.date));

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<AssessmentBloc>().add(
                        LoadAssessmentsByWoundEvent(widget.wound.id),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: sortedAssessments.length,
                      itemBuilder: (context, index) {
                        final assessment = sortedAssessments[index];
                        final isLatest = index == 0;

                        return _AssessmentListTile(
                          assessment: assessment,
                          isLatest: isLatest,
                          onTap: () {
                            // TODO: Navegar para detalhes da avaliação
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Visualização de detalhes em desenvolvimento',
                                ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32, right: 16),
        child: FloatingActionButton(
          onPressed: _navigateToNewAssessment,
          tooltip: 'Nova avaliação',
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ativa':
        return Colors.red.shade400;
      case 'melhorando':
        return Colors.orange.shade400;
      case 'cicatrizada':
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getStatusColor(status), width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusColor(status),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _AssessmentListTile extends StatelessWidget {
  final AssessmentManual assessment;
  final bool isLatest;
  final VoidCallback onTap;

  const _AssessmentListTile({
    required this.assessment,
    required this.isLatest,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Color _getPainColor(int painLevel) {
    if (painLevel <= 3) return Colors.green;
    if (painLevel <= 6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isLatest ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com data e badge "mais recente"
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(assessment.date),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isLatest)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Mais recente',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Informações principais
              Row(
                children: [
                  // Medidas
                  Expanded(
                    child: _InfoBox(
                      icon: Icons.straighten,
                      label: 'Dimensões (cm)',
                      value:
                          '${assessment.lengthCm?.toStringAsFixed(1) ?? '?'} x '
                          '${assessment.widthCm?.toStringAsFixed(1) ?? '?'} x '
                          '${assessment.depthCm?.toStringAsFixed(1) ?? '?'}',
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Dor
                  Expanded(
                    child: _InfoBox(
                      icon: Icons.sentiment_satisfied_alt,
                      label: 'Dor',
                      value: '${assessment.painScale ?? 0}/10',
                      valueColor: _getPainColor(assessment.painScale ?? 0),
                    ),
                  ),
                ],
              ),

              // Características (se disponíveis)
              if (assessment.woundBed != null || assessment.exudateType != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (assessment.woundBed != null)
                        _CharacteristicChip(
                          icon: Icons.layers,
                          label: 'Leito: ${assessment.woundBed}',
                        ),
                      if (assessment.exudateType != null)
                        _CharacteristicChip(
                          icon: Icons.water_drop,
                          label: 'Exsudato: ${assessment.exudateType}',
                        ),
                    ],
                  ),
                ),

              // Notas (se disponíveis)
              if (assessment.notes != null && assessment.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notes,
                            size: 14,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Observações:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        assessment.notes!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacteristicChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CharacteristicChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSecondaryContainer,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
