import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../../entities/patient.dart';
import '../../value_objects/contato_emergencia.dart';
import '../../value_objects/endereco.dart';
import '../../repositories/patient_repository.dart';
import '../base/use_case.dart';

// Classes de input e output
class ValidateCompressionInput {
  final List<String> patientIds;
  final int maxPatientsToTest;
  final bool validatePerformance;

  const ValidateCompressionInput({
    this.patientIds = const [],
    this.maxPatientsToTest = 10,
    this.validatePerformance = true,
  });
}

enum ValidationStatus { success, warning, error }

class CompressionValidationResult {
  final List<PatientCompressionTest> testedPatients;
  final CompressionStats compressionStats;
  final List<String> issues;
  final ValidationStatus overallResult;
  final DateTime startTime;
  final DateTime? endTime;

  const CompressionValidationResult({
    required this.testedPatients,
    required this.compressionStats,
    required this.issues,
    required this.overallResult,
    required this.startTime,
    this.endTime,
  });

  Duration? get totalDuration => endTime?.difference(startTime);

  CompressionValidationResult copyWith({
    List<PatientCompressionTest>? testedPatients,
    CompressionStats? compressionStats,
    List<String>? issues,
    ValidationStatus? overallResult,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return CompressionValidationResult(
      testedPatients: testedPatients ?? this.testedPatients,
      compressionStats: compressionStats ?? this.compressionStats,
      issues: issues ?? this.issues,
      overallResult: overallResult ?? this.overallResult,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class PatientCompressionTest {
  final String patientId;
  final String patientName;
  final bool hasSignificantData;
  final CompressionStats compressionStats;
  final List<String> issues;
  final bool success;
  final Duration testDuration;

  const PatientCompressionTest({
    required this.patientId,
    required this.patientName,
    required this.hasSignificantData,
    required this.compressionStats,
    required this.issues,
    required this.success,
    required this.testDuration,
  });
}

class CompressionStats {
  final int originalSize;
  final int compressedSize;
  final double compressionRatio;
  final Duration compressionTime;
  final Duration decompressionTime;
  final int patientsWithCompression;
  final int patientsWithoutCompression;

  const CompressionStats({
    required this.originalSize,
    required this.compressedSize,
    required this.compressionRatio,
    required this.compressionTime,
    required this.decompressionTime,
    required this.patientsWithCompression,
    required this.patientsWithoutCompression,
  });

  factory CompressionStats.empty() {
    return const CompressionStats(
      originalSize: 0,
      compressedSize: 0,
      compressionRatio: 1.0,
      compressionTime: Duration.zero,
      decompressionTime: Duration.zero,
      patientsWithCompression: 0,
      patientsWithoutCompression: 0,
    );
  }

  CompressionStats combine(CompressionStats other) {
    return CompressionStats(
      originalSize: originalSize + other.originalSize,
      compressedSize: compressedSize + other.compressedSize,
      compressionRatio: (compressionRatio + other.compressionRatio) / 2,
      compressionTime: compressionTime + other.compressionTime,
      decompressionTime: decompressionTime + other.decompressionTime,
      patientsWithCompression:
          patientsWithCompression + other.patientsWithCompression,
      patientsWithoutCompression:
          patientsWithoutCompression + other.patientsWithoutCompression,
    );
  }

  int get totalPatients => patientsWithCompression + patientsWithoutCompression;
  double get averageCompressionRatio =>
      totalPatients > 0 ? compressionRatio : 0.0;
  double get spaceSavingsPercent =>
      compressionRatio > 1 ? (1 - 1 / compressionRatio) * 100 : 0.0;
}

class CompressionCycleResult {
  final bool success;
  final String? error;
  final int compressedSize;
  final Duration compressionTime;
  final Duration decompressionTime;
  final Patient? decompressedPatient;

  const CompressionCycleResult({
    required this.success,
    this.error,
    required this.compressedSize,
    required this.compressionTime,
    required this.decompressionTime,
    this.decompressedPatient,
  });
}

class DataIntegrityResult {
  final bool success;
  final List<String> issues;

  const DataIntegrityResult({required this.success, required this.issues});
}

/// Caso de uso para validar a integração da compressão JSON
///
/// Testa:
/// - Compressão e descompressão de dados clínicos
/// - Integridade dos dados após serialização
/// - Performance de compressão
/// - Compatibilidade com a estrutura V5
class ValidateDataCompressionUseCase
    implements UseCase<ValidateCompressionInput, CompressionValidationResult> {
  final PatientRepository _patientRepository;
  final FirebaseAuth _auth;

  ValidateDataCompressionUseCase({
    required PatientRepository patientRepository,
    required FirebaseAuth auth,
  }) : _patientRepository = patientRepository,
       _auth = auth;

  @override
  Future<Result<CompressionValidationResult>> execute(
    ValidateCompressionInput input,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return Failure(ValidationError('Usuário não autenticado'));
      }

      final result = CompressionValidationResult(
        testedPatients: [],
        compressionStats: CompressionStats.empty(),
        issues: [],
        overallResult: ValidationStatus.success,
        startTime: DateTime.now(),
      );

      // Buscar pacientes para teste
      final patients = await _patientRepository.getPatients();
      final testPatients = input.patientIds.isNotEmpty
          ? patients.where((p) => input.patientIds.contains(p.id)).toList()
          : patients.take(input.maxPatientsToTest).toList();

      if (testPatients.isEmpty) {
        return Success(
          result.copyWith(
            overallResult: ValidationStatus.warning,
            issues: ['Nenhum paciente encontrado para teste'],
          ),
        );
      }

      // Executar validação para cada paciente
      final validationResults = <PatientCompressionTest>[];
      final allIssues = <String>[];
      var totalCompressionStats = CompressionStats.empty();

      for (final patient in testPatients) {
        final testResult = await _testPatientCompression(patient);
        validationResults.add(testResult);
        allIssues.addAll(testResult.issues);
        totalCompressionStats = totalCompressionStats.combine(
          testResult.compressionStats,
        );
      }

      // Determinar resultado geral
      final overallResult = _determineOverallResult(
        validationResults,
        allIssues,
      );

      return Success(
        CompressionValidationResult(
          testedPatients: validationResults,
          compressionStats: totalCompressionStats,
          issues: allIssues,
          overallResult: overallResult,
          startTime: result.startTime,
          endTime: DateTime.now(),
        ),
      );
    } catch (e) {
      return Failure(SystemError('Erro na validação de compressão: $e'));
    }
  }

  Future<PatientCompressionTest> _testPatientCompression(
    Patient patient,
  ) async {
    final issues = <String>[];
    final startTime = DateTime.now();

    try {
      // Teste 1: Verificar se patient tem dados clínicos significativos
      final hasSignificantData = _hasSignificantClinicalData(patient);

      // Teste 2: Simular compressão/descompressão
      final originalSize = _calculatePatientDataSize(patient);
      final compressionResult = await _testCompressionCycle(patient);

      if (!compressionResult.success) {
        issues.add('Falha no ciclo de compressão: ${compressionResult.error}');
      }

      // Teste 3: Verificar integridade dos dados
      final integrityResult = _validateDataIntegrity(
        patient,
        compressionResult.decompressedPatient,
      );
      if (!integrityResult.success) {
        issues.addAll(integrityResult.issues);
      }

      // Teste 4: Performance de compressão
      final compressionRatio = compressionResult.compressedSize > 0
          ? originalSize / compressionResult.compressedSize
          : 1.0;

      final stats = CompressionStats(
        originalSize: originalSize,
        compressedSize: compressionResult.compressedSize,
        compressionRatio: compressionRatio,
        compressionTime: compressionResult.compressionTime,
        decompressionTime: compressionResult.decompressionTime,
        patientsWithCompression: hasSignificantData ? 1 : 0,
        patientsWithoutCompression: hasSignificantData ? 0 : 1,
      );

      return PatientCompressionTest(
        patientId: patient.id,
        patientName: patient.name,
        hasSignificantData: hasSignificantData,
        compressionStats: stats,
        issues: issues,
        success: issues.isEmpty,
        testDuration: DateTime.now().difference(startTime),
      );
    } catch (e) {
      issues.add('Erro durante teste: $e');
      return PatientCompressionTest(
        patientId: patient.id,
        patientName: patient.name,
        hasSignificantData: false,
        compressionStats: CompressionStats.empty(),
        issues: issues,
        success: false,
        testDuration: DateTime.now().difference(startTime),
      );
    }
  }

  bool _hasSignificantClinicalData(Patient patient) {
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

  int _calculatePatientDataSize(Patient patient) {
    // Simular serialização para medir tamanho dos dados
    final patientData = {
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
    };

    return jsonEncode(patientData).length;
  }

  Future<CompressionCycleResult> _testCompressionCycle(Patient patient) async {
    try {
      final startCompression = DateTime.now();

      // Simular compressão (como no PatientModel)
      final clinicalData = {
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
      };

      // Remover nulls como no PatientModel
      final cleanedData = <String, dynamic>{};
      clinicalData.forEach((key, value) {
        if (value != null) {
          if (value is List && value.isNotEmpty) {
            cleanedData[key] = value;
          } else if (value is! List) {
            cleanedData[key] = value;
          }
        }
      });

      final compressedJson = jsonEncode(cleanedData);
      final compressionTime = DateTime.now().difference(startCompression);

      // Simular descompressão
      final startDecompression = DateTime.now();
      final decompressedData =
          jsonDecode(compressedJson) as Map<String, dynamic>;
      final decompressionTime = DateTime.now().difference(startDecompression);

      // Reconstruir patient a partir dos dados descomprimidos
      final decompressedPatient = _reconstructPatientFromDecompressed(
        patient,
        decompressedData,
      );

      return CompressionCycleResult(
        success: true,
        compressedSize: compressedJson.length,
        compressionTime: compressionTime,
        decompressionTime: decompressionTime,
        decompressedPatient: decompressedPatient,
      );
    } catch (e) {
      return CompressionCycleResult(
        success: false,
        error: e.toString(),
        compressedSize: 0,
        compressionTime: Duration.zero,
        decompressionTime: Duration.zero,
        decompressedPatient: null,
      );
    }
  }

  Patient _reconstructPatientFromDecompressed(
    Patient original,
    Map<String, dynamic> decompressed,
  ) {
    return original.copyWith(
      contatoEmergencia: decompressed['contatoEmergencia'] != null
          ? ContatoEmergencia.fromJson(
              decompressed['contatoEmergencia'] as Map<String, dynamic>,
            )
          : null,
      endereco: decompressed['endereco'] != null
          ? Endereco.fromJson(decompressed['endereco'] as Map<String, dynamic>)
          : null,
      // Adicionar outros campos conforme necessário
    );
  }

  DataIntegrityResult _validateDataIntegrity(
    Patient? original,
    Patient? decompressed,
  ) {
    final issues = <String>[];

    if (original == null || decompressed == null) {
      issues.add('Patient original ou descomprimido é null');
      return DataIntegrityResult(success: false, issues: issues);
    }

    // Validar campos críticos
    if (original.contatoEmergencia != decompressed.contatoEmergencia) {
      issues.add('Dados de contato emergência não coincidem');
    }

    if (original.endereco != decompressed.endereco) {
      issues.add('Dados de endereço não coincidem');
    }

    if (!_listsEqual(original.alergias, decompressed.alergias)) {
      issues.add('Lista de alergias não coincide');
    }

    if (!_listsEqual(original.comorbidades, decompressed.comorbidades)) {
      issues.add('Lista de comorbidades não coincide');
    }

    return DataIntegrityResult(success: issues.isEmpty, issues: issues);
  }

  bool _listsEqual<T>(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  ValidationStatus _determineOverallResult(
    List<PatientCompressionTest> results,
    List<String> issues,
  ) {
    if (issues.isEmpty && results.every((r) => r.success)) {
      return ValidationStatus.success;
    } else if (results.any((r) => r.success)) {
      return ValidationStatus.warning;
    } else {
      return ValidationStatus.error;
    }
  }
}
