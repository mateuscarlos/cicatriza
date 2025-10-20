import 'dart:async';
import '../../domain/entities/wound_manual.dart';
import '../../domain/repositories/wound_repository_manual.dart';

/// Implementação mock do repositório de feridas para MVP
class WoundRepositoryMock implements WoundRepository {
  final List<WoundManual> _wounds = [];
  final _woundsController = StreamController<List<WoundManual>>.broadcast();

  @override
  Future<List<WoundManual>> getWoundsByPatientId(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _wounds.where((w) => w.patientId == patientId).toList();
  }

  @override
  Future<WoundManual?> getWoundById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _wounds.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<WoundManual> createWound(WoundManual wound) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newWound = wound.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _wounds.add(newWound);
    _woundsController.add(List.from(_wounds));
    return newWound;
  }

  @override
  Future<WoundManual> updateWound(WoundManual wound) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _wounds.indexWhere((w) => w.id == wound.id);
    if (index != -1) {
      _wounds[index] = wound.copyWith(updatedAt: DateTime.now());
      _woundsController.add(List.from(_wounds));
      return _wounds[index];
    }
    throw Exception('Ferida não encontrada');
  }

  @override
  Future<void> deleteWound(String woundId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _wounds.removeWhere((w) => w.id == woundId);
    _woundsController.add(List.from(_wounds));
  }

  @override
  Future<WoundManual> updateWoundStatus(
    String woundId,
    String newStatus,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _wounds.indexWhere((w) => w.id == woundId);
    if (index != -1) {
      _wounds[index] = _wounds[index].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      _woundsController.add(List.from(_wounds));
      return _wounds[index];
    }
    throw Exception('Ferida não encontrada');
  }

  @override
  Stream<List<WoundManual>> watchWounds(String patientId) {
    return _woundsController.stream.map(
      (wounds) => wounds.where((w) => w.patientId == patientId).toList(),
    );
  }

  @override
  Stream<WoundManual?> watchWound(String woundId) {
    return _woundsController.stream.map((wounds) {
      try {
        return wounds.firstWhere((w) => w.id == woundId);
      } catch (e) {
        return null;
      }
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
    await Future.delayed(const Duration(milliseconds: 200));
    var filtered = List<WoundManual>.from(_wounds);

    if (patientId != null) {
      filtered = filtered.where((w) => w.patientId == patientId).toList();
    }
    if (status != null) {
      filtered = filtered.where((w) => w.status == status).toList();
    }
    if (type != null) {
      filtered = filtered.where((w) => w.type == type).toList();
    }
    if (fromDate != null) {
      filtered = filtered.where((w) => w.createdAt.isAfter(fromDate)).toList();
    }
    if (toDate != null) {
      filtered = filtered.where((w) => w.createdAt.isBefore(toDate)).toList();
    }

    return filtered;
  }

  void dispose() {
    _woundsController.close();
  }
}
