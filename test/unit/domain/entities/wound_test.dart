import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/wound.dart';
import 'package:cicatriza/domain/exceptions/domain_exceptions.dart';

void main() {
  group('Wound Entity - Rich Domain Model', () {
    const validPatientId = 'patient-123';
    const validDescription = 'Ferida cirúrgica pós-operatória';
    const validType = WoundType.feridaCirurgica;
    const validLocation = WoundLocation.abdomen;
    final validIdentificationDate = DateTime(2024, 1, 15);

    group('Wound.create', () {
      test('deve criar ferida com dados válidos', () {
        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
          identificationDate: validIdentificationDate,
          notes: 'Ferida limpa, sem sinais de infecção',
        );

        expect(wound.patientId, equals(validPatientId));
        expect(wound.description, equals(validDescription));
        expect(wound.type, equals(validType));
        expect(wound.location, equals(validLocation));
        expect(wound.status, equals(WoundStatus.ativa));
        expect(wound.identificationDate, equals(validIdentificationDate));
        expect(wound.notes, equals('Ferida limpa, sem sinais de infecção'));
        expect(wound.archived, isFalse);
      });

      test('deve validar patientId obrigatório', () {
        expect(
          () => Wound.create(
            patientId: '',
            description: validDescription,
            type: validType,
            location: validLocation,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar descrição obrigatória', () {
        expect(
          () => Wound.create(
            patientId: validPatientId,
            description: '',
            type: validType,
            location: validLocation,
          ),
          throwsA(isA<ValidationException>()),
        );

        expect(
          () => Wound.create(
            patientId: validPatientId,
            description: 'AB', // Muito curta
            type: validType,
            location: validLocation,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar descrição muito longa', () {
        final longDescription = 'A' * 501; // 501 caracteres

        expect(
          () => Wound.create(
            patientId: validPatientId,
            description: longDescription,
            type: validType,
            location: validLocation,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar data de identificação no futuro', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));

        expect(
          () => Wound.create(
            patientId: validPatientId,
            description: validDescription,
            type: validType,
            location: validLocation,
            identificationDate: futureDate,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar data de identificação muito antiga', () {
        final ancientDate = DateTime.now().subtract(
          const Duration(days: 365 * 11),
        );

        expect(
          () => Wound.create(
            patientId: validPatientId,
            description: validDescription,
            type: validType,
            location: validLocation,
            identificationDate: ancientDate,
          ),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('Rich Domain Behaviors - Time Calculations', () {
      test('deve calcular dias desde identificação', () {
        final identificationDate = DateTime.now().subtract(
          const Duration(days: 15),
        );
        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
          identificationDate: identificationDate,
        );

        expect(wound.daysSinceIdentification, equals(15));
      });

      test('deve calcular dias desde cicatrização', () {
        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        );

        // Sem data de cicatrização
        expect(wound.daysSinceHealed, isNull);

        // Com data de cicatrização
        final healedDate = DateTime.now().subtract(const Duration(days: 5));
        final healedWound = wound.copyWith(healedDate: healedDate);
        expect(healedWound.daysSinceHealed, equals(5));
      });

      test('deve calcular duração da cicatrização', () {
        final identificationDate = DateTime.now().subtract(
          const Duration(days: 30),
        );
        final healedDate = DateTime.now().subtract(
          const Duration(days: 10),
        ); // Cicatrizada há 10 dias

        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
          identificationDate: identificationDate,
        );

        // Sem cicatrização
        expect(wound.healingDurationInDays, isNull);

        // Com cicatrização (levou 20 dias para cicatrizar)
        final healedWound = wound.copyWith(healedDate: healedDate);
        expect(healedWound.healingDurationInDays, equals(20));
      });
    });

    group('Rich Domain Behaviors - Wound Classification', () {
      test('deve identificar ferida crônica', () {
        final recentWound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
          identificationDate: DateTime.now().subtract(const Duration(days: 15)),
        );

        final chronicWound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
          identificationDate: DateTime.now().subtract(const Duration(days: 45)),
        );

        expect(recentWound.isChronicWound, isFalse);
        expect(chronicWound.isChronicWound, isTrue);
      });

      test('deve verificar se ferida está ativa', () {
        final activeWound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        );

        expect(activeWound.isActive, isTrue);

        final healedWound = activeWound.copyWith(
          status: WoundStatus.cicatrizada,
        );
        expect(healedWound.isActive, isFalse);
      });

      test('deve verificar se ferida requer cuidado urgente', () {
        // Ferida normal não requer
        final normalWound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: WoundType.feridaCirurgica,
          location: validLocation,
        );
        expect(normalWound.requiresUrgentCare, isFalse);

        // Ferida infectada requer
        final infectedWound = normalWound.copyWith(
          status: WoundStatus.infectada,
        );
        expect(infectedWound.requiresUrgentCare, isTrue);

        // Ferida de monitoramento especial antiga requer
        final diabeticWound = Wound.create(
          patientId: validPatientId,
          description: 'Úlcera diabética',
          type: WoundType.peDiabetico,
          location: WoundLocation.pes,
          identificationDate: DateTime.now().subtract(const Duration(days: 20)),
        );
        expect(diabeticWound.requiresUrgentCare, isTrue);
      });

      test('deve verificar progresso da ferida', () {
        final activeWound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        );

        expect(activeWound.isProgressing, isFalse);

        final healingWound = activeWound.copyWith(
          status: WoundStatus.emCicatrizacao,
        );
        expect(healingWound.isProgressing, isTrue);

        final healedWound = activeWound.copyWith(
          status: WoundStatus.cicatrizada,
        );
        expect(healedWound.isProgressing, isTrue);
      });
    });

    group('Rich Domain Behaviors - Risk Assessment', () {
      test('deve calcular nível de risco baixo', () {
        final lowRiskWound = Wound.create(
          patientId: validPatientId,
          description: 'Ferida cirúrgica simples',
          type: WoundType.feridaCirurgica,
          location: WoundLocation.bracos,
          identificationDate: DateTime.now().subtract(const Duration(days: 5)),
        );

        expect(lowRiskWound.riskLevel, equals(1));
        expect(lowRiskWound.riskDescription, equals('Baixo risco'));
      });

      test('deve calcular nível de risco alto', () {
        final highRiskWound = Wound.create(
          patientId: validPatientId,
          description: 'Úlcera por pressão no sacro',
          type: WoundType.ulceraPressao, // Cicatrização lenta
          location: WoundLocation.sacro, // Alto risco infecção + pressão
          identificationDate: DateTime.now().subtract(
            const Duration(days: 45),
          ), // Crônica
        );

        final infectedHighRiskWound = highRiskWound.copyWith(
          status: WoundStatus.infectada,
        );

        expect(infectedHighRiskWound.riskLevel, equals(5));
        expect(infectedHighRiskWound.riskDescription, equals('Alto risco'));
      });
    });

    group('Enum Behaviors - WoundType', () {
      test('deve identificar tipos com cicatrização lenta', () {
        expect(WoundType.ulceraPressao.hasSlowHealingTendency, isTrue);
        expect(WoundType.ulceraVenosa.hasSlowHealingTendency, isTrue);
        expect(WoundType.peDiabetico.hasSlowHealingTendency, isTrue);
        expect(WoundType.feridaCirurgica.hasSlowHealingTendency, isFalse);
        expect(WoundType.traumatica.hasSlowHealingTendency, isFalse);
      });

      test('deve identificar tipos que requerem monitoramento especial', () {
        expect(WoundType.peDiabetico.requiresSpecialMonitoring, isTrue);
        expect(WoundType.queimadura.requiresSpecialMonitoring, isTrue);
        expect(WoundType.ulceraArterial.requiresSpecialMonitoring, isTrue);
        expect(WoundType.ulceraPressao.requiresSpecialMonitoring, isFalse);
      });
    });

    group('Enum Behaviors - WoundLocation', () {
      test('deve identificar localizações de alto risco para infecção', () {
        expect(WoundLocation.genitais.isHighRiskForInfection, isTrue);
        expect(WoundLocation.abdomen.isHighRiskForInfection, isTrue);
        expect(WoundLocation.sacro.isHighRiskForInfection, isTrue);
        expect(WoundLocation.bracos.isHighRiskForInfection, isFalse);
      });

      test('deve identificar localizações suscetíveis à pressão', () {
        expect(WoundLocation.sacro.isPressureProne, isTrue);
        expect(WoundLocation.calcanhares.isPressureProne, isTrue);
        expect(WoundLocation.quadrisNadegas.isPressureProne, isTrue);
        expect(WoundLocation.bracos.isPressureProne, isFalse);
      });
    });

    group('Enum Behaviors - WoundStatus', () {
      test('deve identificar status que permitem novas avaliações', () {
        expect(WoundStatus.ativa.allowsNewAssessments, isTrue);
        expect(WoundStatus.emCicatrizacao.allowsNewAssessments, isTrue);
        expect(WoundStatus.infectada.allowsNewAssessments, isTrue);
        expect(WoundStatus.cicatrizada.allowsNewAssessments, isFalse);
      });

      test('deve identificar status que requerem atenção urgente', () {
        expect(WoundStatus.infectada.requiresUrgentAttention, isTrue);
        expect(WoundStatus.complicada.requiresUrgentAttention, isTrue);
        expect(WoundStatus.ativa.requiresUrgentAttention, isFalse);
        expect(WoundStatus.emCicatrizacao.requiresUrgentAttention, isFalse);
      });

      test('deve identificar status de progresso positivo', () {
        expect(WoundStatus.emCicatrizacao.isPositiveProgress, isTrue);
        expect(WoundStatus.cicatrizada.isPositiveProgress, isTrue);
        expect(WoundStatus.ativa.isPositiveProgress, isFalse);
        expect(WoundStatus.infectada.isPositiveProgress, isFalse);
      });
    });

    group('updateStatus', () {
      test('deve atualizar status com validação de transição', () {
        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        );

        // Transição válida: ativa → em cicatrização
        final healingWound = wound.updateStatus(WoundStatus.emCicatrizacao);
        expect(healingWound.status, equals(WoundStatus.emCicatrizacao));
        expect(
          healingWound.updatedAt.isAfter(wound.updatedAt) ||
              healingWound.updatedAt.isAtSameMomentAs(wound.updatedAt),
          isTrue,
        );
      });

      test('deve definir data de cicatrização automaticamente', () {
        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        );

        final healedWound = wound.updateStatus(WoundStatus.cicatrizada);
        expect(healedWound.status, equals(WoundStatus.cicatrizada));
        expect(healedWound.healedDate, isNotNull);
      });

      test('deve validar transições inválidas', () {
        final healedWound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        ).copyWith(status: WoundStatus.cicatrizada);

        // Ferida cicatrizada só pode voltar para ativa
        expect(
          () => healedWound.updateStatus(WoundStatus.emCicatrizacao),
          throwsA(isA<BusinessRuleException>()),
        );

        // Ferida infectada não pode ir direto para cicatrizada
        final infectedWound = healedWound.copyWith(
          status: WoundStatus.infectada,
        );
        expect(
          () => infectedWound.updateStatus(WoundStatus.cicatrizada),
          throwsA(isA<BusinessRuleException>()),
        );
      });
    });

    group('updateInfo', () {
      test('deve atualizar informações com validação', () {
        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        );

        final updatedWound = wound.updateInfo(
          description: 'Nova descrição da ferida',
          type: WoundType.traumatica,
          notes: 'Novas observações',
        );

        expect(updatedWound.description, equals('Nova descrição da ferida'));
        expect(updatedWound.type, equals(WoundType.traumatica));
        expect(updatedWound.notes, equals('Novas observações'));
        expect(
          updatedWound.updatedAt.isAfter(wound.updatedAt) ||
              updatedWound.updatedAt.isAtSameMomentAs(wound.updatedAt),
          isTrue,
        );
      });

      test('deve validar dados na atualização', () {
        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        );

        expect(
          () => wound.updateInfo(description: ''),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('Archive/Unarchive', () {
      test('deve arquivar e desarquivar ferida', () {
        final wound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: validType,
          location: validLocation,
        );

        expect(wound.archived, isFalse);

        final archivedWound = wound.archive();
        expect(archivedWound.archived, isTrue);
        expect(
          archivedWound.updatedAt.isAfter(wound.updatedAt) ||
              archivedWound.updatedAt.isAtSameMomentAs(wound.updatedAt),
          isTrue,
        );

        final unarchivedWound = archivedWound.unarchive();
        expect(unarchivedWound.archived, isFalse);
        expect(
          unarchivedWound.updatedAt.isAfter(archivedWound.updatedAt) ||
              unarchivedWound.updatedAt.isAtSameMomentAs(
                archivedWound.updatedAt,
              ),
          isTrue,
        );
      });
    });

    group('Summary Generation', () {
      test('deve gerar resumo da ferida', () {
        final recentWound = Wound.create(
          patientId: validPatientId,
          description: validDescription,
          type: WoundType.feridaCirurgica,
          location: WoundLocation.abdomen,
          identificationDate: DateTime.now().subtract(const Duration(days: 5)),
        );

        final summary = recentWound.summary;
        expect(summary, contains('Ferida Cirúrgica'));
        expect(summary, contains('Abdômen'));
        expect(summary, contains('Ativa'));
        expect(summary, isNot(contains('Crônica')));
        expect(summary, isNot(contains('⚠️')));
      });

      test('deve indicar ferida crônica e urgente no resumo', () {
        final chronicUrgentWound = Wound.create(
          patientId: validPatientId,
          description: 'Úlcera infectada',
          type: WoundType.peDiabetico,
          location: WoundLocation.pes,
          identificationDate: DateTime.now().subtract(const Duration(days: 45)),
        ).copyWith(status: WoundStatus.infectada);

        final summary = chronicUrgentWound.summary;
        expect(summary, contains('(Crônica)'));
        expect(summary, contains('⚠️'));
      });
    });
  });
}
