import '../entities/audit_log.dart';

/// Repositório para gerenciamento de logs de auditoria
abstract class AuditRepository {
  /// Registra um novo log de auditoria
  Future<void> logAction({
    required String userId,
    required String action,
    Map<String, dynamic>? metadata,
  });

  /// Obtém os logs de auditoria de um usuário
  Future<List<AuditLog>> getUserLogs(String userId, {int limit = 50});

  /// Obtém os logs de auditoria por ação
  Future<List<AuditLog>> getLogsByAction(
    String userId,
    String action, {
    int limit = 20,
  });

  /// Limpa logs antigos (mais de 90 dias)
  Future<void> cleanOldLogs(String userId);
}
