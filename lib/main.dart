import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_routes.dart';
import 'core/utils/app_logger.dart';
import 'presentation/blocs/patient_bloc.dart';
import 'presentation/blocs/wound_bloc.dart';
import 'presentation/blocs/assessment_bloc.dart';
import 'domain/repositories/patient_repository_manual.dart';
import 'domain/repositories/wound_repository_manual.dart';
import 'domain/repositories/assessment_repository_manual.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  try {
    await Firebase.initializeApp();
    AppLogger.info('Firebase inicializado com sucesso');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Erro ao inicializar Firebase',
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

class CicatrizaApp extends StatelessWidget {
  const CicatrizaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PatientBloc>(
          create: (context) =>
              PatientBloc(patientRepository: sl<PatientRepository>()),
        ),
        BlocProvider<WoundBloc>(
          create: (context) =>
              WoundBloc(woundRepository: sl<WoundRepository>()),
        ),
        BlocProvider<AssessmentBloc>(
          create: (context) =>
              AssessmentBloc(assessmentRepository: sl<AssessmentRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Cicatriza',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
