import 'package:equatable/equatable.dart';

import '../exceptions/domain_exceptions.dart';

/// Enum para classificação de apetite
enum Apetite {
  bom,
  regular,
  ruim;

  String get displayName {
    switch (this) {
      case Apetite.bom:
        return 'Bom';
      case Apetite.regular:
        return 'Regular';
      case Apetite.ruim:
        return 'Ruim';
    }
  }
}

/// Value Object representando estado nutricional do paciente
class EstadoNutricional extends Equatable {
  const EstadoNutricional._({
    this.pesoKg,
    this.alturaM,
    this.imc,
    this.perdaPesoUltimos3Meses,
    this.apetite,
  });

  final double? pesoKg;
  final double? alturaM;
  final double? imc;
  final double? perdaPesoUltimos3Meses; // Percentual de perda de peso
  final Apetite? apetite;

  @override
  List<Object?> get props => [
    pesoKg,
    alturaM,
    imc,
    perdaPesoUltimos3Meses,
    apetite,
  ];

  /// Factory para criar estado nutricional com validações
  factory EstadoNutricional.create({
    double? pesoKg,
    double? alturaM,
    double? imc,
    double? perdaPesoUltimos3Meses,
    Apetite? apetite,
  }) {
    // Validações de peso
    if (pesoKg != null) {
      if (pesoKg <= 0 || pesoKg > 1000) {
        throw const ValidationException('Peso deve estar entre 0,1 e 1000 kg');
      }
    }

    // Validações de altura
    if (alturaM != null) {
      if (alturaM <= 0 || alturaM > 3.0) {
        throw const ValidationException(
          'Altura deve estar entre 0,01 e 3,0 metros',
        );
      }
    }

    // Validações de IMC se fornecido diretamente
    if (imc != null) {
      if (imc <= 0 || imc > 100) {
        throw const ValidationException('IMC deve estar entre 0,1 e 100');
      }
    }

    // Validações de perda de peso
    if (perdaPesoUltimos3Meses != null) {
      if (perdaPesoUltimos3Meses < 0 || perdaPesoUltimos3Meses > 100) {
        throw const ValidationException(
          'Perda de peso deve estar entre 0% e 100%',
        );
      }
    }

    // Calcular IMC se não fornecido mas temos peso e altura
    double? imcCalculado = imc;
    if (imcCalculado == null && pesoKg != null && alturaM != null) {
      imcCalculado = pesoKg / (alturaM * alturaM);
    }

    return EstadoNutricional._(
      pesoKg: pesoKg,
      alturaM: alturaM,
      imc: imcCalculado,
      perdaPesoUltimos3Meses: perdaPesoUltimos3Meses,
      apetite: apetite,
    );
  }

  /// Factory from JSON
  factory EstadoNutricional.fromJson(Map<String, dynamic> json) {
    return EstadoNutricional._(
      pesoKg: json['pesoKg'] != null
          ? (json['pesoKg'] as num).toDouble()
          : null,
      alturaM: json['alturaM'] != null
          ? (json['alturaM'] as num).toDouble()
          : null,
      imc: json['imc'] != null ? (json['imc'] as num).toDouble() : null,
      perdaPesoUltimos3Meses: json['perdaPesoUltimos3Meses'] != null
          ? (json['perdaPesoUltimos3Meses'] as num).toDouble()
          : null,
      apetite: json['apetite'] != null
          ? Apetite.values.byName(json['apetite'] as String)
          : null,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      if (pesoKg != null) 'pesoKg': pesoKg,
      if (alturaM != null) 'alturaM': alturaM,
      if (imc != null) 'imc': imc,
      if (perdaPesoUltimos3Meses != null)
        'perdaPesoUltimos3Meses': perdaPesoUltimos3Meses,
      if (apetite != null) 'apetite': apetite!.name,
    };
  }

  /// IMC calculado (se possível)
  double? get imcCalculado {
    if (pesoKg != null && alturaM != null) {
      return pesoKg! / (alturaM! * alturaM!);
    }
    return imc;
  }

