import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  try {
    await Firebase.initializeApp();
    print('Firebase inicializado com sucesso');
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
  }

  // Inicializar Dependency Injection
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
