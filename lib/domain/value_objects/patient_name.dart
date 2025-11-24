import 'package:equatable/equatable.dart';

import '../exceptions/domain_exceptions.dart';

/// Value Object representando o nome de um paciente
///
/// Garante que apenas nomes válidos sejam utilizados no sistema,
/// aplicando regras específicas para nomes médicos.
class PatientName extends Equatable {
  const PatientName._(this._value);

  final String _value;

  /// Criar PatientName com validação
  factory PatientName(String value) {
    final cleanValue = value.trim();

    if (!_isValidName(cleanValue)) {
      throw InvalidNameException(_getValidationError(cleanValue));
    }

    return PatientName._(cleanValue);
  }

  /// Verificar se nome é válido sem lançar exceção
  static bool isValid(String name) {
    try {
      PatientName(name);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validação de nome
  static bool _isValidName(String name) {
    if (name.isEmpty) return false;
    if (name.length < 2) return false;
    if (name.length > 100) return false;

    // Apenas letras, espaços, hífen e apóstrofe
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$");
    if (!nameRegex.hasMatch(name)) return false;

    // Não pode começar ou terminar com espaço, hífen ou apóstrofe
    if (name.startsWith(' ') ||
        name.startsWith('-') ||
        name.startsWith("'") ||
        name.endsWith(' ') ||
        name.endsWith('-') ||
        name.endsWith("'")) {
      return false;
    }

    // Não pode ter espaços consecutivos
    if (name.contains(RegExp(r'\s{2,}'))) return false;

    // Deve ter pelo menos um caractere alfabético
    if (!name.contains(RegExp(r'[a-zA-ZÀ-ÿ]'))) return false;

    return true;
  }

  /// Obter mensagem de erro específica
  static String _getValidationError(String name) {
    if (name.isEmpty) {
      return 'Nome não pode estar vazio';
    }
    if (name.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    if (name.length > 100) {
      return 'Nome não pode ter mais de 100 caracteres';
    }
    if (name.startsWith(' ') ||
        name.startsWith('-') ||
        name.startsWith("'") ||
        name.endsWith(' ') ||
        name.endsWith('-') ||
        name.endsWith("'")) {
      return 'Nome não pode começar ou terminar com espaço, hífen ou apóstrofe';
    }
    if (name.contains(RegExp(r'\s{2,}'))) {
      return 'Nome não pode ter espaços consecutivos';
    }
    if (!name.contains(RegExp(r'[a-zA-ZÀ-ÿ]'))) {
      return 'Nome deve conter pelo menos uma letra';
    }
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$").hasMatch(name)) {
      return 'Nome pode conter apenas letras, espaços, hífen e apóstrofe';
    }

    return 'Nome inválido';
  }

  /// Valor do nome
  String get value => _value;

  /// Nome em formato título (primeira letra maiúscula)
  String get titleCase {
    return _value
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;

          // Preposições e artigos em minúscula (exceto se for a primeira palavra)
          final lowercaseWords = {
            'de',
            'da',
            'do',
            'das',
            'dos',
            'e',
            'o',
            'a',
            'os',
            'as',
          };
          final words = _value.split(' ');
          final isFirstWord = words.indexOf(word) == 0;

          if (!isFirstWord && lowercaseWords.contains(word.toLowerCase())) {
            return word.toLowerCase();
          }

          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Nome em formato maiúsculo
  String get upperCase => _value.toUpperCase();

  /// Nome em formato minúsculo (para busca)
  String get lowerCase => _value.toLowerCase();

  /// Iniciais do nome (para avatar)
  String get initials {
    final words = _value.split(' ').where((word) => word.isNotEmpty).toList();

    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].length >= 2
          ? words[0].substring(0, 2).toUpperCase()
          : words[0].toUpperCase();
    }

    // Primeira e última palavra
    final first = words.first[0].toUpperCase();
    final last = words.last[0].toUpperCase();
    return first + last;
  }

  /// Primeiro nome
  String get firstName {
    final words = _value.split(' ').where((word) => word.isNotEmpty).toList();
    return words.isNotEmpty ? words.first : '';
  }

  /// Último nome (sobrenome)
  String get lastName {
    final words = _value.split(' ').where((word) => word.isNotEmpty).toList();
    return words.length > 1 ? words.last : '';
  }

  /// Nome do meio (todos exceto primeiro e último)
  String get middleName {
    final words = _value.split(' ').where((word) => word.isNotEmpty).toList();
    if (words.length <= 2) return '';

    return words.sublist(1, words.length - 1).join(' ');
  }

  /// Verificar se é nome composto
  bool get isCompound =>
      _value.split(' ').where((word) => word.isNotEmpty).length > 1;

  /// Verificar se contém caracteres especiais (acentos)
  bool get hasAccents => _value.contains(RegExp(r'[À-ÿ]'));

  /// Nome sem acentos (para busca)
  String get withoutAccents {
    const accents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÌÍÎÏìíîïÙÚÛÜùúûüÿÑñÇç';
    const withoutAccents =
        'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeIIIIiiiiUUUUuuuuyNnCc';

    String result = _value;

    for (int i = 0; i < accents.length; i++) {
      result = result.replaceAll(accents[i], withoutAccents[i]);
    }

    return result;
  }

  @override
  String toString() => _value;

  @override
  List<Object> get props => [_value];
}
