import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/assessment_manual.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/assessment_repository_manual.dart';
import '../../domain/repositories/media_repository.dart';
import 'assessment_event.dart';
import 'assessment_state.dart';

/// BLoC para gerenciar estado das avaliações com validações
class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final AssessmentRepository _assessmentRepository;
  final MediaRepository _mediaRepository;
  final StorageService _storageService;
  final AnalyticsService _analytics;
  StreamSubscription<List<AssessmentManual>>? _assessmentsSubscription;

  AssessmentBloc({
    required AssessmentRepository assessmentRepository,
    required MediaRepository mediaRepository,
    required StorageService storageService,
    required AnalyticsService analytics,
  }) : _assessmentRepository = assessmentRepository,
       _mediaRepository = mediaRepository,
       _storageService = storageService,
       _analytics = analytics,
       super(const AssessmentInitialState()) {
    // Registra os handlers dos eventos
    on<LoadAssessmentsByWoundEvent>(_onLoadAssessmentsByWound);
    on<CreateAssessmentEvent>(_onCreateAssessment);
    on<UpdateAssessmentEvent>(_onUpdateAssessment);
    on<DeleteAssessmentEvent>(_onDeleteAssessment);
    on<SelectAssessmentEvent>(_onSelectAssessment);
    on<LoadLatestAssessmentEvent>(_onLoadLatestAssessment);
    on<LoadAssessmentHistoryEvent>(_onLoadAssessmentHistory);
    on<FilterAssessmentsEvent>(_onFilterAssessments);
    on<ValidateAssessmentEvent>(_onValidateAssessment);
  }

  /// Valida dados de avaliação segundo regras do M1
  Map<String, String> _validateAssessmentData({
    required DateTime date,
    required int painScale,
    required double lengthCm,
    required double widthCm,
    required double depthCm,
    String? notes,
  }) {
    final errors = <String, String>{};
    final now = DateTime.now();

    // Validação da data: não pode ser futura (> hoje)
    if (date.isAfter(DateTime(now.year, now.month, now.day))) {
      errors['date'] = 'Data não pode ser futura';
    }

    // Validação da dor: deve estar entre 0 e 10
    if (painScale < 0 || painScale > 10) {
      errors['painScale'] = 'Escala de dor deve estar entre 0 e 10';
    }

    // Validação das medidas: devem ser > 0
    if (lengthCm <= 0) {
      errors['lengthCm'] = 'Comprimento deve ser maior que 0';
    }
    if (widthCm <= 0) {
      errors['widthCm'] = 'Largura deve ser maior que 0';
    }
    if (depthCm <= 0) {
      errors['depthCm'] = 'Profundidade deve ser maior que 0';
    }

    if (notes != null && notes.isNotEmpty) {
      if (notes.length > 2000) {
        errors['notes'] = 'Observações devem ter no máximo 2000 caracteres';
      }

      final containsHtmlTags = RegExp(r'<[^>]+>').hasMatch(notes);
      if (containsHtmlTags) {
        errors['notes'] =
            'Observações não podem conter marcações HTML ou scripts';
      }
    }

    return errors;
  }

  /// Carrega avaliações de uma ferida
  Future<void> _onLoadAssessmentsByWound(
    LoadAssessmentsByWoundEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    try {
      emit(const AssessmentLoadingState());

      // Cancela subscription anterior se existir
      await _assessmentsSubscription?.cancel();

      // Inicia stream de avaliações da ferida
      _assessmentsSubscription = _assessmentRepository
          .watchAssessments(event.woundId)
          .listen((assessments) {
            if (!isClosed) {
              // Emite estado atualizado com novas avaliações do stream
              if (state is AssessmentLoadedState) {
                final currentState = state as AssessmentLoadedState;
                emit(currentState.copyWith(assessments: assessments));
              }
            }
          });

      // Carrega avaliações iniciais
      final assessments = await _assessmentRepository.getAssessmentsByWoundId(
        event.woundId,
      );

      // Carrega também a última avaliação
      final latestAssessment = await _assessmentRepository.getLatestAssessment(
        event.woundId,
      );

      emit(
        AssessmentLoadedState(
          assessments: assessments,
          latestAssessment: latestAssessment,
          currentWoundId: event.woundId,
        ),
      );
    } catch (e) {
      emit(
        AssessmentErrorState(
          message: 'Erro ao carregar avaliações: $e',
          currentWoundId: event.woundId,
        ),
      );
    }
  }

  /// Valida dados da avaliação
  Future<void> _onValidateAssessment(
    ValidateAssessmentEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    final errors = _validateAssessmentData(
      date: event.date,
      painScale: event.painScale,
      lengthCm: event.lengthCm,
      widthCm: event.widthCm,
      depthCm: event.depthCm,
      notes: event.notes,
    );

    emit(AssessmentValidationState(errors: errors, isValid: errors.isEmpty));
  }

  /// Cria uma nova avaliação
  Future<void> _onCreateAssessment(
    CreateAssessmentEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    try {
      AppLogger.info('[AssessmentBloc] 🔵 Iniciando criação de avaliação');

      // Primeiro valida os dados
      final errors = _validateAssessmentData(
        date: event.date,
        painScale: event.painScale,
        lengthCm: event.lengthCm,
        widthCm: event.widthCm,
        depthCm: event.depthCm,
        notes: event.notes,
      );

      if (errors.isNotEmpty) {
        AppLogger.warning('[AssessmentBloc] ❌ Validação falhou: $errors');
        emit(AssessmentValidationState(errors: errors, isValid: false));
        return;
      }

      AppLogger.info('[AssessmentBloc] ✅ Validação passou');
      final currentAssessments = _getCurrentAssessments();

      emit(
        AssessmentOperationInProgressState(
          assessments: currentAssessments,
          operation: 'creating',
          selectedAssessment: _getCurrentSelectedAssessment(),
          currentWoundId: event.woundId,
        ),
      );

      AppLogger.info(
        '[AssessmentBloc] 📝 Criando assessment no repositório...',
      );

      final newAssessment = AssessmentManual.create(
        woundId: event.woundId,
        date: event.date,
        painScale: event.painScale,
        lengthCm: event.lengthCm,
        widthCm: event.widthCm,
        depthCm: event.depthCm,
        edgeAppearance: event.edgeAppearance,
        woundBed: event.woundBed,
        exudateType: event.exudateType,
        exudateAmount: event.exudateAmount,
        notes: event.notes,
      );

      AppLogger.info('[AssessmentBloc] 💾 Salvando no repositório...');
      final createdAssessment = await _assessmentRepository.createAssessment(
        newAssessment,
      );

      AppLogger.info(
        '[AssessmentBloc] ✅ Assessment criado: ${createdAssessment.id}',
      );

      // Processar upload de fotos se houver
      if (event.photoPaths.isNotEmpty) {
        AppLogger.info(
          '[AssessmentBloc] 📸 Iniciando upload de ${event.photoPaths.length} foto(s)',
        );
        unawaited(
          _processPhotoUploads(
            assessmentId: createdAssessment.id,
            woundId: event.woundId,
            photoPaths: event.photoPaths,
          ),
        );
      }

      final updatedAssessments = [createdAssessment, ...currentAssessments];

      AppLogger.info(
        '[AssessmentBloc] 📤 Emitindo AssessmentOperationSuccessState',
      );
      emit(
        AssessmentOperationSuccessState(
          assessments: updatedAssessments,
          message: 'Avaliação criada com sucesso!',
          selectedAssessment: createdAssessment,
          currentWoundId: event.woundId,
        ),
      );
      AppLogger.info('[AssessmentBloc] ✅ Estado de sucesso emitido!');
    } catch (e, stackTrace) {
      AppLogger.error(
        '[AssessmentBloc] ❌ Erro ao criar avaliação',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        AssessmentErrorState(
          message: 'Erro ao criar avaliação: $e',
          assessments: _getCurrentAssessments(),
          selectedAssessment: _getCurrentSelectedAssessment(),
          currentWoundId: event.woundId,
        ),
      );
    }
  }

  /// Atualiza uma avaliação existente
  Future<void> _onUpdateAssessment(
    UpdateAssessmentEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    try {
      // Valida os dados atualizados
      final errors = _validateAssessmentData(
        date: event.assessment.date,
        painScale: event.assessment.painScale ?? 0,
        lengthCm: event.assessment.lengthCm ?? 0.0,
        widthCm: event.assessment.widthCm ?? 0.0,
        depthCm: event.assessment.depthCm ?? 0.0,
        notes: event.assessment.notes,
      );

      if (errors.isNotEmpty) {
        emit(AssessmentValidationState(errors: errors, isValid: false));
        return;
      }

      final currentAssessments = _getCurrentAssessments();

      emit(
        AssessmentOperationInProgressState(
          assessments: currentAssessments,
          operation: 'updating',
          selectedAssessment: _getCurrentSelectedAssessment(),
          currentWoundId: _getCurrentWoundId(),
        ),
      );

      final updatedAssessment = await _assessmentRepository.updateAssessment(
        event.assessment,
      );

      final updatedAssessments = currentAssessments.map((a) {
        return a.id == updatedAssessment.id ? updatedAssessment : a;
      }).toList();

      emit(
        AssessmentOperationSuccessState(
          assessments: updatedAssessments,
          message: 'Avaliação atualizada com sucesso!',
          selectedAssessment: updatedAssessment,
          currentWoundId: _getCurrentWoundId(),
        ),
      );
    } catch (e) {
      emit(
        AssessmentErrorState(
          message: 'Erro ao atualizar avaliação: $e',
          assessments: _getCurrentAssessments(),
          selectedAssessment: _getCurrentSelectedAssessment(),
          currentWoundId: _getCurrentWoundId(),
        ),
      );
    }
  }

  /// Deleta uma avaliação
  Future<void> _onDeleteAssessment(
    DeleteAssessmentEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    try {
      final currentAssessments = _getCurrentAssessments();
      final selectedAssessment = _getCurrentSelectedAssessment();

      emit(
        AssessmentOperationInProgressState(
          assessments: currentAssessments,
          operation: 'deleting',
          selectedAssessment: selectedAssessment,
          currentWoundId: _getCurrentWoundId(),
        ),
      );

      await _assessmentRepository.deleteAssessment(event.assessmentId);

      final updatedAssessments = currentAssessments
          .where((a) => a.id != event.assessmentId)
          .toList();

      // Se a avaliação deletada estava selecionada, limpa a seleção
      final newSelectedAssessment = selectedAssessment?.id == event.assessmentId
          ? null
          : selectedAssessment;

      emit(
        AssessmentOperationSuccessState(
          assessments: updatedAssessments,
          message: 'Avaliação removida com sucesso!',
          selectedAssessment: newSelectedAssessment,
          currentWoundId: _getCurrentWoundId(),
        ),
      );
    } catch (e) {
      emit(
        AssessmentErrorState(
          message: 'Erro ao remover avaliação: $e',
          assessments: _getCurrentAssessments(),
          selectedAssessment: _getCurrentSelectedAssessment(),
          currentWoundId: _getCurrentWoundId(),
        ),
      );
    }
  }

  /// Seleciona uma avaliação
  Future<void> _onSelectAssessment(
    SelectAssessmentEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    if (state is AssessmentLoadedState) {
      final currentState = state as AssessmentLoadedState;
      emit(currentState.copyWith(selectedAssessment: event.assessment));
    }
  }

  /// Carrega última avaliação
  Future<void> _onLoadLatestAssessment(
    LoadLatestAssessmentEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    try {
      final latestAssessment = await _assessmentRepository.getLatestAssessment(
        event.woundId,
      );

      if (state is AssessmentLoadedState) {
        final currentState = state as AssessmentLoadedState;
        emit(currentState.copyWith(latestAssessment: latestAssessment));
      } else {
        emit(
          AssessmentLoadedState(
            assessments: const [],
            latestAssessment: latestAssessment,
            currentWoundId: event.woundId,
          ),
        );
      }
    } catch (e) {
      emit(
        AssessmentErrorState(
          message: 'Erro ao carregar última avaliação: $e',
          currentWoundId: event.woundId,
        ),
      );
    }
  }

  /// Carrega histórico de avaliações
  Future<void> _onLoadAssessmentHistory(
    LoadAssessmentHistoryEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    try {
      final assessments = await _assessmentRepository
          .getAssessmentsSortedByDate(event.woundId, limit: event.limit);

      emit(
        AssessmentLoadedState(
          assessments: assessments,
          currentWoundId: event.woundId,
        ),
      );
    } catch (e) {
      emit(
        AssessmentErrorState(
          message: 'Erro ao carregar histórico: $e',
          currentWoundId: event.woundId,
        ),
      );
    }
  }

  /// Filtra avaliações
  Future<void> _onFilterAssessments(
    FilterAssessmentsEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    try {
      emit(const AssessmentLoadingState());

      final assessments = await _assessmentRepository.getAssessmentsWithFilters(
        woundId: event.woundId,
        fromDate: event.fromDate,
        toDate: event.toDate,
        minPainScale: event.minPainScale,
        maxPainScale: event.maxPainScale,
      );

      final filters = <String, dynamic>{};
      if (event.woundId != null) filters['woundId'] = event.woundId;
      if (event.fromDate != null) filters['fromDate'] = event.fromDate;
      if (event.toDate != null) filters['toDate'] = event.toDate;
      if (event.minPainScale != null) {
        filters['minPainScale'] = event.minPainScale;
      }
      if (event.maxPainScale != null) {
        filters['maxPainScale'] = event.maxPainScale;
      }

      emit(
        AssessmentLoadedState(
          assessments: assessments,
          currentWoundId: event.woundId,
          activeFilters: filters.isNotEmpty ? filters : null,
        ),
      );
    } catch (e) {
      emit(
        AssessmentErrorState(
          message: 'Erro ao filtrar avaliações: $e',
          currentWoundId: event.woundId,
        ),
      );
    }
  }

  /// Obtém a lista atual de avaliações do estado
  List<AssessmentManual> _getCurrentAssessments() {
    if (state is AssessmentLoadedState) {
      return (state as AssessmentLoadedState).assessments;
    }
    if (state is AssessmentErrorState) {
      return (state as AssessmentErrorState).assessments;
    }
    if (state is AssessmentOperationInProgressState) {
      return (state as AssessmentOperationInProgressState).assessments;
    }
    if (state is AssessmentOperationSuccessState) {
      return (state as AssessmentOperationSuccessState).assessments;
    }
    return [];
  }

  /// Obtém a avaliação selecionada atual do estado
  AssessmentManual? _getCurrentSelectedAssessment() {
    if (state is AssessmentLoadedState) {
      return (state as AssessmentLoadedState).selectedAssessment;
    }
    if (state is AssessmentErrorState) {
      return (state as AssessmentErrorState).selectedAssessment;
    }
    if (state is AssessmentOperationInProgressState) {
      return (state as AssessmentOperationInProgressState).selectedAssessment;
    }
    if (state is AssessmentOperationSuccessState) {
      return (state as AssessmentOperationSuccessState).selectedAssessment;
    }
    return null;
  }

  /// Obtém o ID da ferida atual do estado
  String? _getCurrentWoundId() {
    if (state is AssessmentLoadedState) {
      return (state as AssessmentLoadedState).currentWoundId;
    }
    if (state is AssessmentErrorState) {
      return (state as AssessmentErrorState).currentWoundId;
    }
    if (state is AssessmentOperationInProgressState) {
      return (state as AssessmentOperationInProgressState).currentWoundId;
    }
    if (state is AssessmentOperationSuccessState) {
      return (state as AssessmentOperationSuccessState).currentWoundId;
    }
    return null;
  }

  /// Processa upload de fotos em background
  Future<void> _processPhotoUploads({
    required String assessmentId,
    required String woundId,
    required List<String> photoPaths,
  }) async {
    for (final photoPath in photoPaths) {
      try {
        AppLogger.info('[AssessmentBloc] 📸 Processando foto: $photoPath');

        // 1. Criar registro Media pendente
        final media = Media.createLocal(
          assessmentId: assessmentId,
          type: MediaType.image,
          localPath: photoPath,
        );

        final createdMedia = await _mediaRepository.createMedia(media);
        AppLogger.info('[AssessmentBloc] ✅ Media criado: ${createdMedia.id}');

        // 2. Comprimir imagem
        AppLogger.info('[AssessmentBloc] 🗜️ Comprimindo imagem...');
        final compressed = await _storageService.compressImage(photoPath);
        AppLogger.info(
          '[AssessmentBloc] ✅ Comprimido: ${(compressed.originalSize / 1024).toStringAsFixed(2)}KB → ${(compressed.compressedSize / 1024).toStringAsFixed(2)}KB',
        );

        // 3. Atualizar status para uploading
        await _mediaRepository.updateMedia(
          createdMedia.copyWith(uploadStatus: UploadStatus.uploading),
        );

        // 4. Fazer upload para Storage
        AppLogger.info('[AssessmentBloc] ☁️ Iniciando upload...');

        // Obter IDs necessários (precisamos buscar do assessment)
        final assessment = await _assessmentRepository.getAssessmentById(
          assessmentId,
        );
        if (assessment == null) {
          throw Exception('Assessment não encontrado: $assessmentId');
        }

        // Buscar patientId através do wound
        // Por ora, vamos usar um placeholder - isso será resolvido na integração completa
        const ownerId = 'temp_owner'; // TODO: Obter do AuthRepository
        const patientId = 'temp_patient'; // TODO: Obter via WoundRepository

        final uploadResult = await _storageService.uploadPhoto(
          ownerId: ownerId,
          patientId: patientId,
          woundId: woundId,
          assessmentId: assessmentId,
          localPath: photoPath,
          compressedBytes: compressed.bytes,
          mimeType: compressed.mimeType,
          onProgress: (progress) {
            // Atualizar progresso no repositório
            unawaited(
              _mediaRepository.updateUploadProgress(createdMedia.id, progress),
            );
          },
        );

        AppLogger.info(
          '[AssessmentBloc] ✅ Upload concluído: ${uploadResult.downloadUrl}',
        );

        // 5. Marcar upload como completo
        await _mediaRepository.completeUpload(
          createdMedia.id,
          uploadResult.storagePath,
          uploadResult.downloadUrl,
        );

        // 6. Registrar evento no Analytics
        await _analytics.logPhotoUploaded(photoCount: 1);

        AppLogger.info('[AssessmentBloc] ✅ Foto processada com sucesso!');
      } catch (e, stackTrace) {
        AppLogger.error(
          '[AssessmentBloc] ❌ Erro ao processar foto: $photoPath',
          error: e,
          stackTrace: stackTrace,
        );

        // Marcar upload como falho
        try {
          final failedMedia = await _mediaRepository.getMediaByAssessment(
            assessmentId,
          );
          final media = failedMedia.firstWhere(
            (m) => m.localPath == photoPath,
            orElse: () => throw Exception('Media não encontrado'),
          );

          await _mediaRepository.failUpload(
            media.id,
            'Erro ao fazer upload: ${e.toString()}',
          );
        } catch (updateError) {
          AppLogger.error(
            '[AssessmentBloc] ❌ Erro ao atualizar status de falha',
            error: updateError,
          );
        }
      }
    }
  }

  @override
  Future<void> close() {
    _assessmentsSubscription?.cancel();
    return super.close();
  }
}
