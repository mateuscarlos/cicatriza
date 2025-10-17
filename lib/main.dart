import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Inicializar Firebase quando os emuladores estiverem funcionando
  // Por enquanto, pular Firebase para testar UI-UX
  print('Iniciando Cicatriza - Modo desenvolvimento (sem Firebase)');

  // Inicializar Dependency Injection simplificado
  try {
    await initDependencies();
    print('Dependências inicializadas com sucesso');
  } catch (e) {
    print('Erro ao inicializar dependências: $e');
  }

  runApp(const CicatrizaApp());
}

class CicatrizaApp extends StatelessWidget {
  const CicatrizaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Reativar BlocProvider quando AuthBloc estiver funcionando
    return MaterialApp.router(
      title: 'Cicatriza',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
