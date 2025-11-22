import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/offline_database.dart';
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
import '../../presentation/blocs/assessment_bloc.dart';
import '../../presentation/blocs/auth_bloc.dart';
import '../../presentation/blocs/patient_bloc.dart';
import '../../presentation/blocs/wound_bloc.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';
import '../config/google_sign_in_config.dart';
import '../services/analytics_service.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';
import '../utils/app_logger.dart';

/// Service Locator para Dependency Injection
final GetIt sl = GetIt.instance;

/// Inicializar todas as dependências
Future<void> initDependencies() async {
  // ============================================================================
  // Shared Preferences
  // ============================================================================

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ============================================================================
  // Firebase Services
  // ============================================================================

  try {
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    sl.registerLazySingleton<FirebaseAnalytics>(
      () => FirebaseAnalytics.instance,
    );

    final googleSignIn = GoogleSignIn.instance;

    if (kIsWeb) {
      await googleSignIn.initialize();
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          await googleSignIn.initialize(
            serverClientId: GoogleSignInConfig.serverClientId,
          );
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          await googleSignIn.initialize(
            clientId: GoogleSignInConfig.iosClientId,
            serverClientId: GoogleSignInConfig.serverClientId,
          );
          break;
        default:
          await googleSignIn.initialize();
      }
    }
    sl.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
    AppLogger.info('Firebase services registrados com sucesso');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Erro ao registrar Firebase services',
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }

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
  sl.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(analytics: sl()),
  );
  sl.registerLazySingleton<StorageService>(() => StorageService(storage: sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryOffline(
      database: sl(),
      firestore: sl(),
      auth: sl(),
      connectivityService: sl(),
    ),
  );

  sl.registerLazySingleton<WoundRepository>(
    () => WoundRepositoryOffline(
      database: sl(),
      firestore: sl(),
      auth: sl(),
      connectivityService: sl(),
    ),
  );

  sl.registerLazySingleton<AssessmentRepository>(
    () => AssessmentRepositoryOffline(
      database: sl(),
      firestore: sl(),
      auth: sl(),
      connectivityService: sl(),
    ),
  );

  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryOffline(
      database: sl(),
      firestore: sl(),
      auth: sl(),
      connectivityService: sl(),
    ),
  );

  // ============================================================================
  // BLoCs
  // ============================================================================

  sl.registerFactory(() => AuthBloc(authRepository: sl(), analytics: sl()));
  sl.registerFactory(
    () => PatientBloc(patientRepository: sl(), analytics: sl()),
  );
  sl.registerFactory(() => WoundBloc(woundRepository: sl()));
  sl.registerFactory(
    () => AssessmentBloc(
      assessmentRepository: sl(),
      mediaRepository: sl(),
      storageService: sl(),
      analytics: sl(),
      auth: sl(),
    ),
  );
  sl.registerFactory(() => ProfileBloc(authRepository: sl()));

  // Theme Cubit
  sl.registerLazySingleton(() => ThemeCubit(sl()));
}