  /// Classificação do IMC segundo OMS
  String? get classificacaoImc {
    final imcAtual = imcCalculado;
    if (imcAtual == null) return null;

    if (imcAtual < 16.0) return 'Magreza grave';
    if (imcAtual < 17.0) return 'Magreza moderada';
    if (imcAtual < 18.5) return 'Magreza leve';
    if (imcAtual < 25.0) return 'Eutrofia';
    if (imcAtual < 30.0) return 'Sobrepeso';
    if (imcAtual < 35.0) return 'Obesidade grau I';
    if (imcAtual < 40.0) return 'Obesidade grau II';
    return 'Obesidade grau III';
  }

  /// Cor para classificação (semáforo)
  String? get corClassificacao {
    final imcAtual = imcCalculado;
    if (imcAtual == null) return null;

    if (imcAtual < 16.0) return 'red'; // Magreza grave
    if (imcAtual < 18.5) return 'orange'; // Magreza
    if (imcAtual < 25.0) return 'green'; // Normal
    if (imcAtual < 30.0) return 'yellow'; // Sobrepeso
    return 'red'; // Obesidade
  }

  /// Verifica se está em peso adequado
  bool? get pesoAdequado {
    final imcAtual = imcCalculado;
    if (imcAtual == null) return null;
    return imcAtual >= 18.5 && imcAtual < 25.0;
  }

  /// Verifica se há risco nutricional
  bool get hasRiscoNutricional {
    // IMC fora da faixa normal
    final imcAtual = imcCalculado;
    if (imcAtual != null && (imcAtual < 18.5 || imcAtual >= 30.0)) {
      return true;
    }

    // Perda de peso significativa
    if (perdaPesoUltimos3Meses != null && perdaPesoUltimos3Meses! >= 10.0) {
      return true;
    }

    // Apetite ruim
    if (apetite == Apetite.ruim) {
      return true;
    }

    return false;
  }

  /// Lista de fatores de risco identificados
  List<String> get fatoresRisco {
    final fatores = <String>[];

    final imcAtual = imcCalculado;
    if (imcAtual != null) {
      if (imcAtual < 18.5) {
        fatores.add('Baixo peso (IMC ${imcAtual.toStringAsFixed(1)})');
      } else if (imcAtual >= 30.0) {
        fatores.add('Obesidade (IMC ${imcAtual.toStringAsFixed(1)})');
      }
    }

    if (perdaPesoUltimos3Meses != null && perdaPesoUltimos3Meses! >= 10.0) {
      fatores.add(
        'Perda de peso significativa (${perdaPesoUltimos3Meses!.toStringAsFixed(1)}%)',
      );
    }

    if (apetite == Apetite.ruim) {
      fatores.add('Apetite prejudicado');
    }

    return fatores;
  }

  /// Verifica se tem dados suficientes para avaliação
  bool get hasDadosSuficientes {
    return pesoKg != null ||
        alturaM != null ||
        imc != null ||
        perdaPesoUltimos3Meses != null ||
        apetite != null;
  }

  /// Peso formatado para exibição
  String get pesoFormatado {
    if (pesoKg == null) return 'Não informado';
    return '${pesoKg!.toStringAsFixed(1)} kg';
  }

  /// Altura formatada para exibição
  String get alturaFormatada {
    if (alturaM == null) return 'Não informada';
    return '${(alturaM! * 100).toStringAsFixed(0)} cm';
  }

  /// IMC formatado para exibição
  String get imcFormatado {
    final imcAtual = imcCalculado;
    if (imcAtual == null) return 'Não calculável';
    return '${imcAtual.toStringAsFixed(1)} kg/m²';
  }

  /// Resumo do estado nutricional
  String get resumo {
    if (!hasDadosSuficientes) {
      return 'Estado nutricional não avaliado - dados insuficientes';
    }

    final parts = <String>[];

    if (pesoKg != null) parts.add('Peso: ${pesoFormatado}');
    if (alturaM != null) parts.add('Altura: ${alturaFormatada}');
    if (imcCalculado != null)
      parts.add('IMC: ${imcFormatado} (${classificacaoImc})');
    if (perdaPesoUltimos3Meses != null) {
      parts.add(
        'Perda de peso: ${perdaPesoUltimos3Meses!.toStringAsFixed(1)}%',
      );
    }
    if (apetite != null) parts.add('Apetite: ${apetite!.displayName}');

    return parts.join(' | ');
  }
}
