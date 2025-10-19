import '../../domain/entities/patient_manual.dart';

/// Eventos do PatientBloc
abstract class PatientEvent {
  const PatientEvent();
}

/// Carrega lista de pacientes
class LoadPatientsEvent extends PatientEvent {
  const LoadPatientsEvent();
}

/// Busca pacientes por termo
class SearchPatientsEvent extends PatientEvent {
  final String query;

  const SearchPatientsEvent(this.query);
}

/// Cria um novo paciente
class CreatePatientEvent extends PatientEvent {
  final String name;
  final DateTime birthDate;
  final String? notes;
  final String? phone;
  final String? email;

  const CreatePatientEvent({
    required this.name,
    required this.birthDate,
    this.notes,
    this.phone,
    this.email,
  });
}

/// Atualiza um paciente existente
class UpdatePatientEvent extends PatientEvent {
  final PatientManual patient;

  const UpdatePatientEvent(this.patient);
}

/// Arquiva um paciente
class ArchivePatientEvent extends PatientEvent {
  final String patientId;

  const ArchivePatientEvent(this.patientId);
}

/// Seleciona um paciente
class SelectPatientEvent extends PatientEvent {
  final PatientManual? patient;

  const SelectPatientEvent(this.patient);
}

/// Limpa a busca
class ClearSearchEvent extends PatientEvent {
  const ClearSearchEvent();
}
