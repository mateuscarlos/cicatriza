# Documentação da Camada de Domínio - Cicatriza

## 🏛️ Visão Geral da Arquitetura de Domínio

A camada de domínio do Cicatriza segue os princípios da **Clean Architecture** e **Domain-Driven Design (DDD)**, mantendo o núcleo de negócio completamente independente de frameworks e tecnologias externas.

### Estrutura da Camada de Domínio

```
lib/domain/
├── entities/           # Entidades de negócio
├── value_objects/      # Objetos de valor
├── use_cases/         # Casos de uso
├── repositories/      # Interfaces dos repositórios
├── services/          # Interfaces dos serviços de domínio
├── events/           # Eventos de domínio
└── exceptions/       # Exceções específicas do domínio
```

---

## 🏗️ Entidades (Entities)

### Patient Entity

**Arquivo**: `lib/domain/entities/patient.dart`

```dart
/// Entidade principal representando um paciente no sistema
/// 
/// Contém todas as regras de negócio relacionadas ao paciente,
/// incluindo validações e invariantes de domínio.
class Patient extends Equatable {
  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.profileImageUrl,
    this.lastVisitDate,
  });

  final String id;
  final String name;
  final int age;
  final Gender gender;
  final String? notes;
  final String ownerId;
  final String? profileImageUrl;
  final DateTime? lastVisitDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Regras de negócio: Validação de idade
  bool get isValidAge => age >= 0 && age <= 150;

  /// Regras de negócio: Nome válido
  bool get hasValidName => name.trim().length >= 2;

  /// Regras de negócio: Paciente é menor de idade
  bool get isMinor => age < 18;

  /// Regras de negócio: Paciente é idoso
  bool get isElderly => age >= 65;

  /// Regras de negócio: Última visita foi recente (30 dias)
  bool get hasRecentVisit {
    if (lastVisitDate == null) return false;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return lastVisitDate!.isAfter(thirtyDaysAgo);
  }

  /// Validação completa da entidade
  List<String> validate() {
    final errors = <String>[];

    if (!hasValidName) {
      errors.add('Nome deve ter pelo menos 2 caracteres');
    }

    if (!isValidAge) {
      errors.add('Idade deve estar entre 0 e 150 anos');
    }

    if (ownerId.trim().isEmpty) {
      errors.add('ID do proprietário é obrigatório');
    }

    return errors;
  }

  /// Atualizar informações do paciente mantendo invariantes
  Patient copyWith({
    String? id,
    String? name,
    int? age,
    Gender? gender,
    String? notes,
    String? ownerId,
    String? profileImageUrl,
    DateTime? lastVisitDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      notes: notes ?? this.notes,
      ownerId: ownerId ?? this.ownerId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Sempre atualiza timestamp
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        notes,
        ownerId,
        profileImageUrl,
        lastVisitDate,
        createdAt,
        updatedAt,
      ];
}
```

### Treatment Entity

**Arquivo**: `lib/domain/entities/treatment.dart`

