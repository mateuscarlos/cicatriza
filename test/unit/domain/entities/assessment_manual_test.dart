import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/assessment_manual.dart';
import 'package:cicatriza/domain/exceptions/domain_exceptions.dart';

void main() {
  group('AssessmentManual Entity - Rich Domain Model', () {
    const validWoundId = 'wound-123';
    final validDate = DateTime.now().subtract(
      const Duration(days: 1),
    ); // Data recente
    const validLength = 5.0;
    const validWidth = 3.0;
    const validDepth = 1.2;
    const validPainScale = 4;
    const validEdgeAppearance = 'Bem definida';
    const validWoundBed = 'Granulação';
    const validExudateType = 'Seroso';
    const validExudateAmount = 'Moderada';

    group('AssessmentManual.create', () {
      test('deve criar avaliação com dados válidos', () {
        final assessment = AssessmentManual.create(
          woundId: validWoundId,
          date: validDate,
          lengthCm: validLength,
          widthCm: validWidth,
          depthCm: validDepth,
          painScale: validPainScale,
          edgeAppearance: validEdgeAppearance,
          woundBed: validWoundBed,
          exudateType: validExudateType,
          exudateAmount: validExudateAmount,
          notes: 'Avaliação de rotina',
        );

        expect(assessment.woundId, equals(validWoundId));
        expect(assessment.date, equals(validDate));
        expect(assessment.lengthCm, equals(validLength));
        expect(assessment.widthCm, equals(validWidth));
        expect(assessment.depthCm, equals(validDepth));
        expect(assessment.painScale, equals(validPainScale));
        expect(assessment.edgeAppearance, equals(validEdgeAppearance));
        expect(assessment.woundBed, equals(validWoundBed));
        expect(assessment.exudateType, equals(validExudateType));
        expect(assessment.exudateAmount, equals(validExudateAmount));
        expect(assessment.notes, equals('Avaliação de rotina'));
      });

      test('deve validar woundId obrigatório', () {
        expect(
          () => AssessmentManual.create(woundId: ''),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar data no futuro', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));

        expect(
          () =>
              AssessmentManual.create(woundId: validWoundId, date: futureDate),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar data muito antiga', () {
        final ancientDate = DateTime.now().subtract(const Duration(days: 400));

        expect(
          () =>
              AssessmentManual.create(woundId: validWoundId, date: ancientDate),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar dimensões inválidas', () {
        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            lengthCm: -1.0, // Negativo
          ),
          throwsA(isA<ValidationException>()),
        );

        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            lengthCm: 150.0, // Muito grande
          ),
          throwsA(isA<ValidationException>()),
        );

        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            depthCm: 60.0, // Profundidade muito grande
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test(
        'deve exigir comprimento quando outras dimensões são informadas',
        () {
          expect(
            () => AssessmentManual.create(
              woundId: validWoundId,
              widthCm: 3.0, // Sem comprimento
            ),
            throwsA(isA<ValidationException>()),
          );
        },
      );

      test('deve validar escala de dor inválida', () {
        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            painScale: 15, // Fora da escala
          ),
          throwsA(isA<ValidationException>()),
        );

        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            painScale: -1, // Negativo
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar opções inválidas', () {
        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            edgeAppearance: 'Opção Inválida',
          ),
          throwsA(isA<ValidationException>()),
        );

        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            woundBed: 'Leito Inválido',
          ),
          throwsA(isA<ValidationException>()),
        );

        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            exudateType: 'Tipo Inválido',
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar regras de exudato', () {
        // Se exudato é ausente, quantidade deve ser ausente
        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            exudateType: 'Ausente',
            exudateAmount: 'Grande',
          ),
          throwsA(isA<ValidationException>()),
        );

        // Se há quantidade mas não há tipo, é inválido
        expect(
          () => AssessmentManual.create(
            woundId: validWoundId,
            exudateAmount: 'Moderada',
          ),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('Rich Domain Behaviors - Calculations', () {
      test('deve calcular área corretamente', () {
        final assessment = AssessmentManual.create(
          woundId: validWoundId,
          lengthCm: 4.0,
          widthCm: 3.0,
        );

        expect(assessment.area, equals(12.0));
      });

      test('deve calcular volume corretamente', () {
        final assessment = AssessmentManual.create(
          woundId: validWoundId,
          lengthCm: 4.0,
          widthCm: 3.0,
          depthCm: 2.0,
        );

        expect(assessment.volume, equals(24.0));
      });

      test(
        'deve retornar null para área/volume quando dimensões não disponíveis',
        () {
          final assessment = AssessmentManual.create(
            woundId: validWoundId,
            lengthCm: 4.0,
            // Sem largura
          );

          expect(assessment.area, isNull);
          expect(assessment.volume, isNull);
        },
      );
    });

    group('Rich Domain Behaviors - Assessment Checks', () {
      test('deve verificar medidas completas', () {
        final completeAssessment = AssessmentManual.create(
          woundId: validWoundId,
          lengthCm: validLength,
          widthCm: validWidth,
          depthCm: validDepth,
        );

        final incompleteAssessment = AssessmentManual.create(
          woundId: validWoundId,
          lengthCm: validLength,
          widthCm: validWidth,
          // Sem profundidade
        );

        expect(completeAssessment.hasCompleteMeasurements, isTrue);
        expect(incompleteAssessment.hasCompleteMeasurements, isFalse);
      });

      test('deve identificar dor significativa e severa', () {
        final noPain = AssessmentManual.create(
          woundId: validWoundId,
          painScale: 2,
        );

        final significantPain = AssessmentManual.create(
          woundId: validWoundId,
          painScale: 5,
        );

        final severePain = AssessmentManual.create(
          woundId: validWoundId,
          painScale: 9,
        );

        expect(noPain.hasSignificantPain, isFalse);
        expect(noPain.hasSeverePain, isFalse);

        expect(significantPain.hasSignificantPain, isTrue);
        expect(significantPain.hasSeverePain, isFalse);

        expect(severePain.hasSignificantPain, isTrue);
        expect(severePain.hasSeverePain, isTrue);
      });

      test('deve verificar presença de exudato', () {
        final noExudate = AssessmentManual.create(
          woundId: validWoundId,
          exudateType: 'Ausente',
        );

        final withExudate = AssessmentManual.create(
          woundId: validWoundId,
          exudateType: 'Seroso',
        );

        expect(noExudate.hasExudate, isFalse);
        expect(withExudate.hasExudate, isTrue);
      });

      test('deve identificar sinais de infecção', () {
        final cleanWound = AssessmentManual.create(
          woundId: validWoundId,
          exudateType: 'Seroso',
        );

        final infectedWound = AssessmentManual.create(
          woundId: validWoundId,
          exudateType: 'Purulento',
        );

        final partiallyInfected = AssessmentManual.create(
          woundId: validWoundId,
          exudateType: 'Seropurulento',
        );

        expect(cleanWound.hasInfectionSigns, isFalse);
        expect(infectedWound.hasInfectionSigns, isTrue);
        expect(partiallyInfected.hasInfectionSigns, isTrue);
      });

      test('deve identificar sinais de cicatrização positiva', () {
        final cleanWound = AssessmentManual.create(
          woundId: validWoundId,
          woundBed: 'Limpo',
        );

        final granulatingWound = AssessmentManual.create(
          woundId: validWoundId,
          woundBed: 'Granulação',
        );

        final necroticWound = AssessmentManual.create(
          woundId: validWoundId,
          woundBed: 'Necrose',
        );

        expect(cleanWound.hasPositiveHealingSigns, isTrue);
        expect(granulatingWound.hasPositiveHealingSigns, isTrue);
        expect(necroticWound.hasPositiveHealingSigns, isFalse);
      });

      test('deve identificar tecido necrótico', () {
        final necroticBed = AssessmentManual.create(
          woundId: validWoundId,
          woundBed: 'Necrose',
        );

        final necroticEdge = AssessmentManual.create(
          woundId: validWoundId,
          edgeAppearance: 'Necrótica',
        );

        final healthyWound = AssessmentManual.create(
          woundId: validWoundId,
          woundBed: 'Limpo',
          edgeAppearance: 'Regular',
        );

        expect(necroticBed.hasNecroticTissue, isTrue);
        expect(necroticEdge.hasNecroticTissue, isTrue);
        expect(healthyWound.hasNecroticTissue, isFalse);
      });
    });

    group('Rich Domain Behaviors - Severity Assessment', () {
      test('deve calcular score de gravidade baixo', () {
        final mildAssessment = AssessmentManual.create(
          woundId: validWoundId,
          painScale: 1,
          woundBed: 'Limpo',
          exudateType: 'Ausente',
        );

        expect(mildAssessment.severityScore, lessThanOrEqualTo(2));
        expect(mildAssessment.severityDescription, equals('Leve'));
      });

      test('deve calcular score de gravidade alto', () {
        final severeAssessment = AssessmentManual.create(
          woundId: validWoundId,
          painScale: 10,
          woundBed: 'Necrose',
          edgeAppearance: 'Necrótica',
          exudateType: 'Purulento',
          exudateAmount: 'Grande',
        );

        expect(severeAssessment.severityScore, greaterThanOrEqualTo(7));
        expect(
          [
            'Grave',
            'Muito Grave',
          ].contains(severeAssessment.severityDescription),
          isTrue,
        );
      });

      test('deve classificar corretamente todos os níveis de gravidade', () {
        expect(
          AssessmentManual.create(
            woundId: validWoundId,
            painScale: 0,
          ).severityDescription,
          equals('Leve'),
        );

        final moderateAssessment = AssessmentManual.create(
          woundId: validWoundId,
          painScale: 5, // Pontos da dor: 2.5 ≈ 3
          exudateType: 'Seroso', // Sem pontos de infecção
        );
        expect(moderateAssessment.severityDescription, equals('Moderada'));
      });
    });

    group('updateInfo', () {
      test('deve atualizar informações com validação', () {
        final assessment = AssessmentManual.create(
          woundId: validWoundId,
          lengthCm: 3.0,
          painScale: 2,
        );

        final updatedAssessment = assessment.updateInfo(
          lengthCm: 4.0,
          widthCm: 2.0,
          painScale: 5,
          notes: 'Avaliação atualizada',
        );

        expect(updatedAssessment.lengthCm, equals(4.0));
        expect(updatedAssessment.widthCm, equals(2.0));
        expect(updatedAssessment.painScale, equals(5));
        expect(updatedAssessment.notes, equals('Avaliação atualizada'));
        expect(
          updatedAssessment.updatedAt.isAtSameMomentAs(assessment.updatedAt) ||
              updatedAssessment.updatedAt.isAfter(assessment.updatedAt),
          isTrue,
        );
      });

      test('deve validar dados na atualização', () {
        final assessment = AssessmentManual.create(woundId: validWoundId);

        expect(
          () => assessment.updateInfo(painScale: 15),
          throwsA(isA<ValidationException>()),
        );

        expect(
          () => assessment.updateInfo(lengthCm: -1.0),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('Summary Generation', () {
      test('deve gerar resumo com medidas completas', () {
        final assessment = AssessmentManual.create(
          woundId: validWoundId,
          lengthCm: 5.0,
          widthCm: 3.0,
          depthCm: 2.0,
          painScale: 4,
          exudateType: 'Seroso',
          exudateAmount: 'Moderada',
        );

        final summary = assessment.summary;

        expect(summary, contains('5.0x3.0x2.0 cm'));
        expect(summary, contains('Dor: 4/10'));
        expect(summary, contains('Exudato: Seroso (Moderada)'));
        expect(summary, contains('Gravidade:'));
      });

      test('deve gerar resumo com área quando sem profundidade', () {
        final assessment = AssessmentManual.create(
          woundId: validWoundId,
          lengthCm: 4.0,
          widthCm: 3.0,
          painScale: 2,
        );

        final summary = assessment.summary;

        expect(summary, contains('4.0x3.0 cm'));
        expect(summary, contains('área: 12.00 cm²'));
        expect(summary, contains('Dor: 2/10'));
      });

      test('deve gerar resumo sem medidas', () {
        final assessment = AssessmentManual.create(
          woundId: validWoundId,
          painScale: 3,
          exudateType: 'Ausente',
        );

        final summary = assessment.summary;

        expect(summary, contains('Sem medidas'));
        expect(summary, contains('Dor: 3/10'));
        expect(summary, contains('Sem exudato'));
      });

      test('deve indicar informação não informada', () {
        final assessment = AssessmentManual.create(woundId: validWoundId);

        final summary = assessment.summary;

        expect(summary, contains('Dor: N/I'));
        expect(summary, contains('Sem exudato'));
      });
    });

    group('Static Options Validation', () {
      test('deve ter listas de opções definidas', () {
        expect(AssessmentManual.painScaleValues, hasLength(11));
        expect(AssessmentManual.painScaleValues.first, equals(0));
        expect(AssessmentManual.painScaleValues.last, equals(10));

        expect(AssessmentManual.edgeAppearanceOptions, isNotEmpty);
        expect(AssessmentManual.woundBedOptions, isNotEmpty);
        expect(AssessmentManual.exudateTypeOptions, isNotEmpty);
        expect(AssessmentManual.exudateAmountOptions, isNotEmpty);

        expect(AssessmentManual.exudateTypeOptions.contains('Ausente'), isTrue);
        expect(
          AssessmentManual.exudateAmountOptions.contains('Ausente'),
          isTrue,
        );
      });
    });
  });
}
