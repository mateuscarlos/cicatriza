import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/assessment.dart';
import '../../domain/repositories/assessment_repository.dart';
import '../models/assessment_model_v2.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AssessmentRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  CollectionReference<Map<String, dynamic>> _getAssessmentsCollection(
    String patientId,
    String woundId,
  ) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection('estomaterapeutas')
        .doc(userId)
        .collection('pacientes')
        .doc(patientId)
        .collection('feridas')
        .doc(woundId)
        .collection('avaliacoes');
  }

  Future<String> _getPatientIdFromWound(String woundId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final patientsSnapshot = await _firestore
        .collection('estomaterapeutas')
        .doc(userId)
        .collection('pacientes')
        .get();

    for (final patientDoc in patientsSnapshot.docs) {
      final woundDoc = await patientDoc.reference
          .collection('feridas')
          .doc(woundId)
          .get();

      if (woundDoc.exists) {
        return patientDoc.id;
      }
    }

    throw Exception('Patient not found for wound: $woundId');
  }

  @override
  Future<List<Assessment>> getAssessmentsByWound(String woundId) async {
    try {
      final patientId = await _getPatientIdFromWound(woundId);
      final snapshot = await _getAssessmentsCollection(patientId, woundId)
          .where('archived', isEqualTo: false)
          .orderBy('criadoEm', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final model = AssessmentModel.fromFirestore(doc);
        return model.toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar avaliações: $e');
    }
  }

  @override
  Future<Assessment?> getAssessmentById(String assessmentId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final patientsSnapshot = await _firestore
          .collection('estomaterapeutas')
          .doc(userId)
          .collection('pacientes')
          .get();

      for (final patientDoc in patientsSnapshot.docs) {
        final woundsSnapshot = await patientDoc.reference
            .collection('feridas')
            .get();

        for (final woundDoc in woundsSnapshot.docs) {
          final assessmentDoc = await woundDoc.reference
              .collection('avaliacoes')
              .doc(assessmentId)
              .get();

          if (assessmentDoc.exists) {
            final model = AssessmentModel.fromFirestore(assessmentDoc);
            return model.toEntity();
          }
        }
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao buscar avaliação: $e');
    }
  }

  @override
  Future<Assessment> createAssessment(Assessment assessment) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final patientId = await _getPatientIdFromWound(assessment.woundId);

      final model = AssessmentModel.fromEntity(
        assessment,
      ).copyWith(ownerId: userId, patientId: patientId);

      final data = model.toFirestore();
      data.remove('assessmentId');

      final docRef = await _getAssessmentsCollection(
        patientId,
        assessment.woundId,
      ).add(data);

      return assessment.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Erro ao criar avaliação: $e');
    }
  }

  @override
  Future<Assessment> updateAssessment(Assessment assessment) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final patientId = await _getPatientIdFromWound(assessment.woundId);

      final model = AssessmentModel.fromEntity(
        assessment,
      ).copyWith(ownerId: userId, patientId: patientId);

      final data = model.toFirestore();
      data.remove('assessmentId');
      data['atualizadoEm'] = FieldValue.serverTimestamp();

      await _getAssessmentsCollection(
        patientId,
        assessment.woundId,
      ).doc(assessment.id).update(data);

      return assessment.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Erro ao atualizar avaliação: $e');
    }
  }

  @override
  Future<void> deleteAssessment(String assessmentId) async {
    try {
      final assessment = await getAssessmentById(assessmentId);
      if (assessment == null) throw Exception('Avaliação não encontrada');

      final patientId = await _getPatientIdFromWound(assessment.woundId);

      await _getAssessmentsCollection(
        patientId,
        assessment.woundId,
      ).doc(assessmentId).update({
        'archived': true,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao deletar avaliação: $e');
    }
  }

  @override
  Stream<List<Assessment>> watchAssessmentsByWound(String woundId) {
    return Stream.fromFuture(_getPatientIdFromWound(woundId)).asyncExpand((
      patientId,
    ) {
      return _getAssessmentsCollection(patientId, woundId)
          .where('archived', isEqualTo: false)
          .orderBy('criadoEm', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final model = AssessmentModel.fromFirestore(doc);
              return model.toEntity();
            }).toList();
          });
    });
  }

  @override
  Stream<Assessment?> watchAssessment(String assessmentId) {
    return Stream.fromFuture(getAssessmentById(assessmentId));
  }

  @override
  Future<List<Assessment>> getAssessmentsByDateRange(
    String woundId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final patientId = await _getPatientIdFromWound(woundId);
      final snapshot = await _getAssessmentsCollection(patientId, woundId)
          .where('archived', isEqualTo: false)
          .where(
            'criadoEm',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .where('criadoEm', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('criadoEm', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final model = AssessmentModel.fromFirestore(doc);
        return model.toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar avaliações por data: $e');
    }
  }

  @override
  Future<Assessment?> getLatestAssessment(String woundId) async {
    try {
      final patientId = await _getPatientIdFromWound(woundId);
      final snapshot = await _getAssessmentsCollection(patientId, woundId)
          .where('archived', isEqualTo: false)
          .orderBy('criadoEm', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final model = AssessmentModel.fromFirestore(snapshot.docs.first);
      return model.toEntity();
    } catch (e) {
      throw Exception('Erro ao buscar última avaliação: $e');
    }
  }

  @override
  Future<List<Assessment>> getAssessmentsSortedByDate(String woundId) async {
    return getAssessmentsByWound(woundId);
  }
}

extension AssessmentModelExtensions on AssessmentModel {
  AssessmentModel copyWith({
    String? assessmentId,
    String? ownerId,
    String? patientId,
    String? woundId,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
    int? pain,
    double? lengthCm,
    double? widthCm,
    double? depthCm,
    String? observacoes,
    String? exudate,
    String? edgeAppearance,
    String? woundBed,
    String? periwoundSkin,
    String? odor,
    String? treatmentPlan,
    bool? archived,
  }) {
    return AssessmentModel(
      assessmentId: assessmentId ?? this.assessmentId,
      ownerId: ownerId ?? this.ownerId,
      patientId: patientId ?? this.patientId,
      woundId: woundId ?? this.woundId,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      pain: pain ?? this.pain,
      lengthCm: lengthCm ?? this.lengthCm,
      widthCm: widthCm ?? this.widthCm,
      depthCm: depthCm ?? this.depthCm,
      observacoes: observacoes ?? this.observacoes,
      exudate: exudate ?? this.exudate,
      edgeAppearance: edgeAppearance ?? this.edgeAppearance,
      woundBed: woundBed ?? this.woundBed,
      periwoundSkin: periwoundSkin ?? this.periwoundSkin,
      odor: odor ?? this.odor,
      treatmentPlan: treatmentPlan ?? this.treatmentPlan,
      archived: archived ?? this.archived,
    );
  }
}
