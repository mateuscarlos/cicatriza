import 'package:cicatriza/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile', () {
    final now = DateTime(2025, 11, 22);

    final testProfile = UserProfile(
      uid: 'test_uid',
      email: 'test@example.com',
      displayName: 'Test User',
      photoURL: 'https://example.com/photo.jpg',
      crmCofen: 'CRM123456',
      specialty: 'Estomaterapia',
      institution: 'Hospital Test',
      role: 'Enfermeiro',
      phone: '11999999999',
      address: 'Rua Test, 123',
      city: 'São Paulo',
      language: 'pt-BR',
      theme: 'light',
      ownerId: 'test_uid',
      createdAt: now,
      updatedAt: now,
      lgpdConsent: true,
      termsAccepted: true,
      termsAcceptedAt: now,
      privacyPolicyAccepted: true,
      privacyPolicyAcceptedAt: now,
    );

    test('creates UserProfile with all fields', () {
      expect(testProfile.uid, 'test_uid');
      expect(testProfile.email, 'test@example.com');
      expect(testProfile.displayName, 'Test User');
      expect(testProfile.photoURL, 'https://example.com/photo.jpg');
      expect(testProfile.crmCofen, 'CRM123456');
      expect(testProfile.specialty, 'Estomaterapia');
      expect(testProfile.termsAccepted, true);
      expect(testProfile.privacyPolicyAccepted, true);
    });

    test('toJson serializes correctly', () {
      final json = testProfile.toJson();

      expect(json['uid'], 'test_uid');
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
      expect(json['lgpdConsent'], true);
      expect(json['termsAccepted'], true);
      expect(json['privacyPolicyAccepted'], true);
      expect(json['termsAcceptedAt'], isNotNull);
      expect(json['privacyPolicyAcceptedAt'], isNotNull);
    });

    test('fromJson deserializes correctly', () {
      final json = testProfile.toJson();
      final profile = UserProfile.fromJson(json);

      expect(profile.uid, testProfile.uid);
      expect(profile.email, testProfile.email);
      expect(profile.displayName, testProfile.displayName);
      expect(profile.lgpdConsent, testProfile.lgpdConsent);
      expect(profile.termsAccepted, testProfile.termsAccepted);
      expect(profile.privacyPolicyAccepted, testProfile.privacyPolicyAccepted);
    });

    test('copyWith creates new instance with updated fields', () {
      final updated = testProfile.copyWith(
        displayName: 'Updated Name',
        phone: '11888888888',
      );

      expect(updated.displayName, 'Updated Name');
      expect(updated.phone, '11888888888');
      expect(updated.uid, testProfile.uid);
      expect(updated.email, testProfile.email);
    });

    test('copyWith without arguments returns same values', () {
      final copy = testProfile.copyWith();

      expect(copy.uid, testProfile.uid);
      expect(copy.email, testProfile.email);
      expect(copy.displayName, testProfile.displayName);
    });

    test('equality works correctly', () {
      final profile1 = UserProfile(
        uid: 'test_uid',
        email: 'test@example.com',
        ownerId: 'test_uid',
        createdAt: now,
        updatedAt: now,
      );

      final profile2 = UserProfile(
        uid: 'test_uid',
        email: 'test@example.com',
        ownerId: 'test_uid',
        createdAt: now,
        updatedAt: now,
      );

      expect(profile1, equals(profile2));
      expect(profile1.hashCode, equals(profile2.hashCode));
    });

    test('default values are set correctly', () {
      final minimalProfile = UserProfile(
        uid: 'test_uid',
        email: 'test@example.com',
        ownerId: 'test_uid',
        createdAt: now,
        updatedAt: now,
      );

      expect(minimalProfile.specialty, 'Estomaterapia');
      expect(minimalProfile.language, 'pt-BR');
      expect(minimalProfile.theme, 'system');
      expect(minimalProfile.lgpdConsent, false);
      expect(minimalProfile.termsAccepted, false);
      expect(minimalProfile.privacyPolicyAccepted, false);
      expect(minimalProfile.calendarSync, false);
      expect(minimalProfile.notifications['agendas'], true);
      expect(minimalProfile.notifications['transferencias'], true);
      expect(minimalProfile.notifications['alertas_clinicos'], true);
    });
  });
}
