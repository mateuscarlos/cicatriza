// ignore_for_file: non_abstract_class_inherits_abstract_member
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';
import '../value_objects/email.dart';
import '../value_objects/patient_name.dart';
import '../value_objects/phone.dart';
import '../exceptions/domain_exceptions.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

@freezed
class Patient with _$Patient {
  const factory Patient({
    required String id,
    required String name,
    @TimestampConverter() required DateTime birthDate,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required String nameLowercase,
    @Default(false) bool archived,
    String? notes,
    String? phone,
    String? email,
  }) = _Patient;

  const Patient._();

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  /// Factory para criar um novo paciente com validações de domínio
  factory Patient.create({
    required String name,
    required DateTime birthDate,
    String? notes,
    String? phone,
    String? email,
  }) {
    // Validações de domínio
    final patientName = PatientName(name);

    // Validar email se fornecido
    if (email != null && email.trim().isNotEmpty) {
      Email(email);
    }

    // Validar telefone se fornecido
    if (phone != null && phone.trim().isNotEmpty) {
      Phone(phone);
    }

    // Validar idade mínima e máxima
    _validateAge(birthDate);

    final now = DateTime.now();

    return Patient(
      id: '',
      name: patientName.value,
      birthDate: birthDate,
      nameLowercase: patientName.value.toLowerCase(),
      createdAt: now,
      updatedAt: now,
      notes: notes?.trim(),
      phone: phone?.trim(),
      email: email?.trim(),
    );
  }

  /// Método para atualizar dados do paciente com validações
  Patient updateInfo({
    String? name,
    DateTime? birthDate,
    String? notes,
    String? phone,
    String? email,
  }) {
    // Validar nome se fornecido
    String finalName = this.name;
    if (name != null) {
      final patientName = PatientName(name);
      finalName = patientName.value;
    }

    // Validar email se fornecido
    if (email != null && email.trim().isNotEmpty) {
      Email(email);
    }

    // Validar telefone se fornecido
    if (phone != null && phone.trim().isNotEmpty) {
      Phone(phone);
    }

    // Validar idade se data nascimento fornecida
    if (birthDate != null) {
      _validateAge(birthDate);
    }

    return copyWith(
      name: finalName,
      nameLowercase: finalName.toLowerCase(),
      birthDate: birthDate ?? this.birthDate,
      notes: notes?.trim() ?? this.notes,
      phone: phone?.trim() ?? this.phone,
      email: email?.trim() ?? this.email,
      updatedAt: DateTime.now(),
    );
  }

  /// Calcula a idade atual do paciente
  int get currentAge {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // Ajusta se ainda não fez aniversário este ano
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Verifica se o paciente é idoso (≥ 65 anos)
  bool get isElderly => currentAge >= 65;

  /// Verifica se o paciente é criança (< 18 anos)
  bool get isChild => currentAge < 18;

  /// Verifica se o paciente é adolescente (13-17 anos)
  bool get isAdolescent => currentAge >= 13 && currentAge <= 17;

  /// Verifica se tem informações de contato completas
  bool get hasCompleteContactInfo =>
      phone != null && phone!.isNotEmpty && email != null && email!.isNotEmpty;

  /// Retorna a idade em uma data específica
  int ageAt(DateTime date) {
    if (date.isBefore(birthDate)) {
      throw const ValidationException(
        'Data não pode ser anterior ao nascimento',
      );
    }

    int age = date.year - birthDate.year;

    if (date.month < birthDate.month ||
        (date.month == birthDate.month && date.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Verifica se o paciente é considerado de risco para cicatrização
  /// baseado em fatores de idade
  bool get isHighRiskForHealing {
    // Pacientes muito jovens (< 2 anos) ou idosos (> 75 anos)
    // podem ter cicatrização mais lenta
    return currentAge < 2 || currentAge > 75;
  }

  /// Gera um resumo do perfil do paciente
  String get profileSummary {
    final ageGroup = isChild
        ? 'Criança'
        : isAdolescent
        ? 'Adolescente'
        : isElderly
        ? 'Idoso'
        : 'Adulto';

    final contactInfo = hasCompleteContactInfo
        ? 'Contato completo'
        : 'Contato incompleto';

    return '$name, $currentAge anos ($ageGroup) - $contactInfo';
  }

  /// Método para arquivar/desarquivar paciente
  Patient archive() => copyWith(archived: true, updatedAt: DateTime.now());

  Patient unarchive() => copyWith(archived: false, updatedAt: DateTime.now());

  /// Validação privada de idade
  static void _validateAge(DateTime birthDate) {
    final today = DateTime.now();

    // Não pode nascer no futuro
    if (birthDate.isAfter(today)) {
      throw const ValidationException(
        'Data de nascimento não pode ser no futuro',
      );
    }

    // Idade máxima razoável (150 anos)
    final maxAge = today.subtract(const Duration(days: 365 * 150));
    if (birthDate.isBefore(maxAge)) {
      throw const ValidationException(
        'Data de nascimento muito antiga (máximo 150 anos)',
      );
    }
  }
}
