import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/offline_database.dart';
import '../services/analytics_service.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';

/// Módulo de configuração para serviços de core
class ServicesModule {
  /// Registra todos os serviços de core no service locator
  static Future<void> register(GetIt sl) async {
    // Shared Preferences - deve ser registrado primeiro
    final prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);

    // Offline Database
    sl.registerLazySingleton<OfflineDatabase>(() => OfflineDatabase.instance);

    // Connectivity Service
    sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

    // Analytics Service (dependente do Firebase)
    sl.registerLazySingleton<AnalyticsService>(
      () => AnalyticsService(analytics: sl()),
    );

    // Storage Service (dependente do Firebase Storage)
    sl.registerLazySingleton<StorageService>(
      () => StorageService(storage: sl()),
    );
  }
}
