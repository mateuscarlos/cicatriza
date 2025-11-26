import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/firebase_environment_config.dart';
import 'core/di/injection_container.dart';
import 'core/routing/app_routes.dart';
import 'core/services/app_check_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'presentation/blocs/assessment_bloc.dart';
import 'presentation/blocs/auth_bloc.dart';
import 'presentation/blocs/auth_event.dart';
import 'presentation/blocs/auth_state.dart';
import 'presentation/blocs/patient_bloc.dart';
import 'presentation/blocs/wound_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mostrar loading app enquanto inicializa
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Inicializando aplicação...'),
            ],
          ),
        ),
      ),
    ),
  );

  // Inicializar Firebase e Crashlytics com configuração de ambiente
  try {
    await Firebase.initializeApp(
      options: FirebaseEnvironmentConfig.currentOptions,
    );

    // Log informações do ambiente
    final debugInfo = FirebaseEnvironmentConfig.debugInfo;
    AppLogger.info(
      'Firebase inicializado com sucesso - '
      'Ambiente: ${debugInfo['environment']}, '
      'Projeto: ${debugInfo['projectId']}',
    );

    // Configurar Firebase App Check
    try {
      await AppCheckService.initialize();
    } catch (e) {
      AppLogger.error(
        'App Check não pôde ser inicializado, continuando sem ele',
        error: e,
      );
    }

    // Configurar Crashlytics baseado no ambiente
    final loggingConfig =
        FirebaseEnvironmentConfig.getConfigForCurrentEnvironment(
          FirebaseEnvironmentConfig.loggingConfig,
        );

    if (loggingConfig['enableCrashlytics'] as bool) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      AppLogger.info('Crashlytics configurado e habilitado');
    } else {
      AppLogger.info('Crashlytics desabilitado em desenvolvimento');
    }

    // Configurar Analytics baseado no ambiente
    if (loggingConfig['enableAnalytics'] as bool) {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      AppLogger.info('Analytics configurado e habilitado');
    } else {
      AppLogger.info('Analytics desabilitado em desenvolvimento');
    }
  } catch (e, stackTrace) {
    AppLogger.error(
      'Erro ao inicializar Firebase/Crashlytics/App Check',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // Inicializar Dependency Injection
  try {
    AppLogger.info('Iniciando inicialização das dependências...');
    await initDependencies();
    AppLogger.info('Dependências inicializadas com sucesso');

    // Verificar se AuthBloc pode ser criado
    try {
      final authBloc = sl<AuthBloc>();
      AppLogger.info('AuthBloc criado com sucesso');
      authBloc.close();
    } catch (e) {
      AppLogger.error('Erro ao criar AuthBloc durante teste', error: e);
      rethrow;
    }
  } catch (e, stackTrace) {
    AppLogger.error(
      'Erro ao inicializar dependências',
      error: e,
      stackTrace: stackTrace,
    );
    // Mostrar erro na tela
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Erro na inicialização:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('$e', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  // Agora inicializar o app principal
  runApp(const CicatrizaApp());
}

class CicatrizaApp extends StatelessWidget {
  const CicatrizaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _ensureDependenciesInitialized(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Erro na inicialização: ${snapshot.error}'),
                  ],
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data != true) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return _CicatrizaMainApp();
      },
    );
  }

  Future<bool> _ensureDependenciesInitialized() async {
    try {
      // Verificar se já está inicializado
      if (sl.isRegistered<AuthBloc>()) {
        return true;
      }

      // Se não estiver, aguardar um momento e tentar novamente
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return sl.isRegistered<AuthBloc>();
    } catch (e) {
      AppLogger.error('Erro ao verificar dependências', error: e);
      return false;
    }
  }
}

class _CicatrizaMainApp extends StatefulWidget {
  @override
  State<_CicatrizaMainApp> createState() => _CicatrizaAppState();
}

class _CicatrizaAppState extends State<_CicatrizaMainApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<PatientBloc>(create: (context) => sl<PatientBloc>()),
        BlocProvider<WoundBloc>(create: (context) => sl<WoundBloc>()),
        BlocProvider<AssessmentBloc>(create: (context) => sl<AssessmentBloc>()),
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is AuthUnauthenticated) {
            _navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              navigatorKey: _navigatorKey,
              title: 'Cicatriza',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              initialRoute: AppRoutes.login,
              onGenerateRoute: AppRoutes.generateRoute,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
