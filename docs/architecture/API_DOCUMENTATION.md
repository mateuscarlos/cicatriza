# Documentação Técnica - APIs e Arquitetura

## 🏗️ Visão Geral da Arquitetura

O projeto Cicatriza segue os princípios da **Clean Architecture** com uma implementação modular baseada em camadas bem definidas:

```
lib/
├── core/           # Núcleo da aplicação (infraestrutura)
├── data/           # Camada de dados (adapters)
├── domain/         # Camada de domínio (regras de negócio)
└── presentation/   # Camada de apresentação (UI)
```

## 🔄 Result Pattern

### Implementação Base

Todas as operações que podem falhar utilizam o **Result Pattern** para tratamento de erros consistente:

```dart
// Definição do Result<T>
abstract class Result<T> {
  const Result();
  
  bool get isSuccess;
  bool get isFailure;
  T get data;
  String get error;
}

class Success<T> extends Result<T> {
  const Success(this._data);
  final T _data;
  
  @override
  bool get isSuccess => true;
  @override
  bool get isFailure => false;
  @override
  T get data => _data;
  @override
  String get error => throw StateError('Success result has no error');
}

class Failure<T> extends Result<T> {
  const Failure(this._error);
  final String _error;
  
  @override
  bool get isSuccess => false;
  @override
  bool get isFailure => true;
  @override
  T get data => throw StateError('Failure result has no data');
  @override
  String get error => _error;
}
```

### Exemplo de Uso

```dart
// No Repository
Future<Result<User>> signInWithEmail(String email, String password) async {
  return executeOperation(
    operation: () async {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return User.fromFirebase(userCredential.user!);
    },
    operationName: 'signInWithEmail',
  );
}

// No BLoC
void _handleSignIn(AuthSignInRequested event, Emitter<AuthState> emit) async {
  emit(const AuthLoading());
  
  final result = await _authRepository.signInWithEmail(
    event.email,
    event.password,
  );
  
  if (result.isSuccess) {
    emit(AuthAuthenticated(result.data));
  } else {
    emit(AuthError(result.error));
  }
}
```

## 🏛️ BaseRepository

### Funcionalidades

O `BaseRepository` fornece uma base comum para todos os repositórios:

```dart
abstract class BaseRepository {
  const BaseRepository();

  /// Executa uma operação com tratamento de erro padronizado
  @protected
  Future<Result<T>> executeOperation<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      AppLogger.info('Iniciando operação: $operationName');
      
      final result = await operation();
      
      stopwatch.stop();
      AppLogger.info(
        'Operação "$operationName" concluída com sucesso em ${stopwatch.elapsedMilliseconds}ms'
      );
      
      return Success(result);
    } catch (e, stackTrace) {
      stopwatch.stop();
      final errorMessage = _extractErrorMessage(e);
      
      AppLogger.error(
        'Falha na operação "$operationName" após ${stopwatch.elapsedMilliseconds}ms: $errorMessage',
        error: e,
        stackTrace: stackTrace,
      );
      
      return Failure(errorMessage);
    }
  }

  /// Valida se um email é válido
  @protected
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Valida se uma senha atende aos critérios mínimos
  @protected
  bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
```

### Benefícios

1. **Consistência**: Tratamento de erro padronizado
2. **Observabilidade**: Logging automático com métricas
3. **Reutilização**: Validações comuns centralizadas
4. **Manutenibilidade**: Mudanças de infraestrutura em um local

## 🗂️ Repositories

### AuthRepository

**Interface**: `lib/domain/repositories/auth_repository.dart`
```dart
abstract class AuthRepository {
  Stream<User?> get userStream;
  User? get currentUser;
  
  Future<Result<User>> signInWithGoogle();
  Future<Result<User>> signInWithEmailAndPassword(String email, String password);
  Future<Result<User>> signUpWithEmailAndPassword(String email, String password);
  Future<Result<void>> signOut();
  Future<Result<void>> deleteAccount();
}
```

**Implementação**: `lib/data/repositories/auth_repository_impl.dart`

#### Métodos Principais:

##### `signInWithGoogle()`
```dart
@override
Future<Result<User>> signInWithGoogle() async {
  return executeOperation(
    operation: () async {
      // Iniciar processo de autenticação Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Login com Google cancelado pelo usuário');
      }

      // Obter credenciais de autenticação
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autenticar no Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        throw Exception('Falha na autenticação com Firebase');
      }

      // Criar/atualizar perfil no Firestore
      await _createOrUpdateUserProfile(firebaseUser);

      return User.fromFirebase(firebaseUser);
    },
    operationName: 'signInWithGoogle',
  );
}
```

