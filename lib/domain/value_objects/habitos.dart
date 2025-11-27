import 'package:equatable/equatable.dart';

import '../exceptions/domain_exceptions.dart';

/// Enums para classificação de hábitos
enum StatusTabagismo {
  nao,
  ex,
  sim;

  String get displayName {
    switch (this) {
      case StatusTabagismo.nao:
        return 'Não fumante';
      case StatusTabagismo.ex:
        return 'Ex-fumante';
      case StatusTabagismo.sim:
        return 'Fumante';
    }
  }
}

enum StatusEtilismo {
  nao,
  social,
  frequente;

  String get displayName {
    switch (this) {
      case StatusEtilismo.nao:
        return 'Não bebe';
      case StatusEtilismo.social:
        return 'Social';
      case StatusEtilismo.frequente:
        return 'Frequente';
    }
  }
}

enum NivelHidratacao {
  adequada,
  baixa;

  String get displayName {
    switch (this) {
      case NivelHidratacao.adequada:
        return 'Adequada';
      case NivelHidratacao.baixa:
        return 'Baixa';
    }
  }
}

enum NivelAtividadeFisica {
  sedentario,
  leve,
  moderado,
  intenso;

  String get displayName {
    switch (this) {
      case NivelAtividadeFisica.sedentario:
        return 'Sedentário';
      case NivelAtividadeFisica.leve:
        return 'Leve';
      case NivelAtividadeFisica.moderado:
        return 'Moderado';
      case NivelAtividadeFisica.intenso:
        return 'Intenso';
    }
  }
}

/// Value Object representando hábitos do paciente
class Habitos extends Equatable {
  const Habitos._({
    this.tabagismo,
    this.cigarrosDia,
    this.etilismo,
    this.hidratacao,
    this.dieta,
    this.atividadeFisica,
    this.sonoHoras,
  });

  final StatusTabagismo? tabagismo;
  final int? cigarrosDia;
  final StatusEtilismo? etilismo;
  final NivelHidratacao? hidratacao;
  final String? dieta;
  final NivelAtividadeFisica? atividadeFisica;
  final int? sonoHoras;

  @override
  List<Object?> get props => [
    tabagismo,
    cigarrosDia,
    etilismo,
    hidratacao,
    dieta,
    atividadeFisica,
    sonoHoras,
  ];

  /// Factory para criar hábitos com validações
  factory Habitos.create({
    StatusTabagismo? tabagismo,
    int? cigarrosDia,
    StatusEtilismo? etilismo,
    NivelHidratacao? hidratacao,
    String? dieta,
    NivelAtividadeFisica? atividadeFisica,
    int? sonoHoras,
  }) {
    // Validações de cigarros por dia
    if (cigarrosDia != null && (cigarrosDia < 0 || cigarrosDia > 200)) {
      throw const ValidationException(
        'Número de cigarros por dia deve estar entre 0 e 200',
      );
    }

    // Validações de horas de sono
    if (sonoHoras != null && (sonoHoras < 0 || sonoHoras > 24)) {
      throw const ValidationException('Horas de sono devem estar entre 0 e 24');
    }

    // Validações de dieta
    if (dieta != null && dieta.length > 200) {
      throw const ValidationException(
        'Descrição da dieta não pode ter mais de 200 caracteres',
      );
    }

    return Habitos._(
      tabagismo: tabagismo,
      cigarrosDia: cigarrosDia,
      etilismo: etilismo,
      hidratacao: hidratacao,
      dieta: dieta?.trim(),
      atividadeFisica: atividadeFisica,
      sonoHoras: sonoHoras,
    );
  }

  /// Factory from JSON
  factory Habitos.fromJson(Map<String, dynamic> json) {
    return Habitos._(
      tabagismo: json['tabagismo'] != null
          ? StatusTabagismo.values.byName(json['tabagismo'] as String)
          : null,
      cigarrosDia: json['cigarrosDia'] as int?,
      etilismo: json['etilismo'] != null
          ? StatusEtilismo.values.byName(json['etilismo'] as String)
          : null,
      hidratacao: json['hidratacao'] != null
          ? NivelHidratacao.values.byName(json['hidratacao'] as String)
          : null,
      dieta: json['dieta'] as String?,
      atividadeFisica: json['atividadeFisica'] != null
          ? NivelAtividadeFisica.values.byName(
              json['atividadeFisica'] as String,
            )
          : null,
      sonoHoras: json['sonoHoras'] as int?,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      if (tabagismo != null) 'tabagismo': tabagismo!.name,
      if (cigarrosDia != null) 'cigarrosDia': cigarrosDia,
      if (etilismo != null) 'etilismo': etilismo!.name,
      if (hidratacao != null) 'hidratacao': hidratacao!.name,
      if (dieta != null) 'dieta': dieta,
      if (atividadeFisica != null) 'atividadeFisica': atividadeFisica!.name,
      if (sonoHoras != null) 'sonoHoras': sonoHoras,
    };
  }

  /// Verifica se é fumante atual
  bool get isFumante => tabagismo == StatusTabagismo.sim;

  /// Verifica se há fatores de risco
  bool get hasFactoresRisco {
    return isFumante ||
        etilismo == StatusEtilismo.frequente ||
        hidratacao == NivelHidratacao.baixa ||
        atividadeFisica == NivelAtividadeFisica.sedentario ||
        (sonoHoras != null && (sonoHoras! < 6 || sonoHoras! > 9));
  }

  /// Lista de fatores de risco
  List<String> get fatoresRisco {
    final fatores = <String>[];

    if (isFumante) {
      final info = cigarrosDia != null ? ' ($cigarrosDia/dia)' : '';
      fatores.add('Tabagismo atual$info');
    }

    if (etilismo == StatusEtilismo.frequente) {
      fatores.add('Etilismo frequente');
    }

    if (hidratacao == NivelHidratacao.baixa) {
      fatores.add('Hidratação inadequada');
    }

    if (atividadeFisica == NivelAtividadeFisica.sedentario) {
      fatores.add('Sedentarismo');
    }

    if (sonoHoras != null && (sonoHoras! < 6 || sonoHoras! > 9)) {
      fatores.add('Padrão de sono inadequado (${sonoHoras}h)');
    }

    return fatores;
  }
}
