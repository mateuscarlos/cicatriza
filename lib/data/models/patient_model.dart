import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/patient.dart';
import '../../domain/value_objects/contato_emergencia.dart';
import '../../domain/value_objects/endereco.dart';
import '../../domain/value_objects/consentimentos.dart';
import '../../domain/value_objects/estado_nutricional.dart';
import '../../domain/value_objects/habitos.dart';
import '../../domain/value_objects/patient_clinical_data.dart';

/// Modelo para serialização/deserialização do Patient no Firestore
/// Utiliza compressão JSON para dados clínicos volumosos
class PatientModel {
  final String id;
  final String ownerId;
  final String pacienteId;
  final String name;
  final String nameLowercase;
  final DateTime birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Consentimentos consentimentos;
  final StatusPaciente status;
  final int versao;

  // Campos básicos opcionais
  final bool archived;
  final String? identificador;
  final String? nomeSocial;
  final int? idade;
  final Sexo? sexo;
  final String? genero;
  final String? cpfOuId;
  final String? email;
  final String? phone;
  final String? notes;

  // Dados clínicos comprimidos como JSON string
  final String? dadosClinicosComprimidos;

  // Metadados de compressão
  final bool usaCompressao;
  final int? versaoEstrutura;

  const PatientModel({
    required this.id,
    required this.ownerId,
    required this.pacienteId,
    required this.name,
    required this.nameLowercase,
    required this.birthDate,
    required this.createdAt,
    required this.updatedAt,
    required this.consentimentos,
    required this.status,
    required this.versao,
    this.archived = false,
    this.identificador,
    this.nomeSocial,
    this.idade,
    this.sexo,
    this.genero,
    this.cpfOuId,
    this.email,
    this.phone,
    this.notes,
    this.dadosClinicosComprimidos,
    this.usaCompressao = false,
    this.versaoEstrutura,
  });

  /// Converte de entidade de domínio para modelo Firestore
  factory PatientModel.fromEntity(Patient patient) {
    // Comprime dados clínicos para JSON se existirem
    String? dadosComprimidos;
    bool usaCompressao = false;

    if (_temDadosClinicosSignificativos(patient)) {
      dadosComprimidos = _comprimirDadosClinicosParaJson({
        'contatoEmergencia': patient.contatoEmergencia?.toJson(),
        'endereco': patient.endereco?.toJson(),
        'estadoNutricional': patient.estadoNutricional?.toJson(),
        'habitos': patient.habitos?.toJson(),
        'alergias': patient.alergias,
        'medicacoesAtuais': patient.medicacoesAtuais
            .map((m) => m.toJson())
            .toList(),
        'comorbidades': patient.comorbidades,
        'cirurgiasPrevias': patient.cirurgiasPrevias
            .map((c) => c.toJson())
            .toList(),
        'vacinas': patient.vacinas.map((v) => v.toJson()).toList(),
        'tags': patient.tags,
      });
      usaCompressao = true;
    }

    return PatientModel(
      id: patient.id,
      ownerId: patient.ownerId,
      pacienteId: patient.pacienteId,
      name: patient.name,
      nameLowercase: patient.nameLowercase,
      birthDate: patient.birthDate,
      createdAt: patient.createdAt,
      updatedAt: patient.updatedAt,
      consentimentos: patient.consentimentos,
      status: patient.status,
      versao: patient.versao,
      archived: patient.archived,
      identificador: patient.identificador,
      nomeSocial: patient.nomeSocial,
      idade: patient.idade,
      sexo: patient.sexo,
      genero: patient.genero,
      cpfOuId: patient.cpfOuId,
      email: patient.email,
      phone: patient.phone,
      notes: patient.notes,
      dadosClinicosComprimidos: dadosComprimidos,
      usaCompressao: usaCompressao,
      versaoEstrutura: 5, // Versão atual da estrutura de dados
    );
  }

  /// Converte modelo Firestore para entidade de domínio
  Patient toEntity() {
    // Descomprime dados clínicos se existirem
    Map<String, dynamic>? dadosDescomprimidos;

    if (dadosClinicosComprimidos != null && usaCompressao) {
      try {
        dadosDescomprimidos = _descomprimirDadosClinicosDeJson(
          dadosClinicosComprimidos!,
        );
      } catch (e) {
        // Log error but continue without clinical data
        print('Erro ao descomprimir dados clínicos para paciente $id: $e');
      }
    }

    return Patient(
      id: id,
      ownerId: ownerId,
      pacienteId: pacienteId,
      name: name,
      nameLowercase: nameLowercase,
      birthDate: birthDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      consentimentos: consentimentos,
      status: status,
      versao: versao,
      archived: archived,
      identificador: identificador,
      nomeSocial: nomeSocial,
      idade: idade,
      sexo: sexo,
      genero: genero,
      cpfOuId: cpfOuId,
      email: email,
      phone: phone,
      notes: notes,

      // Reconstrói dados clínicos a partir dos dados descomprimidos
      contatoEmergencia: dadosDescomprimidos?['contatoEmergencia'] != null
          ? ContatoEmergencia.fromJson(
              dadosDescomprimidos!['contatoEmergencia'] as Map<String, dynamic>,
            )
          : null,
      endereco: dadosDescomprimidos?['endereco'] != null
          ? Endereco.fromJson(
              dadosDescomprimidos!['endereco'] as Map<String, dynamic>,
            )
          : null,
      estadoNutricional: dadosDescomprimidos?['estadoNutricional'] != null
          ? EstadoNutricional.fromJson(
              dadosDescomprimidos!['estadoNutricional'] as Map<String, dynamic>,
            )
          : null,
      habitos: dadosDescomprimidos?['habitos'] != null
          ? Habitos.fromJson(
              dadosDescomprimidos!['habitos'] as Map<String, dynamic>,
            )
          : null,
      alergias: dadosDescomprimidos?['alergias'] != null
          ? List<String>.from(
              dadosDescomprimidos!['alergias'] as Iterable<dynamic>,
            )
          : [],
      medicacoesAtuais: dadosDescomprimidos?['medicacoesAtuais'] != null
          ? (dadosDescomprimidos!['medicacoesAtuais'] as List<dynamic>)
                .map((m) => MedicacaoAtual.fromJson(m as Map<String, dynamic>))
                .toList()
          : [],
      comorbidades: dadosDescomprimidos?['comorbidades'] != null
          ? List<String>.from(
              dadosDescomprimidos!['comorbidades'] as Iterable<dynamic>,
            )
          : [],
      cirurgiasPrevias: dadosDescomprimidos?['cirurgiasPrevias'] != null
          ? (dadosDescomprimidos!['cirurgiasPrevias'] as List<dynamic>)
                .map((c) => CirurgiaPrevias.fromJson(c as Map<String, dynamic>))
                .toList()
          : [],
      vacinas: dadosDescomprimidos?['vacinas'] != null
          ? (dadosDescomprimidos!['vacinas'] as List<dynamic>)
                .map((v) => Vacina.fromJson(v as Map<String, dynamic>))
                .toList()
          : [],
      tags: dadosDescomprimidos?['tags'] != null
          ? List<String>.from(dadosDescomprimidos!['tags'] as Iterable<dynamic>)
          : [],
    );
  }

