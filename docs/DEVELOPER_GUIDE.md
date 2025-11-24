# Guia de Desenvolvimento - Cicatriza

## 🚀 Começando

### 1. Configuração do Ambiente

#### Pré-requisitos
- Flutter SDK 3.24.0+
- Dart SDK 3.4.0+
- Android Studio / VS Code
- Git
- Firebase CLI
- Node.js 18+ (para Firebase Functions)

#### Instalação
```bash
# 1. Clonar o repositório
git clone https://github.com/your-org/cicatriza.git
cd cicatriza

# 2. Instalar dependências
flutter pub get

# 3. Configurar Firebase (seguir docs/security/FIREBASE_SETUP_INSTRUCTIONS.md)
# 4. Executar testes
flutter test

# 5. Executar aplicação
flutter run
```

## 🏗️ Arquitetura e Padrões

### Clean Architecture

O projeto segue a Clean Architecture com 4 camadas:

```
lib/
├── core/           # Infraestrutura comum
├── data/           # Camada de dados (implementações)
├── domain/         # Camada de domínio (contratos)
└── presentation/   # Camada de apresentação (UI)
```

### Princípios Fundamentais

1. **SOLID**: Todos os componentes seguem os princípios SOLID
2. **Dependency Inversion**: Use interfaces, não implementações
3. **Single Responsibility**: Uma classe, uma responsabilidade
4. **Open/Closed**: Aberto para extensão, fechado para modificação
5. **DRY**: Don't Repeat Yourself

### Result Pattern

**Use sempre o Result Pattern para operações que podem falhar:**

```dart
// ✅ Correto
Future<Result<User>> signInUser(String email, String password) async {
  return executeOperation(
    operation: () async {
      // lógica de autenticação
      return user;
    },
    operationName: 'signInUser',
  );
}

// ❌ Incorreto - lançar exceções diretamente
Future<User> signInUser(String email, String password) async {
  throw Exception('Erro na autenticação');
}
```

## 📝 Padrões de Código

### 1. Nomenclatura

#### Classes
```dart
// ✅ Correto - PascalCase
class UserProfileRepository {}
class AuthenticationBloc {}

// ❌ Incorreto
class userProfileRepository {}
class authentication_bloc {}
```

#### Métodos e Variáveis
```dart
// ✅ Correto - camelCase
void signInWithGoogle() {}
final String userId = '';

// ❌ Incorreto
void SignInWithGoogle() {}
final String user_id = '';
```

#### Constantes
```dart
// ✅ Correto - SCREAMING_SNAKE_CASE
static const String API_BASE_URL = 'https://api.example.com';
static const int MAX_RETRY_ATTEMPTS = 3;
```

#### Arquivos
```dart
// ✅ Correto - snake_case
user_profile_repository.dart
authentication_bloc.dart

// ❌ Incorreto
UserProfileRepository.dart
authenticationBloc.dart
```

### 2. Estrutura de Classes

#### Repository
```dart
class UserRepositoryImpl extends BaseRepository implements UserRepository {
  const UserRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore, _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<Result<User>> getUser(String userId) async {
    return executeOperation(
      operation: () async {
        // implementação
      },
      operationName: 'getUser',
    );
  }
}
```

#### BLoC
```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,
  }) : _userRepository = userRepository,
       super(const UserInitial()) {
    on<UserLoadRequested>(_handleLoadUser);
    on<UserUpdateRequested>(_handleUpdateUser);
  }

  final UserRepository _userRepository;

  void _handleLoadUser(
    UserLoadRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    
    final result = await _userRepository.getUser(event.userId);
    
    if (result.isSuccess) {
      emit(UserLoaded(result.data));
    } else {
      emit(UserError(result.error));
    }
  }
}
```

### 3. Comentários e Documentação

#### Comentários de Classe
```dart
/// Repository responsável pela gestão de perfis de usuário.
/// 
/// Fornece operações CRUD para perfis de usuário no Firestore,
/// incluindo validação de dados e tratamento de erros.
class UserProfileRepository extends BaseRepository {
  // implementação
}
```