```dart
/// Entidade representando um tratamento médico
/// 
/// Contém informações sobre procedimentos, medicamentos e evolução
/// do tratamento de um paciente específico.
class Treatment extends Equatable {
  const Treatment({
    required this.id,
    required this.patientId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.startDate,
    this.expectedEndDate,
    this.actualEndDate,
    this.medications,
    this.procedures,
    this.notes,
    this.images,
  });

  final String id;
  final String patientId;
  final String title;
  final String description;
  final TreatmentStatus status;
  final String createdBy;
  final DateTime? startDate;
  final DateTime? expectedEndDate;
  final DateTime? actualEndDate;
  final List<Medication>? medications;
  final List<Procedure>? procedures;
  final String? notes;
  final List<String>? images;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Regras de negócio: Tratamento está ativo
  bool get isActive => status == TreatmentStatus.active;

  /// Regras de negócio: Tratamento foi concluído
  bool get isCompleted => status == TreatmentStatus.completed;

  /// Regras de negócio: Tratamento está atrasado
  bool get isOverdue {
    if (expectedEndDate == null || isCompleted) return false;
    return DateTime.now().isAfter(expectedEndDate!);
  }

  /// Regras de negócio: Duração do tratamento em dias
  int? get durationInDays {
    if (startDate == null) return null;
    final endDate = actualEndDate ?? DateTime.now();
    return endDate.difference(startDate!).inDays;
  }

  /// Validação da entidade
  List<String> validate() {
    final errors = <String>[];

    if (title.trim().isEmpty) {
      errors.add('Título do tratamento é obrigatório');
    }

    if (description.trim().isEmpty) {
      errors.add('Descrição do tratamento é obrigatória');
    }

    if (patientId.trim().isEmpty) {
      errors.add('ID do paciente é obrigatório');
    }

    if (startDate != null && expectedEndDate != null) {
      if (startDate!.isAfter(expectedEndDate!)) {
        errors.add('Data de início não pode ser posterior à data esperada de fim');
      }
    }

    if (actualEndDate != null && startDate != null) {
      if (actualEndDate!.isBefore(startDate!)) {
        errors.add('Data de fim não pode ser anterior à data de início');
      }
    }

    return errors;
  }

  /// Iniciar tratamento
  Treatment start() {
    if (isActive) {
      throw BusinessException('Tratamento já está ativo');
    }

    return copyWith(
      status: TreatmentStatus.active,
      startDate: DateTime.now(),
    );
  }

  /// Concluir tratamento
  Treatment complete() {
    if (isCompleted) {
      throw BusinessException('Tratamento já está concluído');
    }

    return copyWith(
      status: TreatmentStatus.completed,
      actualEndDate: DateTime.now(),
    );
  }

  Treatment copyWith({
    String? id,
    String? patientId,
    String? title,
    String? description,
    TreatmentStatus? status,
    String? createdBy,
    DateTime? startDate,
    DateTime? expectedEndDate,
    DateTime? actualEndDate,
    List<Medication>? medications,
    List<Procedure>? procedures,
    String? notes,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Treatment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      startDate: startDate ?? this.startDate,
      expectedEndDate: expectedEndDate ?? this.expectedEndDate,
      actualEndDate: actualEndDate ?? this.actualEndDate,
      medications: medications ?? this.medications,
      procedures: procedures ?? this.procedures,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        title,
        description,
        status,
        createdBy,
        startDate,
        expectedEndDate,
        actualEndDate,
        medications,
        procedures,
        notes,
        images,
        createdAt,
        updatedAt,
      ];
}
```

---

## 💎 Value Objects

### Gender Value Object

**Arquivo**: `lib/domain/value_objects/gender.dart`

```dart
/// Value Object representando gênero do paciente
/// 
/// Encapsula as regras de negócio relacionadas ao gênero,
/// garantindo consistência e validação.
enum Gender {
  male('M', 'Masculino'),
  female('F', 'Feminino'),
  other('O', 'Outro'),
  notInformed('N', 'Não informado');

  const Gender(this.value, this.displayName);

  final String value;
  final String displayName;

  /// Criar Gender a partir de string
  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (gender) => gender.value.toLowerCase() == value.toLowerCase(),
      orElse: () => Gender.notInformed,
    );
  }

  /// Ícone apropriado para UI
  IconData get icon {
    switch (this) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
      case Gender.other:
      case Gender.notInformed:
        return Icons.person;
    }
  }

  /// Cor associada (para UI)
  Color get color {
    switch (this) {
      case Gender.male:
        return Colors.blue;
      case Gender.female:
        return Colors.pink;
      case Gender.other:
      case Gender.notInformed:
        return Colors.grey;
    }
  }
}
```

### Email Value Object

**Arquivo**: `lib/domain/value_objects/email.dart`

```dart
/// Value Object para email com validação
/// 
/// Garante que apenas emails válidos sejam utilizados no sistema.
class Email extends Equatable {
  const Email._(this.value);

  final String value;

  /// Criar Email com validação
  factory Email(String value) {
    if (!_isValidEmail(value)) {
      throw InvalidEmailException('Email inválido: $value');
    }
    return Email._(value.toLowerCase().trim());
  }

  /// Validação de email
  static bool _isValidEmail(String email) {
    if (email.trim().isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    return emailRegex.hasMatch(email.trim());
  }

  /// Verificar se email é válido sem lançar exceção
  static bool isValid(String email) {
    return _isValidEmail(email);
  }

  /// Domínio do email
  String get domain => value.split('@').last;

  /// Parte local do email (antes do @)
  String get localPart => value.split('@').first;

  /// Verificar se é email corporativo
  bool get isCorporateEmail {
    final corporateDomains = ['gmail.com', 'yahoo.com', 'hotmail.com'];
    return !corporateDomains.contains(domain);
  }

  @override
  String toString() => value;

  @override
  List<Object> get props => [value];
}
```

