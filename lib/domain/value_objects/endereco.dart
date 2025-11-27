import 'package:equatable/equatable.dart';

import '../exceptions/domain_exceptions.dart';

/// Value Object representando endereço do paciente
///
/// **Padrão para VOs complexos:** Equatable + validações + toJson/fromJson manual
/// - Mantém controle total sobre validações de domínio
/// - Flexibilidade para lógicas de negócio complexas
class Endereco extends Equatable {
  const Endereco._({
    required this.logradouro,
    required this.numero,
    required this.cidade,
    required this.estado,
    required this.pais,
    this.complemento,
    this.bairro,
    this.cep,
    this.geoloc,
    this.pontoReferencia,
  });

  final String logradouro;
  final String numero;
  final String? complemento;
  final String? bairro;
  final String cidade;
  final String estado;
  final String? cep;
  final String pais;
  final Geolocalizacao? geoloc;
  final String? pontoReferencia;

  @override
  List<Object?> get props => [
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado,
    cep,
    pais,
    geoloc,
    pontoReferencia,
  ];

  /// Factory para criar endereço com validações
  factory Endereco.create({
    required String logradouro,
    required String numero,
    required String cidade,
    required String estado,
    required String pais,
    String? complemento,
    String? bairro,
    String? cep,
    Geolocalizacao? geoloc,
    String? pontoReferencia,
  }) {
    // Validações de domínio
    _validateLogradouro(logradouro);
    _validateNumero(numero);
    _validateCidade(cidade);
    _validateEstado(estado);
    _validatePais(pais);

    if (cep != null) {
      _validateCep(cep);
    }

    if (pontoReferencia != null && pontoReferencia.length > 200) {
      throw const ValidationException(
        'Ponto de referência não pode ter mais de 200 caracteres',
      );
    }

    return Endereco._(
      logradouro: logradouro.trim(),
      numero: numero.trim(),
      cidade: cidade.trim(),
      estado: estado.trim().toUpperCase(),
      pais: pais.trim(),
      complemento: complemento?.trim(),
      bairro: bairro?.trim(),
      cep: cep?.replaceAll(RegExp(r'[^\d]'), ''), // Remove formatação
      geoloc: geoloc,
      pontoReferencia: pontoReferencia?.trim(),
    );
  }

  /// Factory from JSON
  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco._(
      logradouro: json['logradouro'] as String,
      numero: json['numero'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      pais: json['pais'] as String,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String?,
      cep: json['cep'] as String?,
      geoloc: json['geoloc'] != null
          ? Geolocalizacao.fromJson(json['geoloc'] as Map<String, dynamic>)
          : null,
      pontoReferencia: json['pontoReferencia'] as String?,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'logradouro': logradouro,
      'numero': numero,
      'cidade': cidade,
      'estado': estado,
      'pais': pais,
      if (complemento != null) 'complemento': complemento,
      if (bairro != null) 'bairro': bairro,
      if (cep != null) 'cep': cep,
      if (geoloc != null) 'geoloc': geoloc!.toJson(),
      if (pontoReferencia != null) 'pontoReferencia': pontoReferencia,
    };
  }

  /// Validação de logradouro
  static void _validateLogradouro(String logradouro) {
    final clean = logradouro.trim();
    if (clean.isEmpty) {
      throw const ValidationException('Logradouro é obrigatório');
    }
    if (clean.length < 3) {
      throw const ValidationException(
        'Logradouro deve ter pelo menos 3 caracteres',
      );
    }
    if (clean.length > 200) {
      throw const ValidationException(
        'Logradouro não pode ter mais de 200 caracteres',
      );
    }
  }

  /// Validação de número
  static void _validateNumero(String numero) {
    final clean = numero.trim();
    if (clean.isEmpty) {
      throw const ValidationException('Número é obrigatório');
    }
    if (clean.length > 20) {
      throw const ValidationException(
        'Número não pode ter mais de 20 caracteres',
      );
    }
  }