#### Comentários de Método
```dart
/// Atualiza o perfil do usuário no Firestore.
/// 
/// [profile] deve conter todos os campos obrigatórios.
/// Retorna [Success] com void em caso de sucesso,
/// ou [Failure] com mensagem de erro em caso de falha.
/// 
/// Throws [ArgumentError] se [profile.id] for vazio.
Future<Result<void>> updateUserProfile(UserProfile profile) async {
  if (profile.id.isEmpty) {
    throw ArgumentError('User profile ID cannot be empty');
  }
  
  return executeOperation(
    operation: () async {
      // implementação
    },
    operationName: 'updateUserProfile',
  );
}
```

## 🆕 Adicionando Novos Features

### 1. Criar uma Nova Entidade

#### Passo 1: Domain Entity
```dart
// lib/domain/entities/patient.dart
class Patient extends Equatable {
  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final int age;
  final Gender gender;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, name, age, gender, notes, createdAt, updatedAt];
}
```

#### Passo 2: Data Model
```dart
// lib/data/models/patient_model.dart
class PatientModel extends Patient {
  const PatientModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PatientModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PatientModel(
      id: doc.id,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      gender: Gender.fromString(data['gender'] ?? 'O'),
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'age': age,
      'gender': gender.value,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### 2. Criar Repository

#### Passo 1: Interface
```dart
// lib/domain/repositories/patient_repository.dart
abstract class PatientRepository {
  Future<Result<List<Patient>>> getPatients(String userId);
  Future<Result<Patient>> getPatient(String patientId);
  Future<Result<Patient>> createPatient(Patient patient);
  Future<Result<void>> updatePatient(Patient patient);
  Future<Result<void>> deletePatient(String patientId);
  Stream<List<Patient>> watchPatients(String userId);
}
```

#### Passo 2: Implementação
```dart
// lib/data/repositories/patient_repository_impl.dart
class PatientRepositoryImpl extends BaseRepository implements PatientRepository {
  const PatientRepositoryImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<Result<List<Patient>>> getPatients(String userId) async {
    return executeOperation(
      operation: () async {
        final snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('patients')
            .orderBy('createdAt', descending: true)
            .get();

        return snapshot.docs
            .map((doc) => PatientModel.fromFirestore(doc))
            .toList();
      },
      operationName: 'getPatients',
    );
  }

  @override
  Future<Result<Patient>> createPatient(Patient patient) async {
    return executeOperation(
      operation: () async {
        final docRef = _firestore
            .collection('users')
            .doc(patient.ownerId)
            .collection('patients')
            .doc();

        final patientModel = PatientModel(
          id: docRef.id,
          name: patient.name,
          age: patient.age,
          gender: patient.gender,
          notes: patient.notes,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await docRef.set(patientModel.toFirestore());
        return patientModel;
      },
      operationName: 'createPatient',
    );
  }
}
```

### 3. Criar BLoC

#### Passo 1: Events
```dart
// lib/presentation/blocs/patient_event.dart
abstract class PatientEvent extends Equatable {
  const PatientEvent();
}

class PatientLoadRequested extends PatientEvent {
  const PatientLoadRequested(this.userId);
  final String userId;
  @override
  List<Object> get props => [userId];
}

class PatientCreateRequested extends PatientEvent {
  const PatientCreateRequested(this.patient);
  final Patient patient;
  @override
  List<Object> get props => [patient];
}
```

#### Passo 2: States
```dart
// lib/presentation/blocs/patient_state.dart
abstract class PatientState extends Equatable {
  const PatientState();
}

class PatientInitial extends PatientState {
  const PatientInitial();
  @override
  List<Object> get props => [];
}

class PatientLoading extends PatientState {
  const PatientLoading();
  @override
  List<Object> get props => [];
}

class PatientLoaded extends PatientState {
  const PatientLoaded(this.patients);
  final List<Patient> patients;
  @override
  List<Object> get props => [patients];
}

class PatientError extends PatientState {
  const PatientError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
```

#### Passo 3: BLoC
```dart
// lib/presentation/blocs/patient_bloc.dart
class PatientBloc extends Bloc<PatientEvent, PatientState> {
  PatientBloc({
    required PatientRepository patientRepository,
  }) : _patientRepository = patientRepository,
       super(const PatientInitial()) {
    on<PatientLoadRequested>(_handleLoadPatients);
    on<PatientCreateRequested>(_handleCreatePatient);
  }

  final PatientRepository _patientRepository;

