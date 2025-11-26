import '../../entities/patient.dart';
import '../../repositories/patient_repository.dart';

import '../../exceptions/domain_exceptions.dart';
import '../base/use_case.dart';

/// Input para atualização de paciente
class UpdatePatientInput {
  final String patientId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final DateTime? birthDate;
  final String? notes;

  const UpdatePatientInput({
    required this.patientId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.birthDate,
    this.notes,
  });

  /// Verifica se há alguma atualização para aplicar
  bool get hasUpdates =>
      firstName != null ||
      lastName != null ||
      email != null ||
      phone != null ||
      birthDate != null ||
      notes != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdatePatientInput &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          phone == other.phone &&
          birthDate == other.birthDate &&
          notes == other.notes;

  @override
  int get hashCode =>
      patientId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      birthDate.hashCode ^
      notes.hashCode;
}

/// Caso de uso para atualização de pacientes existentes.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Buscar paciente existente
/// - Verificar conflitos (ex: email duplicado)
/// - Aplicar atualizações usando métodos da entidade
/// - Persistir alterações
/// - Retornar paciente atualizado
class UpdatePatientUseCase implements UseCase<UpdatePatientInput, Patient> {
  final PatientRepository _patientRepository;

  const UpdatePatientUseCase(this._patientRepository);

  @override
  Future<Result<Patient>> execute(UpdatePatientInput input) async {
    try {
      // Validar entrada
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      // Buscar paciente existente
      final existingPatient = await _patientRepository.getPatientById(
        input.patientId,
      );
      if (existingPatient == null) {
        return Failure(NotFoundError.withId('Patient', input.patientId));
      }

      // Verificar se email está sendo alterado e se já existe
      if (input.email != null && input.email != existingPatient.email) {
        final duplicatePatient = await _patientRepository.getPatientById(
          _generateIdFromEmail(input.email!),
        );
        if (duplicatePatient != null) {
          return const Failure(
            ConflictError(
              'Já existe outro paciente com este email',
              code: 'EMAIL_ALREADY_EXISTS',
            ),
          );
        }
      }

      // Preparar dados para atualização
      String? newName;
      if (input.firstName != null || input.lastName != null) {
        // Extrair partes do nome atual
        final currentNameParts = existingPatient.name.split(' ');
        final currentFirstName = currentNameParts.isNotEmpty
            ? currentNameParts.first
            : '';
        final currentLastName = currentNameParts.length > 1
            ? currentNameParts.skip(1).join(' ')
            : '';

        final firstName = input.firstName ?? currentFirstName;
        final lastName = input.lastName ?? currentLastName;
        newName = '$firstName $lastName'.trim();
      }

      String? newEmail = input.email;

      String? newPhone;
      if (input.phone != null) {
        newPhone = input.phone!.trim().isEmpty ? null : input.phone!.trim();
      }

      // Aplicar atualizações usando método da entidade
      final updatedPatient = existingPatient.updateInfo(
        name: newName,
        email: newEmail,
        birthDate: input.birthDate,
        phone: newPhone,
        notes: input.notes?.trim().isEmpty == true ? null : input.notes?.trim(),
      ); // Persistir alterações
      final savedPatient = await _patientRepository.updatePatient(
        updatedPatient,
      );

      return Success(savedPatient);
    } on ValidationException catch (e) {
      return Failure(ValidationError(e.message));
    } on BusinessRuleException catch (e) {
      return Failure(ConflictError(e.message));
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao atualizar paciente: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada
  ValidationError? _validateInput(UpdatePatientInput input) {
    if (input.patientId.trim().isEmpty) {
      return const ValidationError(
        'ID do paciente é obrigatório',
        field: 'patientId',
      );
    }

    if (!input.hasUpdates) {
      return const ValidationError(
        'Pelo menos um campo deve ser informado para atualização',
      );
    }

    if (input.firstName?.trim().isEmpty == true) {
      return const ValidationError(
        'Nome não pode ser vazio',
        field: 'firstName',
      );
    }

    if (input.lastName?.trim().isEmpty == true) {
      return const ValidationError(
        'Sobrenome não pode ser vazio',
        field: 'lastName',
      );
    }

    if (input.email?.trim().isEmpty == true) {
      return const ValidationError('Email não pode ser vazio', field: 'email');
    }

    if (input.birthDate != null) {
      final now = DateTime.now();
      if (input.birthDate!.isAfter(now)) {
        return const ValidationError(
          'Data de nascimento não pode ser no futuro',
          field: 'birthDate',
        );
      }

      final maxAge = now.subtract(const Duration(days: 365 * 150));
      if (input.birthDate!.isBefore(maxAge)) {
        return const ValidationError(
          'Data de nascimento muito antiga',
          field: 'birthDate',
        );
      }
    }

    return null;
  }

  /// Gera ID baseado no email
  String _generateIdFromEmail(String email) {
    return email.toLowerCase().trim();
  }
}
