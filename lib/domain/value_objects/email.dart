import 'package:equatable/equatable.dart';

import '../exceptions/domain_exceptions.dart';

/// Value Object representando um email válido
///
/// Garante que apenas emails válidos sejam utilizados no sistema,
/// aplicando validações específicas de domínio.
class Email extends Equatable {
  const Email._(this._value);

  final String _value;

  /// Criar Email com validação rigorosa
  factory Email(String value) {
    final cleanValue = value.trim().toLowerCase();

    if (!_isValidEmail(cleanValue)) {
      throw InvalidEmailException('Email inválido: $value');
    }

    return Email._(cleanValue);
  }

  /// Verificar se email é válido sem lançar exceção
  static bool isValid(String email) {
    try {
      Email(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validação robusta de email
  static bool _isValidEmail(String email) {
    if (email.isEmpty) return false;

    // Regex mais restritiva para emails médicos/profissionais
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9]([a-zA-Z0-9._-])*[a-zA-Z0-9]@[a-zA-Z0-9]([a-zA-Z0-9.-])*[a-zA-Z0-9]\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) return false;

    // Validações adicionais
    if (email.length > 254) return false; // RFC 5321
    if (email.contains('..')) return false; // Pontos consecutivos
    if (email.startsWith('.') || email.endsWith('.')) return false;

    final parts = email.split('@');
    if (parts.length != 2) return false;

    final localPart = parts[0];
    final domainPart = parts[1];

    // Local part não pode exceder 64 caracteres
    if (localPart.length > 64) return false;

    // Domain part validations
    if (domainPart.length > 253) return false;
    if (domainPart.startsWith('-') || domainPart.endsWith('-')) return false;

    return true;
  }

  /// Valor do email
  String get value => _value;

  /// Domínio do email (parte após @)
  String get domain => _value.split('@').last;

  /// Parte local do email (antes do @)
  String get localPart => _value.split('@').first;

  /// Verificar se é email corporativo (não é gmail, yahoo, etc.)
  bool get isCorporateEmail {
    const personalDomains = {
      'gmail.com',
      'yahoo.com',
      'hotmail.com',
      'outlook.com',
      'live.com',
      'icloud.com',
      'aol.com',
      'terra.com.br',
      'bol.com.br',
      'uol.com.br',
    };

    return !personalDomains.contains(domain);
  }

  /// Verificar se é email de instituição de saúde
  bool get isHealthcareEmail {
    const healthcareDomains = {
      // Hospitais e clínicas conhecidos
      'hc.fm.usp.br',
      'einstein.br',
      'hsl.org.br',
      'inca.gov.br',
      'fiocruz.br',
      // Adicionar mais conforme necessário
    };

    return healthcareDomains.contains(domain) ||
        domain.contains('hospital') ||
        domain.contains('clinica') ||
        domain.contains('saude') ||
        domain.contains('med');
  }

  /// Obter iniciais para avatar (primeiras 2 letras da parte local)
  String get initials {
    final localPart = this.localPart;
    if (localPart.length >= 2) {
      return localPart.substring(0, 2).toUpperCase();
    } else if (localPart.length == 1) {
      return localPart.toUpperCase();
    }
    return 'EM'; // Email
  }

  @override
  String toString() => _value;

  @override
  List<Object> get props => [_value];
}
