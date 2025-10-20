import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/patient_manual.dart';
import '../../domain/entities/wound_manual.dart';
import '../blocs/assessment_bloc.dart';
import '../blocs/assessment_state.dart';
import '../blocs/assessment_event.dart';
import '../widgets/widgets.dart';

class AssessmentCreatePage extends StatefulWidget {
  final PatientManual patient;
  final WoundManual wound;

  const AssessmentCreatePage({
    super.key,
    required this.patient,
    required this.wound,
  });

  @override
  State<AssessmentCreatePage> createState() => _AssessmentCreatePageState();
}

class _AssessmentCreatePageState extends State<AssessmentCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controladores dos campos
  double? _length;
  double? _width;
  double? _depth;
  int _painLevel = 0;
  String? _woundBed;
  String? _exudate;
  String? _periphery;
  String? _notes;
  DateTime _assessmentDate = DateTime.now();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectAssessmentDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _assessmentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _assessmentDate = date;
      });
    }
  }

  void _saveAssessment() {
    AppLogger.info('[AssessmentCreatePage] 🔘 Botão salvar clicado');
    AppLogger.info('[AssessmentCreatePage] Validando formulário...');

    try {
      if (_formKey.currentState!.validate()) {
        AppLogger.info('[AssessmentCreatePage] ✅ Validação passou!');
        AppLogger.info(
          '[AssessmentCreatePage] Dados: length=$_length, width=$_width, depth=$_depth, pain=$_painLevel',
        );

        final bloc = context.read<AssessmentBloc>();
        AppLogger.info('[AssessmentCreatePage] BLoC encontrado: $bloc');

        bloc.add(
          CreateAssessmentEvent(
            woundId: widget.wound.id,
            date: _assessmentDate,
            painScale: _painLevel,
            lengthCm: _length ?? 0.0,
            widthCm: _width ?? 0.0,
            depthCm: _depth ?? 0.0,
            woundBed: _woundBed,
            exudateType: _exudate,
            edgeAppearance: _periphery,
            notes: _notes,
          ),
        );
        AppLogger.info(
          '[AssessmentCreatePage] 📤 Evento CreateAssessmentEvent disparado',
        );
      } else {
        AppLogger.warning('[AssessmentCreatePage] ❌ Validação falhou!');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        '[AssessmentCreatePage] ❌❌ ERRO CRÍTICO',
        error: e,
        stackTrace: stackTrace,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Avaliação'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAssessment,
            tooltip: 'Salvar avaliação',
          ),
        ],
      ),

      body: BlocListener<AssessmentBloc, AssessmentState>(
        listener: (context, state) {
          AppLogger.info(
            '[AssessmentCreatePage] 📢 Estado recebido: ${state.runtimeType}',
          );

          if (state is AssessmentOperationSuccessState) {
            AppLogger.info(
              '[AssessmentCreatePage] ✅ Sucesso! Mensagem: ${state.message}',
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Avaliação salva com sucesso!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );

            AppLogger.info(
              '[AssessmentCreatePage] 🔙 Navegando de volta para detalhes do paciente...',
            );
            // Volta para a tela de feridas do paciente (1 tela para trás)
            Navigator.of(context).pop(true);
            AppLogger.info('[AssessmentCreatePage] ✅ Navegação concluída!');
          } else if (state is AssessmentErrorState) {
            AppLogger.error(
              '[AssessmentCreatePage] ❌ Erro ao salvar avaliação: ${state.message}',
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informações do contexto
                _buildContextCard(),

                const SizedBox(height: 24),

                // Seção de medidas
                FormSection(
                  title: 'Medidas da Ferida',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: NumberField(
                            label: 'Comprimento',
                            hint: 'Em centímetros',
                            suffix: 'cm',
                            value: _length,
                            min: 0.1,
                            max: 100,
                            decimals: 1,
                            required: true,
                            onChanged: (value) =>
                                setState(() => _length = value),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: NumberField(
                            label: 'Largura',
                            hint: 'Em centímetros',
                            suffix: 'cm',
                            value: _width,
                            min: 0.1,
                            max: 100,
                            decimals: 1,
                            required: true,
                            onChanged: (value) =>
                                setState(() => _width = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NumberField(
                      label: 'Profundidade',
                      hint: 'Em centímetros',
                      suffix: 'cm',
                      value: _depth,
                      min: 0.1,
                      max: 20,
                      decimals: 1,
                      onChanged: (value) => setState(() => _depth = value),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Seção de dor
                FormSection(
                  title: 'Avaliação da Dor',
                  children: [
                    PainSlider(
                      label: 'Nível de dor relatado pelo paciente',
                      value: _painLevel,
                      onChanged: (value) => setState(() => _painLevel = value),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Seção de características
                FormSection(
                  title: 'Características da Ferida',
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Leito da ferida',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _woundBed,
                      items: const [
                        DropdownMenuItem(
                          value: 'vermelho',
                          child: Text('Vermelho (tecido de granulação)'),
                        ),
                        DropdownMenuItem(
                          value: 'amarelo',
                          child: Text('Amarelo (tecido fibrinoso)'),
                        ),
                        DropdownMenuItem(
                          value: 'preto',
                          child: Text('Preto (tecido necrótico)'),
                        ),
                        DropdownMenuItem(value: 'misto', child: Text('Misto')),
                      ],
                      onChanged: (value) => setState(() => _woundBed = value),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Exsudato',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _exudate,
                      items: const [
                        DropdownMenuItem(
                          value: 'ausente',
                          child: Text('Ausente'),
                        ),
                        DropdownMenuItem(
                          value: 'escasso',
                          child: Text('Escasso'),
                        ),
                        DropdownMenuItem(
                          value: 'moderado',
                          child: Text('Moderado'),
                        ),
                        DropdownMenuItem(
                          value: 'abundante',
                          child: Text('Abundante'),
                        ),
                      ],
                      onChanged: (value) => setState(() => _exudate = value),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Bordas/Periferia',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _periphery,
                      items: const [
                        DropdownMenuItem(
                          value: 'integra',
                          child: Text('Íntegra'),
                        ),
                        DropdownMenuItem(
                          value: 'eritematosa',
                          child: Text('Eritematosa'),
                        ),
                        DropdownMenuItem(
                          value: 'descamativa',
                          child: Text('Descamativa'),
                        ),
                        DropdownMenuItem(
                          value: 'macerada',
                          child: Text('Macerada'),
                        ),
                        DropdownMenuItem(
                          value: 'fibrótica',
                          child: Text('Fibrótica'),
                        ),
                      ],
                      onChanged: (value) => setState(() => _periphery = value),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Seção de observações
                FormSection(
                  title: 'Data e Observações',
                  children: [
                    InkWell(
                      onTap: _selectAssessmentDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data da avaliação',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_assessmentDate.day.toString().padLeft(2, '0')}/'
                          '${_assessmentDate.month.toString().padLeft(2, '0')}/'
                          '${_assessmentDate.year}',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Observações',
                        hintText: 'Observações adicionais sobre a ferida...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      onChanged: (value) =>
                          _notes = value.trim().isEmpty ? null : value.trim(),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BlocBuilder<AssessmentBloc, AssessmentState>(
                        builder: (context, state) {
                          final isLoading =
                              state is AssessmentOperationInProgressState;

                          return ElevatedButton(
                            onPressed: isLoading ? null : _saveAssessment,
                            child: isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Salvar Avaliação'),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContextCard() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Paciente',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.patient.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Idade: ${_calculateAge(widget.patient.birthDate)} anos',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.healing, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Ferida',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.wound.type} - ${widget.wound.location}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getWoundStatusColor(
                  widget.wound.status,
                ).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getWoundStatusColor(
                    widget.wound.status,
                  ).withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                widget.wound.status.toUpperCase(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getWoundStatusColor(widget.wound.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getWoundStatusColor(String status) {
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
