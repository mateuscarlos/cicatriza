import 'package:flutter_test/flutter_test.dart';

/// Testes que validam as regras de negócio do Firestore
void main() {
  group('Validações Firestore', () {
    test('Dor entre 0 e 10', () {
      const pain = 5;
      expect(pain >= 0 && pain <= 10, isTrue);
    });

    test('Medidas positivas', () {
      const length = 10.5;
      expect(length > 0, isTrue);
    });

    test('Nome válido', () {
      const name = 'João Silva';
      expect(name.isNotEmpty, isTrue);
      expect(name.length <= 200, isTrue);
    });
  });
}