### Phone Value Object

**Arquivo**: `lib/domain/value_objects/phone.dart`

```dart
/// Value Object para número de telefone brasileiro
/// 
/// Valida e formata números de telefone seguindo padrões brasileiros
class Phone extends Equatable {
  const Phone._(this.value, this.formattedValue);

  final String value; // Apenas números
  final String formattedValue; // Com formatação

  /// Criar Phone com validação e formatação
  factory Phone(String value) {
    final cleanValue = _cleanPhoneNumber(value);
    
    if (!_isValidBrazilianPhone(cleanValue)) {
      throw InvalidPhoneException('Telefone inválido: $value');
    }

    final formatted = _formatBrazilianPhone(cleanValue);
    return Phone._(cleanValue, formatted);
  }

  /// Limpar número de telefone (manter apenas dígitos)
  static String _cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Validar número de telefone brasileiro
  static bool _isValidBrazilianPhone(String phone) {
    // Celular: 11 dígitos (XX9XXXXXXXX)
    // Fixo: 10 dígitos (XXXXXXXXXX)
    if (phone.length == 11) {
      // Celular: terceiro dígito deve ser 9
      return phone[2] == '9';
    } else if (phone.length == 10) {
      // Telefone fixo
      return true;
    }
    return false;
  }

  /// Formatar número brasileiro
  static String _formatBrazilianPhone(String phone) {
    if (phone.length == 11) {
      // (XX) 9XXXX-XXXX
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 7)}-${phone.substring(7)}';
    } else if (phone.length == 10) {
      // (XX) XXXX-XXXX
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

  /// Verificar se é telefone celular
  bool get isMobile => value.length == 11 && value[2] == '9';

  /// Verificar se é telefone fixo
  bool get isLandline => value.length == 10;

  /// Código de área
  String get areaCode => value.substring(0, 2);

  /// Verificar se número é válido sem lançar exceção
  static bool isValid(String phone) {
    try {
      Phone(phone);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() => formattedValue;

  @override
  List<Object> get props => [value];
}
```

---

## 🎯 Use Cases (Casos de Uso)

### Create Patient Use Case

**Arquivo**: `lib/domain/use_cases/patient/create_patient_use_case.dart`

