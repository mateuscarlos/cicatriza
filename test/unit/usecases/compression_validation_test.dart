import 'package:flutter_test/flutter_test.dart';

import '../../../lib/domain/usecases/migration/validate_data_compression_use_case_v2.dart';

void main() {
  group('CompressionStats Tests', () {
    test('deve combinar estatísticas de compressão corretamente', () {
      // Arrange
      const stats1 = CompressionStats(
        originalSize: 1000,
        compressedSize: 500,
        compressionRatio: 2.0,
        compressionTime: Duration(milliseconds: 10),
        decompressionTime: Duration(milliseconds: 5),
        patientsWithCompression: 1,
        patientsWithoutCompression: 0,
      );

      const stats2 = CompressionStats(
        originalSize: 2000,
        compressedSize: 800,
        compressionRatio: 2.5,
        compressionTime: Duration(milliseconds: 20),
        decompressionTime: Duration(milliseconds: 10),
        patientsWithCompression: 1,
        patientsWithoutCompression: 1,
      );

      // Act
      final combined = stats1.combine(stats2);

      // Assert
      expect(combined.originalSize, 3000);
      expect(combined.compressedSize, 1300);
      expect(combined.compressionRatio, 2.25); // Média dos ratios
      expect(combined.compressionTime, const Duration(milliseconds: 30));
      expect(combined.decompressionTime, const Duration(milliseconds: 15));
      expect(combined.patientsWithCompression, 2);
      expect(combined.patientsWithoutCompression, 1);
      expect(combined.totalPatients, 3);
    });

    test('deve calcular percentual de economia de espaço corretamente', () {
      // Arrange - Compressão de 4:1 = 75% de economia
      const stats = CompressionStats(
        originalSize: 1000,
        compressedSize: 250,
        compressionRatio: 4.0,
        compressionTime: Duration.zero,
        decompressionTime: Duration.zero,
        patientsWithCompression: 1,
        patientsWithoutCompression: 0,
      );

      // Act & Assert
      expect(stats.spaceSavingsPercent, 75.0);
    });

    test('deve retornar 0% de economia quando não há compressão', () {
      // Arrange
      const stats = CompressionStats(
        originalSize: 1000,
        compressedSize: 1000,
        compressionRatio: 1.0,
        compressionTime: Duration.zero,
        decompressionTime: Duration.zero,
        patientsWithCompression: 0,
        patientsWithoutCompression: 1,
      );

      // Act & Assert
      expect(stats.spaceSavingsPercent, 0.0);
    });

    test('deve calcular razão de compressão média corretamente', () {
      // Arrange
      const stats = CompressionStats(
        originalSize: 3000,
        compressedSize: 1000,
        compressionRatio: 3.0,
        compressionTime: Duration.zero,
        decompressionTime: Duration.zero,
        patientsWithCompression: 2,
        patientsWithoutCompression: 1,
      );

      // Act & Assert
      expect(stats.totalPatients, 3);
      expect(stats.averageCompressionRatio, 3.0);
    });
  });

  group('ValidateCompressionInput Tests', () {
    test('deve ter valores padrão corretos', () {
      // Arrange & Act
      const input = ValidateCompressionInput();

      // Assert
      expect(input.patientIds, isEmpty);
      expect(input.maxPatientsToTest, 10);
      expect(input.validatePerformance, true);
    });

    test('deve aceitar parâmetros customizados', () {
      // Arrange & Act
      const input = ValidateCompressionInput(
        patientIds: ['patient1', 'patient2'],
        maxPatientsToTest: 5,
        validatePerformance: false,
      );

      // Assert
      expect(input.patientIds, ['patient1', 'patient2']);
      expect(input.maxPatientsToTest, 5);
      expect(input.validatePerformance, false);
    });
  });

  group('ValidationStatus Tests', () {
    test('deve ter valores enum corretos', () {
      // Act & Assert
      expect(ValidationStatus.values.length, 3);
      expect(ValidationStatus.values, contains(ValidationStatus.success));
      expect(ValidationStatus.values, contains(ValidationStatus.warning));
      expect(ValidationStatus.values, contains(ValidationStatus.error));
    });
  });

  group('CompressionValidationResult Tests', () {
    test('deve calcular duração total corretamente', () {
      // Arrange
      final result = CompressionValidationResult(
        testedPatients: const <PatientCompressionTest>[],
        compressionStats: const CompressionStats(
          originalSize: 0,
          compressedSize: 0,
          compressionRatio: 1.0,
          compressionTime: Duration.zero,
          decompressionTime: Duration.zero,
          patientsWithCompression: 0,
          patientsWithoutCompression: 0,
        ),
        issues: const <String>[],
        overallResult: ValidationStatus.success,
        startTime: DateTime(2023, 1, 1, 10, 0, 0),
        endTime: DateTime(2023, 1, 1, 10, 0, 5),
      );

      // Act & Assert
      expect(result.totalDuration, const Duration(seconds: 5));
    });

    test('deve retornar null para duração quando endTime é null', () {
      // Arrange
      final result = CompressionValidationResult(
        testedPatients: const <PatientCompressionTest>[],
        compressionStats: const CompressionStats(
          originalSize: 0,
          compressedSize: 0,
          compressionRatio: 1.0,
          compressionTime: Duration.zero,
          decompressionTime: Duration.zero,
          patientsWithCompression: 0,
          patientsWithoutCompression: 0,
        ),
        issues: const <String>[],
        overallResult: ValidationStatus.success,
        startTime: DateTime.now(),
      );

      // Act & Assert
      expect(result.totalDuration, null);
    });

    test('copyWith deve funcionar corretamente', () {
      // Arrange
      final original = CompressionValidationResult(
        testedPatients: const <PatientCompressionTest>[],
        compressionStats: const CompressionStats(
          originalSize: 1000,
          compressedSize: 500,
          compressionRatio: 2.0,
          compressionTime: Duration.zero,
          decompressionTime: Duration.zero,
          patientsWithCompression: 1,
          patientsWithoutCompression: 0,
        ),
        issues: const <String>['issue1'],
        overallResult: ValidationStatus.success,
        startTime: DateTime(2023, 1, 1),
      );

      // Act
      final updated = original.copyWith(
        overallResult: ValidationStatus.error,
        issues: const ['issue1', 'issue2'],
      );

      // Assert
      expect(updated.overallResult, ValidationStatus.error);
      expect(updated.issues, ['issue1', 'issue2']);
      expect(updated.startTime, original.startTime); // Não alterado
      expect(updated.compressionStats.originalSize, 1000); // Não alterado
    });
  });

  group('PatientCompressionTest Tests', () {
    test('deve criar instância com valores corretos', () {
      // Arrange & Act
      const test = PatientCompressionTest(
        patientId: 'patient123',
        patientName: 'João Silva',
        hasSignificantData: true,
        compressionStats: CompressionStats(
          originalSize: 500,
          compressedSize: 250,
          compressionRatio: 2.0,
          compressionTime: Duration(milliseconds: 10),
          decompressionTime: Duration(milliseconds: 5),
          patientsWithCompression: 1,
          patientsWithoutCompression: 0,
        ),
        issues: <String>['warning1'],
        success: false,
        testDuration: Duration(milliseconds: 100),
      );

      // Assert
      expect(test.patientId, 'patient123');
      expect(test.patientName, 'João Silva');
      expect(test.hasSignificantData, true);
      expect(test.success, false);
      expect(test.issues, ['warning1']);
      expect(test.testDuration, const Duration(milliseconds: 100));
      expect(test.compressionStats.compressionRatio, 2.0);
    });
  });

  group('CompressionCycleResult Tests', () {
    test('deve criar resultado de sucesso corretamente', () {
      // Arrange & Act
      const result = CompressionCycleResult(
        success: true,
        compressedSize: 250,
        compressionTime: Duration(milliseconds: 10),
        decompressionTime: Duration(milliseconds: 5),
        decompressedPatient: null,
      );

      // Assert
      expect(result.success, true);
      expect(result.error, null);
      expect(result.compressedSize, 250);
      expect(result.compressionTime, const Duration(milliseconds: 10));
      expect(result.decompressionTime, const Duration(milliseconds: 5));
    });

    test('deve criar resultado de erro corretamente', () {
      // Arrange & Act
      const result = CompressionCycleResult(
        success: false,
        error: 'Erro de teste',
        compressedSize: 0,
        compressionTime: Duration.zero,
        decompressionTime: Duration.zero,
        decompressedPatient: null,
      );

      // Assert
      expect(result.success, false);
      expect(result.error, 'Erro de teste');
      expect(result.compressedSize, 0);
    });
  });

  group('DataIntegrityResult Tests', () {
    test('deve criar resultado de sucesso', () {
      // Arrange & Act
      const result = DataIntegrityResult(success: true, issues: <String>[]);

      // Assert
      expect(result.success, true);
      expect(result.issues, isEmpty);
    });

    test('deve criar resultado com problemas', () {
      // Arrange & Act
      const result = DataIntegrityResult(
        success: false,
        issues: ['Problema 1', 'Problema 2'],
      );

      // Assert
      expect(result.success, false);
      expect(result.issues, ['Problema 1', 'Problema 2']);
    });
  });
}