##### `signInWithEmailAndPassword()`
```dart
@override
Future<Result<User>> signInWithEmailAndPassword(String email, String password) async {
  return executeOperation(
    operation: () async {
      // Validações
      if (!isValidEmail(email)) {
        throw Exception('Email inválido');
      }
      if (!isValidPassword(password)) {
        throw Exception('Senha deve ter pelo menos 6 caracteres');
      }

      // Autenticação
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Falha na autenticação');
      }

      return User.fromFirebase(firebaseUser);
    },
    operationName: 'signInWithEmailAndPassword',
  );
}
```

### UserProfileRepository

**Interface**: `lib/domain/repositories/user_profile_repository.dart`
```dart
abstract class UserProfileRepository {
  Future<Result<UserProfile>> getUserProfile(String userId);
  Future<Result<void>> updateUserProfile(UserProfile profile);
  Future<Result<void>> deleteUserProfile(String userId);
  Stream<UserProfile?> watchUserProfile(String userId);
}
```

#### Métodos Principais:

##### `getUserProfile()`
```dart
@override
Future<Result<UserProfile>> getUserProfile(String userId) async {
  return executeOperation(
    operation: () async {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (!doc.exists) {
        throw Exception('Perfil do usuário não encontrado');
      }
      
      return UserProfile.fromFirestore(doc);
    },
    operationName: 'getUserProfile',
  );
}
```

##### `updateUserProfile()`
```dart
@override
Future<Result<void>> updateUserProfile(UserProfile profile) async {
  return executeOperation(
    operation: () async {
      final data = profile.toFirestore();
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('users').doc(profile.id).update(data);
    },
    operationName: 'updateUserProfile',
  );
}
```

## 🎭 BLoCs (Business Logic Components)

### AuthBloc

**Estados**: `lib/presentation/blocs/auth_state.dart`
```dart
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final User user;
  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
```

**Eventos**: `lib/presentation/blocs/auth_event.dart`
```dart
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
  @override
  List<Object> get props => [];
}

class AuthSignInWithGoogleRequested extends AuthEvent {
  const AuthSignInWithGoogleRequested();
  @override
  List<Object> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;
  @override
  List<Object> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
  @override
  List<Object> get props => [];
}
```

**BLoC**: `lib/presentation/blocs/auth_bloc.dart`

#### Handlers Principais:

##### `_handleSignInWithGoogle()`
```dart
void _handleSignInWithGoogle(
  AuthSignInWithGoogleRequested event,
  Emitter<AuthState> emit,
) async {
  emit(const AuthLoading());
  
  final result = await _authRepository.signInWithGoogle();
  
  if (result.isSuccess) {
    emit(AuthAuthenticated(result.data));
  } else {
    emit(AuthError(result.error));
  }
}
```

##### `_handleSignIn()`
```dart
void _handleSignIn(
  AuthSignInRequested event,
  Emitter<AuthState> emit,
) async {
  emit(const AuthLoading());
  
  final result = await _authRepository.signInWithEmailAndPassword(
    event.email,
    event.password,
  );
  
  if (result.isSuccess) {
    emit(AuthAuthenticated(result.data));
  } else {
    emit(AuthError(result.error));
  }
}
```

## 🔌 Services

### Estrutura de Services

Os services encapsulam lógica de negócio específica e integração com APIs externas:

```dart
// lib/core/services/app_check_service.dart
class AppCheckService {
  static Future<void> initialize() async {
    final config = FirebaseEnvironmentConfig.getConfigForCurrentEnvironment(
      FirebaseEnvironmentConfig.appCheckConfig,
    );
    
    if (config['provider'] == 'debug') {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.deviceCheck,
      );
    }
  }
}
```

## 🏭 Dependency Injection

### Estrutura Modular

O DI é organizado em módulos especializados usando GetIt:

```dart
// lib/core/di/injection_container.dart
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Registrar módulos em ordem de dependência
  await FirebaseModule.register(sl);
  await ServicesModule.register(sl);
  await RepositoriesModule.register(sl);
  await BlocsModule.register(sl);
  
  AppLogger.info('Todas as dependências inicializadas com sucesso');
}
```

### Módulos Específicos:

#### FirebaseModule
```dart
class FirebaseModule {
  static Future<void> register(GetIt sl) async {
    // Validar configuração
    if (!FirebaseEnvironmentConfig.validateConfiguration()) {
      throw Exception('Configuração Firebase inválida');
    }

    // Registrar serviços Firebase
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    
    // Configurar Google Sign In
    await _registerGoogleSignIn(sl);
  }
}
```