```dart
/// Caso de uso para criação de pacientes
/// 
/// Contém toda a lógica de negócio relacionada à criação de um novo paciente,
/// incluindo validações, regras de negócio e orquestração de operações.
class CreatePatientUseCase {
  const CreatePatientUseCase({
    required PatientRepository patientRepository,
    required AuthenticationService authService,
    required ImageService imageService,
  }) : _patientRepository = patientRepository,
       _authService = authService,
       _imageService = imageService;

  final PatientRepository _patientRepository;
  final AuthenticationService _authService;
  final ImageService _imageService;

  /// Executar caso de uso
  Future<Result<Patient>> execute(CreatePatientParams params) async {
    try {
      // 1. Verificar se usuário está autenticado
      final currentUser = await _authService.getCurrentUser();
      if (!currentUser.isSuccess) {
        return Failure('Usuário não autenticado');
      }

      // 2. Criar entidade Patient
      final patient = Patient(
        id: '', // Será definido pelo repository
        name: params.name.trim(),
        age: params.age,
        gender: params.gender,
        notes: params.notes?.trim(),
        ownerId: currentUser.data.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 3. Validar entidade
      final validationErrors = patient.validate();
      if (validationErrors.isNotEmpty) {
        return Failure('Dados inválidos: ${validationErrors.join(', ')}');
      }

      // 4. Verificar regras de negócio específicas
      final businessValidation = await _validateBusinessRules(patient);
      if (!businessValidation.isSuccess) {
        return businessValidation;
      }

      // 5. Processar imagem de perfil se fornecida
      String? profileImageUrl;
      if (params.profileImage != null) {
        final imageResult = await _imageService.uploadPatientImage(
          params.profileImage!,
          currentUser.data.id,
        );
        if (imageResult.isSuccess) {
          profileImageUrl = imageResult.data;
        }
        // Não falhar se upload da imagem falhar, apenas logar
      }

      // 6. Criar paciente no repository
      final patientWithImage = patient.copyWith(
        profileImageUrl: profileImageUrl,
      );

      final result = await _patientRepository.createPatient(patientWithImage);
      
      // 7. Log de auditoria
      if (result.isSuccess) {
        await _logAuditEvent(
          'PATIENT_CREATED',
          currentUser.data.id,
          result.data.id,
        );
      }

      return result;

    } catch (e, stackTrace) {
      // Log do erro
      Logger.error(
        'Erro ao criar paciente',
        error: e,
        stackTrace: stackTrace,
      );
      return Failure('Erro interno do sistema');
    }
  }

  /// Validar regras de negócio específicas
  Future<Result<void>> _validateBusinessRules(Patient patient) async {
    // Regra: Máximo de pacientes por usuário (exemplo: 100)
    final existingPatientsResult = await _patientRepository.countPatients(
      patient.ownerId,
    );
    
    if (!existingPatientsResult.isSuccess) {
      return Failure('Erro ao verificar limite de pacientes');
    }

    if (existingPatientsResult.data >= 100) {
      return Failure('Limite máximo de 100 pacientes atingido');
    }

    // Regra: Nome não pode ser duplicado para o mesmo usuário
    final duplicateCheckResult = await _patientRepository.findByName(
      patient.ownerId,
      patient.name,
    );

    if (!duplicateCheckResult.isSuccess) {
      return Failure('Erro ao verificar duplicação de nome');
    }

    if (duplicateCheckResult.data != null) {
      return Failure('Já existe um paciente com este nome');
    }

    return const Success(null);
  }

  /// Log de eventos de auditoria
  Future<void> _logAuditEvent(
    String eventType,
    String userId,
    String resourceId,
  ) async {
    // Implementar log de auditoria
    // Pode ser enviado para sistema de logging externo
  }
}

/// Parâmetros para criação de paciente
class CreatePatientParams extends Equatable {
  const CreatePatientParams({
    required this.name,
    required this.age,
    required this.gender,
    this.notes,
    this.profileImage,
  });

  final String name;
  final int age;
  final Gender gender;
  final String? notes;
  final File? profileImage;

  @override
  List<Object?> get props => [name, age, gender, notes, profileImage];
}
```

### Search Patients Use Case

**Arquivo**: `lib/domain/use_cases/patient/search_patients_use_case.dart`

