import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PatientRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  CollectionReference<Map<String, dynamic>> get _collection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    return _firestore.collection('users').doc(userId).collection('patients');
  }

  @override
  Future<List<Patient>> getPatients() async {
    try {
      final snapshot = await _collection
          .where('archived', isEqualTo: false)
          .orderBy('nameLowercase')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Patient.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar pacientes: $e');
    }
  }

  @override
  Future<List<Patient>> searchPatients(String query) async {
    try {
      final lowerQuery = query.toLowerCase();
      final snapshot = await _collection
          .where('archived', isEqualTo: false)
          .where('nameLowercase', isGreaterThanOrEqualTo: lowerQuery)
          .where('nameLowercase', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .orderBy('nameLowercase')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Patient.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar pacientes: $e');
    }
  }

  @override
  Future<Patient?> getPatientById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      return Patient.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao buscar paciente: $e');
    }
  }

  @override
  Future<Patient> createPatient(Patient patient) async {
    try {
      final data = patient.toJson();
      data.remove('id'); // Remove o ID para deixar o Firestore gerar

      final docRef = await _collection.add(data);
      return patient.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Erro ao criar paciente: $e');
    }
  }

  @override
  Future<Patient> updatePatient(Patient patient) async {
    try {
      final data = patient.toJson();
      data.remove('id');
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _collection.doc(patient.id).update(data);
      return patient.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Erro ao atualizar paciente: $e');
    }
  }

  @override
  Future<Patient> togglePatientArchived(String patientId) async {
    try {
      final patient = await getPatientById(patientId);
      if (patient == null) throw Exception('Paciente não encontrado');

      final updatedPatient = patient.copyWith(
        archived: !patient.archived,
        updatedAt: DateTime.now(),
      );

      await updatePatient(updatedPatient);
      return updatedPatient;
    } catch (e) {
      throw Exception('Erro ao arquivar/desarquivar paciente: $e');
    }
  }

  @override
  Future<void> deletePatient(String patientId) async {
    try {
      await _collection.doc(patientId).update({
        'archived': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao deletar paciente: $e');
    }
  }

  @override
  Stream<List<Patient>> watchPatients() {
    return _collection
        .where('archived', isEqualTo: false)
        .orderBy('nameLowercase')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Patient.fromJson(data);
          }).toList();
        });
  }

  @override
  Stream<Patient?> watchPatient(String patientId) {
    return _collection.doc(patientId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data()!;
      data['id'] = doc.id;
      return Patient.fromJson(data);
    });
  }
}
