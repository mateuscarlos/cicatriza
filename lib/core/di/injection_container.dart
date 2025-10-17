import 'package:get_it/get_it.dart';

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
  // Repositories (temporariamente desabilitado)
  // ============================================================================

  // TODO: Reativar quando Firebase estiver funcionando
  /*
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(firestore: sl()),
  );
  */

  // ============================================================================
  // Use Cases
  // ============================================================================

  // TODO: Implementar Use Cases em M1
  // sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  // sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));

  // ============================================================================
  // BLoCs (temporariamente desabilitado)
  // ============================================================================

  // TODO: Reativar quando repositories estiverem funcionando
  // sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));

  // TODO: Implementar em M1
  // sl.registerFactory<PatientsBloc>(() => PatientsBloc(sl()));
  // sl.registerFactory<WoundsBloc>(() => WoundsBloc(sl()));
}
