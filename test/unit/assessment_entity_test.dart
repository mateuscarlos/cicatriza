import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/assessment.dart';

void main() {
  group('Assessment Entity', () {
    final testDate = DateTime(2024, 1, 15);
    final testCreatedAt = DateTime.now();
    final testUpdatedAt = DateTime.now();

    test('should create Assessment with required fields', () {
      final assessment = Assessment(
        id: 'assessment-123',
        woundId: 'wound-456',
        date: testDate,
        pain: 5,
        lengthCm: 3.5,
        widthCm: 2.0,
        depthCm: 0.5,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(assessment.id, 'assessment-123');
      expect(assessment.woundId, 'wound-456');
      expect(assessment.date, testDate);
      expect(assessment.pain, 5);
      expect(assessment.lengthCm, 3.5);
      expect(assessment.widthCm, 2.0);
      expect(assessment.depthCm, 0.5);
      expect(assessment.notes, null);
      expect(assessment.exudate, null);
    });

    test('should create Assessment with all fields', () {
      final assessment = Assessment(
        id: 'assessment-123',
        woundId: 'wound-456',
        date: testDate,
        pain: 7,
        lengthCm: 4.2,
        widthCm: 3.1,
        depthCm: 1.2,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        notes: 'Wound showing signs of healing',
        exudate: 'Moderate serous drainage',
        edgeAppearance: 'Well-defined edges',
        woundBed: 'Granulation tissue present',
        periwoundSkin: 'Intact, no maceration',
        odor: 'None',
        treatmentPlan: 'Continue current dressing regimen',
      );

      expect(assessment.notes, 'Wound showing signs of healing');
      expect(assessment.exudate, 'Moderate serous drainage');
      expect(assessment.edgeAppearance, 'Well-defined edges');
      expect(assessment.woundBed, 'Granulation tissue present');
      expect(assessment.periwoundSkin, 'Intact, no maceration');
      expect(assessment.odor, 'None');
      expect(assessment.treatmentPlan, 'Continue current dressing regimen');
    });

    test('should create copy with modified measurements using copyWith', () {
      final original = Assessment(
        id: 'assessment-123',
        woundId: 'wound-456',
        date: testDate,
        pain: 5,
        lengthCm: 4.0,
        widthCm: 3.0,
        depthCm: 1.0,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      final modified = original.copyWith(
        lengthCm: 3.5,
        widthCm: 2.5,
        depthCm: 0.8,
        pain: 4,
        notes: 'Improvement noted',
      );

      expect(modified.id, original.id);
      expect(modified.lengthCm, 3.5);
      expect(modified.widthCm, 2.5);
      expect(modified.depthCm, 0.8);
      expect(modified.pain, 4);
      expect(modified.notes, 'Improvement noted');
    });

    test('should serialize to JSON correctly', () {
      final assessment = Assessment(
        id: 'assessment-123',
        woundId: 'wound-456',
        date: testDate,
        pain: 6,
        lengthCm: 5.0,
        widthCm: 3.5,
        depthCm: 1.5,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        notes: 'Regular assessment',
      );

      final json = assessment.toJson();

      expect(json['id'], 'assessment-123');
      expect(json['woundId'], 'wound-456');
      expect(json['pain'], 6);
      expect(json['lengthCm'], 5.0);
      expect(json['widthCm'], 3.5);
      expect(json['depthCm'], 1.5);
      expect(json['notes'], 'Regular assessment');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'assessment-123',
        'woundId': 'wound-456',
        'date': testDate.toIso8601String(),
        'pain': 3,
        'lengthCm': 2.5,
        'widthCm': 1.8,
        'depthCm': 0.4,
        'createdAt': testCreatedAt.toIso8601String(),
        'updatedAt': testUpdatedAt.toIso8601String(),
        'notes': 'Follow-up assessment',
        'exudate': 'Minimal',
      };

      final assessment = Assessment.fromJson(json);

      expect(assessment.id, 'assessment-123');
      expect(assessment.woundId, 'wound-456');
      expect(assessment.pain, 3);
      expect(assessment.lengthCm, 2.5);
      expect(assessment.widthCm, 1.8);
      expect(assessment.depthCm, 0.4);
      expect(assessment.notes, 'Follow-up assessment');
      expect(assessment.exudate, 'Minimal');
    });

    test('should handle equality correctly', () {
      final assessment1 = Assessment(
        id: 'assessment-123',
        woundId: 'wound-456',
        date: testDate,
        pain: 5,
        lengthCm: 3.0,
        widthCm: 2.0,
        depthCm: 0.5,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      final assessment2 = Assessment(
        id: 'assessment-123',
        woundId: 'wound-456',
        date: testDate,
        pain: 5,
        lengthCm: 3.0,
        widthCm: 2.0,
        depthCm: 0.5,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      final assessment3 = Assessment(
        id: 'assessment-789',
        woundId: 'wound-456',
        date: testDate,
        pain: 8,
        lengthCm: 5.0,
        widthCm: 4.0,
        depthCm: 2.0,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(assessment1, assessment2);
      expect(assessment1, isNot(assessment3));
    });

    test('should create Assessment using factory create method', () {
      final assessment = Assessment.create(
        woundId: 'wound-456',
        date: testDate,
        pain: 4,
        lengthCm: 3.2,
        widthCm: 2.4,
        depthCm: 0.8,
        notes: 'Initial assessment',
        exudate: 'Moderate',
        treatmentPlan: 'Daily dressing changes',
      );

      expect(assessment.woundId, 'wound-456');
      expect(assessment.date, testDate);
      expect(assessment.pain, 4);
      expect(assessment.lengthCm, 3.2);
      expect(assessment.widthCm, 2.4);
      expect(assessment.depthCm, 0.8);
      expect(assessment.notes, 'Initial assessment');
      expect(assessment.exudate, 'Moderate');
      expect(assessment.treatmentPlan, 'Daily dressing changes');
    });

    test('should handle pain scale boundaries', () {
      final lowPain = Assessment(
        id: 'assessment-low',
        woundId: 'wound-456',
        date: testDate,
        pain: 0,
        lengthCm: 1.0,
        widthCm: 1.0,
        depthCm: 0.1,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      final highPain = Assessment(
        id: 'assessment-high',
        woundId: 'wound-456',
        date: testDate,
        pain: 10,
        lengthCm: 1.0,
        widthCm: 1.0,
        depthCm: 0.1,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(lowPain.pain, 0);
      expect(highPain.pain, 10);
    });

    test('should handle small and large measurements', () {
      final smallWound = Assessment(
        id: 'assessment-small',
        woundId: 'wound-456',
        date: testDate,
        pain: 2,
        lengthCm: 0.5,
        widthCm: 0.3,
        depthCm: 0.1,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      final largeWound = Assessment(
        id: 'assessment-large',
        woundId: 'wound-456',
        date: testDate,
        pain: 8,
        lengthCm: 15.0,
        widthCm: 10.0,
        depthCm: 5.0,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(smallWound.lengthCm, 0.5);
      expect(largeWound.lengthCm, 15.0);
    });

    test('should calculate wound area conceptually', () {
      final assessment = Assessment(
        id: 'assessment-123',
        woundId: 'wound-456',
        date: testDate,
        pain: 5,
        lengthCm: 4.0,
        widthCm: 3.0,
        depthCm: 1.0,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      // Área = comprimento × largura
      final area = assessment.lengthCm * assessment.widthCm;
      expect(area, 12.0);

      // Volume aproximado = comprimento × largura × profundidade
      final volume =
          assessment.lengthCm * assessment.widthCm * assessment.depthCm;
      expect(volume, 12.0);
    });
  });
}