```dart
/// Caso de uso para busca de pacientes
/// 
/// Implementa lógica de busca inteligente com filtros,
/// paginação e ordenação.
class SearchPatientsUseCase {
  const SearchPatientsUseCase({
    required PatientRepository patientRepository,
    required AuthenticationService authService,
  }) : _patientRepository = patientRepository,
       _authService = authService;

  final PatientRepository _patientRepository;
  final AuthenticationService _authService;

  /// Executar busca
  Future<Result<SearchPatientsResult>> execute(
    SearchPatientsParams params,
  ) async {
    try {
      // 1. Verificar autenticação
      final currentUser = await _authService.getCurrentUser();
      if (!currentUser.isSuccess) {
        return Failure('Usuário não autenticado');
      }

      // 2. Validar parâmetros
      final validationResult = _validateParams(params);
      if (!validationResult.isSuccess) {
        return Failure(validationResult.error);
      }

      // 3. Executar busca no repository
      final searchResult = await _patientRepository.searchPatients(
        currentUser.data.id,
        params.query,
        filters: params.filters,
        orderBy: params.orderBy,
        limit: params.limit,
        offset: params.offset,
      );

      if (!searchResult.isSuccess) {
        return Failure(searchResult.error);
      }

      // 4. Aplicar lógica de negócio adicional
      final processedPatients = _processSearchResults(
        searchResult.data,
        params,
      );

      // 5. Contar total de resultados para paginação
      final totalCountResult = await _patientRepository.countSearchResults(
        currentUser.data.id,
        params.query,
        filters: params.filters,
      );

      final totalCount = totalCountResult.isSuccess ? totalCountResult.data : 0;

      return Success(SearchPatientsResult(
        patients: processedPatients,
        totalCount: totalCount,
        hasNextPage: (params.offset + params.limit) < totalCount,
        currentPage: (params.offset ~/ params.limit) + 1,
        totalPages: (totalCount / params.limit).ceil(),
      ));

    } catch (e, stackTrace) {
      Logger.error(
        'Erro ao buscar pacientes',
        error: e,
        stackTrace: stackTrace,
      );
      return Failure('Erro interno do sistema');
    }
  }

  /// Validar parâmetros de busca
  Result<void> _validateParams(SearchPatientsParams params) {
    if (params.query.trim().isEmpty) {
      return Failure('Termo de busca não pode estar vazio');
    }

    if (params.query.trim().length < 2) {
      return Failure('Termo de busca deve ter pelo menos 2 caracteres');
    }

    if (params.limit <= 0 || params.limit > 100) {
      return Failure('Limite deve estar entre 1 e 100');
    }

    if (params.offset < 0) {
      return Failure('Offset não pode ser negativo');
    }

    return const Success(null);
  }

  /// Processar resultados da busca
  List<Patient> _processSearchResults(
    List<Patient> patients,
    SearchPatientsParams params,
  ) {
    var result = patients;

    // Aplicar filtros de idade se especificados
    if (params.filters.minAge != null) {
      result = result.where((p) => p.age >= params.filters.minAge!).toList();
    }

    if (params.filters.maxAge != null) {
      result = result.where((p) => p.age <= params.filters.maxAge!).toList();
    }

    // Aplicar filtro de gênero
    if (params.filters.gender != null) {
      result = result.where((p) => p.gender == params.filters.gender).toList();
    }

    // Aplicar ordenação adicional se necessário
    switch (params.orderBy) {
      case PatientOrderBy.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case PatientOrderBy.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
      case PatientOrderBy.ageAsc:
        result.sort((a, b) => a.age.compareTo(b.age));
        break;
      case PatientOrderBy.ageDesc:
        result.sort((a, b) => b.age.compareTo(a.age));
        break;
      case PatientOrderBy.createdAtDesc:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return result;
  }
}

/// Parâmetros de busca
class SearchPatientsParams extends Equatable {
  const SearchPatientsParams({
    required this.query,
    this.filters = const PatientSearchFilters(),
    this.orderBy = PatientOrderBy.nameAsc,
    this.limit = 20,
    this.offset = 0,
  });

  final String query;
  final PatientSearchFilters filters;
  final PatientOrderBy orderBy;
  final int limit;
  final int offset;

  @override
  List<Object> get props => [query, filters, orderBy, limit, offset];
}

/// Filtros de busca
class PatientSearchFilters extends Equatable {
  const PatientSearchFilters({
    this.gender,
    this.minAge,
    this.maxAge,
    this.hasRecentVisit,
  });

  final Gender? gender;
  final int? minAge;
  final int? maxAge;
  final bool? hasRecentVisit;

  @override
  List<Object?> get props => [gender, minAge, maxAge, hasRecentVisit];
}

/// Ordenação
enum PatientOrderBy {
  nameAsc,
  nameDesc,
  ageAsc,
  ageDesc,
  createdAtDesc,
}

/// Resultado da busca
class SearchPatientsResult extends Equatable {
  const SearchPatientsResult({
    required this.patients,
    required this.totalCount,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalPages,
  });

  final List<Patient> patients;
  final int totalCount;
  final bool hasNextPage;
  final int currentPage;
  final int totalPages;

  @override
  List<Object> get props => [
        patients,
        totalCount,
        hasNextPage,
        currentPage,
        totalPages,
      ];
}
```

---

## 🏪 Services de Domínio

### Patient Validation Service

**Arquivo**: `lib/domain/services/patient_validation_service.dart`

