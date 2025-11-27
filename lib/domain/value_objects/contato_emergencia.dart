import 'package:equatable/equatable.dart';

import '../exceptions/domain_exceptions.dart';
import 'phone.dart';
import 'email.dart';

/// Value Object representando dados de contato de emergência
class ContatoEmergencia extends Equatable {
  const ContatoEmergencia._({
    required this.nome,
    required this.parentesco,
    required this.telefone,
    this.email,
    this.observacoes,
  });

  final String nome;
  final String parentesco;
  final String telefone;
  final String? email;
  final String? observacoes;

  @override
  List<Object?> get props => [nome, parentesco, telefone, email, observacoes];

  /// Factory para criar contato de emergência com validações
  factory ContatoEmergencia.create({
    required String nome,
    required String parentesco,
    required String telefone,
    String? email,
    String? observacoes,
  }) {
    // Validações de domínio
    _validateNome(nome);
    _validateParentesco(parentesco);

    // Validar telefone
    Phone(telefone);

    // Validar email se fornecido
    if (email != null && email.trim().isNotEmpty) {
      Email(email);
    }

    // Validar observações
    if (observacoes != null && observacoes.length > 500) {
      throw const ValidationException(
        'Observações não podem ter mais de 500 caracteres',
      );
    }

    return ContatoEmergencia._(
      nome: nome.trim(),
      parentesco: parentesco.trim().toLowerCase(),
      telefone: telefone.trim(),
      email: email?.trim(),
      observacoes: observacoes?.trim(),
    );
  }

  /// Factory from JSON
  factory ContatoEmergencia.fromJson(Map<String, dynamic> json) {
    return ContatoEmergencia._(
      nome: json['nome'] as String,
      parentesco: json['parentesco'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String?,
      observacoes: json['observacoes'] as String?,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'parentesco': parentesco,
      'telefone': telefone,
      if (email != null) 'email': email,
      if (observacoes != null) 'observacoes': observacoes,
    };
  }

  /// Validação de nome do contato
  static void _validateNome(String nome) {
    final cleanNome = nome.trim();
    if (cleanNome.isEmpty) {
      throw const ValidationException('Nome do contato é obrigatório');
    }
    if (cleanNome.length < 2) {
      throw const ValidationException(
        'Nome do contato deve ter pelo menos 2 caracteres',
      );
    }
    if (cleanNome.length > 100) {
      throw const ValidationException(
        'Nome do contato não pode ter mais de 100 caracteres',
      );
    }
  }

  /// Validação de parentesco
  static void _validateParentesco(String parentesco) {
    final cleanParentesco = parentesco.trim();
    if (cleanParentesco.isEmpty) {
      throw const ValidationException('Parentesco é obrigatório');
    }
    if (cleanParentesco.length > 50) {
      throw const ValidationException(
        'Parentesco não pode ter mais de 50 caracteres',
      );
    }

    // Lista de parentescos válidos
    final parentescosValidos = {
      'cônjuge',
      'marido',
      'esposa',
      'filho',
      'filha',
      'pai',
      'mãe',
      'irmão',
      'irmã',
      'avô',
      'avó',
      'neto',
      'neta',
      'genro',
      'nora',
      'sogro',
      'sogra',
      'cunhado',
      'cunhada',
      'primo',
      'prima',
      'tio',
      'tia',
      'sobrinho',
      'sobrinha',
      'cuidador',
      'acompanhante',
      'responsável',
      'amigo',
      'vizinho',
      'outro',
    };

    if (!parentescosValidos.contains(cleanParentesco.toLowerCase())) {
      throw ValidationException(
        'Parentesco "$cleanParentesco" não é válido. '
        'Use um dos valores: ${parentescosValidos.join(', ')}',
      );
    }
  }

  /// Verifica se o contato tem informações completas
  bool get isComplete =>
      nome.isNotEmpty && parentesco.isNotEmpty && telefone.isNotEmpty;

  /// Verifica se tem email de contato
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Representação textual para exibição
  String get displayText => '$nome ($parentesco) - $telefone';
}
