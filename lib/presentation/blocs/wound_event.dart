import '../../domain/entities/wound_manual.dart';

/// Eventos do WoundBloc
abstract class WoundEvent {
  const WoundEvent();
}

/// Carrega feridas de um paciente
class LoadWoundsByPatientEvent extends WoundEvent {
  final String patientId;

  const LoadWoundsByPatientEvent(this.patientId);
}

/// Cria uma nova ferida
class CreateWoundEvent extends WoundEvent {
  final String patientId;
  final String type;
  final String location;
  final String? locationDescription;
  final String? causeDescription;

  const CreateWoundEvent({
    required this.patientId,
    required this.type,
    required this.location,
    this.locationDescription,
    this.causeDescription,
  });
}

/// Atualiza uma ferida existente
class UpdateWoundEvent extends WoundEvent {
  final WoundManual wound;

  const UpdateWoundEvent(this.wound);
}

/// Atualiza apenas o status de uma ferida
class UpdateWoundStatusEvent extends WoundEvent {
  final String woundId;
  final String newStatus;

  const UpdateWoundStatusEvent({
    required this.woundId,
    required this.newStatus,
  });
}

/// Deleta uma ferida
class DeleteWoundEvent extends WoundEvent {
  final String woundId;

  const DeleteWoundEvent(this.woundId);
}

/// Seleciona uma ferida
class SelectWoundEvent extends WoundEvent {
  final WoundManual? wound;

  const SelectWoundEvent(this.wound);
}

/// Busca feridas com filtros
class FilterWoundsEvent extends WoundEvent {
  final String? patientId;
  final String? status;
  final String? type;
  final DateTime? fromDate;
  final DateTime? toDate;

  const FilterWoundsEvent({
    this.patientId,
    this.status,
    this.type,
    this.fromDate,
    this.toDate,
  });
}

/// Limpa filtros
class ClearFiltersEvent extends WoundEvent {
  final String patientId;

  const ClearFiltersEvent(this.patientId);
}
