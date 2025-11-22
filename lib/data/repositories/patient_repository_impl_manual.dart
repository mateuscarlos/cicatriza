import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/patient_manual.dart';
import '../../domain/repositories/patient_repository_manual.dart';

class PatientRepositoryImpl implements PatientRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PatientRepositoryImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Referência da coleção de pacientes do usuário atual
  CollectionReference<Map<String, dynamic>> get _patientsCollection {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }
    return _firestore.collection('users').doc(user.uid).collection('patients');
  }

  @override
  Future<List<PatientManual>> getPatients() async {
    try {
      final querySnapshot = await _patientsCollection
          .where('archived', isEqualTo: false)
          .orderBy('nameLowercase')
          .get();

      return querySnapshot.docs.map((doc) => _fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar pacientes: $e');
    }
  }

  @override
  Future<List<PatientManual>> searchPatients(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase();

      final querySnapshot = await _patientsCollection
          .where('archived', isEqualTo: false)
          .where('nameLowercase', isGreaterThanOrEqualTo: lowercaseQuery)
          .where('nameLowercase', isLessThan: '$lowercaseQuery\uf8ff')
          .orderBy('nameLowercase')
          .get();

      return querySnapshot.docs.map((doc) => _fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar pacientes: $e');
    }
  }

  @override
  Future<PatientManual?> getPatientById(String id) async {
    try {
      final doc = await _patientsCollection.doc(id).get();
      if (!doc.exists) return null;
      return _fromFirestore(doc);
    } catch (e) {
      throw Exception('Erro ao buscar paciente: $e');
    }
  }

  @override
  Future<PatientManual> createPatient(PatientManual patient) async {
    try {
      final docRef = _patientsCollection.doc();
      final now = DateTime.now();

      final patientWithId = patient.copyWith(
        id: docRef.id,
        createdAt: now,
        updatedAt: now,
      );

      await docRef.set(_toFirestore(patientWithId));
      return patientWithId;
    } catch (e) {
      throw Exception('Erro ao criar paciente: $e');
    }
  }

  @override
  Future<PatientManual> updatePatient(PatientManual patient) async {
    try {
      final updatedPatient = patient.copyWith(updatedAt: DateTime.now());

      await _patientsCollection
          .doc(patient.id)
          .update(_toFirestore(updatedPatient));
      return updatedPatient;
    } catch (e) {
      throw Exception('Erro ao atualizar paciente: $e');
    }
  }

  @override
  Future<PatientManual> togglePatientArchived(String patientId) async {
    try {
      final doc = await _patientsCollection.doc(patientId).get();
      if (!doc.exists) {
        throw Exception('Paciente não encontrado');
      }

      final patient = _fromFirestore(doc);
      final updatedPatient = patient.copyWith(
        archived: !patient.archived,
        updatedAt: DateTime.now(),
      );

      await _patientsCollection
          .doc(patientId)
          .update(_toFirestore(updatedPatient));
      return updatedPatient;
    } catch (e) {
      throw Exception('Erro ao arquivar/desarquivar paciente: $e');
    }
  }

  @override
  Future<void> deletePatient(String patientId) async {
    try {
      // Soft delete - apenas arquiva o paciente
      await togglePatientArchived(patientId);
    } catch (e) {
      throw Exception('Erro ao deletar paciente: $e');
    }
  }

  @override
  Stream<List<PatientManual>> watchPatients() {
    try {
      return _patientsCollection
          .where('archived', isEqualTo: false)
          .orderBy('nameLowercase')
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs.map((doc) => _fromFirestore(doc)).toList(),
          );
    } catch (e) {
      throw Exception('Erro ao escutar pacientes: $e');
    }
  }

  @override
  Stream<PatientManual?> watchPatient(String patientId) {
    try {
      return _patientsCollection
          .doc(patientId)
          .snapshots()
          .map((doc) => doc.exists ? _fromFirestore(doc) : null);
    } catch (e) {
      throw Exception('Erro ao escutar paciente: $e');
    }
  }

  /// Converte documento do Firestore para PatientManual
  PatientManual _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PatientManual(
      id: doc.id,
      name: data['name'] as String,
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      archived: data['archived'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      nameLowercase: data['nameLowercase'] as String,
      notes: data['notes'] as String?,
      phone: data['phone'] as String?,
      email: data['email'] as String?,
    );
  }

  /// Converte PatientManual para Map do Firestore
  Map<String, dynamic> _toFirestore(PatientManual patient) {
    return {
      'name': patient.name,
      'birthDate': Timestamp.fromDate(patient.birthDate),
      'archived': patient.archived,
      'createdAt': Timestamp.fromDate(patient.createdAt),
      'updatedAt': Timestamp.fromDate(patient.updatedAt),
      'nameLowercase': patient.nameLowercase,
      'notes': patient.notes,
      'phone': patient.phone,
      'email': patient.email,
    };
  }
}
