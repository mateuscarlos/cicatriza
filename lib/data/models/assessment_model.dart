import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/assessment.dart';
import '../../domain/value_objects/medidas_ferida.dart';
import '../../domain/value_objects/tecido_ferida.dart';
import '../../domain/value_objects/exsudato_ferida.dart';
import '../../domain/value_objects/dor_ferida.dart';

/// Modelo para serialização/deserialização do Assessment no Firestore
/// Compatível com a estrutura de Assessment existente mas usando hierarquia V5
///
/// **Padrão de serialização adotado:**
/// - Value Objects simples (medidas, tecido, exsudato, dor): **Freezed + json_annotation**
/// - Value Objects complexos (endereco, contatos): **Equatable + toJson/fromJson manual**
/// - Models: **Classes normais + toFirestore/fromFirestore**
/// - Entities: **Freezed** para imutabilidade
class AssessmentModel {
  final String assessmentId;
  final String ownerId;
  final String patientId;
  final String woundId;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final MedidasFerida medidas;
  final TecidoFerida tecido;
  final ExsudatoFerida exsudato;
  final DorFerida? dor;
  final String? observacoes;
  final List<String> images;
  final bool archived;

  const AssessmentModel({
    required this.assessmentId,
    required this.ownerId,
    required this.patientId,
    required this.woundId,
    required this.criadoEm,
    required this.atualizadoEm,
    required this.medidas,
    required this.tecido,
    required this.exsudato,
    this.dor,
    this.observacoes,
    this.images = const <String>[],
    this.archived = false,
  });

  /// Converte de entidade de domínio para modelo Firestore
  factory AssessmentModel.fromEntity(Assessment assessment) {
    // Converter a estrutura antiga para a nova estrutura V5
    final medidas = MedidasFerida(
      comprimento: assessment.lengthCm,
      largura: assessment.widthCm,
      profundidade: assessment.depthCm > 0 ? assessment.depthCm : null,
      area: assessment.lengthCm * assessment.widthCm,
      volume: assessment.depthCm > 0
          ? assessment.lengthCm * assessment.widthCm * assessment.depthCm
          : null,
    );

    // Mapear tecido baseado nas informações disponíveis
    final tecido = TecidoFerida(
      granulacao: assessment.woundBed?.contains('granulation') == true
          ? 70
          : 50,
      fibrina: assessment.woundBed?.contains('fibrin') == true ? 30 : 10,
      necrose: assessment.woundBed?.contains('necrotic') == true ? 20 : 0,
      epitelizacao: assessment.edgeAppearance?.contains('epithelial') == true
          ? 10
          : 0,
    );

    // Mapear exsudato
    final exsudato = ExsudatoFerida(
      tipo: _mapExudateType(assessment.exudate),
      quantidade: _mapExudateAmount(assessment.exudate),

      odor: assessment.odor?.isNotEmpty == true,
    );

    // Mapear dor
    final dor = assessment.pain > 0
        ? DorFerida(
            intensidade: assessment.pain,
            tipo: _mapPainType(assessment.pain),
            localizacao: 'Ferida',
          )
        : null;

    return AssessmentModel(
      assessmentId: assessment.id,
      ownerId: '', // Será definido no repositório
      patientId: '', // Será definido no repositório
      woundId: assessment.woundId,
      criadoEm: assessment.createdAt,
      atualizadoEm: assessment.updatedAt,
      medidas: medidas,
      tecido: tecido,
      exsudato: exsudato,
      dor: dor,
      observacoes: assessment.notes,
    );
  }

