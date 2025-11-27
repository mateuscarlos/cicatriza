import 'package:equatable/equatable.dart';

import '../exceptions/domain_exceptions.dart';

/// Value Object representando consentimentos LGPD do paciente
///
/// **Padrão para VOs de negócio:** Equatable + factories + validações de domínio
/// - Regras LGPD exigem validações específicas
/// - Factories permitem criação controlada e validada
class Consentimentos extends Equatable {
  const Consentimentos._({
    required this.coletaDados,
    required this.usoImagem,
    required this.compartilhamentoProfissional,
    required this.contatoEmail,
    required this.contatoSmsWhats,
  });

  final ConsentimentoItem coletaDados;
  final ConsentimentoItem usoImagem;
  final ConsentimentoItem compartilhamentoProfissional;
  final ConsentimentoItem contatoEmail;
  final ConsentimentoItem contatoSmsWhats;

  @override
  List<Object> get props => [
    coletaDados,
    usoImagem,
    compartilhamentoProfissional,
    contatoEmail,
    contatoSmsWhats,
  ];

  /// Factory para criar consentimentos com validações
  factory Consentimentos.create({
    required ConsentimentoItem coletaDados,
    required ConsentimentoItem usoImagem,
    required ConsentimentoItem compartilhamentoProfissional,
    required ConsentimentoItem contatoEmail,
    required ConsentimentoItem contatoSmsWhats,
  }) {
    // Coleta de dados é obrigatória para usar o sistema
    if (!coletaDados.aceito) {
      throw const ValidationException(
        'Consentimento para coleta de dados é obrigatório',
      );
    }

    return Consentimentos._(
      coletaDados: coletaDados,
      usoImagem: usoImagem,
      compartilhamentoProfissional: compartilhamentoProfissional,
      contatoEmail: contatoEmail,
      contatoSmsWhats: contatoSmsWhats,
    );
  }

  /// Factory para consentimentos padrão (apenas coleta de dados aceita)
  factory Consentimentos.padrao() {
    final agora = DateTime.now();
    return Consentimentos._(
      coletaDados: ConsentimentoItem.create(aceito: true, data: agora),
      usoImagem: ConsentimentoItem.create(aceito: false, data: agora),
      compartilhamentoProfissional: ConsentimentoItem.create(
        aceito: false,
        data: agora,
      ),
      contatoEmail: ConsentimentoItem.create(aceito: false, data: agora),
      contatoSmsWhats: ConsentimentoItem.create(aceito: false, data: agora),
    );
  }

  /// Factory from JSON
  factory Consentimentos.fromJson(Map<String, dynamic> json) {
    return Consentimentos._(
      coletaDados: ConsentimentoItem.fromJson(
        json['coletaDados'] as Map<String, dynamic>,
      ),
      usoImagem: ConsentimentoItem.fromJson(
        json['usoImagem'] as Map<String, dynamic>,
      ),
      compartilhamentoProfissional: ConsentimentoItem.fromJson(
        json['compartilhamentoProfissional'] as Map<String, dynamic>,
      ),
      contatoEmail: ConsentimentoItem.fromJson(
        json['contatoEmail'] as Map<String, dynamic>,
      ),
      contatoSmsWhats: ConsentimentoItem.fromJson(
        json['contatoSmsWhats'] as Map<String, dynamic>,
      ),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'coletaDados': coletaDados.toJson(),
      'usoImagem': usoImagem.toJson(),
      'compartilhamentoProfissional': compartilhamentoProfissional.toJson(),
      'contatoEmail': contatoEmail.toJson(),
      'contatoSmsWhats': contatoSmsWhats.toJson(),
    };
  }

  /// Verifica se pode usar imagens do paciente
  bool get podeUsarImagens => usoImagem.aceito;

  /// Verifica se pode compartilhar com outros profissionais
  bool get podeCompartilhar => compartilhamentoProfissional.aceito;

  /// Verifica se pode enviar emails
  bool get podeEnviarEmail => contatoEmail.aceito;

  /// Verifica se pode enviar SMS/WhatsApp
  bool get podeEnviarSmsWhats => contatoSmsWhats.aceito;

  /// Verifica se tem todos os consentimentos
  bool get todoAceitos =>
      coletaDados.aceito &&
      usoImagem.aceito &&
      compartilhamentoProfissional.aceito &&
      contatoEmail.aceito &&
      contatoSmsWhats.aceito;

  /// Lista consentimentos aceitos
  List<String> get consentimentosAceitos {
    final aceitos = <String>[];
    if (coletaDados.aceito) aceitos.add('Coleta de dados');
    if (usoImagem.aceito) aceitos.add('Uso de imagem');
    if (compartilhamentoProfissional.aceito) aceitos.add('Compartilhamento');
    if (contatoEmail.aceito) aceitos.add('Contato por email');
    if (contatoSmsWhats.aceito) aceitos.add('Contato por SMS/WhatsApp');
    return aceitos;
  }

  /// Atualiza consentimento específico
  Consentimentos atualizarConsentimento({
    ConsentimentoItem? coletaDados,
    ConsentimentoItem? usoImagem,
    ConsentimentoItem? compartilhamentoProfissional,
    ConsentimentoItem? contatoEmail,
    ConsentimentoItem? contatoSmsWhats,
  }) {
    return Consentimentos._(
      coletaDados: coletaDados ?? this.coletaDados,
      usoImagem: usoImagem ?? this.usoImagem,
      compartilhamentoProfissional:
          compartilhamentoProfissional ?? this.compartilhamentoProfissional,
      contatoEmail: contatoEmail ?? this.contatoEmail,
      contatoSmsWhats: contatoSmsWhats ?? this.contatoSmsWhats,
    );
  }
}

/// Item individual de consentimento
class ConsentimentoItem extends Equatable {
  const ConsentimentoItem._({required this.aceito, required this.data});

  final bool aceito;
  final DateTime data;

  @override
  List<Object> get props => [aceito, data];

  /// Factory para criar item de consentimento
  factory ConsentimentoItem.create({
    required bool aceito,
    required DateTime data,
  }) {
    // Data não pode ser no futuro
    if (data.isAfter(DateTime.now())) {
      throw const ValidationException(
        'Data do consentimento não pode ser no futuro',
      );
    }

    return ConsentimentoItem._(aceito: aceito, data: data);
  }

  /// Factory from JSON
  factory ConsentimentoItem.fromJson(Map<String, dynamic> json) {
    return ConsentimentoItem._(
      aceito: json['aceito'] as bool,
      data: DateTime.parse(json['data'] as String),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {'aceito': aceito, 'data': data.toIso8601String()};
  }

  /// Data formatada para exibição
  String get dataFormatada {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  /// Verifica se o consentimento é recente (últimos 365 dias)
  bool get isRecente {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);
    return diferenca.inDays <= 365;
  }

  /// Status textual
  String get status => aceito ? 'Aceito' : 'Negado';

  /// Cria nova versão aceita
  ConsentimentoItem aceitar() {
    return ConsentimentoItem._(aceito: true, data: DateTime.now());
  }

  /// Cria nova versão negada
  ConsentimentoItem negar() {
    return ConsentimentoItem._(aceito: false, data: DateTime.now());
  }
}
