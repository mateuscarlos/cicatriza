import 'package:get_it/get_it.dart';

import 'blocs_module.dart';
import 'firebase_module.dart';
import 'repositories_module.dart';
import 'services_module.dart';

/// Service Locator para Dependency Injection
final GetIt sl = GetIt.instance;

/// Inicializar todas as dependências usando módulos
///
/// A inicialização segue a ordem de dependências:
/// 1. Firebase Services (infraestrutura base)
/// 2. Core Services (dependem do Firebase)
/// 3. Repositories (dependem dos Services)
/// 4. BLoCs (dependem dos Repositories)
Future<void> initDependencies() async {
  // Módulo Firebase - deve ser primeiro pois outros dependem dele
  await FirebaseModule.register(sl);

  // Módulo de Serviços Core - dependem do Firebase
  await ServicesModule.register(sl);

  // Módulo de Repositórios - dependem dos serviços
  RepositoriesModule.register(sl);

  // Módulo de BLoCs - dependem dos repositórios
  BlocsModule.register(sl);
}
