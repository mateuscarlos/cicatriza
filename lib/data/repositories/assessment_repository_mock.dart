import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/assessment_manual.dart';
import '../../domain/repositories/assessment_repository_manual.dart';

/// Implementação mock do repositório de avaliações para MVP
/// Agora com armazenamento local e sincronização offline-first
class AssessmentRepositoryMock implements AssessmentRepository {
  final List<AssessmentManual> _assessments = [];
  final _assessmentsController =
      StreamController<List<AssessmentManual>>.broadcast();
  static const String _storageKey = 'assessments_local';
  bool _isInitialized = false;

  /// Inicializa carregando dados do armazenamento local
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    await _loadFromLocalStorage();
    _isInitialized = true;
  }

  /// Carrega avaliações salvas localmente
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _assessments.clear();
        _assessments.addAll(
          jsonList.map(
            (json) => _assessmentFromJson(json as Map<String, dynamic>),
          ),
        );
        print(
          '[AssessmentRepository] ✅ Carregadas ${_assessments.length} avaliações do armazenamento local',
        );
      }
    } catch (e) {
      print(
        '[AssessmentRepository] ❌ Erro ao carregar do armazenamento local: $e',
      );
    }
  }

  /// Salva avaliações no armazenamento local
  Future<void> _saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _assessments.map((a) => _assessmentToJson(a)).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
      print(
        '[AssessmentRepository] ✅ Salvas ${_assessments.length} avaliações no armazenamento local',
      );
    } catch (e) {
      print(
        '[AssessmentRepository] ❌ Erro ao salvar no armazenamento local: $e',
      );
    }
  }

  /// Verifica se há conexão com a internet
  Future<bool> _hasConnection() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      return connectivityResults.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<AssessmentManual>> getAssessmentsByWoundId(String woundId) async {
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 300));
    return _assessments.where((a) => a.woundId == woundId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<AssessmentManual?> getAssessmentById(String id) async {
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _assessments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AssessmentManual> createAssessment(AssessmentManual assessment) async {
    await _ensureInitialized();

    final newAssessment = assessment.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
    );

    // 1. SEMPRE salva localmente primeiro (offline-first)
    _assessments.add(newAssessment);
    _assessmentsController.add(List.from(_assessments));
    await _saveToLocalStorage();

    // 2. Tenta sincronizar com Firestore se online
    final isOnline = await _hasConnection();
    if (isOnline) {
      print(
        '[AssessmentRepository] 🌐 Online - Sincronizando com Firestore...',
      );
      // TODO: Implementar sync com Firestore quando Firebase estiver configurado
      // await _firestore.collection('assessments').doc(newAssessment.id).set(...)
    } else {
      print('[AssessmentRepository] 📴 Offline - Avaliação salva localmente');
    }

    return newAssessment;
  }

  @override
  Future<AssessmentManual> updateAssessment(AssessmentManual assessment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _assessments.indexWhere((a) => a.id == assessment.id);
    if (index != -1) {
      _assessments[index] = assessment;
      _assessmentsController.add(List.from(_assessments));
      return _assessments[index];
    }
    throw Exception('Avaliação não encontrada');
  }

  @override
  Future<void> deleteAssessment(String assessmentId) async {
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 300));
    _assessments.removeWhere((a) => a.id == assessmentId);
    _assessmentsController.add(List.from(_assessments));
    await _saveToLocalStorage();
  }

  @override
  Stream<List<AssessmentManual>> watchAssessments(String woundId) {
    return _assessmentsController.stream.map((assessments) {
      final filtered = assessments.where((a) => a.woundId == woundId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return filtered;
    });
  }

  @override
  Stream<AssessmentManual?> watchAssessment(String assessmentId) {
    return _assessmentsController.stream.map((assessments) {
      try {
        return assessments.firstWhere((a) => a.id == assessmentId);
      } catch (e) {
        return null;
      }
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
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 200));
    var filtered = List<AssessmentManual>.from(_assessments);

    if (woundId != null) {
      filtered = filtered.where((a) => a.woundId == woundId).toList();
    }
    if (fromDate != null) {
      filtered = filtered.where((a) => a.date.isAfter(fromDate)).toList();
    }
    if (toDate != null) {
      filtered = filtered.where((a) => a.date.isBefore(toDate)).toList();
    }
    if (minPainScale != null) {
      filtered = filtered
          .where((a) => (a.painScale ?? 0) >= minPainScale)
          .toList();
    }
    if (maxPainScale != null) {
      filtered = filtered
          .where((a) => (a.painScale ?? 0) <= maxPainScale)
          .toList();
    }

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  @override
  Future<AssessmentManual?> getLatestAssessment(String woundId) async {
    await _ensureInitialized();
    final assessments = await getAssessmentsByWoundId(woundId);
    return assessments.isEmpty ? null : assessments.first;
  }

  @override
  Future<List<AssessmentManual>> getAssessmentsSortedByDate(
    String woundId, {
    int? limit,
  }) async {
    await _ensureInitialized();
    var assessments = await getAssessmentsByWoundId(woundId);
    if (limit != null && assessments.length > limit) {
      assessments = assessments.sublist(0, limit);
    }
    return assessments;
  }

  /// Métodos auxiliares de serialização
  Map<String, dynamic> _assessmentToJson(AssessmentManual assessment) {
    return {
      'id': assessment.id,
      'woundId': assessment.woundId,
      'date': assessment.date.toIso8601String(),
      'painScale': assessment.painScale,
      'lengthCm': assessment.lengthCm,
      'widthCm': assessment.widthCm,
      'depthCm': assessment.depthCm,
      'woundBed': assessment.woundBed,
      'exudateType': assessment.exudateType,
      'edgeAppearance': assessment.edgeAppearance,
      'notes': assessment.notes,
      'createdAt': assessment.createdAt.toIso8601String(),
      'updatedAt': assessment.updatedAt.toIso8601String(),
    };
  }

  AssessmentManual _assessmentFromJson(Map<String, dynamic> json) {
    return AssessmentManual(
      id: json['id'] as String,
      woundId: json['woundId'] as String,
      date: DateTime.parse(json['date'] as String),
      painScale: json['painScale'] as int?,
      lengthCm: json['lengthCm'] != null
          ? (json['lengthCm'] as num).toDouble()
          : null,
      widthCm: json['widthCm'] != null
          ? (json['widthCm'] as num).toDouble()
          : null,
      depthCm: json['depthCm'] != null
          ? (json['depthCm'] as num).toDouble()
          : null,
      woundBed: json['woundBed'] as String?,
      exudateType: json['exudateType'] as String?,
      edgeAppearance: json['edgeAppearance'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  void dispose() {
    _assessmentsController.close();
  }
}
