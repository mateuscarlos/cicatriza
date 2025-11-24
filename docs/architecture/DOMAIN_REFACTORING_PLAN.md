# Análise e Plano de Refatoração da Camada de Domínio - Cicatriza

## 🔍 Análise da Situação Atual

### ✅ Pontos Positivos Identificados

1. **BaseRepository implementado**: Sistema básico de Result pattern funcional
2. **Estrutura inicial**: Separação clara entre entities, repositories e usecases
3. **Freezed usage**: Uso adequado do Freezed para imutabilidade das entidades
4. **Alguns patterns**: Result pattern parcialmente implementado

### ❌ Deficiências Críticas Identificadas

#### 1. **Entidades Anêmicas (Violação do DDD)**
- **Patient**: Apenas data holder, sem comportamentos ou validações
- **Wound**: Sem regras de negócio implementadas
- **Assessment**: Ausência de validações de domínio

#### 2. **Ausência de Value Objects**
- Email, telefone, e outros dados importantes não são tipados
- Ausência de validações específicas de domínio
- Dados primitivos obsession

#### 3. **Repositories Inconsistentes**
- **PatientRepository**: Não usa Result pattern
- **WoundRepository**: Não usa Result pattern
- **AssessmentRepository**: Não usa Result pattern
- Apenas AuthRepository e UserProfileRepository usam Result

#### 4. **Use Cases Ausentes**
- Pasta `usecases` vazia
- Lógica de negócio provavelmente espalhada nas camadas superiores
- Violação da Clean Architecture

#### 5. **Ausência de Domain Services**
- Regras de negócio complexas sem local apropriado
- Validações cruzadas não implementadas

#### 6. **Exceções de Domínio Ausentes**
- Tratamento de erros genérico
- Ausência de semântica específica do domínio

---

## 🎯 Plano de Refatoração

### Fase 1: Criar Value Objects (Priority: High)

#### 1.1 Implementar Value Objects Essenciais
```dart
// lib/domain/value_objects/
├── email.dart              # Validação de email
├── phone.dart              # Validação de telefone brasileiro
├── patient_name.dart       # Validação de nome de paciente
├── wound_dimensions.dart   # Dimensões da ferida com validações
└── pain_scale.dart         # Escala de dor (0-10)
```

#### 1.2 Benefícios Esperados
- **Type Safety**: Eliminar primitive obsession
- **Validação Centralizada**: Regras de negócio nos value objects
- **Expressividade**: Código mais semântico

### Fase 2: Enriquecer Entidades (Priority: High)

#### 2.1 Refatorar Patient Entity
```dart
class Patient {
  // Value Objects
  final PatientName name;
  final Email? email;
  final Phone? phone;
  
  // Comportamentos de domínio
  int get ageInYears;
  bool get isMinor;
  bool get isElderly;
  bool get hasValidContactInfo;
  
  // Validações
  List<String> validate();
  bool canBeArchived();
  bool canReceiveTreatment();
}
```

#### 2.2 Refatorar Wound Entity
```dart
class Wound {
  // Value Objects
  final WoundDimensions dimensions;
  
  // Comportamentos de domínio
  double get area;
  double get volume;
  bool get isHealing;
  bool get requiresImmediateAttention;
  WoundSeverity get severity;
  
  // Validações
  List<String> validate();
  bool canBeMarkedAsHealed();
  Wound markAsHealed();
}
```

#### 2.3 Refatorar Assessment Entity
```dart
class Assessment {
  // Value Objects  
  final PainScale pain;
  final WoundDimensions dimensions;
  
  // Comportamentos de domínio
  bool get showsImprovement;
  AssessmentSeverity get overallSeverity;
  List<String> get recommendedActions;
  
  // Validações
  List<String> validate();
  bool isConsistentWith(Assessment previous);
}
```

### Fase 3: Implementar Use Cases (Priority: High)

#### 3.1 Patient Use Cases
```dart
// lib/domain/usecases/patient/
├── create_patient_use_case.dart
├── update_patient_use_case.dart
├── archive_patient_use_case.dart
├── search_patients_use_case.dart
└── get_patient_details_use_case.dart
```

#### 3.2 Wound Use Cases
```dart
// lib/domain/usecases/wound/
├── create_wound_use_case.dart
├── update_wound_status_use_case.dart
├── mark_wound_healed_use_case.dart
└── get_wound_history_use_case.dart
```

#### 3.3 Assessment Use Cases
```dart
// lib/domain/usecases/assessment/
├── create_assessment_use_case.dart
├── compare_assessments_use_case.dart
└── generate_progress_report_use_case.dart
```

### Fase 4: Atualizar Repository Contracts (Priority: High)

#### 4.1 Migrar para Result Pattern
```dart
abstract class PatientRepository {
  Future<Result<List<Patient>>> getPatients();
  Future<Result<Patient?>> getPatientById(String id);
  Future<Result<Patient>> createPatient(Patient patient);
  Future<Result<Patient>> updatePatient(Patient patient);
  Future<Result<void>> archivePatient(String id);
  Future<Result<List<Patient>>> searchPatients(String query);
}
```

