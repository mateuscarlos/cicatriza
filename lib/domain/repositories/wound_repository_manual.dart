import '../entities/wound_manual.dart';

/// Interface para repositório de feridas usando entidade manual
abstract class WoundRepository {
  /// Lista todas as feridas de um paciente
  Future<List<WoundManual>> getWoundsByPatientId(String patientId);

  /// Busca uma ferida por ID
  Future<WoundManual?> getWoundById(String id);

  /// Cria uma nova ferida
  Future<WoundManual> createWound(WoundManual wound);

  /// Atualiza uma ferida existente
  Future<WoundManual> updateWound(WoundManual wound);

  /// Deleta uma ferida
  Future<void> deleteWound(String woundId);

  /// Atualiza o status de uma ferida
  Future<WoundManual> updateWoundStatus(String woundId, String newStatus);

  /// Stream de feridas de um paciente para atualizações em tempo real
  Stream<List<WoundManual>> watchWounds(String patientId);

  /// Stream de uma ferida específica
  Stream<WoundManual?> watchWound(String woundId);

  /// Lista feridas com filtros
  Future<List<WoundManual>> getWoundsWithFilters({
    String? patientId,
    String? status,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
  });
}
