import '../../entities/patient.dart';
import '../../repositories/patient_repository.dart';

import '../../exceptions/domain_exceptions.dart';
import '../base/use_case.dart';

/// Input para criação de paciente
class CreatePatientInput {
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final DateTime birthDate;
  final String? notes;

  const CreatePatientInput({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.birthDate,
    this.notes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatePatientInput &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          phone == other.phone &&
          birthDate == other.birthDate &&
          notes == other.notes;

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      birthDate.hashCode ^
      notes.hashCode;
}

/// Caso de uso para criação de novos pacientes.
///
/// Responsabilidades:
/// - Validar dados de entrada
/// - Verificar duplicação de email
/// - Criar value objects necessários
/// - Persistir o novo paciente
/// - Retornar resultado da operação
class CreatePatientUseCase implements UseCase<CreatePatientInput, Patient> {
  final PatientRepository _patientRepository;

  const CreatePatientUseCase(this._patientRepository);

  @override
  Future<Result<Patient>> execute(CreatePatientInput input) async {
    try {
      // Validar entrada básica
      final validationResult = _validateInput(input);
      if (validationResult != null) {
        return Failure(validationResult);
      }

      // Verificar se email já existe
      final existingPatient = await _patientRepository.getPatientById(
        _generateIdFromEmail(input.email),
      );
      if (existingPatient != null) {
        return const Failure(
          ConflictError(
            'Já existe um paciente cadastrado com este email',
            code: 'EMAIL_ALREADY_EXISTS',
          ),
        );
      }

      // Validar value objects (validação será feita internamente na entidade)
      final fullName = '${input.firstName.trim()} ${input.lastName.trim()}';

      // Criar entidade Patient (validações internas dos value objects)
      final patient = Patient.create(
        name: fullName,
        email: input.email.trim(),
        birthDate: input.birthDate,
        phone: input.phone?.trim().isEmpty == true ? null : input.phone?.trim(),
        notes: input.notes?.trim().isEmpty == true ? null : input.notes?.trim(),
      ); // Persistir paciente
      final savedPatient = await _patientRepository.createPatient(patient);

      return Success(savedPatient);
    } on ValidationException catch (e) {
      return Failure(ValidationError(e.message));
    } on BusinessRuleException catch (e) {
      return Failure(ConflictError(e.message));
    } catch (e) {
      return Failure(
        SystemError(
          'Erro interno ao criar paciente: ${e.toString()}',
          cause: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Valida os dados de entrada básicos
  ValidationError? _validateInput(CreatePatientInput input) {
    if (input.firstName.trim().isEmpty) {
      return const ValidationError('Nome é obrigatório', field: 'firstName');
    }

    if (input.lastName.trim().isEmpty) {
      return const ValidationError(
        'Sobrenome é obrigatório',
        field: 'lastName',
      );
    }

    if (input.email.trim().isEmpty) {
      return const ValidationError('Email é obrigatório', field: 'email');
    }

    final now = DateTime.now();
    if (input.birthDate.isAfter(now)) {
      return const ValidationError(
        'Data de nascimento não pode ser no futuro',
        field: 'birthDate',
      );
    }

    final maxAge = now.subtract(const Duration(days: 365 * 150)); // 150 anos
    if (input.birthDate.isBefore(maxAge)) {
      return const ValidationError(
        'Data de nascimento muito antiga',
        field: 'birthDate',
      );
    }

    return null;
  }

  /// Gera ID baseado no email (temporário - idealmente seria UUID)
  String _generateIdFromEmail(String email) {
    return email.toLowerCase().trim();
  }
}
