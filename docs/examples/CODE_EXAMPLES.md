# Exemplos de Código - Cicatriza

## 🎯 Result Pattern - Exemplos Práticos

### Exemplo 1: Repository com Validação

```dart
// lib/data/repositories/patient_repository_impl.dart
class PatientRepositoryImpl extends BaseRepository implements PatientRepository {
  const PatientRepositoryImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<Result<Patient>> createPatient(Patient patient) async {
    return executeOperation(
      operation: () async {
        // Validações de negócio
        if (patient.name.trim().isEmpty) {
          throw ValidationException('Nome do paciente é obrigatório');
        }
        
        if (patient.age < 0 || patient.age > 150) {
          throw ValidationException('Idade deve estar entre 0 e 150 anos');
        }

        // Verificar se já existe paciente com mesmo nome para este usuário
        final existingPatient = await _firestore
            .collection('users')
            .doc(patient.ownerId)
            .collection('patients')
            .where('nameLowercase', isEqualTo: patient.name.toLowerCase())
            .get();

        if (existingPatient.docs.isNotEmpty) {
          throw BusinessException('Já existe um paciente com este nome');
        }

        // Criar documento no Firestore
        final docRef = _firestore
            .collection('users')
            .doc(patient.ownerId)
            .collection('patients')
            .doc();

        final now = DateTime.now();
        final patientData = {
          'name': patient.name.trim(),
          'nameLowercase': patient.name.trim().toLowerCase(),
          'age': patient.age,
          'gender': patient.gender.value,
          'notes': patient.notes?.trim(),
          'ownerId': patient.ownerId,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await docRef.set(patientData);

        // Retornar paciente criado
        return Patient(
          id: docRef.id,
          name: patient.name.trim(),
          age: patient.age,
          gender: patient.gender,
          notes: patient.notes?.trim(),
          ownerId: patient.ownerId,
          createdAt: now,
          updatedAt: now,
        );
      },
      operationName: 'createPatient',
    );
  }

  @override
  Future<Result<List<Patient>>> searchPatients(
    String userId,
    String searchQuery,
  ) async {
    return executeOperation(
      operation: () async {
        if (searchQuery.trim().isEmpty) {
          throw ValidationException('Termo de busca não pode estar vazio');
        }

        final query = searchQuery.toLowerCase().trim();
        
        // Buscar por nome (usando array-contains para busca parcial)
        final snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('patients')
            .where('nameLowercase', isGreaterThanOrEqualTo: query)
            .where('nameLowercase', isLessThan: query + '\uf8ff')
            .orderBy('nameLowercase')
            .limit(20)
            .get();

        return snapshot.docs
            .map((doc) => PatientModel.fromFirestore(doc))
            .toList();
      },
      operationName: 'searchPatients',
    );
  }
}
```

### Exemplo 2: BLoC com Múltiplos Estados

```dart
// lib/presentation/blocs/patient_bloc.dart
class PatientBloc extends Bloc<PatientEvent, PatientState> {
  PatientBloc({
    required PatientRepository patientRepository,
  }) : _patientRepository = patientRepository,
       super(const PatientInitial()) {
    on<PatientLoadRequested>(_handleLoadPatients);
    on<PatientCreateRequested>(_handleCreatePatient);
    on<PatientUpdateRequested>(_handleUpdatePatient);
    on<PatientDeleteRequested>(_handleDeletePatient);
    on<PatientSearchRequested>(_handleSearchPatients);
  }

  final PatientRepository _patientRepository;

  void _handleCreatePatient(
    PatientCreateRequested event,
    Emitter<PatientState> emit,
  ) async {
    // Preservar estado atual se já temos pacientes carregados
    final currentState = state;
    if (currentState is PatientLoaded) {
      emit(PatientLoaded(
        patients: currentState.patients,
        isCreating: true,
      ));
    } else {
      emit(const PatientCreating());
    }

    final result = await _patientRepository.createPatient(event.patient);

    if (result.isSuccess) {
      // Recarregar lista de pacientes após criação
      add(PatientLoadRequested(event.patient.ownerId));
      
      // Emitir evento de sucesso para mostrar feedback
      emit(const PatientCreateSuccess());
    } else {
      // Restaurar estado anterior e mostrar erro
      if (currentState is PatientLoaded) {
        emit(PatientLoaded(
          patients: currentState.patients,
          error: result.error,
        ));
      } else {
        emit(PatientError(result.error));
      }
    }
  }

  void _handleSearchPatients(
    PatientSearchRequested event,
    Emitter<PatientState> emit,
  ) async {
    // Manter estado de busca separado
    emit(const PatientSearching());

    final result = await _patientRepository.searchPatients(
      event.userId,
      event.searchQuery,
    );

    if (result.isSuccess) {
      emit(PatientSearchResults(
        patients: result.data,
        searchQuery: event.searchQuery,
      ));
    } else {
      emit(PatientSearchError(result.error));
    }
  }

  void _handleDeletePatient(
    PatientDeleteRequested event,
    Emitter<PatientState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PatientLoaded) return;

    // Otimistic update - remover da lista temporariamente
    final updatedPatients = currentState.patients
        .where((p) => p.id != event.patientId)
        .toList();
    
    emit(PatientLoaded(
      patients: updatedPatients,
      isDeleting: true,
    ));

    final result = await _patientRepository.deletePatient(event.patientId);

    if (result.isSuccess) {
      // Confirmar remoção
      emit(PatientLoaded(patients: updatedPatients));
    } else {
      // Restaurar estado anterior
      emit(PatientLoaded(
        patients: currentState.patients,
        error: result.error,
      ));
    }
  }
}
```

