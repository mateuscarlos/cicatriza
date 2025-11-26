import 'package:flutter_test/flutter_test.dart';
import 'package:cicatriza/domain/entities/patient.dart';
import 'package:cicatriza/domain/exceptions/domain_exceptions.dart';

void main() {
  group('Patient Entity - Rich Domain Model', () {
    const validName = 'João Silva Santos';
    final validBirthDate = DateTime(1990, 5, 15);
    const validPhone = '(11) 99999-9999';
    const validEmail = 'joao@example.com';

    group('Patient.create', () {
      test('deve criar paciente com dados válidos', () {
        final patient = Patient.create(
          name: validName,
          birthDate: validBirthDate,
          phone: validPhone,
          email: validEmail,
          notes: 'Paciente teste',
        );

        expect(patient.name, equals(validName));
        expect(patient.birthDate, equals(validBirthDate));
        expect(patient.phone, equals(validPhone));
        expect(patient.email, equals(validEmail));
        expect(patient.notes, equals('Paciente teste'));
        expect(patient.nameLowercase, equals(validName.toLowerCase()));
        expect(patient.archived, isFalse);
      });

      test('deve validar nome inválido', () {
        expect(
          () => Patient.create(
            name: '', // Nome vazio
            birthDate: validBirthDate,
          ),
          throwsA(isA<InvalidNameException>()),
        );

        expect(
          () => Patient.create(
            name: 'A', // Nome muito curto
            birthDate: validBirthDate,
          ),
          throwsA(isA<InvalidNameException>()),
        );
      });

      test('deve validar email inválido', () {
        expect(
          () => Patient.create(
            name: validName,
            birthDate: validBirthDate,
            email: 'email-inválido',
          ),
          throwsA(isA<InvalidEmailException>()),
        );
      });

      test('deve validar telefone inválido', () {
        expect(
          () => Patient.create(
            name: validName,
            birthDate: validBirthDate,
            phone: '123', // Telefone muito curto
          ),
          throwsA(isA<InvalidPhoneException>()),
        );
      });

      test('deve validar data de nascimento no futuro', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));

        expect(
          () => Patient.create(name: validName, birthDate: futureDate),
          throwsA(isA<ValidationException>()),
        );
      });

      test('deve validar data de nascimento muito antiga', () {
        final ancientDate = DateTime.now().subtract(
          const Duration(days: 365 * 151),
        );

        expect(
          () => Patient.create(name: validName, birthDate: ancientDate),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('Rich Domain Behaviors - Age Calculations', () {
      test('deve calcular idade atual corretamente', () {
        final birthDate = DateTime(1990, 5, 15);
        final patient = Patient.create(name: validName, birthDate: birthDate);

        final expectedAge = DateTime.now().year - 1990;
        expect(patient.currentAge, isA<int>());
        expect(patient.currentAge, greaterThanOrEqualTo(expectedAge - 1));
        expect(patient.currentAge, lessThanOrEqualTo(expectedAge));
      });

      test('deve calcular idade em data específica', () {
        final birthDate = DateTime(1990, 5, 15);
        final patient = Patient.create(name: validName, birthDate: birthDate);

        final targetDate = DateTime(2020, 6, 20);
        final age = patient.ageAt(targetDate);

        expect(age, equals(30));
      });

      test('deve calcular idade considerando mês/dia de aniversário', () {
        final birthDate = DateTime(1990, 12, 25); // Nasceu em 25 de dezembro
        final patient = Patient.create(name: validName, birthDate: birthDate);

        // Antes do aniversário (dezembro 20)
        final beforeBirthday = DateTime(2020, 12, 20);
        expect(patient.ageAt(beforeBirthday), equals(29));

        // Depois do aniversário (dezembro 30)
        final afterBirthday = DateTime(2020, 12, 30);
        expect(patient.ageAt(afterBirthday), equals(30));
      });

      test('deve rejeitar data anterior ao nascimento', () {
        final birthDate = DateTime(1990, 5, 15);
        final patient = Patient.create(name: validName, birthDate: birthDate);

        final pastDate = DateTime(1985, 1, 1);

        expect(
          () => patient.ageAt(pastDate),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('Rich Domain Behaviors - Age Groups', () {
      test('deve identificar paciente criança', () {
        final childBirthDate = DateTime.now().subtract(
          const Duration(days: 365 * 10),
        );
        final child = Patient.create(
          name: 'Maria Silva',
          birthDate: childBirthDate,
        );

        expect(child.isChild, isTrue);
        expect(child.isAdolescent, isFalse);
        expect(child.isElderly, isFalse);
      });

      test('deve identificar paciente adolescente', () {
        final teenBirthDate = DateTime.now().subtract(
          const Duration(days: 365 * 15),
        );
        final teen = Patient.create(
          name: 'Pedro Silva',
          birthDate: teenBirthDate,
        );

        expect(teen.isChild, isTrue); // 15 anos ainda é criança (< 18)
        expect(teen.isAdolescent, isTrue);
        expect(teen.isElderly, isFalse);
      });

      test('deve identificar paciente idoso', () {
        final elderlyBirthDate = DateTime.now().subtract(
          const Duration(days: 365 * 70),
        );
        final elderly = Patient.create(
          name: 'Antonio Silva',
          birthDate: elderlyBirthDate,
        );

        expect(elderly.isChild, isFalse);
        expect(elderly.isAdolescent, isFalse);
        expect(elderly.isElderly, isTrue);
      });
    });

    group('Rich Domain Behaviors - Contact Information', () {
      test('deve verificar informações de contato completas', () {
        final patientWithCompleteContact = Patient.create(
          name: validName,
          birthDate: validBirthDate,
          phone: validPhone,
          email: validEmail,
        );

        final patientWithIncompleteContact = Patient.create(
          name: validName,
          birthDate: validBirthDate,
          phone: validPhone,
          // email: null,
        );

        expect(patientWithCompleteContact.hasCompleteContactInfo, isTrue);
        expect(patientWithIncompleteContact.hasCompleteContactInfo, isFalse);
      });
    });

    group('Rich Domain Behaviors - Healing Risk Assessment', () {
      test(
        'deve identificar paciente de alto risco para cicatrização - muito jovem',
        () {
          final babyBirthDate = DateTime.now().subtract(
            const Duration(days: 365),
          );
          final baby = Patient.create(
            name: 'Bebê Silva',
            birthDate: babyBirthDate,
          );

          expect(baby.isHighRiskForHealing, isTrue);
        },
      );

      test(
        'deve identificar paciente de alto risco para cicatrização - muito idoso',
        () {
          final veryElderlyBirthDate = DateTime.now().subtract(
            const Duration(days: 365 * 80),
          );
          final veryElderly = Patient.create(
            name: 'Idoso Silva',
            birthDate: veryElderlyBirthDate,
          );

          expect(veryElderly.isHighRiskForHealing, isTrue);
        },
      );

      test('deve identificar paciente de baixo risco para cicatrização', () {
        final adultBirthDate = DateTime.now().subtract(
          const Duration(days: 365 * 35),
        );
        final adult = Patient.create(
          name: 'Adulto Silva',
          birthDate: adultBirthDate,
        );

        expect(adult.isHighRiskForHealing, isFalse);
      });
    });

    group('Rich Domain Behaviors - Profile Summary', () {
      test('deve gerar resumo do perfil completo', () {
        final patient = Patient.create(
          name: validName,
          birthDate: DateTime.now().subtract(const Duration(days: 365 * 35)),
          phone: validPhone,
          email: validEmail,
        );

        final summary = patient.profileSummary;

        expect(summary, contains(validName));
        expect(summary, matches(RegExp(r'\d+ anos'))); // Aceita qualquer idade
        expect(summary, contains('Adulto'));
        expect(summary, contains('Contato completo'));
      });

      test('deve gerar resumo indicando contato incompleto', () {
        final patient = Patient.create(
          name: validName,
          birthDate: DateTime.now().subtract(const Duration(days: 365 * 70)),
        );

        final summary = patient.profileSummary;

        expect(summary, contains('Idoso'));
        expect(summary, contains('Contato incompleto'));
      });
    });

    group('updateInfo', () {
      test('deve atualizar informações com validação', () {
        final patient = Patient.create(
          name: validName,
          birthDate: validBirthDate,
        );

        final updatedPatient = patient.updateInfo(
          name: 'Nome Atualizado',
          email: 'novo@email.com',
          notes: 'Novas observações',
        );

        expect(updatedPatient.name, equals('Nome Atualizado'));
        expect(updatedPatient.nameLowercase, equals('nome atualizado'));
        expect(updatedPatient.email, equals('novo@email.com'));
        expect(updatedPatient.notes, equals('Novas observações'));
        expect(
          updatedPatient.updatedAt.isAfter(patient.updatedAt) ||
              updatedPatient.updatedAt.isAtSameMomentAs(patient.updatedAt),
          isTrue,
        );
      });

      test('deve validar dados na atualização', () {
        final patient = Patient.create(
          name: validName,
          birthDate: validBirthDate,
        );

        expect(
          () => patient.updateInfo(name: ''),
          throwsA(isA<InvalidNameException>()),
        );

        expect(
          () => patient.updateInfo(email: 'email-inválido'),
          throwsA(isA<InvalidEmailException>()),
        );
      });
    });

    group('Archive/Unarchive', () {
      test('deve arquivar e desarquivar paciente', () {
        final patient = Patient.create(
          name: validName,
          birthDate: validBirthDate,
        );

        expect(patient.archived, isFalse);

        final archivedPatient = patient.archive();
        expect(archivedPatient.archived, isTrue);
        expect(
          archivedPatient.updatedAt.isAfter(patient.updatedAt) ||
              archivedPatient.updatedAt.isAtSameMomentAs(patient.updatedAt),
          isTrue,
        );

        final unarchivedPatient = archivedPatient.unarchive();
        expect(unarchivedPatient.archived, isFalse);
        expect(
          unarchivedPatient.updatedAt.isAfter(archivedPatient.updatedAt) ||
              unarchivedPatient.updatedAt.isAtSameMomentAs(
                archivedPatient.updatedAt,
              ),
          isTrue,
        );
      });
    });
  });
}
