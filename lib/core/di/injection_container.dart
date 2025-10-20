import 'package:get_it/get_it.dart';
import '../../data/repositories/patient_repository_mock.dart';
import '../../data/repositories/wound_repository_mock.dart';
import '../../data/repositories/assessment_repository_mock.dart';
import '../../domain/repositories/patient_repository_manual.dart';
import '../../domain/repositories/wound_repository_manual.dart';
import '../../domain/repositories/assessment_repository_manual.dart';
import '../../presentation/blocs/patient_bloc.dart';
import '../../presentation/blocs/wound_bloc.dart';
import '../../presentation/blocs/assessment_bloc.dart';

/// Service Locator para Dependency Injection
final GetIt sl = GetIt.instance;

/// Inicializar todas as dependências
Future<void> initDependencies() async {
  // ============================================================================
  // Firebase Services
  // ============================================================================

  // TODO: Reativar Firebase quando emuladores estiverem funcionando
  // Por enquanto, desabilitar para testar UI-UX
  /*
  try {
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    print('Firebase services registrados com sucesso');
  } catch (e) {
    print('Erro ao registrar Firebase services: $e');
    // Continua sem Firebase para desenvolvimento
  }
  */

  print('Firebase temporariamente desabilitado para desenvolvimento UI-UX');

  // ============================================================================
  // Data Sources (Firebase)
  // ============================================================================

  // Neste skeleton, os repositórios acessam Firebase diretamente
  // Em M1, será criada uma camada de DataSources separada

  // ============================================================================
  // Repositories (Mock para MVP)
  // ============================================================================

  sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryMock());
  sl.registerLazySingleton<WoundRepository>(() => WoundRepositoryMock());
  sl.registerLazySingleton<AssessmentRepository>(
    () => AssessmentRepositoryMock(),
  );

  // ============================================================================
  // BLoCs
  // ============================================================================

  sl.registerFactory(() => PatientBloc(patientRepository: sl()));
  sl.registerFactory(() => WoundBloc(woundRepository: sl()));
  sl.registerFactory(() => AssessmentBloc(assessmentRepository: sl()));
}
