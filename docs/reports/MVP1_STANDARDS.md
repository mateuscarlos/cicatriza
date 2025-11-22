# MVP1 - Padrões e Convenções Implementadas

## 1. Arquitetura

### 1.1 Padrão BLoC
- **Eventos**: Nomes começam com verbo de ação (Load, Create, Update, Delete, Search)
- **Estados**: Sufixo com "State" (LoadingState, LoadedState, ErrorState, SuccessState)
- **BLoCs**: Um por entidade principal (PatientBloc, WoundBloc, AssessmentBloc)

### 1.2 Estrutura de Pastas
```
lib/
├── core/
│   ├── constants/       # Constantes globais
│   ├── di/             # Dependency injection (GetIt)
│   ├── routing/        # Sistema de rotas
│   ├── theme/          # Tema Material 3
│   └── utils/          # Utilitários
├── data/
│   ├── datasources/    # Fontes de dados (Firebase, Isar)
│   ├── models/         # Modelos de dados (DTOs)
│   └── repositories/   # Implementações de repositórios
├── domain/
│   ├── entities/       # Entidades de negócio
│   ├── repositories/   # Interfaces de repositórios
│   └── usecases/       # Casos de uso
└── presentation/
    ├── blocs/          # Gerenciamento de estado
    ├── pages/          # Telas completas
    └── widgets/        # Componentes reutilizáveis
```

---

## 2. Nomenclatura

### 2.1 Língua
- **Domínio clínico**: Português (paciente, ferida, avaliação)
- **Código técnico**: Inglês (bloc, state, event)
- **UI**: Português para usuário final

### 2.2 Convenções de Nomes
- **Classes**: PascalCase (`PatientBloc`, `WoundsListPage`)
- **Arquivos**: snake_case (`patient_bloc.dart`, `wounds_list_page.dart`)
- **Variáveis**: camelCase (`patientId`, `woundLocation`)
- **Constantes**: camelCase para rotas (`AppRoutes.patients`)

### 2.3 Sufixos Específicos
- Telas: `Page` (PacientesListPage)
- Widgets: descritivo (FormSection, NumberField)
- BLoCs: `Bloc` (PatientBloc)
- Estados: `State` (PatientLoadedState)
- Eventos: descrição da ação (LoadPatients, CreateWound)

---

## 3. UI/UX

### 3.1 Material 3 Design System
- Componentes nativos do Material 3
- Theme configurado em `app_theme.dart`
- Cores: scheme gerado do `seedColor: Color(0xFF007D3D)` (verde institucional)

### 3.2 Componentes Padrão

#### AppBar
```dart
AppBar(
  title: Text('Título'),
  // centerTitle: true para MVP
)
```

#### FAB (Floating Action Button)
```dart
FloatingActionButton.extended(
  onPressed: () {},
  icon: Icon(Icons.add),
  label: Text('Nova [Entidade]'),
)
```

#### Cards
```dart
Card(
  child: InkWell(
    onTap: () {},
    child: Padding(
      padding: EdgeInsets.all(16),
      child: // conteúdo
    ),
  ),
)
```

#### Dialogs
- `showDialog` para criação rápida
- Formulários em dialogs para MVP
- Botões: "Cancelar" (TextButton) e "Salvar" (ElevatedButton)

### 3.3 Feedback Visual

#### Loading
```dart
// Lista vazia com loading
if (state is LoadingState)
  Center(child: CircularProgressIndicator())
```

#### Mensagens
```dart
// Sucesso
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Operação realizada com sucesso'),
    backgroundColor: Colors.green,
  ),
)

// Erro
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Erro: ${error.message}'),
    backgroundColor: Colors.red,
  ),
)
```

#### Estados Vazios
```dart
// Lista vazia
Center(
  child: Text(
    'Nenhum registro encontrado',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)
```

---

## 4. Navegação

