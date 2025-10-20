import 'dart:async';
import '../../domain/entities/assessment_manual.dart';
import '../../domain/repositories/assessment_repository_manual.dart';

/// Implementação mock do repositório de avaliações para MVP
class AssessmentRepositoryMock implements AssessmentRepository {
  final List<AssessmentManual> _assessments = [];
  final _assessmentsController =
      StreamController<List<AssessmentManual>>.broadcast();

  @override
  Future<List<AssessmentManual>> getAssessmentsByWoundId(String woundId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _assessments.where((a) => a.woundId == woundId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<AssessmentManual?> getAssessmentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _assessments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AssessmentManual> createAssessment(AssessmentManual assessment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newAssessment = assessment.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
    );
    _assessments.add(newAssessment);
    _assessmentsController.add(List.from(_assessments));
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
    await Future.delayed(const Duration(milliseconds: 300));
    _assessments.removeWhere((a) => a.id == assessmentId);
    _assessmentsController.add(List.from(_assessments));
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
    final assessments = await getAssessmentsByWoundId(woundId);
    return assessments.isEmpty ? null : assessments.first;
  }

  @override
  Future<List<AssessmentManual>> getAssessmentsSortedByDate(
    String woundId, {
    int? limit,
  }) async {
    var assessments = await getAssessmentsByWoundId(woundId);
    if (limit != null && assessments.length > limit) {
      assessments = assessments.sublist(0, limit);
    }
    return assessments;
  }

  void dispose() {
    _assessmentsController.close();
  }
}