  /// Cria modelo a partir de documento do Firestore
  factory AssessmentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return AssessmentModel(
      assessmentId: doc.id,
      ownerId: data['ownerId'] as String? ?? '',
      patientId: data['patientId'] as String? ?? '',
      woundId: data['woundId'] as String? ?? '',
      criadoEm: (data['criadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
      atualizadoEm:
          (data['atualizadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
      medidas: MedidasFerida.fromJson(
        data['medidas'] as Map<String, dynamic>? ?? {},
      ),
      tecido: TecidoFerida.fromJson(
        data['tecido'] as Map<String, dynamic>? ?? {},
      ),
      exsudato: ExsudatoFerida.fromJson(
        data['exsudato'] as Map<String, dynamic>? ?? {},
      ),
      dor: data['dor'] != null
          ? DorFerida.fromJson(data['dor'] as Map<String, dynamic>)
          : null,
      observacoes: data['observacoes'] as String?,
      images: (data['images'] as List<dynamic>?)?.cast<String>() ?? const [],
      archived: data['archived'] as bool? ?? false,
    );
  }

  /// Converte modelo para entidade de domínio
  Assessment toEntity() {
    return Assessment(
      id: assessmentId,
      woundId: woundId,
      date: criadoEm,
      pain: dor?.intensidade ?? 0,
      lengthCm: medidas.comprimento,
      widthCm: medidas.largura,
      depthCm: medidas.profundidade ?? 0.0,
      createdAt: criadoEm,
      updatedAt: atualizadoEm,
      notes: observacoes,
      exudate: _exudateToString(),
      edgeAppearance: tecido.epitelizacao > 0
          ? 'Epithelialization present'
          : 'No epithelialization',
      woundBed: _tissueToString(),
      periwoundSkin: 'Normal',
      odor: exsudato.odor ? 'Present' : 'Absent',
    );
  }

  /// Converte modelo para mapa do Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'assessmentId': assessmentId,
      'ownerId': ownerId,
      'patientId': patientId,
      'woundId': woundId,
      'criadoEm': Timestamp.fromDate(criadoEm),
      'atualizadoEm': Timestamp.fromDate(atualizadoEm),
      'medidas': medidas.toJson(),
      'tecido': tecido.toJson(),
      'exsudato': exsudato.toJson(),
      'dor': dor?.toJson(),
      'observacoes': observacoes,
      'images': images,
      'archived': archived,
      // Adiciona metadados de acesso
      'acl': {
        'roles': {ownerId: 'owner'},
      },
    };
  }

  String _exudateToString() {
    final parts = <String>[];
    parts.add('Type: ${exsudato.tipo.name}');
    parts.add('Amount: ${exsudato.quantidade.name}');
    parts.add('Aspect: ${exsudato.aspecto.name}');
    return parts.join(', ');
  }

  String _tissueToString() {
    final parts = <String>[];
    if (tecido.granulacao > 0) parts.add('Granulation: ${tecido.granulacao}%');
    if (tecido.fibrina > 0) parts.add('Fibrin: ${tecido.fibrina}%');
    if (tecido.necrose > 0) parts.add('Necrosis: ${tecido.necrose}%');
    return parts.join(', ');
  }

  static ExsudatoTipo _mapExudateType(String? exudate) {
    if (exudate == null) return ExsudatoTipo.seroso;
    final lower = exudate.toLowerCase();
    if (lower.contains('purulent')) return ExsudatoTipo.purulento;
    if (lower.contains('seropurulent')) return ExsudatoTipo.seropurulento;
    if (lower.contains('bloody')) return ExsudatoTipo.sanguinolento;
    return ExsudatoTipo.seroso;
  }

  static ExsudatoQuantidade _mapExudateAmount(String? exudate) {
    if (exudate == null) return ExsudatoQuantidade.ausente;
    final lower = exudate.toLowerCase();
    if (lower.contains('large')) return ExsudatoQuantidade.grande;
    if (lower.contains('moderate')) return ExsudatoQuantidade.moderada;
    if (lower.contains('small')) return ExsudatoQuantidade.pequena;
    return ExsudatoQuantidade.ausente;
  }

  static DorTipo _mapPainType(int intensity) {
    if (intensity == 0) return DorTipo.ausente;
    if (intensity <= 3) return DorTipo.leve;
    if (intensity <= 6) return DorTipo.moderada;
    if (intensity <= 8) return DorTipo.intensa;
    return DorTipo.insuportavel;
  }
}