### 4.1 Named Routes
- Definidas em `app_routes.dart`
- Constantes para type-safety
- `onGenerateRoute` para argumentos tipados

```dart
// Navegação simples
Navigator.pushNamed(context, AppRoutes.patients);

// Com argumentos
Navigator.pushNamed(
  context,
  AppRoutes.wounds,
  arguments: patient,
);

// Substituir (ex: após login)
Navigator.pushReplacementNamed(context, AppRoutes.patients);
```

### 4.2 Estrutura de Rotas
```dart
class AppRoutes {
  static const String login = '/login';
  static const String patients = '/patients';
  static const String wounds = '/wounds';
  static const String assessmentCreate = '/assessment/create';
}
```

---

## 5. Gerenciamento de Estado

### 5.1 BLoC Pattern

#### Eventos
```dart
abstract class EntityEvent extends Equatable {}

class LoadEntity extends EntityEvent {
  @override
  List<Object?> get props => [];
}
```

#### Estados
```dart
abstract class EntityState extends Equatable {}

class EntityInitialState extends EntityState {
  @override
  List<Object?> get props => [];
}

class EntityLoadingState extends EntityState {
  @override
  List<Object?> get props => [];
}

class EntityLoadedState extends EntityState {
  final List<Entity> entities;
  
  EntityLoadedState(this.entities);
  
  @override
  List<Object?> get props => [entities];
}
```

#### BLoC
```dart
class EntityBloc extends Bloc<EntityEvent, EntityState> {
  final EntityRepository repository;
  
  EntityBloc(this.repository) : super(EntityInitialState()) {
    on<LoadEntity>(_onLoadEntity);
  }
  
  Future<void> _onLoadEntity(
    LoadEntity event,
    Emitter<EntityState> emit,
  ) async {
    emit(EntityLoadingState());
    try {
      final entities = await repository.getAll();
      emit(EntityLoadedState(entities));
    } catch (e) {
      emit(EntityErrorState(e.toString()));
    }
  }
}
```

### 5.2 Provider no main.dart
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => sl<PatientBloc>()..add(LoadPatients())),
    BlocProvider(create: (_) => sl<WoundBloc>()),
    BlocProvider(create: (_) => sl<AssessmentBloc>()),
  ],
  child: MaterialApp(...),
)
```

---

## 6. Validações

### 6.1 Regras de Negócio (M1)

#### Dor
- **Tipo**: Inteiro
- **Range**: 0 a 10
- **Obrigatório**: Sim
- **Implementação**: Slider com steps

#### Medições (comprimento, largura, profundidade)
- **Tipo**: Decimal (double)
- **Validação**: > 0
- **Unidade**: cm
- **Obrigatório**: Sim
- **Implementação**: NumberField

#### Data
- **Tipo**: DateTime
- **Validação**: ≤ hoje
- **Obrigatório**: Sim
- **Implementação**: DatePicker

### 6.2 Campos de Formulário
```dart
// Exemplo: NumberField
NumberField(
  label: 'Comprimento',
  suffix: 'cm',
  value: lengthCm,
  onChanged: (v) => lengthCm = v,
  min: 0.1,
  decimals: 1,
  required: true,
)
```

---

## 7. Componentes Reutilizáveis

### 7.1 FormSection
**Propósito**: Agrupar campos de formulário com título

```dart
FormSection(
  title: 'Medições',
  children: [
    NumberField(...),
    NumberField(...),
  ],
)
```

### 7.2 NumberField
**Propósito**: Input numérico com validação

```dart
NumberField(
  label: 'Campo',
  suffix: 'unidade',
  value: valor,
  onChanged: (v) => setState(() => valor = v),
  min: 0,
  max: 100,
  decimals: 2,
  required: true,
)
```

### 7.3 PainSlider
**Propósito**: Slider visual para escala de dor 0-10

```dart
PainSlider(
  value: painLevel,
  onChanged: (v) => setState(() => painLevel = v),
)
```

**Feedback visual:**
- 0-2: Verde (sem dor - leve)
- 3-5: Amarelo (moderada)
- 6-8: Laranja (intensa)
- 9-10: Vermelho (insuportável)

---

## 8. Dependency Injection

### 8.1 GetIt (sl - Service Locator)
```dart
// Registro em di/injection.dart
sl.registerLazySingleton(() => PatientBloc(sl()));
sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryMock());

