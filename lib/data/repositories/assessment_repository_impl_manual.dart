import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/assessment_manual.dart';
import '../../domain/repositories/assessment_repository_manual.dart';

/// Implementação do repositório de avaliações usando Firestore
class AssessmentRepositoryImplManual implements AssessmentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AssessmentRepositoryImplManual({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  /// Coleção de avaliações do usuário atual
  CollectionReference<Map<String, dynamic>> get _assessmentsCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuário não autenticado');
    }
    return _firestore.collection('users').doc(userId).collection('assessments');
  }

  @override
  Future<AssessmentManual> createAssessment(AssessmentManual assessment) async {
    try {
      final docRef = await _assessmentsCollection.add(_toFirestore(assessment));
      final createdAssessment = assessment.copyWith(id: docRef.id);
      return createdAssessment;
    } catch (e) {
      throw Exception('Falha ao criar avaliação: $e');
    }
  }

  @override
  Future<AssessmentManual?> getAssessmentById(String id) async {
    try {
      final doc = await _assessmentsCollection.doc(id).get();
      if (!doc.exists) return null;
      return _fromFirestore(doc);
    } catch (e) {
      throw Exception('Falha ao buscar avaliação: $e');
    }
  }

  @override
  Future<List<AssessmentManual>> getAssessmentsByWoundId(String woundId) async {
    try {
      final querySnapshot = await _assessmentsCollection
          .where('woundId', isEqualTo: woundId)
          .where('archived', isEqualTo: false)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map(_fromFirestore).toList();
    } catch (e) {
      throw Exception('Falha ao buscar avaliações da ferida: $e');
    }
  }

  @override
  Future<AssessmentManual> updateAssessment(AssessmentManual assessment) async {
    try {
      final updatedAssessment = assessment.copyWith(updatedAt: DateTime.now());
      await _assessmentsCollection
          .doc(assessment.id)
          .update(_toFirestore(updatedAssessment));
      return updatedAssessment;
    } catch (e) {
      throw Exception('Falha ao atualizar avaliação: $e');
    }
  }

  @override
  Future<void> deleteAssessment(String assessmentId) async {
    try {
      await _assessmentsCollection.doc(assessmentId).delete();
    } catch (e) {
      throw Exception('Falha ao deletar avaliação: $e');
    }
  }

  @override
  Stream<List<AssessmentManual>> watchAssessments(String woundId) {
    return _assessmentsCollection
        .where('woundId', isEqualTo: woundId)
        .where('archived', isEqualTo: false)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromFirestore).toList());
  }

  @override
  Stream<AssessmentManual?> watchAssessment(String assessmentId) {
    return _assessmentsCollection.doc(assessmentId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return _fromFirestore(doc);
    });
  }

  @override
  Future<List<AssessmentManual>> getAssessmentsWithFilters({
    String? woundId,
    DateTime? fromDate,
    DateTime? toDate,
    int? minPainScale,
    int? maxPainScale,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _assessmentsCollection.where(
        'archived',
        isEqualTo: false,
      );

      if (woundId != null) {
        query = query.where('woundId', isEqualTo: woundId);
      }

      if (minPainScale != null) {
        query = query.where('painScale', isGreaterThanOrEqualTo: minPainScale);
      }

      if (maxPainScale != null) {
        query = query.where('painScale', isLessThanOrEqualTo: maxPainScale);
      }

      if (fromDate != null) {
        query = query.where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate),
        );
      }

      if (toDate != null) {
        query = query.where(
          'date',
          isLessThanOrEqualTo: Timestamp.fromDate(toDate),
        );
      }

      final querySnapshot = await query.orderBy('date', descending: true).get();

      return querySnapshot.docs.map(_fromFirestore).toList();
    } catch (e) {
      throw Exception('Falha ao buscar avaliações com filtros: $e');
    }
  }

  @override
  Future<AssessmentManual?> getLatestAssessment(String woundId) async {
    try {
      final querySnapshot = await _assessmentsCollection
          .where('woundId', isEqualTo: woundId)
          .where('archived', isEqualTo: false)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return _fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Falha ao buscar última avaliação: $e');
    }
  }

  @override
  Future<List<AssessmentManual>> getAssessmentsSortedByDate(
    String woundId, {
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _assessmentsCollection
          .where('woundId', isEqualTo: woundId)
          .where('archived', isEqualTo: false)
          .orderBy('date', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map(_fromFirestore).toList();
    } catch (e) {
      throw Exception('Falha ao buscar histórico de avaliações: $e');
    }
  }

  /// Converte documento Firestore para entidade AssessmentManual
  AssessmentManual _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AssessmentManual.fromJson({
      ...data,
      'id': doc.id,
      'date': (data['date'] as Timestamp).toDate().toIso8601String(),
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  /// Converte entidade AssessmentManual para dados do Firestore
  Map<String, dynamic> _toFirestore(AssessmentManual assessment) {
    final json = assessment.toJson();
    json.remove('id'); // Remove o ID do mapa

    // Converte DateTime para Timestamp
    json['date'] = Timestamp.fromDate(assessment.date);
    json['createdAt'] = Timestamp.fromDate(assessment.createdAt);
    json['updatedAt'] = Timestamp.fromDate(assessment.updatedAt);

    return json;
  }
}