  void _handleLoadPatients(
    PatientLoadRequested event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    
    final result = await _patientRepository.getPatients(event.userId);
    
    if (result.isSuccess) {
      emit(PatientLoaded(result.data));
    } else {
      emit(PatientError(result.error));
    }
  }

  void _handleCreatePatient(
    PatientCreateRequested event,
    Emitter<PatientState> emit,
  ) async {
    final result = await _patientRepository.createPatient(event.patient);
    
    if (result.isSuccess) {
      // Recarregar lista de pacientes
      add(PatientLoadRequested(event.patient.ownerId));
    } else {
      emit(PatientError(result.error));
    }
  }
}
```

### 4. Registrar no DI

```dart
// lib/core/di/repositories_module.dart
class RepositoriesModule {
  static Future<void> register(GetIt sl) async {
    // ... outros repositories

    // Patient Repository
    sl.registerLazySingleton<PatientRepository>(
      () => PatientRepositoryImpl(
        firestore: sl<FirebaseFirestore>(),
      ),
    );
  }
}

// lib/core/di/blocs_module.dart
class BlocsModule {
  static Future<void> register(GetIt sl) async {
    // ... outros blocs

    // Patient BLoC
    sl.registerFactory<PatientBloc>(
      () => PatientBloc(
        patientRepository: sl<PatientRepository>(),
      ),
    );
  }
}
```

### 5. Criar Testes

#### Repository Test
```dart
// test/unit/repositories/patient_repository_test.dart
void main() {
  group('PatientRepository', () {
    late PatientRepository repository;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      repository = PatientRepositoryImpl(firestore: mockFirestore);
    });

    group('getPatients', () {
      test('should return Success with patients list when successful', () async {
        // Arrange
        when(mockFirestore.collection(any).doc(any).collection(any).orderBy(any, descending: true).get())
            .thenAnswer((_) async => mockQuerySnapshot);

        // Act
        final result = await repository.getPatients('userId');

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, isA<List<Patient>>());
      });
    });
  });
}
```

#### BLoC Test
```dart
// test/unit/blocs/patient_bloc_test.dart
void main() {
  group('PatientBloc', () {
    late PatientBloc patientBloc;
    late MockPatientRepository mockPatientRepository;

    setUp(() {
      mockPatientRepository = MockPatientRepository();
      patientBloc = PatientBloc(patientRepository: mockPatientRepository);
    });

    tearDown(() {
      patientBloc.close();
    });

    blocTest<PatientBloc, PatientState>(
      'emits [PatientLoading, PatientLoaded] when load succeeds',
      build: () {
        when(mockPatientRepository.getPatients(any))
            .thenAnswer((_) async => Success([mockPatient]));
        return patientBloc;
      },
      act: (bloc) => bloc.add(const PatientLoadRequested('userId')),
      expect: () => [
        const PatientLoading(),
        PatientLoaded([mockPatient]),
      ],
    );
  });
}
```

## 🧪 Testes

### Estrutura de Testes

```
test/
├── unit/              # Testes unitários
│   ├── blocs/        # Testes de BLoCs
│   ├── repositories/ # Testes de repositories
│   ├── services/     # Testes de services
│   └── models/       # Testes de models
├── widget/           # Testes de widgets
├── integration/      # Testes de integração
└── golden/          # Golden tests
```

### Executar Testes

```bash
# Todos os testes
flutter test

# Testes com cobertura
flutter test --coverage

# Testes específicos
flutter test test/unit/blocs/
flutter test test/widget/

# Testes com watch mode
flutter test --watch
```

### Padrões de Teste

#### 1. Use AAA Pattern
```dart
test('should return success when operation completes', () async {
  // Arrange
  when(mockRepository.getUser(any))
      .thenAnswer((_) async => Success(mockUser));

  // Act
  final result = await useCase.call('userId');

  // Assert
  expect(result.isSuccess, true);
  expect(result.data, equals(mockUser));
});
```

#### 2. Teste Comportamentos, Não Implementação
```dart
// ✅ Correto - testa comportamento
test('should emit loading then success when user is loaded', () async {
  // teste o que o usuário vê
});

// ❌ Incorreto - testa implementação interna
test('should call repository.getUser with correct parameters', () async {
  // teste implementação interna
});
```

#### 3. Nomes Descritivos
```dart
// ✅ Correto
test('should return failure when network is unavailable', () async {});