### Exemplo 3: Estados Complexos

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
  const PatientLoaded({
    required this.patients,
    this.isCreating = false,
    this.isDeleting = false,
    this.error,
  });

  final List<Patient> patients;
  final bool isCreating;
  final bool isDeleting;
  final String? error;

  @override
  List<Object?> get props => [patients, isCreating, isDeleting, error];

  PatientLoaded copyWith({
    List<Patient>? patients,
    bool? isCreating,
    bool? isDeleting,
    String? error,
  }) {
    return PatientLoaded(
      patients: patients ?? this.patients,
      isCreating: isCreating ?? this.isCreating,
      isDeleting: isDeleting ?? this.isDeleting,
      error: error,
    );
  }
}

class PatientSearching extends PatientState {
  const PatientSearching();
  @override
  List<Object> get props => [];
}

class PatientSearchResults extends PatientState {
  const PatientSearchResults({
    required this.patients,
    required this.searchQuery,
  });

  final List<Patient> patients;
  final String searchQuery;

  @override
  List<Object> get props => [patients, searchQuery];
}

class PatientError extends PatientState {
  const PatientError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
```

## 🎨 Widgets Reutilizáveis

### Exemplo 1: Widget com Estado de Loading

```dart
// lib/presentation/widgets/patient/patient_list_widget.dart
class PatientListWidget extends StatelessWidget {
  const PatientListWidget({
    super.key,
    required this.patients,
    this.isLoading = false,
    this.error,
    this.onPatientTap,
    this.onDeletePatient,
  });

  final List<Patient> patients;
  final bool isLoading;
  final String? error;
  final Function(Patient)? onPatientTap;
  final Function(Patient)? onDeletePatient;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mostrar erro se houver
        if (error != null) ...[
          ErrorWidget(
            message: error!,
            onRetry: () {
              // Implementar retry
            },
          ),
          const SizedBox(height: 16),
        ],
        
        // Loading overlay
        if (isLoading)
          const LinearProgressIndicator()
        else
          const SizedBox(height: 4),
        
        // Lista de pacientes
        Expanded(
          child: patients.isEmpty
              ? const EmptyStateWidget(
                  title: 'Nenhum paciente encontrado',
                  subtitle: 'Adicione seu primeiro paciente',
                  icon: Icons.person_add,
                )
              : ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return PatientListItem(
                      patient: patient,
                      onTap: () => onPatientTap?.call(patient),
                      onDelete: () => onDeletePatient?.call(patient),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
```

### Exemplo 2: Widget de Formulário com Validação

```dart
// lib/presentation/widgets/patient/patient_form_widget.dart
class PatientFormWidget extends StatefulWidget {
  const PatientFormWidget({
    super.key,
    this.patient,
    required this.onSubmit,
    this.isLoading = false,
  });

  final Patient? patient;
  final Function(Patient) onSubmit;
  final bool isLoading;

  @override
  State<PatientFormWidget> createState() => _PatientFormWidgetState();
}

class _PatientFormWidgetState extends State<PatientFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _notesController = TextEditingController();
  Gender _selectedGender = Gender.other;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.patient != null) {
      _nameController.text = widget.patient!.name;
      _ageController.text = widget.patient!.age.toString();
      _notesController.text = widget.patient!.notes ?? '';
      _selectedGender = widget.patient!.gender;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nome
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome do Paciente',
              hintText: 'Digite o nome completo',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nome é obrigatório';
              }
              if (value.trim().length < 2) {
                return 'Nome deve ter pelo menos 2 caracteres';
              }
              return null;
            },
            enabled: !widget.isLoading,
          ),
          