#### RepositoriesModule
```dart
class RepositoriesModule {
  static Future<void> register(GetIt sl) async {
    // Auth Repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        firebaseAuth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
        googleSignIn: sl<GoogleSignIn>(),
      ),
    );

    // User Profile Repository
    sl.registerLazySingleton<UserProfileRepository>(
      () => UserProfileRepositoryImpl(
        firestore: sl<FirebaseFirestore>(),
      ),
    );
  }
}
```

#### BlocsModule
```dart
class BlocsModule {
  static Future<void> register(GetIt sl) async {
    // Auth BLoC
    sl.registerFactory<AuthBloc>(
      () => AuthBloc(authRepository: sl<AuthRepository>()),
    );

    // Patient BLoC
    sl.registerFactory<PatientBloc>(
      () => PatientBloc(patientRepository: sl<PatientRepository>()),
    );
  }
}
```

## 🧪 Testes

### Estrutura de Testes

```
test/
├── unit/           # Testes unitários
│   ├── blocs/     # Testes de BLoCs
│   ├── repositories/ # Testes de repositories
│   └── services/  # Testes de services
├── widget/        # Testes de widgets
├── integration/   # Testes de integração
└── golden/        # Golden tests (UI)
```

### Exemplo de Teste de Repository

```dart
// test/unit/repositories/auth_repository_test.dart
void main() {
  group('AuthRepository', () {
    late AuthRepository repository;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockGoogleSignIn mockGoogleSignIn;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockGoogleSignIn = MockGoogleSignIn();
      repository = AuthRepositoryImpl(
        firebaseAuth: mockFirebaseAuth,
        firestore: mockFirestore,
        googleSignIn: mockGoogleSignIn,
      );
    });

    group('signInWithGoogle', () {
      test('should return Success when authentication succeeds', () async {
        // Arrange
        final mockUser = MockUser();
        when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleUser);
        when(mockFirebaseAuth.signInWithCredential(any))
            .thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await repository.signInWithGoogle();

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, isA<User>());
      });

      test('should return Failure when user cancels', () async {
        // Arrange
        when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

        // Act
        final result = await repository.signInWithGoogle();

        // Assert
        expect(result.isFailure, true);
        expect(result.error, contains('cancelado'));
      });
    });
  });
}
```

### Exemplo de Teste de BLoC

```dart
// test/unit/blocs/auth_bloc_test.dart
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when sign in succeeds',
      build: () {
        when(mockAuthRepository.signInWithGoogle())
            .thenAnswer((_) async => Success(mockUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignInWithGoogleRequested()),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(mockUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when sign in fails',
      build: () {
        when(mockAuthRepository.signInWithGoogle())
            .thenAnswer((_) async => const Failure('Erro de autenticação'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignInWithGoogleRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthError('Erro de autenticação'),
      ],
    );
  });
}
```

## 🔐 Firebase Configuration

### Environment-Based Configuration

```dart
class FirebaseEnvironmentConfig {
  // Configurações por ambiente
  static FirebaseOptions get currentOptions {
    return isDevelopment ? _developmentOptions : _productionOptions;
  }
  
  // Validação de configuração
  static bool validateConfiguration() {
    try {
      final options = currentOptions;
      return options.projectId.isNotEmpty && 
             options.apiKey.isNotEmpty && 
             options.appId.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
```

### Security Rules (Firestore)

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    // Perfis de usuário - apenas o próprio usuário
    match /users/{uid} {
      allow read, write: if isOwner(uid) && isValidUserProfile(request.resource.data);
      
      // Pacientes do usuário
      match /patients/{patientId} {
        allow read, write: if isOwner(uid) && isValidPatient(request.resource.data);
        
        // Estrutura hierárquica para feridas e avaliações
        match /wounds/{woundId} {
          allow read, write: if isOwner(uid);
          
          match /assessments/{assessmentId} {
            allow read, write: if isOwner(uid);
          }
        }
      }
    }
  }
}
```

## 📊 Logging e Monitoramento

### AppLogger

```dart
class AppLogger {
  static void info(String message, {String name = 'Cicatriza'}) {
    developer.log(message, name: name, level: 800);
  }

  static void warning(String message, {String name = 'Cicatriza'}) {
    developer.log(message, name: name, level: 900);
  }

  static void error(
    String message, {
    String name = 'Cicatriza',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
```

## 🎯 Próximos Passos

1. **Documentar Domain Layer**: Entities, Value Objects, Use Cases
2. **Criar guias de desenvolvimento**: Como adicionar novos features
3. **Documentar padrões de UI**: Design System e componentes
4. **Adicionar diagramas de arquitetura**: UML e fluxos de dados
5. **Criar templates de código**: Snippets para VS Code

---

**Esta documentação é mantida automaticamente e reflete o estado atual da aplicação.**