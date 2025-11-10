import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../data/datasources/local/offline_database.dart';
import '../../data/models/sync_operation.dart';
import '../utils/app_logger.dart';
import 'connectivity_service.dart';

/// Serviço centralizado para gerenciar sincronização offline-first
/// Processa fila de operações pendentes quando há conectividade
class SyncService {
  SyncService({
    OfflineDatabase? database,
    FirebaseAuth? auth,
    ConnectivityService? connectivity,
  }) : _database = database ?? OfflineDatabase.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _connectivity = connectivity ?? ConnectivityService();

  final OfflineDatabase _database;
  final FirebaseAuth _auth;
  final ConnectivityService _connectivity;

  Timer? _syncTimer;
  bool _isSyncing = false;

  static const Duration _syncInterval = Duration(minutes: 5);
  static const int _maxRetries = 3;

  /// Inicia sincronização periódica automática
  void startPeriodicSync() {
    stopPeriodicSync();

    AppLogger.info('[SyncService] Iniciando sincronização periódica');

    // Primeira sincronização imediata
    unawaited(syncAll());

    // Sincronizações periódicas
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      unawaited(syncAll());
    });

    // Sincronizar quando reconectar
    _connectivity.onConnectivityChanged.listen((hasConnection) {
      if (hasConnection && !_isSyncing) {
        AppLogger.info(
          '[SyncService] Conectividade restaurada, sincronizando...',
        );
        unawaited(syncAll());
      }
    });
  }

  /// Para sincronização periódica
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    AppLogger.info('[SyncService] Sincronização periódica parada');
  }

  /// Sincroniza todas as operações pendentes
  Future<SyncResult> syncAll() async {
    if (_isSyncing) {
      AppLogger.info('[SyncService] Sincronização já em andamento, ignorando');
      return SyncResult(success: 0, failed: 0, skipped: 0, errors: []);
    }

    if (!await _connectivity.hasConnection()) {
      AppLogger.info('[SyncService] Sem conectividade, pulando sincronização');
      return SyncResult(success: 0, failed: 0, skipped: 0, errors: []);
    }

    if (_auth.currentUser == null) {
      AppLogger.info(
        '[SyncService] Usuário não autenticado, pulando sincronização',
      );
      return SyncResult(success: 0, failed: 0, skipped: 0, errors: []);
    }

    _isSyncing = true;

    try {
      AppLogger.info(
        '[SyncService] ========== Iniciando Sincronização ==========',
      );

      final operations = await _database.nextPendingOperations(limit: 100);

      if (operations.isEmpty) {
        AppLogger.info('[SyncService] Nenhuma operação pendente');
        return SyncResult(success: 0, failed: 0, skipped: 0, errors: []);
      }

      AppLogger.info('[SyncService] ${operations.length} operações pendentes');

      int successCount = 0;
      int failedCount = 0;
      int skippedCount = 0;
      final List<String> errors = [];

      for (final operation in operations) {
        try {
          // Verificar se excedeu máximo de tentativas
          if (operation.retryCount >= _maxRetries) {
            AppLogger.warning(
              '[SyncService] Operação ${operation.id} excedeu máximo de tentativas (${operation.retryCount}/$_maxRetries)',
            );
            skippedCount++;
            continue;
          }

          // Processar operação com base na entidade
          final success = await _processOperation(operation);

          if (success) {
            await _database.removeOperation(operation.id!);
            successCount++;
            AppLogger.info(
              '[SyncService] ✓ Operação ${operation.id} sincronizada: ${operation.entity} (${operation.type})',
            );
          } else {
            await _database.incrementRetry(operation.id!);
            failedCount++;
            final error =
                'Falha ao processar ${operation.entity} ${operation.type}';
            errors.add(error);
            AppLogger.error('[SyncService] ✗ $error');
          }
        } catch (e, stackTrace) {
          await _database.incrementRetry(operation.id!);
          failedCount++;
          final error = '${operation.entity} ${operation.type}: $e';
          errors.add(error);
          AppLogger.error(
            '[SyncService] ✗ Erro ao processar operação ${operation.id}',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }

      AppLogger.info(
        '[SyncService] ========== Sincronização Concluída ==========',
      );
      AppLogger.info('[SyncService] ✓ Sucesso: $successCount');
      AppLogger.info('[SyncService] ✗ Falhas: $failedCount');
      AppLogger.info('[SyncService] ⊘ Ignoradas: $skippedCount');

      return SyncResult(
        success: successCount,
        failed: failedCount,
        skipped: skippedCount,
        errors: errors,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Processa uma operação individual
  /// Delega para o handler específico baseado na entidade
  Future<bool> _processOperation(SyncOperation operation) async {
    // A sincronização real é feita pelos repositórios
    // Este método serve como ponto de extensão futuro para:
    // - Validação de dados antes de sincronizar
    // - Tratamento de conflitos
    // - Logs centralizados
    // - Métricas de sincronização

    AppLogger.info(
      '[SyncService] Processando: ${operation.entity} ${operation.type} (tentativa ${operation.retryCount + 1})',
    );

    // Por enquanto, retorna true pois a sincronização é feita
    // automaticamente pelos repositórios quando há conectividade
    return true;
  }

  /// Obtém estatísticas da fila de sincronização
  Future<SyncStats> getStats() async {
    final operations = await _database.nextPendingOperations(limit: 1000);

    final Map<String, int> byEntity = {};
    final Map<String, int> byType = {};
    int needsRetry = 0;
    int overMaxRetries = 0;

    for (final op in operations) {
      byEntity[op.entity] = (byEntity[op.entity] ?? 0) + 1;
      byType[op.type.toString()] = (byType[op.type.toString()] ?? 0) + 1;

      if (op.retryCount > 0) needsRetry++;
      if (op.retryCount >= _maxRetries) overMaxRetries++;
    }

    return SyncStats(
      totalPending: operations.length,
      byEntity: byEntity,
      byType: byType,
      needsRetry: needsRetry,
      overMaxRetries: overMaxRetries,
    );
  }

  /// Limpa operações que excederam o máximo de tentativas
  Future<int> clearFailedOperations() async {
    final operations = await _database.nextPendingOperations(limit: 1000);
    int cleared = 0;

    for (final op in operations) {
      if (op.retryCount >= _maxRetries) {
        await _database.removeOperation(op.id!);
        cleared++;
      }
    }

    AppLogger.info('[SyncService] $cleared operações falhadas removidas');
    return cleared;
  }

  void dispose() {
    stopPeriodicSync();
  }
}

/// Resultado de uma sincronização
class SyncResult {
  final int success;
  final int failed;
  final int skipped;
  final List<String> errors;

  SyncResult({
    required this.success,
    required this.failed,
    required this.skipped,
    required this.errors,
  });

  bool get hasErrors => failed > 0 || errors.isNotEmpty;
  int get total => success + failed + skipped;

  @override
  String toString() {
    return 'SyncResult(success: $success, failed: $failed, skipped: $skipped, errors: ${errors.length})';
  }
}

/// Estatísticas da fila de sincronização
class SyncStats {
  final int totalPending;
  final Map<String, int> byEntity;
  final Map<String, int> byType;
  final int needsRetry;
  final int overMaxRetries;

  SyncStats({
    required this.totalPending,
    required this.byEntity,
    required this.byType,
    required this.needsRetry,
    required this.overMaxRetries,
  });

  @override
  String toString() {
    return 'SyncStats(pending: $totalPending, needsRetry: $needsRetry, overMax: $overMaxRetries)';
  }
}