```dart
/// Serviço de domínio para validações complexas de pacientes
/// 
/// Contém regras de negócio que envolvem múltiplas entidades
/// ou validações complexas que não pertencem a uma entidade específica.
abstract class PatientValidationService {
  /// Validar se paciente pode ser criado
  Future<ValidationResult> validatePatientCreation(
    Patient patient,
    String userId,
  );

  /// Validar se paciente pode ser atualizado
  Future<ValidationResult> validatePatientUpdate(
    Patient currentPatient,
    Patient updatedPatient,
  );

  /// Validar se paciente pode ser excluído
  Future<ValidationResult> validatePatientDeletion(
    Patient patient,
  );

  /// Validar transferência de propriedade
  Future<ValidationResult> validateOwnershipTransfer(
    Patient patient,
    String newOwnerId,
  );
}

class PatientValidationServiceImpl implements PatientValidationService {
  const PatientValidationServiceImpl({
    required PatientRepository patientRepository,
    required TreatmentRepository treatmentRepository,
  }) : _patientRepository = patientRepository,
       _treatmentRepository = treatmentRepository;

  final PatientRepository _patientRepository;
  final TreatmentRepository _treatmentRepository;

  @override
  Future<ValidationResult> validatePatientCreation(
    Patient patient,
    String userId,
  ) async {
    final errors = <String>[];

    // Validação básica da entidade
    errors.addAll(patient.validate());

    // Validar limite de pacientes por usuário
    final countResult = await _patientRepository.countPatients(userId);
    if (countResult.isSuccess && countResult.data >= 100) {
      errors.add('Limite máximo de 100 pacientes atingido');
    }

    // Validar nome único por usuário
    final duplicateResult = await _patientRepository.findByName(
      userId,
      patient.name,
    );
    if (duplicateResult.isSuccess && duplicateResult.data != null) {
      errors.add('Já existe um paciente com este nome');
    }

    // Validar idade em contexto médico
    if (patient.age > 120) {
      errors.add('Idade muito avançada para contexto médico');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  @override
  Future<ValidationResult> validatePatientUpdate(
    Patient currentPatient,
    Patient updatedPatient,
  ) async {
    final errors = <String>[];

    // Validação básica da entidade
    errors.addAll(updatedPatient.validate());

    // Não permitir mudança de proprietário através de update
    if (currentPatient.ownerId != updatedPatient.ownerId) {
      errors.add('Proprietário não pode ser alterado através de atualização');
    }

    // Não permitir mudança de ID
    if (currentPatient.id != updatedPatient.id) {
      errors.add('ID do paciente não pode ser alterado');
    }

    // Validar se nome não conflita com outros pacientes
    if (currentPatient.name != updatedPatient.name) {
      final duplicateResult = await _patientRepository.findByName(
        updatedPatient.ownerId,
        updatedPatient.name,
      );
      if (duplicateResult.isSuccess && 
          duplicateResult.data != null && 
          duplicateResult.data!.id != updatedPatient.id) {
        errors.add('Já existe outro paciente com este nome');
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  @override
  Future<ValidationResult> validatePatientDeletion(
    Patient patient,
  ) async {
    final errors = <String>[];

    // Verificar se paciente tem tratamentos ativos
    final activeTreatmentsResult = await _treatmentRepository
        .getActiveTreatmentsByPatient(patient.id);
    
    if (activeTreatmentsResult.isSuccess && 
        activeTreatmentsResult.data.isNotEmpty) {
      errors.add(
        'Paciente possui ${activeTreatmentsResult.data.length} '
        'tratamento(s) ativo(s). Finalize os tratamentos antes de excluir.',
      );
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  @override
  Future<ValidationResult> validateOwnershipTransfer(
    Patient patient,
    String newOwnerId,
  ) async {
    final errors = <String>[];

    if (patient.ownerId == newOwnerId) {
      errors.add('Novo proprietário é igual ao atual');
    }

    // Verificar se novo proprietário existe e está ativo
    // (implementar quando houver repositório de usuários)

    // Verificar limite de pacientes do novo proprietário
    final countResult = await _patientRepository.countPatients(newOwnerId);
    if (countResult.isSuccess && countResult.data >= 100) {
      errors.add('Novo proprietário já atingiu o limite de 100 pacientes');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// Resultado de validação
class ValidationResult extends Equatable {
  const ValidationResult({
    required this.isValid,
    required this.errors,
  });

  final bool isValid;
  final List<String> errors;

  String get errorMessage => errors.join(', ');

  @override
  List<Object> get props => [isValid, errors];
}
```

---

## 🚨 Exceções de Domínio

### Domain Exceptions

**Arquivo**: `lib/domain/exceptions/domain_exceptions.dart`

