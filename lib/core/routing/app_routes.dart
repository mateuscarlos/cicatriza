import 'package:flutter/material.dart';
import '../../domain/entities/patient_manual.dart';
import '../../domain/entities/wound_manual.dart';
import '../../presentation/pages/pages.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String patients = '/patients';
  static const String wounds = '/wounds';
  static const String assessmentCreate = '/assessment/create';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case home:
      case patients:
        return MaterialPageRoute(
          builder: (_) => const PacientesListPage(),
          settings: settings,
        );

      case wounds:
        final patient = settings.arguments as PatientManual?;
        if (patient == null) {
          return _errorRoute('Paciente não encontrado');
        }
        return MaterialPageRoute(
          builder: (_) => WoundsListPage(patient: patient),
          settings: settings,
        );

      case assessmentCreate:
        final args = settings.arguments as Map<String, dynamic>?;
        final patient = args?['patient'] as PatientManual?;
        final wound = args?['wound'] as WoundManual?;

        if (patient == null || wound == null) {
          return _errorRoute('Dados incompletos para avaliação');
        }

        return MaterialPageRoute(
          builder: (_) => AssessmentCreatePage(patient: patient, wound: wound),
          settings: settings,
        );

      default:
        return _errorRoute('Rota não encontrada: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Erro de Navegação',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.patients,
                    (route) => false,
                  );
                },
                child: const Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
