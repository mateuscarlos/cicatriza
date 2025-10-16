import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../presentation/blocs/auth_bloc.dart';

/// Service Locator para Dependency Injection
final GetIt sl = GetIt.instance;

/// Inicializar todas as dependências
Future<void> initDependencies() async {
  // ============================================================================
  // Firebase Services
  // ============================================================================

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // ============================================================================
  // Data Sources (Firebase)
  // ============================================================================

  // Neste skeleton, os repositórios acessam Firebase diretamente
  // Em M1, será criada uma camada de DataSources separada

  // ============================================================================
  // Repositories
  // ============================================================================

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(firestore: sl()),
  );

  // ============================================================================
  // Use Cases
  // ============================================================================

  // TODO: Implementar Use Cases em M1
  // sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  // sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));

  // ============================================================================
  // BLoCs
  // ============================================================================

  sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));

  // TODO: Implementar em M1
  // sl.registerFactory<PatientsBloc>(() => PatientsBloc(sl()));
  // sl.registerFactory<WoundsBloc>(() => WoundsBloc(sl()));
}
