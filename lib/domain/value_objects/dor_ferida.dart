import 'package:freezed_annotation/freezed_annotation.dart';

part 'dor_ferida.freezed.dart';
part 'dor_ferida.g.dart';

enum DorTipo {
  @JsonValue('AUSENTE')
  ausente,
  @JsonValue('LEVE')
  leve,
  @JsonValue('MODERADA')
  moderada,
  @JsonValue('INTENSA')
  intensa,
  @JsonValue('INSUPORTAVEL')
  insuportavel,
}

/// Value object para características da dor da ferida
@freezed
class DorFerida with _$DorFerida {
  const factory DorFerida({
    @Default(0) int intensidade,
    @Default(DorTipo.ausente) DorTipo tipo,
    String? localizacao,
  }) = _DorFerida;

  factory DorFerida.fromJson(Map<String, dynamic> json) =>
      _$DorFeridaFromJson(json);
}
