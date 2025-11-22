import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/wound_manual.dart';
import '../../domain/repositories/wound_repository_manual.dart';

/// Implementação do repositório de feridas usando Firestore
class WoundRepositoryImplManual implements WoundRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  WoundRepositoryImplManual({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Coleção de feridas do usuário atual
  CollectionReference<Map<String, dynamic>> get _woundsCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuário não autenticado');
    }
    return _firestore.collection('users').doc(userId).collection('wounds');
  }

  @override
  Future<WoundManual> createWound(WoundManual wound) async {
    try {
      final docRef = await _woundsCollection.add(_toFirestore(wound));
      final createdWound = wound.copyWith(id: docRef.id);
      return createdWound;
    } catch (e) {
      throw Exception('Falha ao criar ferida: $e');
    }
  }

  @override
  Future<WoundManual?> getWoundById(String id) async {
    try {
      final doc = await _woundsCollection.doc(id).get();
      if (!doc.exists) return null;
      return _fromFirestore(doc);
    } catch (e) {
      throw Exception('Falha ao buscar ferida: $e');
    }
  }

  @override
  Future<List<WoundManual>> getWoundsByPatientId(String patientId) async {
    try {
      final querySnapshot = await _woundsCollection
          .where('patientId', isEqualTo: patientId)
          .where('archived', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map(_fromFirestore).toList();
    } catch (e) {
      throw Exception('Falha ao buscar feridas do paciente: $e');
    }
  }

  @override
  Future<WoundManual> updateWound(WoundManual wound) async {
    try {
      final updatedWound = wound.copyWith(updatedAt: DateTime.now());
      await _woundsCollection.doc(wound.id).update(_toFirestore(updatedWound));
      return updatedWound;
    } catch (e) {
      throw Exception('Falha ao atualizar ferida: $e');
    }
  }

  @override
  Future<void> deleteWound(String woundId) async {
    try {
      await _woundsCollection.doc(woundId).delete();
    } catch (e) {
      throw Exception('Falha ao deletar ferida: $e');
    }
  }

  @override
  Future<WoundManual> updateWoundStatus(
    String woundId,
    String newStatus,
  ) async {
    try {
      final wound = await getWoundById(woundId);
      if (wound == null) {
        throw Exception('Ferida não encontrada');
      }

      final updatedWound = wound.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      await _woundsCollection.doc(woundId).update(_toFirestore(updatedWound));
      return updatedWound;
    } catch (e) {
      throw Exception('Falha ao atualizar status da ferida: $e');
    }
  }

  @override
  Stream<List<WoundManual>> watchWounds(String patientId) {
    return _woundsCollection
        .where('patientId', isEqualTo: patientId)
        .where('archived', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromFirestore).toList());
  }

  @override
  Stream<WoundManual?> watchWound(String woundId) {
    return _woundsCollection.doc(woundId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return _fromFirestore(doc);
    });
  }

  @override
  Future<List<WoundManual>> getWoundsWithFilters({
    String? patientId,
    String? status,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _woundsCollection.where(
        'archived',
        isEqualTo: false,
      );

      if (patientId != null) {
        query = query.where('patientId', isEqualTo: patientId);
      }

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }

      if (fromDate != null) {
        query = query.where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate),
        );
      }

      if (toDate != null) {
        query = query.where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(toDate),
        );
      }

      final querySnapshot = await query
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map(_fromFirestore).toList();
    } catch (e) {
      throw Exception('Falha ao buscar feridas com filtros: $e');
    }
  }

  /// Converte documento Firestore para entidade WoundManual
  WoundManual _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return WoundManual.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  /// Converte entidade WoundManual para dados do Firestore
  Map<String, dynamic> _toFirestore(WoundManual wound) {
    final json = wound.toJson();
    json.remove('id'); // Remove o ID do mapa

    // Converte DateTime para Timestamp
    json['createdAt'] = Timestamp.fromDate(wound.createdAt);
    json['updatedAt'] = Timestamp.fromDate(wound.updatedAt);

    return json;
  }
}
