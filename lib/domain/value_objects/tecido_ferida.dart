import 'package:freezed_annotation/freezed_annotation.dart';

part 'tecido_ferida.freezed.dart';
part 'tecido_ferida.g.dart';

/// Value object para composição do tecido da ferida
@freezed
class TecidoFerida with _$TecidoFerida {
  const factory TecidoFerida({
    @Default(0) int granulacao,
    @Default(0) int fibrina,
    @Default(0) int necrose,
    @Default(0) int epitelizacao,
    @Default(0) int outros,
  }) = _TecidoFerida;

  factory TecidoFerida.fromJson(Map<String, dynamic> json) =>
      _$TecidoFeridaFromJson(json);
}
