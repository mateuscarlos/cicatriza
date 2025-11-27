import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/wound.dart';
import '../../domain/repositories/wound_repository.dart';
import '../models/wound_model.dart';

class WoundRepositoryImpl implements WoundRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  WoundRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  CollectionReference<Map<String, dynamic>> _getWoundsCollection(
    String patientId,
  ) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection('estomaterapeutas')
        .doc(userId)
        .collection('pacientes')
        .doc(patientId)
        .collection('feridas');
  }

  @override
  Future<List<Wound>> getWoundsByPatient(String patientId) async {
    try {
      final snapshot = await _getWoundsCollection(patientId)
          .where('archived', isEqualTo: false)
          .orderBy('criadoEm', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final model = WoundModel.fromFirestore(doc);
        return model.toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar feridas: $e');
    }
  }

  @override
  Future<Wound?> getWoundById(String woundId) async {
    try {
      // Como não temos o patientId, precisamos procurar em todos os pacientes do usuário
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
          final model = WoundModel.fromFirestore(woundDoc);
          return model.toEntity();
        }
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao buscar ferida: $e');
    }
  }

  @override
  Future<Wound> createWound(Wound wound) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Garantir que a wound tem ownerId antes da conversão
      final woundWithOwner = wound.copyWith(ownerId: userId);
      final model = WoundModel.fromEntity(woundWithOwner);
      final data = model.toFirestore();

      final docRef = await _getWoundsCollection(wound.patientId).add(data);
      return woundWithOwner.copyWith(feridaId: docRef.id);
    } catch (e) {
      throw Exception('Erro ao criar ferida: $e');
    }
  }

  @override
  Future<Wound> updateWound(Wound wound) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Garantir que a wound tem ownerId antes da conversão
      final woundWithOwner = wound.copyWith(ownerId: userId);
      final model = WoundModel.fromEntity(woundWithOwner);
      final data = model.toFirestore();
      data.remove('feridaId'); // Remove o ID para evitar conflitos
      data['atualizadoEm'] = FieldValue.serverTimestamp();

      await _getWoundsCollection(
        wound.patientId,
      ).doc(wound.feridaId).update(data);

      return woundWithOwner.copyWith(atualizadoEm: DateTime.now());
    } catch (e) {
      throw Exception('Erro ao atualizar ferida: $e');
    }
  }

  @override
  Future<void> deleteWound(String woundId) async {
    try {
      // Buscar a ferida para encontrar o patientId
      final wound = await getWoundById(woundId);
      if (wound == null) throw Exception('Ferida não encontrada');

      await _getWoundsCollection(wound.patientId).doc(woundId).update({
        'archived': true,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao deletar ferida: $e');
    }
  }

  @override
  Future<Wound> updateWoundStatus(String woundId, WoundStatus status) async {
    try {
      final wound = await getWoundById(woundId);
      if (wound == null) throw Exception('Ferida não encontrada');

      final updatedWound = wound.copyWith(
        status: status,
        atualizadoEm: DateTime.now(),
      );

      return await updateWound(updatedWound);
    } catch (e) {
      throw Exception('Erro ao atualizar status da ferida: $e');
    }
  }

  @override
  Stream<List<Wound>> watchWoundsByPatient(String patientId) {
    return _getWoundsCollection(patientId)
        .where('archived', isEqualTo: false)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final model = WoundModel.fromFirestore(doc);
            return model.toEntity();
          }).toList();
        });
  }

  @override
  Stream<Wound?> watchWound(String woundId) {
    // Para watch de ferida específica, precisamos do patientId
    // Como não temos, vamos implementar uma busca dinâmica
    return Stream.fromFuture(getWoundById(woundId));
  }

  @override
  Future<List<Wound>> getWoundsByStatus(
    String patientId,
    WoundStatus status,
  ) async {
    try {
      final statusString = _woundStatusToString(status);
      final snapshot = await _getWoundsCollection(patientId)
          .where('archived', isEqualTo: false)
          .where('status', isEqualTo: statusString)
          .orderBy('criadoEm', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final model = WoundModel.fromFirestore(doc);
        return model.toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar feridas por status: $e');
    }
  }

  String _woundStatusToString(WoundStatus status) {
    switch (status) {
      case WoundStatus.ativa:
        return 'ATIVA';
      case WoundStatus.emCicatrizacao:
        return 'EM_CICATRIZACAO';
      case WoundStatus.cicatrizada:
        return 'CICATRIZADA';
      case WoundStatus.infectada:
        return 'INFECTADA';
      case WoundStatus.complicada:
        return 'COMPLICADA';
    }
  }
}
