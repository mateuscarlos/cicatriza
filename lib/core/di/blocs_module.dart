import 'package:get_it/get_it.dart';

import '../../presentation/blocs/assessment_bloc.dart';
import '../../presentation/blocs/auth_bloc.dart';
import '../../presentation/blocs/patient_bloc.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';
import '../../presentation/blocs/wound_bloc.dart';

/// Módulo de configuração para BLoCs
class BlocsModule {
  /// Registra todos os BLoCs no service locator
  static void register(GetIt sl) {
    // Auth BLoC
    sl.registerFactory(() => AuthBloc(authRepository: sl(), analytics: sl()));

    // Patient BLoC
    sl.registerFactory(
      () => PatientBloc(patientRepository: sl(), analytics: sl()),
    );

    // Wound BLoC
    sl.registerFactory(() => WoundBloc(woundRepository: sl()));

    // Assessment BLoC
    sl.registerFactory(
      () => AssessmentBloc(
        assessmentRepository: sl(),
        mediaRepository: sl(),
        storageService: sl(),
        analytics: sl(),
        auth: sl(),
      ),
    );

    // Profile BLoC
    sl.registerFactory(
      () => ProfileBloc(authRepository: sl(), firebaseStorage: sl()),
    );

    // Theme Cubit (singleton para manter estado)
    sl.registerLazySingleton(() => ThemeCubit(sl()));
  }
}
