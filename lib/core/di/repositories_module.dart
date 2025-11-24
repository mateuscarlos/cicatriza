import 'package:get_it/get_it.dart';

import '../../data/repositories/assessment_repository_offline.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/media_repository_offline.dart';
import '../../data/repositories/patient_repository_offline.dart';
import '../../data/repositories/wound_repository_offline.dart';
import '../../domain/repositories/assessment_repository_manual.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/media_repository.dart';
import '../../domain/repositories/patient_repository_manual.dart';
import '../../domain/repositories/wound_repository_manual.dart';

/// Módulo de configuração para repositórios
class RepositoriesModule {
  /// Registra todos os repositórios no service locator
  static void register(GetIt sl) {
    // Auth Repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        firebaseAuth: sl(),
        firestore: sl(),
        googleSignIn: sl(),
      ),
    );

    // Patient Repository
    sl.registerLazySingleton<PatientRepository>(
      () => PatientRepositoryOffline(
        database: sl(),
        firestore: sl(),
        auth: sl(),
        connectivityService: sl(),
      ),
    );

    // Wound Repository
    sl.registerLazySingleton<WoundRepository>(
      () => WoundRepositoryOffline(
        database: sl(),
        firestore: sl(),
        auth: sl(),
        connectivityService: sl(),
      ),
    );

    // Assessment Repository
    sl.registerLazySingleton<AssessmentRepository>(
      () => AssessmentRepositoryOffline(
        database: sl(),
        firestore: sl(),
        auth: sl(),
        connectivityService: sl(),
      ),
    );

    // Media Repository
    sl.registerLazySingleton<MediaRepository>(
      () => MediaRepositoryOffline(
        database: sl(),
        firestore: sl(),
        auth: sl(),
        connectivityService: sl(),
      ),
    );
  }
}
