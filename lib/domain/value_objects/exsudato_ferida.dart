import 'package:freezed_annotation/freezed_annotation.dart';

part 'exsudato_ferida.freezed.dart';
part 'exsudato_ferida.g.dart';

enum ExsudatoTipo {
  @JsonValue('SEROSO')
  seroso,
  @JsonValue('SEROPURULENTO')
  seropurulento,
  @JsonValue('PURULENTO')
  purulento,
  @JsonValue('SANGUINOLENTO')
  sanguinolento,
  @JsonValue('OUTRO')
  outro,
}

enum ExsudatoQuantidade {
  @JsonValue('AUSENTE')
  ausente,
  @JsonValue('PEQUENA')
  pequena,
  @JsonValue('MODERADA')
  moderada,
  @JsonValue('GRANDE')
  grande,
}

enum ExsudatoAspecto {
  @JsonValue('CLARO')
  claro,
  @JsonValue('TURVO')
  turvo,
  @JsonValue('ESPESSO')
  espesso,
  @JsonValue('VISCOSO')
  viscoso,
}

/// Value object para características do exsudato da ferida
@freezed
class ExsudatoFerida with _$ExsudatoFerida {
  const factory ExsudatoFerida({
    @Default(ExsudatoTipo.seroso) ExsudatoTipo tipo,
    @Default(ExsudatoQuantidade.ausente) ExsudatoQuantidade quantidade,
    @Default(ExsudatoAspecto.claro) ExsudatoAspecto aspecto,
    @Default(false) bool odor,
  }) = _ExsudatoFerida;

  factory ExsudatoFerida.fromJson(Map<String, dynamic> json) =>
      _$ExsudatoFeridaFromJson(json);
}
