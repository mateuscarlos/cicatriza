import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/wound.dart';

/// Modelo para serialização/deserialização do Wound no Firestore
/// Segue o padrão de estrutura de dados compatível com o PatientModel
///
/// **Padrão de serialização:**
/// - Models: Classe normal + toFirestore/fromFirestore + metadados ACL
/// - Enums: Conversão manual string/enum para compatibilidade
class WoundModel {
  final String feridaId;
  final String ownerId;
  final String patientId;
  final WoundType type;
  final String localizacao;
  final WoundStatus status;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  // Campos opcionais
  final DateTime? inicio;
  final String? etiologia;
  final DateTime? ultimaAvaliacaoEm;
  final int contagemAvaliacoes;
  final String? notes;
  final bool archived;

  const WoundModel({
    required this.feridaId,
    required this.ownerId,
    required this.patientId,
    required this.type,
    required this.localizacao,
    required this.status,
    required this.criadoEm,
    required this.atualizadoEm,
    this.inicio,
    this.etiologia,
    this.ultimaAvaliacaoEm,
    this.contagemAvaliacoes = 0,
    this.notes,
    this.archived = false,
  });

  /// Converte de entidade de domínio para modelo Firestore
  factory WoundModel.fromEntity(Wound wound) {
    return WoundModel(
      feridaId: wound.feridaId,
      ownerId: wound.ownerId,
      patientId: wound.patientId,
      type: wound.type,
      localizacao: wound.localizacao,
      status: wound.status,
      criadoEm: wound.criadoEm,
      atualizadoEm: wound.atualizadoEm,
      inicio: wound.inicio,
      etiologia: wound.etiologia,
      ultimaAvaliacaoEm: wound.ultimaAvaliacaoEm,
      contagemAvaliacoes: wound.contagemAvaliacoes,
      notes: wound.notes,
      archived: wound.archived,
    );
  }

  /// Converte modelo Firestore para entidade de domínio
  Wound toEntity() {
    return Wound(
      feridaId: feridaId,
      ownerId: ownerId,
      patientId: patientId,
      type: type,
      localizacao: localizacao,
      status: status,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm,
      inicio: inicio,
      etiologia: etiologia,
      ultimaAvaliacaoEm: ultimaAvaliacaoEm,
      contagemAvaliacoes: contagemAvaliacoes,
      notes: notes,
      archived: archived,
    );
  }

  /// Converte para Map para serialização no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'patientId': patientId,
      'feridaId': feridaId,
      'type': type.name,
      'localizacao': localizacao,
      'status': status.name,
      'criadoEm': Timestamp.fromDate(criadoEm),
      'atualizadoEm': Timestamp.fromDate(atualizadoEm),
      'inicio': inicio != null ? Timestamp.fromDate(inicio!) : null,
      'etiologia': etiologia,
      'ultimaAvaliacaoEm': ultimaAvaliacaoEm != null
          ? Timestamp.fromDate(ultimaAvaliacaoEm!)
          : null,
      'contagemAvaliacoes': contagemAvaliacoes,
      'notes': notes,
      'archived': archived,
      // Adiciona metadados de acesso
      'acl': {
        'roles': {ownerId: 'owner'},
      },
    };
  }

  /// Cria modelo a partir de documento do Firestore
  factory WoundModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    return WoundModel(
      feridaId: data['feridaId'] as String? ?? doc.id,
      ownerId: data['ownerId'] as String? ?? '',
      patientId: data['patientId'] as String? ?? '',
      type: _parseWoundType(data['type']),
      localizacao: data['localizacao'] as String? ?? '',
      status: _parseWoundStatus(data['status']),
      criadoEm: (data['criadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
      atualizadoEm:
          (data['atualizadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
      inicio: (data['inicio'] as Timestamp?)?.toDate(),
      etiologia: data['etiologia'] as String?,
      ultimaAvaliacaoEm: (data['ultimaAvaliacaoEm'] as Timestamp?)?.toDate(),
      contagemAvaliacoes: data['contagemAvaliacoes'] as int? ?? 0,
      notes: data['notes'] as String?,
      archived: data['archived'] as bool? ?? false,
    );
  }

  static WoundType _parseWoundType(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'ulcerapressao':
          return WoundType.ulceraPressao;
        case 'ulceravenosa':
          return WoundType.ulceraVenosa;
        case 'ulceraarterial':
          return WoundType.ulceraArterial;
        case 'pediabetico':
          return WoundType.peDiabetico;
        case 'queimadura':
          return WoundType.queimadura;
        case 'feridacirurgica':
          return WoundType.feridaCirurgica;
        case 'traumatica':
          return WoundType.traumatica;
        case 'outras':
          return WoundType.outras;
        default:
          return WoundType.outras;
      }
    }
    return WoundType.outras;
  }

  static WoundStatus _parseWoundStatus(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'ativa':
          return WoundStatus.ativa;
        case 'emcicatrizacao':
          return WoundStatus.emCicatrizacao;
        case 'cicatrizada':
          return WoundStatus.cicatrizada;
        case 'infectada':
          return WoundStatus.infectada;
        case 'complicada':
          return WoundStatus.complicada;
        default:
          return WoundStatus.ativa;
      }
    }
    return WoundStatus.ativa;
  }
}
