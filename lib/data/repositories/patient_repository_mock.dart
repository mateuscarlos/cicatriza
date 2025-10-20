import 'dart:async';
import '../../domain/entities/patient_manual.dart';
import '../../domain/repositories/patient_repository_manual.dart';

/// Implementação mock do repositório de pacientes para MVP
class PatientRepositoryMock implements PatientRepository {
  final List<PatientManual> _patients = [];
  final _patientsController = StreamController<List<PatientManual>>.broadcast();

  PatientRepositoryMock() {
    // Adiciona alguns pacientes de exemplo para demonstração
    _patients.addAll([
      PatientManual(
        id: '1',
        name: 'João Silva',
        nameLowercase: 'joão silva',
        birthDate: DateTime(1980, 5, 15),
        phone: '(11) 98765-4321',
        email: 'joao.silva@email.com',
        archived: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      PatientManual(
        id: '2',
        name: 'Maria Santos',
        nameLowercase: 'maria santos',
        birthDate: DateTime(1965, 8, 22),
        phone: '(11) 97654-3210',
        archived: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
    ]);
  }

  @override
  Future<List<PatientManual>> getPatients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_patients.where((p) => !p.archived));
  }

  @override
  Future<List<PatientManual>> searchPatients(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final lowerQuery = query.toLowerCase();
    return _patients
        .where((p) => p.nameLowercase.contains(lowerQuery))
        .toList();
  }

  @override
  Future<PatientManual?> getPatientById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PatientManual> createPatient(PatientManual patient) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newPatient = patient.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _patients.add(newPatient);
    _patientsController.add(List.from(_patients));
    return newPatient;
  }

  @override
  Future<PatientManual> updatePatient(PatientManual patient) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _patients.indexWhere((p) => p.id == patient.id);
    if (index != -1) {
      _patients[index] = patient.copyWith(updatedAt: DateTime.now());
      _patientsController.add(List.from(_patients));
      return _patients[index];
    }
    throw Exception('Paciente não encontrado');
  }

  @override
  Future<PatientManual> togglePatientArchived(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _patients.indexWhere((p) => p.id == patientId);
    if (index != -1) {
      _patients[index] = _patients[index].copyWith(
        archived: !_patients[index].archived,
        updatedAt: DateTime.now(),
      );
      _patientsController.add(List.from(_patients));
      return _patients[index];
    }
    throw Exception('Paciente não encontrado');
  }

  @override
  Future<void> deletePatient(String patientId) async {
    await togglePatientArchived(patientId);
  }

  @override
  Stream<List<PatientManual>> watchPatients() {
    return _patientsController.stream;
  }

  @override
  Stream<PatientManual?> watchPatient(String patientId) {
    return _patientsController.stream.map((patients) {
      try {
        return patients.firstWhere((p) => p.id == patientId);
      } catch (e) {
        return null;
      }
    });
  }

  void dispose() {
    _patientsController.close();
  }
}
