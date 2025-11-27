import 'package:equatable/equatable.dart';

/// Medicação atual do paciente
class MedicacaoAtual extends Equatable {
  const MedicacaoAtual({
    required this.nome,
    this.dose,
    this.frequencia,
    this.via,
    this.inicio,
  });

  final String nome;
  final String? dose;
  final String? frequencia;
  final String? via;
  final DateTime? inicio;

  @override
  List<Object?> get props => [nome, dose, frequencia, via, inicio];

  factory MedicacaoAtual.fromJson(Map<String, dynamic> json) {
    return MedicacaoAtual(
      nome: json['nome'] as String,
      dose: json['dose'] as String?,
      frequencia: json['frequencia'] as String?,
      via: json['via'] as String?,
      inicio: json['inicio'] != null
          ? DateTime.parse(json['inicio'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      if (dose != null) 'dose': dose,
      if (frequencia != null) 'frequencia': frequencia,
      if (via != null) 'via': via,
      if (inicio != null) 'inicio': inicio!.toIso8601String(),
    };
  }
}

/// Cirurgia prévia do paciente
class CirurgiaPrevias extends Equatable {
  const CirurgiaPrevias({required this.nome, this.data, this.descricao});

  final String nome;
  final DateTime? data;
  final String? descricao;

  @override
  List<Object?> get props => [nome, data, descricao];

  factory CirurgiaPrevias.fromJson(Map<String, dynamic> json) {
    return CirurgiaPrevias(
      nome: json['nome'] as String,
      data: json['data'] != null
          ? DateTime.parse(json['data'] as String)
          : null,
      descricao: json['descricao'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      if (data != null) 'data': data!.toIso8601String(),
      if (descricao != null) 'descricao': descricao,
    };
  }
}

/// Vacina do paciente
class Vacina extends Equatable {
  const Vacina({required this.nome, this.dose, this.data});

  final String nome;
  final String? dose;
  final DateTime? data;

  @override
  List<Object?> get props => [nome, dose, data];

  factory Vacina.fromJson(Map<String, dynamic> json) {
    return Vacina(
      nome: json['nome'] as String,
      dose: json['dose'] as String?,
      data: json['data'] != null
          ? DateTime.parse(json['data'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      if (dose != null) 'dose': dose,
      if (data != null) 'data': data!.toIso8601String(),
    };
  }
}

/// Foto de perfil do paciente
class FotoPerfil extends Equatable {
  const FotoPerfil({required this.url, required this.hash, required this.data});

  final String url;
  final String hash;
  final DateTime data;

  @override
  List<Object> get props => [url, hash, data];

  factory FotoPerfil.fromJson(Map<String, dynamic> json) {
    return FotoPerfil(
      url: json['url'] as String,
      hash: json['hash'] as String,
      data: DateTime.parse(json['data'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'hash': hash, 'data': data.toIso8601String()};
  }
}

/// Risco de pressão
class RiscoPressao extends Equatable {
  const RiscoPressao({this.instrumento, this.escore, this.data});

  final String? instrumento; // braden, norton, waterlow, outro
  final int? escore;
  final DateTime? data;

  @override
  List<Object?> get props => [instrumento, escore, data];

  factory RiscoPressao.fromJson(Map<String, dynamic> json) {
    return RiscoPressao(
      instrumento: json['instrumento'] as String?,
      escore: json['escore'] as int?,
      data: json['data'] != null
          ? DateTime.parse(json['data'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (instrumento != null) 'instrumento': instrumento,
      if (escore != null) 'escore': escore,
      if (data != null) 'data': data!.toIso8601String(),
    };
  }
}

/// Risco de infecção
class RiscoInfeccao extends Equatable {
  const RiscoInfeccao({
    this.mrsaHistorico,
    this.antibioticosRecentes,
    this.historicoInfeccoes,
  });

  final bool? mrsaHistorico;
  final bool? antibioticosRecentes;
  final String? historicoInfeccoes;

  @override
  List<Object?> get props => [
    mrsaHistorico,
    antibioticosRecentes,
    historicoInfeccoes,
  ];

  factory RiscoInfeccao.fromJson(Map<String, dynamic> json) {
    return RiscoInfeccao(
      mrsaHistorico: json['mrsaHistorico'] as bool?,
      antibioticosRecentes: json['antibioticosRecentes'] as bool?,
      historicoInfeccoes: json['historicoInfeccoes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (mrsaHistorico != null) 'mrsaHistorico': mrsaHistorico,
      if (antibioticosRecentes != null)
        'antibioticosRecentes': antibioticosRecentes,
      if (historicoInfeccoes != null) 'historicoInfeccoes': historicoInfeccoes,
    };
  }
}

/// Dor crônica
class DorCronica extends Equatable {
  const DorCronica({this.escala, this.analgesicos, this.duracaoMeses});

  final int? escala; // 0-10
  final String? analgesicos;
  final int? duracaoMeses;

  @override
  List<Object?> get props => [escala, analgesicos, duracaoMeses];

  factory DorCronica.fromJson(Map<String, dynamic> json) {
    return DorCronica(
      escala: json['escala'] as int?,
      analgesicos: json['analgesicos'] as String?,
      duracaoMeses: json['duracaoMeses'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (escala != null) 'escala': escala,
      if (analgesicos != null) 'analgesicos': analgesicos,
      if (duracaoMeses != null) 'duracaoMeses': duracaoMeses,
    };
  }
}

/// Perfil da pele
class PerfilPele extends Equatable {
  const PerfilPele({
    this.fototipo,
    this.ressecamento,
    this.fragilidade,
    this.dermatite,
    this.cicatrizacaoPreviaRuim,
  });

  final int? fototipo; // 1-6 (Fitzpatrick)
  final bool? ressecamento;
  final bool? fragilidade;
  final bool? dermatite;
  final bool? cicatrizacaoPreviaRuim;

  @override
  List<Object?> get props => [
    fototipo,
    ressecamento,
    fragilidade,
    dermatite,
    cicatrizacaoPreviaRuim,
  ];

  factory PerfilPele.fromJson(Map<String, dynamic> json) {
    return PerfilPele(
      fototipo: json['fototipo'] as int?,
      ressecamento: json['ressecamento'] as bool?,
      fragilidade: json['fragilidade'] as bool?,
      dermatite: json['dermatite'] as bool?,
      cicatrizacaoPreviaRuim: json['cicatrizacaoPreviaRuim'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fototipo != null) 'fototipo': fototipo,
      if (ressecamento != null) 'ressecamento': ressecamento,
      if (fragilidade != null) 'fragilidade': fragilidade,
      if (dermatite != null) 'dermatite': dermatite,
      if (cicatrizacaoPreviaRuim != null)
        'cicatrizacaoPreviaRuim': cicatrizacaoPreviaRuim,
    };
  }
}

/// Perfil vascular
class PerfilVascular extends Equatable {
  const PerfilVascular({
    this.pulsosPerifericos,
    this.edema,
    this.itb,
    this.varizes,
  });

  final String? pulsosPerifericos; // presentes, diminuídos, ausentes
  final String? edema; // nao, leve, moderado, grave
  final double? itb; // índice tornozelo-braquial
  final bool? varizes;

  @override
  List<Object?> get props => [pulsosPerifericos, edema, itb, varizes];

  factory PerfilVascular.fromJson(Map<String, dynamic> json) {
    return PerfilVascular(
      pulsosPerifericos: json['pulsosPerifericos'] as String?,
      edema: json['edema'] as String?,
      itb: json['itb'] != null ? (json['itb'] as num).toDouble() : null,
      varizes: json['varizes'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (pulsosPerifericos != null) 'pulsosPerifericos': pulsosPerifericos,
      if (edema != null) 'edema': edema,
      if (itb != null) 'itb': itb,
      if (varizes != null) 'varizes': varizes,
    };
  }
}

/// Responsável legal
class ResponsavelLegal extends Equatable {
  const ResponsavelLegal({
    required this.nome,
    required this.vinculo,
    required this.contato,
  });

  final String nome;
  final String vinculo;
  final String contato;

  @override
  List<Object> get props => [nome, vinculo, contato];

  factory ResponsavelLegal.fromJson(Map<String, dynamic> json) {
    return ResponsavelLegal(
      nome: json['nome'] as String,
      vinculo: json['vinculo'] as String,
      contato: json['contato'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nome': nome, 'vinculo': vinculo, 'contato': contato};
  }
}

/// Preferências de comunicação
class PreferenciasComunicacao extends Equatable {
  const PreferenciasComunicacao({
    this.whatsapp,
    this.sms,
    this.email,
    this.idioma,
    this.horarios,
  });

  final bool? whatsapp;
  final bool? sms;
  final bool? email;
  final String? idioma;
  final String? horarios;

  @override
  List<Object?> get props => [whatsapp, sms, email, idioma, horarios];

  factory PreferenciasComunicacao.fromJson(Map<String, dynamic> json) {
    return PreferenciasComunicacao(
      whatsapp: json['whatsapp'] as bool?,
      sms: json['sms'] as bool?,
      email: json['email'] as bool?,
      idioma: json['idioma'] as String?,
      horarios: json['horarios'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (whatsapp != null) 'whatsapp': whatsapp,
      if (sms != null) 'sms': sms,
      if (email != null) 'email': email,
      if (idioma != null) 'idioma': idioma,
      if (horarios != null) 'horarios': horarios,
    };
  }
}
