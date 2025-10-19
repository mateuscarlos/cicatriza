import '../entities/wound.dart';

/// Interface para repositório de feridas
abstract class WoundRepository {
  /// Lista todas as feridas de um paciente
  Future<List<Wound>> getWoundsByPatient(String patientId);

  /// Busca uma ferida por ID
  Future<Wound?> getWoundById(String woundId);

  /// Cria uma nova ferida
  Future<Wound> createWound(Wound wound);

  /// Atualiza uma ferida existente
  Future<Wound> updateWound(Wound wound);

  /// Deleta uma ferida
  Future<void> deleteWound(String woundId);

  /// Atualiza o status de uma ferida
  Future<Wound> updateWoundStatus(String woundId, WoundStatus status);

  /// Stream de feridas de um paciente para atualizações em tempo real
  Stream<List<Wound>> watchWoundsByPatient(String patientId);

  /// Stream de uma ferida específica
  Stream<Wound?> watchWound(String woundId);

  /// Lista feridas por status
  Future<List<Wound>> getWoundsByStatus(String patientId, WoundStatus status);
}
