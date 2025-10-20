import 'package:get_it/get_it.dart';
import '../../data/repositories/patient_repository_offline.dart';
import '../../data/repositories/wound_repository_mock.dart';
import '../../data/repositories/assessment_repository_mock.dart';
import '../../data/datasources/local/offline_database.dart';
import '../../domain/repositories/patient_repository_manual.dart';
import '../../domain/repositories/wound_repository_manual.dart';
import '../../domain/repositories/assessment_repository_manual.dart';
import '../utils/app_logger.dart';
import '../services/connectivity_service.dart';
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
    AppLogger.info('Firebase services registrados com sucesso');
  } catch (e) {
    AppLogger.error('Erro ao registrar Firebase services', error: e);
    // Continua sem Firebase para desenvolvimento
  }
  */
  AppLogger.info(
    'Firebase temporariamente desabilitado para desenvolvimento UI-UX',
  );

  // ============================================================================
  // Data Sources (Firebase)
  // ============================================================================

  // Neste skeleton, os repositórios acessam Firebase diretamente
  // Em M1, será criada uma camada de DataSources separada

  // ============================================================================
  // Repositories (Mock para MVP)
  // ============================================================================

  sl.registerLazySingleton<OfflineDatabase>(() => OfflineDatabase.instance);
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryOffline(database: sl(), connectivityService: sl()),
  );
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