          const SizedBox(height: 16),
          
          // Idade
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: 'Idade',
              hintText: 'Digite a idade',
              prefixIcon: Icon(Icons.cake),
              suffix: Text('anos'),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Idade é obrigatória';
              }
              final age = int.tryParse(value);
              if (age == null) {
                return 'Digite uma idade válida';
              }
              if (age < 0 || age > 150) {
                return 'Idade deve estar entre 0 e 150 anos';
              }
              return null;
            },
            enabled: !widget.isLoading,
          ),
          
          const SizedBox(height: 16),
          
          // Gênero
          DropdownButtonFormField<Gender>(
            value: _selectedGender,
            decoration: const InputDecoration(
              labelText: 'Gênero',
              prefixIcon: Icon(Icons.person),
            ),
            items: Gender.values.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender.displayName),
              );
            }).toList(),
            onChanged: widget.isLoading 
                ? null 
                : (value) {
                    if (value != null) {
                      setState(() {
                        _selectedGender = value;
                      });
                    }
                  },
          ),
          
          const SizedBox(height: 16),
          
          // Notas
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Observações',
              hintText: 'Informações adicionais (opcional)',
              prefixIcon: Icon(Icons.notes),
            ),
            maxLines: 3,
            maxLength: 500,
            enabled: !widget.isLoading,
          ),
          
          const SizedBox(height: 24),
          
          // Botão de submit
          AppButton(
            text: widget.patient != null ? 'Atualizar Paciente' : 'Criar Paciente',
            onPressed: widget.isLoading ? null : _handleSubmit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final patient = Patient(
      id: widget.patient?.id ?? '',
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text),
      gender: _selectedGender,
      notes: _notesController.text.trim().isEmpty 
          ? null 
          : _notesController.text.trim(),
      ownerId: widget.patient?.ownerId ?? '',
      createdAt: widget.patient?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSubmit(patient);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
```

## 📱 Páginas com BLoC

### Exemplo: Página de Lista com Estados

```dart
// lib/presentation/pages/patients/patients_page.dart
class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar pacientes...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  if (query.trim().isNotEmpty) {
                    context.read<PatientBloc>().add(
                      PatientSearchRequested(
                        userId: context.read<AuthBloc>().state.user?.id ?? '',
                        searchQuery: query,
                      ),
                    );
                  }
                },
              )
            : const Text('Pacientes'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  // Voltar à lista normal
                  context.read<PatientBloc>().add(
                    PatientLoadRequested(
                      context.read<AuthBloc>().state.user?.id ?? '',
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<PatientBloc, PatientState>(
        listener: (context, state) {
          // Feedback de sucesso/erro
          if (state is PatientCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Paciente criado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PatientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            PatientInitial() => const LoadingWidget(
                message: 'Inicializando...',
              ),
            
            PatientLoading() => const LoadingWidget(
                message: 'Carregando pacientes...',
              ),
            
            PatientLoaded() => PatientListWidget(
                patients: state.patients,
                isLoading: state.isCreating || state.isDeleting,
                error: state.error,
                onPatientTap: (patient) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.patientDetails,
                    arguments: patient,
                  );
                },
                onDeletePatient: (patient) {
                  _showDeleteConfirmation(context, patient);
                },
              ),
            
            PatientSearching() => const LoadingWidget(
                message: 'Buscando pacientes...',
              ),
            
            PatientSearchResults() => PatientListWidget(
                patients: state.patients,
                onPatientTap: (patient) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.patientDetails,
                    arguments: patient,
                  );
                },
              ),
            
            PatientSearchError() => ErrorWidget(
                message: state.message,
                onRetry: () {
                  if (_searchController.text.trim().isNotEmpty) {
                    context.read<PatientBloc>().add(
                      PatientSearchRequested(
                        userId: context.read<AuthBloc>().state.user?.id ?? '',
                        searchQuery: _searchController.text,
                      ),
                    );
                  }
                },
              ),
            
            PatientError() => ErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<PatientBloc>().add(
                    PatientLoadRequested(
                      context.read<AuthBloc>().state.user?.id ?? '',
                    ),
                  );
                },
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createPatient);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Tem certeza que deseja excluir o paciente "${patient.name}"?\n\n'
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(
                PatientDeleteRequested(patient.id),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
```

## 🧪 Testes Avançados

### Exemplo: Teste de Repository com Mocks

```dart
// test/unit/repositories/patient_repository_test.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('PatientRepository', () {
    late PatientRepository repository;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = PatientRepositoryImpl(firestore: fakeFirestore);
    });

    group('createPatient', () {
      test('should create patient successfully with valid data', () async {
        // Arrange
        final patient = Patient(
          id: '',
          name: 'João Silva',
          age: 35,
          gender: Gender.male,
          notes: 'Paciente com diabetes',
          ownerId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final result = await repository.createPatient(patient);

        // Assert
        expect(result.isSuccess, true);
        expect(result.data.name, 'João Silva');
        expect(result.data.id, isNotEmpty);

        // Verificar se foi salvo no Firestore
        final doc = await fakeFirestore
            .collection('users')
            .doc('user123')
            .collection('patients')
            .doc(result.data.id)
            .get();
        
        expect(doc.exists, true);
        expect(doc.data()!['name'], 'João Silva');
      });

      test('should return failure when name is empty', () async {
        // Arrange
        final patient = Patient(
          id: '',
          name: '', // Nome vazio
          age: 35,
          gender: Gender.male,
          ownerId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final result = await repository.createPatient(patient);

        // Assert
        expect(result.isFailure, true);
        expect(result.error, contains('Nome do paciente é obrigatório'));
      });

      test('should return failure when age is invalid', () async {
        // Arrange
        final patient = Patient(
          id: '',
          name: 'João Silva',
          age: -5, // Idade inválida
          gender: Gender.male,
          ownerId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final result = await repository.createPatient(patient);

        // Assert
        expect(result.isFailure, true);
        expect(result.error, contains('Idade deve estar entre 0 e 150 anos'));
      });

      test('should return failure when patient name already exists', () async {
        // Arrange
        final existingPatient = Patient(
          id: 'existing',
          name: 'João Silva',
          age: 30,
          gender: Gender.male,
          ownerId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Criar paciente existente
        await fakeFirestore
            .collection('users')
            .doc('user123')
            .collection('patients')
            .doc('existing')
            .set({
              'name': 'João Silva',
              'nameLowercase': 'joão silva',
              'age': 30,
              'gender': 'M',
              'ownerId': 'user123',
            });

        final newPatient = Patient(
          id: '',
          name: 'João Silva', // Mesmo nome
          age: 35,
          gender: Gender.male,
          ownerId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final result = await repository.createPatient(newPatient);

        // Assert
        expect(result.isFailure, true);
        expect(result.error, contains('Já existe um paciente com este nome'));
      });
    });

    group('searchPatients', () {
      setUp(() async {
        // Preparar dados de teste
        final patients = [
          {'name': 'João Silva', 'nameLowercase': 'joão silva', 'age': 30},
          {'name': 'Maria Santos', 'nameLowercase': 'maria santos', 'age': 25},
          {'name': 'Pedro João', 'nameLowercase': 'pedro joão', 'age': 40},
        ];

        for (int i = 0; i < patients.length; i++) {
          await fakeFirestore
              .collection('users')
              .doc('user123')
              .collection('patients')
              .doc('patient$i')
              .set(patients[i]);
        }
      });

      test('should return patients matching search query', () async {
        // Act
        final result = await repository.searchPatients('user123', 'joão');

        // Assert
        expect(result.isSuccess, true);
        expect(result.data.length, 2); // João Silva e Pedro João
        expect(result.data.any((p) => p.name == 'João Silva'), true);
        expect(result.data.any((p) => p.name == 'Pedro João'), true);
      });

      test('should return empty list when no matches found', () async {
        // Act
        final result = await repository.searchPatients('user123', 'carlos');

        // Assert
        expect(result.isSuccess, true);
        expect(result.data.isEmpty, true);
      });

      test('should return failure when search query is empty', () async {
        // Act
        final result = await repository.searchPatients('user123', '');

        // Assert
        expect(result.isFailure, true);
        expect(result.error, contains('Termo de busca não pode estar vazio'));
      });
    });
  });
}
```

### Exemplo: Teste de BLoC com Estados Complexos

```dart
// test/unit/blocs/patient_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('PatientBloc', () {
    late PatientBloc patientBloc;
    late MockPatientRepository mockPatientRepository;

    final mockPatients = [
      Patient(
        id: '1',
        name: 'João Silva',
        age: 30,
        gender: Gender.male,
        ownerId: 'user123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    setUp(() {
      mockPatientRepository = MockPatientRepository();
      patientBloc = PatientBloc(patientRepository: mockPatientRepository);
    });

    tearDown(() {
      patientBloc.close();
    });

    group('PatientCreateRequested', () {
      blocTest<PatientBloc, PatientState>(
        'emits success and reloads when creation succeeds',
        build: () {
          when(mockPatientRepository.createPatient(any))
              .thenAnswer((_) async => Success(mockPatients.first));
          when(mockPatientRepository.getPatients(any))
              .thenAnswer((_) async => Success(mockPatients));
          return patientBloc;
        },
        act: (bloc) => bloc.add(PatientCreateRequested(mockPatients.first)),
        expect: () => [
          const PatientCreating(),
          const PatientCreateSuccess(),
          const PatientLoading(),
          PatientLoaded(patients: mockPatients),
        ],
        verify: (_) {
          verify(mockPatientRepository.createPatient(any)).called(1);
          verify(mockPatientRepository.getPatients(any)).called(1);
        },
      );

      blocTest<PatientBloc, PatientState>(
        'preserves loaded state during creation and shows error',
        build: () {
          when(mockPatientRepository.createPatient(any))
              .thenAnswer((_) async => const Failure('Erro na criação'));
          return patientBloc;
        },
        seed: () => PatientLoaded(patients: mockPatients),
        act: (bloc) => bloc.add(PatientCreateRequested(mockPatients.first)),
        expect: () => [
          PatientLoaded(patients: mockPatients, isCreating: true),
          PatientLoaded(patients: mockPatients, error: 'Erro na criação'),
        ],
      );
    });

    group('PatientDeleteRequested', () {
      blocTest<PatientBloc, PatientState>(
        'optimistically removes patient and confirms on success',
        build: () {
          when(mockPatientRepository.deletePatient(any))
              .thenAnswer((_) async => const Success(null));
          return patientBloc;
        },
        seed: () => PatientLoaded(patients: mockPatients),
        act: (bloc) => bloc.add(const PatientDeleteRequested('1')),
        expect: () => [
          const PatientLoaded(patients: [], isDeleting: true),
          const PatientLoaded(patients: []),
        ],
        verify: (_) {
          verify(mockPatientRepository.deletePatient('1')).called(1);
        },
      );

      blocTest<PatientBloc, PatientState>(
        'restores patient list when deletion fails',
        build: () {
          when(mockPatientRepository.deletePatient(any))
              .thenAnswer((_) async => const Failure('Erro na exclusão'));
          return patientBloc;
        },
        seed: () => PatientLoaded(patients: mockPatients),
        act: (bloc) => bloc.add(const PatientDeleteRequested('1')),
        expect: () => [
          const PatientLoaded(patients: [], isDeleting: true),
          PatientLoaded(patients: mockPatients, error: 'Erro na exclusão'),
        ],
      );
    });

    group('PatientSearchRequested', () {
      blocTest<PatientBloc, PatientState>(
        'emits search results when search succeeds',
        build: () {
          when(mockPatientRepository.searchPatients(any, any))
              .thenAnswer((_) async => Success(mockPatients));
          return patientBloc;
        },
        act: (bloc) => bloc.add(
          const PatientSearchRequested(
            userId: 'user123',
            searchQuery: 'joão',
          ),
        ),
        expect: () => [
          const PatientSearching(),
          PatientSearchResults(
            patients: mockPatients,
            searchQuery: 'joão',
          ),
        ],
      );
    });
  });
}
```

## 🎯 Boas Práticas Demonstradas

### 1. Validação em Camadas
- **Repository**: Validações de dados e regras de negócio
- **BLoC**: Validações de estado e fluxo
- **UI**: Validações de entrada do usuário

### 2. Estados Otimistas
- Atualizar UI imediatamente para melhor UX
- Reverter mudanças em caso de erro
- Mostrar feedback de loading quando necessário

### 3. Tratamento de Erros Consistente
- Usar Result Pattern em todas as operações
- Mensagens de erro específicas e acionáveis
- Fallbacks apropriados para cada tipo de erro

### 4. Testabilidade
- Mocks apropriados para cada camada
- Testes de comportamento, não implementação
- Cobertura de casos de sucesso e falha

### 5. Performance
- Lazy loading quando possível
- Busca otimizada com limites
- Cache de dados quando apropriado

---

**Estes exemplos demonstram os padrões e melhores práticas estabelecidos no projeto Cicatriza.**