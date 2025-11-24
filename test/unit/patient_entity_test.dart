import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/patient.dart';

void main() {
  group('Patient Entity', () {
    final testDate = DateTime(1990, 5, 15);
    final testCreatedAt = DateTime.now();
    final testUpdatedAt = DateTime.now();

    test('should create Patient with required fields', () {
      final patient = Patient(
        id: 'patient-123',
        name: 'João Silva',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
      );

      expect(patient.id, 'patient-123');
      expect(patient.name, 'João Silva');
      expect(patient.birthDate, testDate);
      expect(patient.archived, false);
      expect(patient.nameLowercase, 'joão silva');
      expect(patient.notes, null);
      expect(patient.phone, null);
      expect(patient.email, null);
    });

    test('should create Patient with all fields', () {
      final patient = Patient(
        id: 'patient-123',
        name: 'João Silva',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
        notes: 'Paciente com diabetes',
        phone: '11999998888',
        email: 'joao@example.com',
      );

      expect(patient.notes, 'Paciente com diabetes');
      expect(patient.phone, '11999998888');
      expect(patient.email, 'joao@example.com');
    });

    test('should create copy with modified fields using copyWith', () {
      final original = Patient(
        id: 'patient-123',
        name: 'João Silva',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
      );

      final modified = original.copyWith(
        name: 'João da Silva',
        nameLowercase: 'joão da silva',
        archived: true,
      );

      expect(modified.id, original.id);
      expect(modified.name, 'João da Silva');
      expect(modified.nameLowercase, 'joão da silva');
      expect(modified.archived, true);
      expect(modified.birthDate, original.birthDate);
    });

    test('should serialize to JSON correctly', () {
      final patient = Patient(
        id: 'patient-123',
        name: 'João Silva',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
        notes: 'Test notes',
      );

      final json = patient.toJson();

      expect(json['id'], 'patient-123');
      expect(json['name'], 'João Silva');
      expect(json['archived'], false);
      expect(json['nameLowercase'], 'joão silva');
      expect(json['notes'], 'Test notes');
      expect(json['birthDate'], isA<dynamic>()); // Timestamp
      expect(json['createdAt'], isA<dynamic>());
      expect(json['updatedAt'], isA<dynamic>());
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'patient-123',
        'name': 'João Silva',
        'birthDate': testDate.toIso8601String(),
        'archived': false,
        'createdAt': testCreatedAt.toIso8601String(),
        'updatedAt': testUpdatedAt.toIso8601String(),
        'nameLowercase': 'joão silva',
        'notes': 'Test notes',
        'phone': '11999998888',
      };

      final patient = Patient.fromJson(json);

      expect(patient.id, 'patient-123');
      expect(patient.name, 'João Silva');
      expect(patient.archived, false);
      expect(patient.nameLowercase, 'joão silva');
      expect(patient.notes, 'Test notes');
      expect(patient.phone, '11999998888');
    });

    test('should handle equality correctly', () {
      final patient1 = Patient(
        id: 'patient-123',
        name: 'João Silva',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
      );

      final patient2 = Patient(
        id: 'patient-123',
        name: 'João Silva',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
      );

      final patient3 = Patient(
        id: 'patient-456',
        name: 'Maria Santos',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'maria santos',
      );

      expect(patient1, patient2);
      expect(patient1, isNot(patient3));
    });

    test('should handle hashCode correctly', () {
      final patient1 = Patient(
        id: 'patient-123',
        name: 'João Silva',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
      );

      final patient2 = Patient(
        id: 'patient-123',
        name: 'João Silva',
        birthDate: testDate,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
        nameLowercase: 'joão silva',
      );

      expect(patient1.hashCode, patient2.hashCode);
    });

    test('should create Patient using factory create method', () {
      final patient = Patient.create(
        name: 'João Silva',
        birthDate: testDate,
        notes: 'Test notes',
        phone: '11999998888',
        email: 'joao@example.com',
      );

      expect(patient.name, 'João Silva');
      expect(patient.nameLowercase, 'joão silva');
      expect(patient.birthDate, testDate);
      expect(patient.archived, false);
      expect(patient.notes, 'Test notes');
      expect(patient.phone, '11999998888');
      expect(patient.email, 'joao@example.com');
    });
  });
}