```dart
/// Exceção base para o domínio
abstract class DomainException implements Exception {
  const DomainException(this.message);
  final String message;

  @override
  String toString() => 'DomainException: $message';
}

/// Exceção para violações de regras de negócio
class BusinessException extends DomainException {
  const BusinessException(super.message);

  @override
  String toString() => 'BusinessException: $message';
}

/// Exceção para validações
class ValidationException extends DomainException {
  const ValidationException(super.message);

  @override
  String toString() => 'ValidationException: $message';
}

/// Exceção para email inválido
class InvalidEmailException extends ValidationException {
  const InvalidEmailException(super.message);
}

/// Exceção para telefone inválido
class InvalidPhoneException extends ValidationException {
  const InvalidPhoneException(super.message);
}

/// Exceção para entidade não encontrada
class EntityNotFoundException extends DomainException {
  const EntityNotFoundException(String entityType, String id)
      : super('$entityType com ID $id não foi encontrado');
}

/// Exceção para operação não permitida
class OperationNotAllowedException extends BusinessException {
  const OperationNotAllowedException(super.message);
}

/// Exceção para limite excedido
class LimitExceededException extends BusinessException {
  const LimitExceededException(String resource, int limit)
      : super('Limite de $limit $resource excedido');
}

/// Exceção para duplicação
class DuplicateEntityException extends BusinessException {
  const DuplicateEntityException(String entityType, String field)
      : super('$entityType com $field já existe');
}
```

---

## 📋 Enums e Status

### Treatment Status

**Arquivo**: `lib/domain/enums/treatment_status.dart`

```dart
/// Status do tratamento
enum TreatmentStatus {
  draft('draft', 'Rascunho'),
  active('active', 'Ativo'),
  paused('paused', 'Pausado'),
  completed('completed', 'Concluído'),
  cancelled('cancelled', 'Cancelado');

  const TreatmentStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static TreatmentStatus fromString(String value) {
    return TreatmentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TreatmentStatus.draft,
    );
  }

  /// Status que permitem edição
  bool get isEditable => this == TreatmentStatus.draft || 
                         this == TreatmentStatus.paused;

  /// Status finais (não podem ser alterados)
  bool get isFinal => this == TreatmentStatus.completed || 
                      this == TreatmentStatus.cancelled;

  /// Cor para UI
  Color get color {
    switch (this) {
      case TreatmentStatus.draft:
        return Colors.grey;
      case TreatmentStatus.active:
        return Colors.green;
      case TreatmentStatus.paused:
        return Colors.orange;
      case TreatmentStatus.completed:
        return Colors.blue;
      case TreatmentStatus.cancelled:
        return Colors.red;
    }
  }

  /// Ícone para UI
  IconData get icon {
    switch (this) {
      case TreatmentStatus.draft:
        return Icons.edit;
      case TreatmentStatus.active:
        return Icons.play_arrow;
      case TreatmentStatus.paused:
        return Icons.pause;
      case TreatmentStatus.completed:
        return Icons.check_circle;
      case TreatmentStatus.cancelled:
        return Icons.cancel;
    }
  }
}
```

---

## 📝 Resumo da Camada de Domínio

### Principais Características

1. **Independência**: Camada de domínio independente de frameworks e tecnologias externas
2. **Validações**: Todas as regras de negócio centralizadas nas entidades e serviços de domínio
3. **Value Objects**: Tipos seguros para dados importantes (Email, Phone, Gender)
4. **Use Cases**: Orquestração de operações complexas com validações de negócio
5. **Exceções Específicas**: Tratamento de erros semântico e específico por contexto

### Padrões Implementados

- **Entity Pattern**: Entidades com identidade e comportamento
- **Value Object Pattern**: Objetos imutáveis sem identidade
- **Use Case Pattern**: Casos de uso para orquestração de operações
- **Domain Service Pattern**: Serviços para lógica que não pertence a uma entidade específica
- **Specification Pattern**: (implícito nas validações)

### Benefícios

- **Testabilidade**: Lógica de negócio facilmente testável
- **Manutenibilidade**: Regras centralizadas e bem organizadas
- **Expressividade**: Código que reflete a linguagem do negócio
- **Evolução**: Facilita mudanças e extensões futuras
- **Qualidade**: Validações consistentes em todo o sistema

---

Esta documentação da camada de domínio fornece uma base sólida para manutenção e evolução das regras de negócio do Cicatriza, seguindo os princípios da Clean Architecture e DDD.