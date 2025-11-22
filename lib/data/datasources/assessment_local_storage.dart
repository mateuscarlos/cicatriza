import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assessment_local_model_v2.dart';

/// Serviço para armazenar avaliações localmente usando SharedPreferences
class AssessmentLocalStorage {
  static const String _keyPrefix = 'assessment_';
  static const String _unsyncedKey = 'unsynced_assessments';

  /// Salva uma avaliação localmente
  Future<void> saveAssessment(AssessmentLocalModel assessment) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix${assessment.id}';
    await prefs.setString(key, assessment.toJsonString());

    // Adiciona à lista de não sincronizados se necessário
    if (!assessment.isSynced) {
      await _addToUnsyncedList(assessment.id);
    }
  }

  /// Busca uma avaliação pelo ID
  Future<AssessmentLocalModel?> getAssessment(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$id';
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;

    return AssessmentLocalModel.fromJsonString(jsonString);
  }

  /// Retorna todas as avaliações de uma lesão específica
  Future<List<AssessmentLocalModel>> getAssessmentsByWoundId(
    String woundId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final assessmentKeys = keys.where((k) => k.startsWith(_keyPrefix)).toList();

    final assessments = <AssessmentLocalModel>[];

    for (final key in assessmentKeys) {
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final assessment = AssessmentLocalModel.fromJsonString(jsonString);
        if (assessment.woundId == woundId) {
          assessments.add(assessment);
        }
      }
    }

    // Ordena por data decrescente
    assessments.sort((a, b) => b.date.compareTo(a.date));

    return assessments;
  }

  /// Retorna IDs das avaliações não sincronizadas
  Future<List<String>> getUnsyncedAssessmentIds() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_unsyncedKey);

    if (jsonString == null) return [];

    final List<dynamic> ids = jsonDecode(jsonString);
    return ids.cast<String>();
  }

  /// Retorna avaliações não sincronizadas
  Future<List<AssessmentLocalModel>> getUnsyncedAssessments() async {
    final ids = await getUnsyncedAssessmentIds();
    final assessments = <AssessmentLocalModel>[];

    for (final id in ids) {
      final assessment = await getAssessment(id);
      if (assessment != null) {
        assessments.add(assessment);
      }
    }

    return assessments;
  }

  /// Marca uma avaliação como sincronizada
  Future<void> markAsSynced(String id) async {
    final assessment = await getAssessment(id);
    if (assessment == null) return;

    final syncedAssessment = assessment.copyWith(isSynced: true);
    await saveAssessment(syncedAssessment);
    await _removeFromUnsyncedList(id);
  }

  /// Remove uma avaliação
  Future<void> deleteAssessment(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$id';
    await prefs.remove(key);
    await _removeFromUnsyncedList(id);
  }

  /// Adiciona ID à lista de não sincronizados
  Future<void> _addToUnsyncedList(String id) async {
    final ids = await getUnsyncedAssessmentIds();
    if (!ids.contains(id)) {
      ids.add(id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_unsyncedKey, jsonEncode(ids));
    }
  }

  /// Remove ID da lista de não sincronizados
  Future<void> _removeFromUnsyncedList(String id) async {
    final ids = await getUnsyncedAssessmentIds();
    ids.remove(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unsyncedKey, jsonEncode(ids));
  }

  /// Limpa todos os dados locais (usar com cuidado!)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final assessmentKeys = keys.where((k) => k.startsWith(_keyPrefix)).toList();

    for (final key in assessmentKeys) {
      await prefs.remove(key);
    }

    await prefs.remove(_unsyncedKey);
  }
}
