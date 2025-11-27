import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/assessment.dart';

/// Modelo simplificado para serialização/deserialização do Assessment no Firestore
/// Compatível com a estrutura de Assessment existente mas usando hierarquia V5
class AssessmentModel {
  final String assessmentId;
  final String ownerId;
  final String patientId;
  final String woundId;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final int pain;
  final double lengthCm;
  final double widthCm;
  final double depthCm;
  final String? observacoes;
  final String? exudate;
  final String? edgeAppearance;
  final String? woundBed;
  final String? periwoundSkin;
  final String? odor;
  final String? treatmentPlan;
  final bool archived;

  const AssessmentModel({
    required this.assessmentId,
    required this.ownerId,
    required this.patientId,
    required this.woundId,
    required this.criadoEm,
    required this.atualizadoEm,
    required this.pain,
    required this.lengthCm,
    required this.widthCm,
    required this.depthCm,
    this.observacoes,
    this.exudate,
    this.edgeAppearance,
    this.woundBed,
    this.periwoundSkin,
    this.odor,
    this.treatmentPlan,
    this.archived = false,
  });

  /// Converte de entidade de domínio para modelo Firestore
  factory AssessmentModel.fromEntity(Assessment assessment) {
    return AssessmentModel(
      assessmentId: assessment.id,
      ownerId: '', // Será definido no repositório
      patientId: '', // Será inferido do woundId no repositório
      woundId: assessment.woundId,
      criadoEm: assessment.createdAt,
      atualizadoEm: assessment.updatedAt,
      pain: assessment.pain,
      lengthCm: assessment.lengthCm,
      widthCm: assessment.widthCm,
      depthCm: assessment.depthCm,
      observacoes: assessment.notes,
      exudate: assessment.exudate,
      edgeAppearance: assessment.edgeAppearance,
      woundBed: assessment.woundBed,
      periwoundSkin: assessment.periwoundSkin,
      odor: assessment.odor,
      treatmentPlan: assessment.treatmentPlan,
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
      criadoEm:
          (data['criadoEm'] as Timestamp?)?.toDate() ??
          (data['date'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      atualizadoEm:
          (data['atualizadoEm'] as Timestamp?)?.toDate() ??
          (data['updatedAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      pain: data['pain'] as int? ?? 0,
      lengthCm: (data['lengthCm'] as num?)?.toDouble() ?? 0.0,
      widthCm: (data['widthCm'] as num?)?.toDouble() ?? 0.0,
      depthCm: (data['depthCm'] as num?)?.toDouble() ?? 0.0,
      observacoes: data['observacoes'] as String? ?? data['notes'] as String?,
      exudate: data['exudate'] as String?,
      edgeAppearance: data['edgeAppearance'] as String?,
      woundBed: data['woundBed'] as String?,
      periwoundSkin: data['periwoundSkin'] as String?,
      odor: data['odor'] as String?,
      treatmentPlan: data['treatmentPlan'] as String?,
      archived: data['archived'] as bool? ?? false,
    );
  }

  /// Converte modelo para entidade de domínio
  Assessment toEntity() {
    return Assessment(
      id: assessmentId,
      woundId: woundId,
      date: criadoEm,
      pain: pain,
      lengthCm: lengthCm,
      widthCm: widthCm,
      depthCm: depthCm,
      createdAt: criadoEm,
      updatedAt: atualizadoEm,
      notes: observacoes,
      exudate: exudate,
      edgeAppearance: edgeAppearance,
      woundBed: woundBed,
      periwoundSkin: periwoundSkin,
      odor: odor,
      treatmentPlan: treatmentPlan,
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
      'pain': pain,
      'lengthCm': lengthCm,
      'widthCm': widthCm,
      'depthCm': depthCm,
      'observacoes': observacoes,
      'exudate': exudate,
      'edgeAppearance': edgeAppearance,
      'woundBed': woundBed,
      'periwoundSkin': periwoundSkin,
      'odor': odor,
      'treatmentPlan': treatmentPlan,
      'archived': archived,
    };
  }
}
