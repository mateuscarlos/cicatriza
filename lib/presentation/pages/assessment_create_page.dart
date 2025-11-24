import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
    required this.patient, required this.wound, super.key,
  });

  @override
  State<AssessmentCreatePage> createState() => _AssessmentCreatePageState();
}

class _AssessmentCreatePageState extends State<AssessmentCreatePage> {
  static const int _maxPhotos = 4;

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  final List<_AssessmentPhoto> _photos = [];

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
  bool _isProcessingPhoto = false;

  @override
  void dispose() {
    for (final photo in _photos) {
      _deleteTempFile(photo.processedPath);
    }
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
            photoPaths: _photos.map((photo) => photo.processedPath).toList(),
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

  bool get _canAddMorePhotos => _photos.length < _maxPhotos;

  void _showPhotoPickerSheet() {
    if (!_canAddMorePhotos || _isProcessingPhoto) {
      if (!_canAddMorePhotos) {
        _showSnackBar('Limite de $_maxPhotos fotos atingido.', isError: false);
      }
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Capturar com a câmera'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _handlePhotoSelection(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _handlePhotoSelection(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePhotoSelection(ImageSource source) async {
    if (_isProcessingPhoto) return;

    setState(() {
      _isProcessingPhoto = true;
    });

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2400,
        maxHeight: 2400,
        imageQuality: 95,
      );

      if (picked == null) {
        return;
      }

      final photo = await _preparePhoto(picked);
      if (photo == null) {
        _showSnackBar('Não foi possível processar a imagem selecionada.');
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _photos.add(photo);
      });
    } catch (error) {
      _showSnackBar('Erro ao selecionar imagem: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPhoto = false;
        });
      }
    }
  }

  Future<_AssessmentPhoto?> _preparePhoto(XFile source) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'assessment_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetPath = p.join(tempDir.path, fileName);

      final compressed = await FlutterImageCompress.compressAndGetFile(
        source.path,
        targetPath,
        quality: 80,
        minWidth: 1600,
        minHeight: 1200,
      );

      if (compressed == null) {
        return null;
      }

      return _AssessmentPhoto(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        originalPath: source.path,
        processedPath: compressed.path,
      );
    } catch (error) {
      AppLogger.error(
        '[AssessmentCreatePage] Erro ao comprimir imagem',
        error: error,
      );
      return null;
    }
  }

  void _removePhoto(String photoId) {
    final index = _photos.indexWhere((photo) => photo.id == photoId);
    if (index == -1) return;

    final photo = _photos[index];
    setState(() {
      _photos.removeAt(index);
    });
    _deleteTempFile(photo.processedPath);
  }

  Widget _buildPhotoSection(ThemeData theme) {
    final remainingSlots = _maxPhotos - _photos.length;

    return FormSection(
      title: 'Registro Fotográfico',
      children: [
        Text(
          'Capture ou selecione até $_maxPhotos fotos para documentar a evolução da ferida. '
          'Restam $remainingSlots.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ..._photos.map(_buildPhotoTile),
            _buildAddPhotoButton(theme),
          ],
        ),
        if (!_canAddMorePhotos)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Você atingiu o limite de $_maxPhotos fotos.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddPhotoButton(ThemeData theme) {
    return SizedBox(
      width: 112,
      height: 112,
      child: OutlinedButton(
        onPressed: !_canAddMorePhotos || _isProcessingPhoto
            ? null
            : _showPhotoPickerSheet,
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(12)),
        child: _isProcessingPhoto
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text('Adicionar', style: theme.textTheme.labelMedium),
                ],
              ),
      ),
    );
  }

  Widget _buildPhotoTile(_AssessmentPhoto photo) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(photo.processedPath),
            width: 112,
            height: 112,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _removePhoto(photo.id),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _deleteTempFile(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (error) {
      AppLogger.warning(
        '[AssessmentCreatePage] Não foi possível remover arquivo temporário: $error',
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

          if (state is AssessmentSavedAndNavigateBackState) {
            AppLogger.info(
              '[AssessmentCreatePage] ✅ Avaliação salva e lista atualizada! Mensagem: ${state.message}',
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Avaliação salva com sucesso!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            AppLogger.info(
              '[AssessmentCreatePage] 🔙 Navegando de volta para lista de avaliações...',
            );

            // Volta para a tela de lista de avaliações (1 tela para trás)
            // Passa true para indicar que uma nova avaliação foi criada
            Navigator.of(context).pop(true);
            AppLogger.info('[AssessmentCreatePage] ✅ Navegação concluída!');
          } else if (state is AssessmentOperationSuccessState) {
            // Mantém o comportamento anterior para outros casos de sucesso
            AppLogger.info(
              '[AssessmentCreatePage] ✅ Sucesso! Mensagem: ${state.message}',
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${state.message}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
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

                _buildPhotoSection(theme),

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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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

class _AssessmentPhoto {
  const _AssessmentPhoto({
    required this.id,
    required this.originalPath,
    required this.processedPath,
  });

  final String id;
  final String originalPath;
  final String processedPath;
}
