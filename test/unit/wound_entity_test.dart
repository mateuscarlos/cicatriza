import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/wound.dart';

void main() {
  group('Wound Entity', () {
    final testCreatedAt = DateTime.now();
    final testUpdatedAt = DateTime.now();

    test('should create Wound with required fields', () {
      final wound = Wound(
        id: 'wound-123',
        patientId: 'patient-456',
        type: WoundType.pressureUlcer,
        locationSimple: WoundLocation.footRight,
        onsetDays: 15,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(wound.id, 'wound-123');
      expect(wound.patientId, 'patient-456');
      expect(wound.type, WoundType.pressureUlcer);
      expect(wound.locationSimple, WoundLocation.footRight);
      expect(wound.onsetDays, 15);
      expect(wound.status, WoundStatus.active);
      expect(wound.locationDescription, null);
      expect(wound.notes, null);
      expect(wound.causeDescription, null);
    });

    test('should create Wound with all fields', () {
      final wound = Wound(
        id: 'wound-123',
        patientId: 'patient-456',
        type: WoundType.diabeticFoot,
        locationSimple: WoundLocation.footRight,
        onsetDays: 30,
        status: WoundStatus.healing,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        locationDescription: 'Plantar region, lateral side',
        notes: 'Patient has controlled diabetes',
        causeDescription: 'Diabetic neuropathy',
      );

      expect(wound.locationDescription, 'Plantar region, lateral side');
      expect(wound.notes, 'Patient has controlled diabetes');
      expect(wound.causeDescription, 'Diabetic neuropathy');
    });

    test('should create copy with modified status using copyWith', () {
      final original = Wound(
        id: 'wound-123',
        patientId: 'patient-456',
        type: WoundType.pressureUlcer,
        locationSimple: WoundLocation.back,
        onsetDays: 20,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      final modified = original.copyWith(
        status: WoundStatus.healing,
        notes: 'Showing signs of improvement',
      );

      expect(modified.id, original.id);
      expect(modified.status, WoundStatus.healing);
      expect(modified.notes, 'Showing signs of improvement');
      expect(modified.type, original.type);
    });

    test('should serialize to JSON correctly', () {
      final wound = Wound(
        id: 'wound-123',
        patientId: 'patient-456',
        type: WoundType.surgical,
        locationSimple: WoundLocation.abdomen,
        onsetDays: 7,
        status: WoundStatus.healing,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        notes: 'Post-operative wound',
      );

      final json = wound.toJson();

      expect(json['id'], 'wound-123');
      expect(json['patientId'], 'patient-456');
      expect(json['type'], 'surgical');
      expect(json['locationSimple'], 'abdomen');
      expect(json['onsetDays'], 7);
      expect(json['status'], 'healing');
      expect(json['notes'], 'Post-operative wound');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'wound-123',
        'patientId': 'patient-456',
        'type': 'venous_ulcer',
        'locationSimple': 'lower_limb_left',
        'onsetDays': 45,
        'status': 'active',
        'createdAt': testCreatedAt.toIso8601String(),
        'updatedAt': testUpdatedAt.toIso8601String(),
        'locationDescription': 'Lower third of leg',
        'causeDescription': 'Chronic venous insufficiency',
      };

      final wound = Wound.fromJson(json);

      expect(wound.id, 'wound-123');
      expect(wound.patientId, 'patient-456');
      expect(wound.type, WoundType.venousUlcer);
      expect(wound.locationSimple, WoundLocation.lowerLimbLeft);
      expect(wound.onsetDays, 45);
      expect(wound.status, WoundStatus.active);
      expect(wound.locationDescription, 'Lower third of leg');
      expect(wound.causeDescription, 'Chronic venous insufficiency');
    });

    test('should handle equality correctly', () {
      final wound1 = Wound(
        id: 'wound-123',
        patientId: 'patient-456',
        type: WoundType.burn,
        locationSimple: WoundLocation.upperLimbRight,
        onsetDays: 5,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      final wound2 = Wound(
        id: 'wound-123',
        patientId: 'patient-456',
        type: WoundType.burn,
        locationSimple: WoundLocation.upperLimbRight,
        onsetDays: 5,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      final wound3 = Wound(
        id: 'wound-789',
        patientId: 'patient-456',
        type: WoundType.traumatic,
        locationSimple: WoundLocation.headNeck,
        onsetDays: 2,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );

      expect(wound1, wound2);
      expect(wound1, isNot(wound3));
    });

    test('should create Wound using factory create method', () {
      final wound = Wound.create(
        patientId: 'patient-456',
        type: WoundType.diabeticFoot,
        locationSimple: WoundLocation.footLeft,
        onsetDays: 25,
        locationDescription: 'Heel area',
        notes: 'Requires daily dressing',
        causeDescription: 'Pressure point',
      );

      expect(wound.patientId, 'patient-456');
      expect(wound.type, WoundType.diabeticFoot);
      expect(wound.locationSimple, WoundLocation.footLeft);
      expect(wound.onsetDays, 25);
      expect(wound.status, WoundStatus.active);
      expect(wound.locationDescription, 'Heel area');
      expect(wound.notes, 'Requires daily dressing');
      expect(wound.causeDescription, 'Pressure point');
    });

    test('should handle different WoundType enums', () {
      final types = [
        WoundType.pressureUlcer,
        WoundType.diabeticFoot,
        WoundType.venousUlcer,
        WoundType.arterialUlcer,
        WoundType.surgical,
        WoundType.traumatic,
        WoundType.burn,
        WoundType.other,
      ];

      for (final type in types) {
        final wound = Wound(
          id: 'wound-test',
          patientId: 'patient-test',
          type: type,
          locationSimple: WoundLocation.other,
          onsetDays: 1,
          createdAt: testCreatedAt,
          updatedAt: testUpdatedAt,
        );
        expect(wound.type, type);
      }
    });

    test('should handle different WoundStatus enums', () {
      final statuses = [
        WoundStatus.active,
        WoundStatus.healing,
        WoundStatus.healed,
        WoundStatus.worsening,
        WoundStatus.inactive,
      ];

      for (final status in statuses) {
        final wound = Wound(
          id: 'wound-test',
          patientId: 'patient-test',
          type: WoundType.other,
          locationSimple: WoundLocation.other,
          onsetDays: 1,
          status: status,
          createdAt: testCreatedAt,
          updatedAt: testUpdatedAt,
        );
        expect(wound.status, status);
      }
    });
  });
}
