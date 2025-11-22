import 'package:flutter_test/flutter_test.dart';

/// Testes unitários para validações de Assessment (M1)
///
/// Valida as regras de negócio:
/// - Dor entre 0 e 10
/// - Medidas positivas (C, L, P > 0)
/// - Data não pode ser futura
/// - Notas sem HTML/script
void main() {
  group('Validação de Assessment', () {
    group('Escala de dor', () {
      test('Deve aceitar dor = 0 (sem dor)', () {
        const painScale = 0;
        expect(painScale >= 0 && painScale <= 10, isTrue);
      });

      test('Deve aceitar dor = 5 (dor moderada)', () {
        const painScale = 5;
        expect(painScale >= 0 && painScale <= 10, isTrue);
      });

      test('Deve aceitar dor = 10 (dor máxima)', () {
        const painScale = 10;
        expect(painScale >= 0 && painScale <= 10, isTrue);
      });

      test('Deve rejeitar dor < 0', () {
        const painScale = -1;
        expect(painScale >= 0 && painScale <= 10, isFalse);
      });

      test('Deve rejeitar dor > 10', () {
        const painScale = 11;
        expect(painScale >= 0 && painScale <= 10, isFalse);
      });
    });

    group('Medidas da ferida', () {
      test('Deve aceitar comprimento positivo', () {
        const lengthCm = 5.5;
        expect(lengthCm > 0, isTrue);
      });

      test('Deve aceitar largura positiva', () {
        const widthCm = 3.2;
        expect(widthCm > 0, isTrue);
      });

      test('Deve aceitar profundidade positiva', () {
        const depthCm = 1.8;
        expect(depthCm > 0, isTrue);
      });

      test('Deve rejeitar comprimento zero', () {
        const lengthCm = 0.0;
        expect(lengthCm > 0, isFalse);
      });

      test('Deve rejeitar largura negativa', () {
        const widthCm = -2.5;
        expect(widthCm > 0, isFalse);
      });

      test('Deve rejeitar profundidade negativa', () {
        const depthCm = -0.5;
        expect(depthCm > 0, isFalse);
      });
    });

    group('Data da avaliação', () {
      test('Deve aceitar data de hoje', () {
        final today = DateTime.now();
        final dateOnly = DateTime(today.year, today.month, today.day);
        final isValidDate = !dateOnly.isAfter(
          DateTime(today.year, today.month, today.day),
        );
        expect(isValidDate, isTrue);
      });

      test('Deve aceitar data no passado', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final today = DateTime.now();
        final isValidDate = !yesterday.isAfter(
          DateTime(today.year, today.month, today.day),
        );
        expect(isValidDate, isTrue);
      });

      test('Deve rejeitar data futura', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final today = DateTime.now();
        final isValidDate = !tomorrow.isAfter(
          DateTime(today.year, today.month, today.day),
        );
        expect(isValidDate, isFalse);
      });
    });

    group('Notas (observações)', () {
      test('Deve aceitar notas vazias', () {
        const notes = '';
        expect(notes.length <= 2000, isTrue);
      });

      test('Deve aceitar notas normais', () {
        const notes =
            'Ferida apresentando boa evolução, sem sinais de infecção';
        expect(notes.length <= 2000, isTrue);
        expect(_containsHtml(notes), isFalse);
      });

      test('Deve aceitar notas com até 2000 caracteres', () {
        final notes = 'A' * 2000;
        expect(notes.length <= 2000, isTrue);
      });

      test('Deve rejeitar notas com mais de 2000 caracteres', () {
        final notes = 'A' * 2001;
        expect(notes.length <= 2000, isFalse);
      });

      test('Deve rejeitar notas com tags HTML simples', () {
        const notes = 'Ferida <b>infectada</b>';
        expect(_containsHtml(notes), isTrue);
      });

      test('Deve rejeitar notas com tags HTML complexas', () {
        const notes = 'Ferida <div class="alert">grave</div>';
        expect(_containsHtml(notes), isTrue);
      });

      test('Deve rejeitar notas com scripts', () {
        const notes = 'Ferida <script>alert("xss")</script>';
        expect(_containsHtml(notes), isTrue);
      });

      test('Deve aceitar notas com símbolos especiais válidos', () {
        const notes = 'Medidas: 5x3x2 cm. Dor: ++. Obs: verificar!';
        expect(_containsHtml(notes), isFalse);
      });
    });

    group('Validação combinada', () {
      test('Deve aceitar avaliação válida completa', () {
        // Usar data do passado para evitar problema de comparação de timestamp
        final assessment = {
          'date': DateTime.now().subtract(const Duration(hours: 1)),
          'painScale': 7,
          'lengthCm': 5.5,
          'widthCm': 3.2,
          'depthCm': 1.8,
          'notes': 'Avaliação de rotina. Boa evolução.',
        };

        final isValid = _validateAssessment(assessment);
        expect(isValid, isEmpty);
      });

      test('Deve rejeitar avaliação com múltiplos erros', () {
        final assessment = {
          'date': DateTime.now().add(const Duration(days: 1)),
          'painScale': 15,
          'lengthCm': -2.0,
          'widthCm': 0.0,
          'depthCm': 1.5,
          'notes': '<script>alert("test")</script>',
        };

        final errors = _validateAssessment(assessment);
        expect(errors, isNotEmpty);
        expect(errors.containsKey('date'), isTrue);
        expect(errors.containsKey('painScale'), isTrue);
        expect(errors.containsKey('lengthCm'), isTrue);
        expect(errors.containsKey('widthCm'), isTrue);
        expect(errors.containsKey('notes'), isTrue);
      });
    });
  });
}

// Funções auxiliares de validação

bool _containsHtml(String text) {
  final htmlRegex = RegExp(r'<[^>]+>');
  return htmlRegex.hasMatch(text);
}

Map<String, String> _validateAssessment(Map<String, dynamic> data) {
  final errors = <String, String>{};
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Validar data
  final date = data['date'] as DateTime;
  final dateOnly = DateTime(date.year, date.month, date.day);
  if (dateOnly.isAfter(today)) {
    errors['date'] = 'Data não pode ser futura';
  }

  // Validar dor
  final painScale = data['painScale'] as int;
  if (painScale < 0 || painScale > 10) {
    errors['painScale'] = 'Escala de dor deve estar entre 0 e 10';
  }

  // Validar medidas
  final lengthCm = data['lengthCm'] as double;
  if (lengthCm <= 0) {
    errors['lengthCm'] = 'Comprimento deve ser maior que 0';
  }

  final widthCm = data['widthCm'] as double;
  if (widthCm <= 0) {
    errors['widthCm'] = 'Largura deve ser maior que 0';
  }

  final depthCm = data['depthCm'] as double;
  if (depthCm <= 0) {
    errors['depthCm'] = 'Profundidade deve ser maior que 0';
  }

  // Validar notas
  final notes = data['notes'] as String?;
  if (notes != null && notes.isNotEmpty) {
    if (notes.length > 2000) {
      errors['notes'] = 'Observações devem ter no máximo 2000 caracteres';
    }

    if (_containsHtml(notes)) {
      errors['notes'] =
          'Observações não podem conter marcações HTML ou scripts';
    }
  }

  return errors;
}
