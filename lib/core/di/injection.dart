import 'package:cicatriza/data/repositories/assessment_repository_mock.dart';
import 'package:cicatriza/data/repositories/patient_repository_mock.dart';
import 'package:cicatriza/data/repositories/wound_repository_mock.dart';
import 'package:cicatriza/domain/repositories/assessment_repository.dart';
import 'package:cicatriza/domain/repositories/patient_repository.dart';
import 'package:cicatriza/domain/repositories/wound_repository.dart';
import 'package:cicatriza/presentation/blocs/assessment_bloc.dart';
import 'package:cicatriza/presentation/blocs/patient_bloc.dart';
import 'package:cicatriza/presentation/blocs/wound_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories (Mock para MVP)
  sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryMock());
  sl.registerLazySingleton<WoundRepository>(() => WoundRepositoryMock());
  sl.registerLazySingleton<AssessmentRepository>(
    () => AssessmentRepositoryMock(),
  );

  // BLoCs
  sl.registerFactory(() => PatientBloc(patientRepository: sl()));
  sl.registerFactory(() => WoundBloc(woundRepository: sl()));
  sl.registerFactory(() => AssessmentBloc(assessmentRepository: sl()));
}