#### 4.2 Adicionar Operações de Domínio
```dart
abstract class PatientRepository {
  // Operações específicas de domínio
  Future<Result<int>> countPatientsByUser(String userId);
  Future<Result<Patient?>> findByName(String userId, String name);
  Future<Result<List<Patient>>> getActivePatients(String userId);
  Future<Result<bool>> hasActiveWounds(String patientId);
}
```

### Fase 5: Criar Domain Services (Priority: Medium)

#### 5.1 Patient Domain Service
```dart
abstract class PatientDomainService {
  Future<ValidationResult> validatePatientCreation(Patient patient);
  Future<ValidationResult> validatePatientUpdate(Patient current, Patient updated);
  Future<bool> canBeArchived(String patientId);
  Future<PatientRiskAssessment> assessPatientRisk(String patientId);
}
```

#### 5.2 Wound Assessment Service
```dart
abstract class WoundAssessmentService {
  WoundProgression assessProgression(List<Assessment> assessments);
  List<String> generateRecommendations(Wound wound, Assessment latestAssessment);
  bool requiresSpecialistAttention(Wound wound);
  WoundSeverity calculateSeverity(Assessment assessment);
}
```

### Fase 6: Implementar Domain Events (Priority: Low)

#### 6.1 Eventos de Domínio
```dart
// lib/domain/events/
├── patient_created_event.dart
├── patient_archived_event.dart
├── wound_healed_event.dart
├── critical_assessment_event.dart
└── treatment_completed_event.dart
```

### Fase 7: Criar Exceções de Domínio (Priority: Medium)

#### 7.1 Hierarquia de Exceções
```dart
// lib/domain/exceptions/
├── domain_exception.dart          # Base
├── business_rule_exception.dart   # Regras de negócio
├── validation_exception.dart      # Validações
├── patient_exceptions.dart        # Específicas de paciente
├── wound_exceptions.dart          # Específicas de ferida
└── assessment_exceptions.dart     # Específicas de avaliação
```

---

## 📈 Cronograma de Implementação

### Sprint 1 (1-2 semanas)
- [ ] **Value Objects** (email, phone, patient_name, pain_scale)
- [ ] **Domain Exceptions** (hierarquia básica)
- [ ] **Patient Entity** (enriquecimento com comportamentos)

### Sprint 2 (1-2 semanas)  
- [ ] **Wound Entity** (comportamentos e validações)
- [ ] **Assessment Entity** (lógica de domínio)
- [ ] **Patient Use Cases** (create, update, search)

### Sprint 3 (1-2 semanas)
- [ ] **Repository Contracts** (migração para Result pattern)
- [ ] **Wound Use Cases** (create, update, heal)
- [ ] **Assessment Use Cases** (create, compare)

### Sprint 4 (1 semana)
- [ ] **Domain Services** (validações complexas)
- [ ] **Testes de Domínio** (cobertura completa)
- [ ] **Documentação Atualizada**

---

## 🧪 Estratégia de Testes

### Testes de Value Objects
```dart
test('should create valid email');
test('should throw exception for invalid email');
test('should format phone number correctly');
```

### Testes de Entidades
```dart
test('should calculate patient age correctly');
test('should validate patient data');
test('should determine if wound is healing');
```

### Testes de Use Cases
```dart
test('should create patient with valid data');
test('should fail when patient limit exceeded');
test('should search patients by name');
```

### Testes de Domain Services
```dart
test('should validate patient creation rules');
test('should assess wound progression correctly');
test('should generate appropriate recommendations');
```

---

## 🎯 Benefícios Esperados

### 1. **Aderência ao DDD**
- Entidades ricas com comportamentos
- Value objects para dados importantes
- Linguagem ubíqua implementada

### 2. **Princípios SOLID**
- **SRP**: Cada classe com responsabilidade única
- **OCP**: Extensível sem modificação
- **LSP**: Substituição correta de tipos
- **ISP**: Interfaces específicas
- **DIP**: Dependência de abstrações

### 3. **Clean Architecture**
- Domínio independente de frameworks
- Use cases bem definidos
- Boundaries claros entre camadas

### 4. **Qualidade de Código**
- Validações centralizadas
- Tratamento de erros semântico
- Testabilidade aprimorada
- Manutenibilidade aumentada

### 5. **Experiência do Desenvolvedor**
- APIs mais expressivas
- Menos bugs de runtime
- IntelliSense melhorado
- Refatoração mais segura

---

## 🚀 Próximos Passos

1. **Aprovação do Plano**: Revisar e aprovar estratégia
2. **Setup de Branches**: Criar branches para cada fase
3. **Implementação Incremental**: Começar pela Fase 1
4. **Testes Contínuos**: Manter cobertura de testes
5. **Integração Gradual**: Migrar camadas superiores gradualmente

Esta refatoração transformará a camada de domínio anêmica atual em um core de negócio robusto, expressivo e alinhado com as melhores práticas de DDD e Clean Architecture.