// ❌ Incorreto
test('test user loading', () async {});
```

## 🎨 UI/UX Guidelines

### Material 3 Design System

O projeto usa Material 3 (Material You) como base do design system.

#### Cores
```dart
// Definidas em lib/core/theme/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF625B71);
  // ...
}
```

#### Tipografia
```dart
// Definida em lib/core/theme/app_text_styles.dart
class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  // ...
}
```

### Componentes Reutilizáveis

#### 1. Buttons
```dart
// lib/presentation/widgets/common/app_button.dart
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.filled,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    // implementação
  }
}
```

#### 2. Loading States
```dart
// lib/presentation/widgets/common/loading_widget.dart
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message = 'Carregando...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
```

### Navegação

Use o sistema de rotas nomeadas:

```dart
// lib/core/routing/app_routes.dart
class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String patientDetails = '/patient/:id';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
```

## 🔧 Ferramentas Úteis

### VS Code Extensions
- Flutter
- Dart
- Flutter BLoC (snippets)
- GitLens
- Error Lens
- Dart Data Class Generator

### Snippets Úteis

#### BLoC Event
```dart
class $NAME$Event extends Equatable {
  const $NAME$Event($PARAMS$);
  $FIELDS$
  @override
  List<Object> get props => [$PROPS$];
}
```

#### Repository Method
```dart
@override
Future<Result<$TYPE$>> $METHOD_NAME$($PARAMS$) async {
  return executeOperation(
    operation: () async {
      $IMPLEMENTATION$
    },
    operationName: '$METHOD_NAME$',
  );
}
```

### Scripts Úteis

```bash
# Formatação automática
dart format .

# Análise de código
flutter analyze

# Geração de cobertura
flutter test --coverage
python3 scripts/calculate_coverage.py

# Build release
flutter build apk --release
```

## 📋 Checklist para PRs

### Antes de Criar PR
- [ ] Testes passando (`flutter test`)
- [ ] Código formatado (`dart format .`)
- [ ] Sem warnings (`flutter analyze`)
- [ ] Documentação atualizada
- [ ] Cobertura de testes mantida/melhorada

### Estrutura do PR
```markdown
## 📝 Descrição
Breve descrição das mudanças implementadas.

## 🎯 Tipo de Mudança
- [ ] Bug fix
- [ ] Nova feature
- [ ] Breaking change
- [ ] Documentação

## 🧪 Testes
- [ ] Testes unitários adicionados/atualizados
- [ ] Testes de widget adicionados/atualizados
- [ ] Testado manualmente

## 📸 Screenshots (se aplicável)
Capturas de tela das mudanças visuais.

## ✅ Checklist
- [ ] Código segue os padrões do projeto
- [ ] Auto-revisão realizada
- [ ] Documentação atualizada
- [ ] Sem console.log/prints desnecessários
```

## 🚀 Deploy

### Ambiente de Desenvolvimento
```bash
# Configurar Firebase para dev
./scripts/configure-firebase-security.ps1 -Environment dev

# Build para desenvolvimento
flutter build apk --dart-define=FIREBASE_ENV=dev
```

### Ambiente de Produção
```bash
# Configurar Firebase para produção
./scripts/configure-firebase-security.ps1 -Environment prod

# Build para produção
flutter build apk --release --dart-define=FIREBASE_ENV=prod
```

## 🆘 Troubleshooting

### Problemas Comuns

#### 1. Firebase não inicializa
```
Solução: Verificar se firebase_options.dart está configurado
e se Firebase.initializeApp() é chamado no main().
```

#### 2. DI não encontra dependência
```
Solução: Verificar se a dependência foi registrada no módulo
correto em injection_container.dart.
```

#### 3. BLoC não emite estados
```
Solução: Verificar se o event handler está registrado
no construtor do BLoC com on<EventType>().
```

#### 4. Testes falhando
```
Solução: Verificar se todos os mocks estão configurados
e se as dependências estão sendo injetadas corretamente.
```

## 📞 Suporte

Para dúvidas ou problemas:
1. Consultar documentação técnica em `/docs`
2. Verificar issues conhecidos no GitHub
3. Entrar em contato com a equipe de desenvolvimento

---

**Mantenha este guia atualizado conforme o projeto evolui!**