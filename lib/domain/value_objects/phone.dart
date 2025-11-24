import 'package:equatable/equatable.dart';

import '../exceptions/domain_exceptions.dart';

/// Value Object para número de telefone brasileiro
///
/// Valida e formata números de telefone seguindo padrões brasileiros,
/// garantindo consistência e qualidade dos dados de contato.
class Phone extends Equatable {
  const Phone._(this._value, this._formattedValue);

  final String _value; // Apenas números
  final String _formattedValue; // Com formatação

  /// Criar Phone com validação e formatação automática
  factory Phone(String value) {
    if (value.trim().isEmpty) {
      throw const InvalidPhoneException('Número de telefone não pode estar vazio');
    }

    final cleanValue = _cleanPhoneNumber(value);

    if (!_isValidBrazilianPhone(cleanValue)) {
      throw InvalidPhoneException(
        'Telefone inválido: $value',
        'Formato esperado: (XX) XXXXX-XXXX ou (XX) XXXX-XXXX',
      );
    }

    final formatted = _formatBrazilianPhone(cleanValue);
    return Phone._(cleanValue, formatted);
  }

  /// Verificar se telefone é válido sem lançar exceção
  static bool isValid(String phone) {
    try {
      Phone(phone);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Limpar número de telefone (manter apenas dígitos)
  static String _cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Validar número de telefone brasileiro
  static bool _isValidBrazilianPhone(String phone) {
    if (phone.length == 11) {
      // Celular: terceiro dígito deve ser 9
      if (phone[2] != '9') return false;

      // Validar DDD (11-99)
      final ddd = int.tryParse(phone.substring(0, 2));
      return ddd != null && ddd >= 11 && ddd <= 99;
    } else if (phone.length == 10) {
      // Telefone fixo: terceiro dígito NÃO deve ser 9
      if (phone[2] == '9') return false;

      // Validar DDD
      final ddd = int.tryParse(phone.substring(0, 2));
      return ddd != null && ddd >= 11 && ddd <= 99;
    } else if (phone.length == 8) {
      // Número local (sem DDD)
      return true;
    }

    return false;
  }

  /// Formatar número brasileiro
  static String _formatBrazilianPhone(String phone) {
    if (phone.length == 11) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 7)}-${phone.substring(7)}';
    } else if (phone.length == 10) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 6)}-${phone.substring(6)}';
    } else if (phone.length == 8) {
      return '${phone.substring(0, 4)}-${phone.substring(4)}';
    }
    return phone;
  }

  /// Número apenas com dígitos
  String get value => _value;

  /// Número formatado para exibição
  String get formattedValue => _formattedValue;

  /// Verificar se é telefone celular
  bool get isMobile => _value.length == 11 && _value[2] == '9';

  /// Verificar se é telefone fixo
  bool get isLandline =>
      (_value.length == 10 && _value[2] != '9') || _value.length == 8;

  /// Código de área (DDD)
  String? get areaCode {
    if (_value.length >= 10) {
      return _value.substring(0, 2);
    }
    return null;
  }

  /// Criar URL para WhatsApp
  String toWhatsAppUrl([String? message]) {
    final cleanNumber = _value.startsWith('55') ? _value : '55$_value';
    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';
    return 'https://wa.me/$cleanNumber${message != null ? '?text=$encodedMessage' : ''}';
  }

  /// Criar URL para chamada telefônica
  String toPhoneUrl() {
    return 'tel:$_formattedValue';
  }

  /// Mascarar número para privacidade
  String get masked {
    if (_value.length <= 4) return _value;

    final visiblePart = _value.substring(_value.length - 4);

    if (_value.length == 11) {
      return '(${_value.substring(0, 2)}) ${_value[2]}****-$visiblePart';
    } else if (_value.length == 10) {
      return '(${_value.substring(0, 2)}) ****-$visiblePart';
    }

    return '****$visiblePart';
  }

  @override
  String toString() => _formattedValue;

  @override
  List<Object> get props => [_value];
}
