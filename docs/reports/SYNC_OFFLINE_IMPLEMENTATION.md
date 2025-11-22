# Implementação de Sincronização Offline-First

## ✅ Estrutura Criada

### 1. **Dependências Adicionadas**
```yaml
dependencies:
  connectivity_plus: ^6.1.1  # Detecção de rede
  path_provider: ^2.1.5       # Acesso a diretórios

Já existentes:
  shared_preferences: ^2.5.3  # Armazenamento local
```

### 2. **Arquivos Criados**

#### `lib/data/models/assessment_local_model_v2.dart`
- ✅ Modelo com flag `isSynced`
- ✅ Métodos `toJson()` / `fromJson()` para SharedPreferences
- ✅ Métodos `toFirestore()` / `fromFirestore()` para Firestore

#### `lib/data/datasources/assessment_local_storage.dart`
- ✅ `saveAssessment()` - Salva localmente
- ✅ `getAssessmentsByWoundId()` - Lista avaliações
- ✅ `getUnsyncedAssessments()` - Retorna não sincronizadas
- ✅ `markAsSynced()` - Marca como sincronizada

#### `lib/core/services/connectivity_service.dart`
- ✅ `hasConnection()` - Verifica conectividade
- ✅ `onConnectivityChanged` - Stream de mudanças

---

## 🚀 Próximos Passos para Concluir

### 3. Criar Repositório Híbrido

Criar `lib/data/repositories/assessment_hybrid_repository.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/assessment_local_storage.dart';
import '../models/assessment_local_model_v2.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/assessment_manual.dart';

class AssessmentHybridRepository {
  final AssessmentLocalStorage _localStorage;
  final ConnectivityService _connectivityService;
  final FirebaseFirestore _firestore;

  AssessmentHybridRepository({
    required AssessmentLocalStorage localStorage,
    required ConnectivityService connectivityService,
    FirebaseFirestore? firestore,
  })  : _localStorage = localStorage,
        _connectivityService = connectivityService,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Cria avaliação (offline-first)
  Future<void> createAssessment(AssessmentManual assessment) async {
    // 1. Salvar localmente SEMPRE
    final localModel = _toLocalModel(assessment);
    await _localStorage.saveAssessment(localModel);

    // 2. Tentar sincronizar imediatamente se online
    if (await _connectivityService.hasConnection()) {
      try {
        await _syncAssessmentToFirestore(localModel);
        await _localStorage.markAsSynced(assessment.id);
      } catch (e) {
        // Se falhar, mantém local e tenta depois
        print('Erro ao sincronizar: $e');
      }
    }
  }

  /// Busca avaliações de uma lesão
  Future<List<AssessmentManual>> getAssessmentsByWoundId(String woundId) async {
    // Retorna dados locais
    final localModels = await _localStorage.getAssessmentsByWoundId(woundId);
    return localModels.map(_toEntity).toList();
  }

  /// Sincroniza avaliações pendentes
  Future<void> syncPendingAssessments() async {
    if (!await _connectivityService.hasConnection()) return;

    final unsyncedAssessments = await _localStorage.getUnsyncedAssessments();

    for (final assessment in unsyncedAssessments) {
      try {
        await _syncAssessmentToFirestore(assessment);
        await _localStorage.markAsSynced(assessment.id);
      } catch (e) {
        print('Erro ao sincronizar ${assessment.id}: $e');
      }
    }
  }

  /// Envia avaliação para Firestore
  Future<void> _syncAssessmentToFirestore(AssessmentLocalModel model) async {
    await _firestore
        .collection('assessments')
        .doc(model.id)
        .set(model.toFirestore());
  }

  /// Converte entity para modelo local
  AssessmentLocalModel _toLocalModel(AssessmentManual entity) {
    return AssessmentLocalModel(
      id: entity.id,
      woundId: entity.woundId,
      date: entity.date,
      painScale: entity.painScale,
      lengthCm: entity.lengthCm,
      widthCm: entity.widthCm,
      depthCm: entity.depthCm,
      woundBed: entity.woundBed,
      exudateType: entity.exudateType,
      edgeAppearance: entity.edgeAppearance,
      notes: entity.notes,
      isSynced: false,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converte modelo local para entity
  AssessmentManual _toEntity(AssessmentLocalModel model) {
    return AssessmentManual(
      id: model.id,
      woundId: model.woundId,
      date: model.date,
      painScale: model.painScale,
      lengthCm: model.lengthCm,
      widthCm: model.widthCm,
      depthCm: model.depthCm,
      woundBed: model.woundBed,
      exudateType: model.exudateType,
      edgeAppearance: model.edgeAppearance,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
```

### 4. Atualizar Dependency Injection

Em `lib/core/di/injection_container.dart`:

```dart
import '../services/connectivity_service.dart';
import '../../data/datasources/assessment_local_storage.dart';
import '../../data/repositories/assessment_hybrid_repository.dart';

void init() {
  // Services
  sl.registerLazySingleton(() => ConnectivityService());
  sl.registerLazySingleton(() => AssessmentLocalStorage());

  // Repositories
  sl.registerLazySingleton<AssessmentRepository>(
    () => AssessmentHybridRepository(
      localStorage: sl(),
      connectivityService: sl(),
    ),
  );

  // BLoCs
  sl.registerFactory(() => AssessmentBloc(assessmentRepository: sl()));
}
```

### 5. Adicionar Sincronização no Startup

Em `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Sincroniza avaliações pendentes ao abrir o app
  final assessmentRepo = sl<AssessmentRepository>();
  if (assessmentRepo is AssessmentHybridRepository) {
    assessmentRepo.syncPendingAssessments().catchError((e) {
      print('Erro na sincronização inicial: $e');
    });
  }

  runApp(const MyApp());
}
```

### 6. Monitorar Conectividade (Opcional)

Criar um widget global que sincroniza quando volta online:

```dart
class ConnectivityListener extends StatefulWidget {
  final Widget child;
  const ConnectivityListener({required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  late StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    final connectivityService = sl<ConnectivityService>();
    _subscription = connectivityService.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        // Sincroniza quando voltar online
        final assessmentRepo = sl<AssessmentRepository>();
        if (assessmentRepo is AssessmentHybridRepository) {
          assessmentRepo.syncPendingAssessments();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
```

---

## 🎯 Comportamento Final

### ✅ Ao Criar Avaliação:
1. **Salva localmente** (sempre)
2. **Tenta enviar para Firestore** (se online)
3. **Se offline:** Mantém localmente com flag `isSynced = false`

### ✅ Ao Abrir o App:
1. **Verifica conectividade**
2. **Sincroniza avaliações pendentes** (`isSynced = false`)
3. **Marca como sincronizadas** após sucesso

### ✅ Quando Volta Online:
1. **Detecta mudança de conectividade**
2. **Sincroniza automaticamente**

---

## 💡 Benefícios

- ✅ **App funciona offline**
- ✅ **Dados nunca são perdidos**
- ✅ **Sincronização automática**
- ✅ **User não precisa fazer nada**
- ✅ **Performance melhor** (dados locais primeiro)

---

## 🔧 Testando

1. **Modo Avião ON:** Criar avaliação → Salva localmente
2. **Modo Avião OFF:** Abrir app → Sincroniza automaticamente
3. **Verificar Firestore:** Dados aparecem após sync

---

Quer que eu continue implementando os arquivos restantes ou prefere revisar essa estrutura primeiro?
