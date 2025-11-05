import 'package:cicatriza/core/services/analytics_service.dart';
import 'package:cicatriza/core/services/storage_service.dart';
import 'package:cicatriza/data/repositories/assessment_repository_mock.dart';
import 'package:cicatriza/data/repositories/media_repository_offline.dart';
import 'package:cicatriza/data/repositories/patient_repository_mock.dart';
import 'package:cicatriza/data/repositories/wound_repository_mock.dart';
import 'package:cicatriza/domain/repositories/assessment_repository_manual.dart';
import 'package:cicatriza/domain/repositories/media_repository.dart';
import 'package:cicatriza/domain/repositories/patient_repository_manual.dart';
import 'package:cicatriza/domain/repositories/wound_repository_manual.dart';
import 'package:cicatriza/presentation/blocs/assessment_bloc.dart';
import 'package:cicatriza/presentation/blocs/patient_bloc.dart';
import 'package:cicatriza/presentation/blocs/wound_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(analytics: FirebaseAnalytics.instance),
  );
  sl.registerLazySingleton<StorageService>(() => StorageService());

  // Repositories (Mock para MVP)
  sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryMock());
  sl.registerLazySingleton<WoundRepository>(() => WoundRepositoryMock());
  sl.registerLazySingleton<AssessmentRepository>(
    () => AssessmentRepositoryMock(),
  );
  sl.registerLazySingleton<MediaRepository>(() => MediaRepositoryOffline());

  // BLoCs
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
    ),
  );
}
