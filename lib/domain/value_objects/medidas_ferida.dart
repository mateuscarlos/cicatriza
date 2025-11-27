import 'package:freezed_annotation/freezed_annotation.dart';

part 'medidas_ferida.freezed.dart';
part 'medidas_ferida.g.dart';

/// Value object para medidas da ferida
@freezed
class MedidasFerida with _$MedidasFerida {
  const factory MedidasFerida({
    required double comprimento,
    required double largura,
    double? profundidade,
    double? area,
    double? volume,
  }) = _MedidasFerida;

  factory MedidasFerida.fromJson(Map<String, dynamic> json) =>
      _$MedidasFeridaFromJson(json);
}