  /// Validação de cidade
  static void _validateCidade(String cidade) {
    final clean = cidade.trim();
    if (clean.isEmpty) {
      throw const ValidationException('Cidade é obrigatória');
    }
    if (clean.length < 2) {
      throw const ValidationException(
        'Cidade deve ter pelo menos 2 caracteres',
      );
    }
    if (clean.length > 100) {
      throw const ValidationException(
        'Cidade não pode ter mais de 100 caracteres',
      );
    }
  }

  /// Validação de estado
  static void _validateEstado(String estado) {
    final clean = estado.trim();
    if (clean.isEmpty) {
      throw const ValidationException('Estado é obrigatório');
    }
    if (clean.length < 2) {
      throw const ValidationException(
        'Estado deve ter pelo menos 2 caracteres',
      );
    }
    if (clean.length > 50) {
      throw const ValidationException(
        'Estado não pode ter mais de 50 caracteres',
      );
    }
  }

  /// Validação de país
  static void _validatePais(String pais) {
    final clean = pais.trim();
    if (clean.isEmpty) {
      throw const ValidationException('País é obrigatório');
    }
    if (clean.length < 2) {
      throw const ValidationException('País deve ter pelo menos 2 caracteres');
    }
    if (clean.length > 50) {
      throw const ValidationException(
        'País não pode ter mais de 50 caracteres',
      );
    }
  }

  /// Validação de CEP brasileiro
  static void _validateCep(String cep) {
    final clean = cep.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.length != 8) {
      throw const ValidationException(
        'CEP deve ter 8 dígitos (formato: 00000-000)',
      );
    }
  }

  /// Verifica se é endereço brasileiro
  bool get isBrasil => pais.toLowerCase() == 'brasil';

  /// CEP formatado
  String get cepFormatado {
    if (cep == null || cep!.length != 8) return cep ?? '';
    return '${cep!.substring(0, 5)}-${cep!.substring(5)}';
  }

  /// Endereço completo formatado
  String get enderecoCompleto {
    final parts = <String>[
      '$logradouro, $numero',
      if (complemento != null) complemento!,
      if (bairro != null) bairro!,
      cidade,
      estado,
      if (cep != null) cepFormatado,
      pais,
    ];
    return parts.join(', ');
  }

  /// Endereço resumido
  String get enderecoResumido {
    return '$logradouro, $numero - $cidade/$estado';
  }

  /// Verifica se tem geolocalização
  bool get hasGeoloc => geoloc != null;

  /// Verifica se endereço está completo
  bool get isComplete =>
      logradouro.isNotEmpty &&
      numero.isNotEmpty &&
      cidade.isNotEmpty &&
      estado.isNotEmpty &&
      pais.isNotEmpty;
}

/// Value Object para geolocalização
class Geolocalizacao extends Equatable {
  const Geolocalizacao._({required this.lat, required this.lng});

  final double lat;
  final double lng;

  @override
  List<Object> get props => [lat, lng];

  /// Factory para criar geolocalização com validações
  factory Geolocalizacao.create({required double lat, required double lng}) {
    // Validar limites de latitude (-90 a 90)
    if (lat < -90 || lat > 90) {
      throw const ValidationException(
        'Latitude deve estar entre -90 e 90 graus',
      );
    }

    // Validar limites de longitude (-180 a 180)
    if (lng < -180 || lng > 180) {
      throw const ValidationException(
        'Longitude deve estar entre -180 e 180 graus',
      );
    }

    return Geolocalizacao._(lat: lat, lng: lng);
  }

  /// Factory from JSON
  factory Geolocalizacao.fromJson(Map<String, dynamic> json) {
    return Geolocalizacao._(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }

  /// Coordenadas formatadas para exibição
  String get coordenadasFormatadas {
    return '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
  }

  /// Verifica se está no Brasil (aproximadamente)
  bool get isNoBrasil {
    return lat >= -33.75 && lat <= 5.27 && lng >= -73.99 && lng <= -28.84;
  }
}