// Uso
final bloc = sl<PatientBloc>();
```

### 8.2 Ordem de Registro
1. Repositories (data layer)
2. BLoCs (presentation layer)

---

## 9. Tratamento de Erros

### 9.1 Try-Catch em BLoCs
```dart
try {
  // operação
  emit(SuccessState());
} catch (e) {
  emit(ErrorState(e.toString()));
}
```

### 9.2 Listener na UI
```dart
BlocListener<EntityBloc, EntityState>(
  listener: (context, state) {
    if (state is EntityErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${state.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (state is EntityOperationSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  },
  child: // ...
)
```

---

## 10. Mock Data (MVP1)

### 10.1 Repositories Mock
Para o MVP, repositórios usam listas em memória:

```dart
class PatientRepositoryMock implements PatientRepository {
  final List<PatientManual> _patients = [];
  
  @override
  Stream<List<PatientManual>> getPatients() {
    return Stream.value(_patients);
  }
  
  @override
  Future<void> createPatient(PatientManual patient) async {
    _patients.add(patient);
  }
}
```

### 10.2 Modelos Simplificados
Entidades com propriedades essenciais:

```dart
class PatientManual {
  final String id;
  final String name;
  final DateTime birthDate;
  // ...
}
```

---

## 11. Testes (Planejamento)

### 11.1 Unit Tests
- [ ] Validadores (pain, measurements, date)
- [ ] Cálculo de idade
- [ ] Formatações

### 11.2 Widget Tests
- [ ] FormSection renderização
- [ ] NumberField validações
- [ ] PainSlider interações

### 11.3 BLoC Tests
- [ ] Estados corretos emitidos
- [ ] Tratamento de erros
- [ ] Fluxo de eventos

### 11.4 Integration Tests
- [ ] Fluxo login → paciente → ferida → avaliação
- [ ] CRUD completo de cada entidade

---

## 12. Observações do MVP1

### Implementado
✅ Navegação completa entre telas
✅ BLoC pattern em todas as features
✅ Componentes reutilizáveis
✅ Validações de negócio
✅ Material 3 Design System
✅ Feedback visual (loading, success, error)
✅ Dependency injection

### Simulado/Mock
⚠️ Autenticação (navegação direta)
⚠️ Persistência (listas em memória)
⚠️ Repositories (mock sem Firebase/Isar)

### Não Implementado (Backlog)
❌ Firebase Authentication
❌ Firestore integration
❌ Isar offline storage
❌ Sync layer
❌ Upload de fotos
❌ Edição de registros
❌ Exclusão de registros
❌ Testes automatizados

---

## 13. Checklist de Qualidade

### Para cada nova feature:
- [ ] Seguir arquitetura em camadas
- [ ] Implementar BLoC com estados adequados
- [ ] Criar eventos com nomes descritivos
- [ ] Adicionar tratamento de erros
- [ ] Implementar feedback visual
- [ ] Usar componentes reutilizáveis
- [ ] Seguir padrões de nomenclatura
- [ ] Validar inputs do usuário
- [ ] Testar fluxo completo manualmente

### Code Review Checklist:
- [ ] Código legível e organizado
- [ ] Nomenclatura consistente
- [ ] Sem código duplicado
- [ ] Tratamento adequado de erros
- [ ] Estados de loading/error/success
- [ ] Navegação funcional
- [ ] UI responsiva
- [ ] Feedback ao usuário

---

**Última atualização:** MVP1
**Próxima revisão:** M1 Completo

