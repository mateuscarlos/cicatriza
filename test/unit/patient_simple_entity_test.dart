import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/patient_simple.dart';

void main() {
  group('PatientSimple Entity', () {
    final testDate = DateTime(1985, 3, 20);
    final testCreatedAt = DateTime.now();
    final testUpdatedAt = DateTime.now();

    test('should create PatientSimple with required fields', () {
      final patient = PatientSimple(
        id: 'patient-123',
        name: 'Maria Santos',
        birthDate: testDate,
        archived: false,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'maria santos',
      );

      expect(patient.id, 'patient-123');
      expect(patient.name, 'Maria Santos');
      expect(patient.birthDate, testDate);
      expect(patient.archived, false);
      expect(patient.nameLowercase, 'maria santos');
      expect(patient.notes, null);
      expect(patient.phone, null);
      expect(patient.email, null);
    });

    test('should create PatientSimple with all fields', () {
      final patient = PatientSimple(
        id: 'patient-123',
        name: 'Maria Santos',
        birthDate: testDate,
        archived: false,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'maria santos',
        notes: 'Regular patient',
        phone: '21988887777',
        email: 'maria@example.com',
      );

      expect(patient.notes, 'Regular patient');
      expect(patient.phone, '21988887777');
      expect(patient.email, 'maria@example.com');
    });

    test('should create copy with archived status using copyWith', () {
      final original = PatientSimple(
        id: 'patient-123',
        name: 'Maria Santos',
        birthDate: testDate,
        archived: false,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'maria santos',
      );

      final modified = original.copyWith(archived: true);

      expect(modified.id, original.id);
      expect(modified.archived, true);
      expect(modified.name, original.name);
    });

    test('should serialize to JSON correctly', () {
      final patient = PatientSimple(
        id: 'patient-123',
        name: 'Maria Santos',
        birthDate: testDate,
        archived: false,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'maria santos',
      );

      final json = patient.toJson();

      expect(json['id'], 'patient-123');
      expect(json['name'], 'Maria Santos');
      expect(json['archived'], false);
      expect(json['nameLowercase'], 'maria santos');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'patient-123',
        'name': 'Maria Santos',
        'birthDate': testDate.toIso8601String(),
        'archived': false,
        'createdAt': testCreatedAt.toIso8601String(),
        'updatedAt': testUpdatedAt.toIso8601String(),
        'nameLowercase': 'maria santos',
        'phone': '21988887777',
      };

      final patient = PatientSimple.fromJson(json);

      expect(patient.id, 'patient-123');
      expect(patient.name, 'Maria Santos');
      expect(patient.archived, false);
      expect(patient.phone, '21988887777');
    });

    test('should handle equality correctly', () {
      final patient1 = PatientSimple(
        id: 'patient-123',
        name: 'Maria Santos',
        birthDate: testDate,
        archived: false,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'maria santos',
      );

      final patient2 = PatientSimple(
        id: 'patient-123',
        name: 'Maria Santos',
        birthDate: testDate,
        archived: false,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'maria santos',
      );

      final patient3 = PatientSimple(
        id: 'patient-456',
        name: 'João Silva',
        birthDate: testDate,
        archived: false,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
      );

      expect(patient1, patient2);
      expect(patient1, isNot(patient3));
    });

    test('should create PatientSimple using factory create method', () {
      final patient = PatientSimple.create(
        name: 'Maria Santos',
        birthDate: testDate,
        notes: 'New patient',
        phone: '21988887777',
        email: 'maria@example.com',
      );

      expect(patient.name, 'Maria Santos');
      expect(patient.nameLowercase, 'maria santos');
      expect(patient.birthDate, testDate);
      expect(patient.archived, false);
      expect(patient.notes, 'New patient');
      expect(patient.phone, '21988887777');
      expect(patient.email, 'maria@example.com');
    });
  });
}
