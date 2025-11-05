import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'firebase_options.dart';
import 'presentation/blocs/assessment_bloc.dart';
import 'presentation/blocs/auth_bloc.dart';
import 'presentation/blocs/auth_event.dart';
import 'presentation/blocs/auth_state.dart';
import 'presentation/blocs/patient_bloc.dart';
import 'presentation/blocs/wound_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase e Crashlytics
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('Firebase inicializado com sucesso');

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    AppLogger.info('Crashlytics configurado com sucesso');

    // Habilitar Analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    AppLogger.info('Analytics configurado com sucesso');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Erro ao inicializar Firebase/Crashlytics',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // Inicializar Dependency Injection
  try {
    await initDependencies();
    AppLogger.info('Dependências inicializadas com sucesso');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Erro ao inicializar dependências',
      error: e,
      stackTrace: stackTrace,
    );
  }

  runApp(const CicatrizaApp());
}

class CicatrizaApp extends StatefulWidget {
  const CicatrizaApp({super.key});

  @override
  State<CicatrizaApp> createState() => _CicatrizaAppState();
}

class _CicatrizaAppState extends State<CicatrizaApp> {
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
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Cicatriza',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: AppRoutes.login,
          onGenerateRoute: AppRoutes.generateRoute,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