  /// Converte para Map para serialização no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'pacienteId': pacienteId,
      'name': name,
      'nameLowercase': nameLowercase,
      'birthDate': Timestamp.fromDate(birthDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'consentimentos': consentimentos.toJson(),
      'status': status.name,
      'versao': versao,
      'archived': archived,
      'identificador': identificador,
      'nomeSocial': nomeSocial,
      'idade': idade,
      'sexo': sexo?.name,
      'genero': genero,
      'cpfOuId': cpfOuId,
      'email': email,
      'phone': phone,
      'notes': notes,
      'dadosClinicosComprimidos': dadosClinicosComprimidos,
      'usaCompressao': usaCompressao,
      'versaoEstrutura': versaoEstrutura,
      // Adiciona metadados de acesso
      'acl': {
        'roles': {ownerId: 'owner'},
      },
    };
  }

  /// Cria modelo a partir de documento do Firestore
  factory PatientModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return PatientModel(
      id: doc.id,
      ownerId: data['ownerId'] as String? ?? '',
      pacienteId: data['pacienteId'] as String? ?? doc.id,
      name: data['name'] as String? ?? '',
      nameLowercase: data['nameLowercase'] as String? ?? '',
      birthDate: (data['birthDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      consentimentos: data['consentimentos'] != null
          ? Consentimentos.fromJson(
              data['consentimentos'] as Map<String, dynamic>,
            )
          : Consentimentos.padrao(),
      status: _parseStatusPaciente(data['status']),
      versao: data['versao'] as int? ?? 1,
      archived: data['archived'] as bool? ?? false,
      identificador: data['identificador'] as String?,
      nomeSocial: data['nomeSocial'] as String?,
      idade: data['idade'] as int?,
      sexo: _parseSexo(data['sexo']),
      genero: data['genero'] as String?,
      cpfOuId: data['cpfOuId'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      notes: data['notes'] as String?,
      dadosClinicosComprimidos: data['dadosClinicosComprimidos'] as String?,
      usaCompressao: data['usaCompressao'] as bool? ?? false,
      versaoEstrutura: data['versaoEstrutura'] as int?,
    );
  }

  // Helper methods para compressão/descompressão de dados clínicos
  static bool _temDadosClinicosSignificativos(Patient patient) {
    return patient.contatoEmergencia != null ||
        patient.endereco != null ||
        patient.estadoNutricional != null ||
        patient.habitos != null ||
        patient.alergias.isNotEmpty ||
        patient.medicacoesAtuais.isNotEmpty ||
        patient.comorbidades.isNotEmpty ||
        patient.cirurgiasPrevias.isNotEmpty ||
        patient.vacinas.isNotEmpty ||
        patient.tags.isNotEmpty;
  }

  static String _comprimirDadosClinicosParaJson(Map<String, dynamic> dados) {
    // Remove nulls e listas vazias para otimizar espaço
    final dadosLimpos = <String, dynamic>{};

    dados.forEach((key, value) {
      if (value != null) {
        if (value is List && value.isNotEmpty) {
          dadosLimpos[key] = value;
        } else if (value is! List) {
          dadosLimpos[key] = value;
        }
      }
    });

    return jsonEncode(dadosLimpos);
  }

  static Map<String, dynamic> _descomprimirDadosClinicosDeJson(String json) {
    return jsonDecode(json) as Map<String, dynamic>;
  }

  static Sexo? _parseSexo(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'masculino':
          return Sexo.masculino;
        case 'feminino':
          return Sexo.feminino;
        case 'intersexo':
          return Sexo.intersexo;
        case 'naoinformado':
        case 'nao_informado':
          return Sexo.naoInformado;
        default:
          return null;
      }
    }
    return null;
  }

  static StatusPaciente _parseStatusPaciente(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'ativo':
          return StatusPaciente.ativo;
        case 'inativo':
          return StatusPaciente.inativo;
        case 'transferido':
          return StatusPaciente.transferido;
        default:
          return StatusPaciente.ativo;
      }
    }
    return StatusPaciente.ativo;
  }
}
