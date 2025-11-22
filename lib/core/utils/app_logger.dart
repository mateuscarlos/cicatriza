import 'dart:developer' as developer;

/// Centraliza logs da aplicação e evita o uso de `print` em produção.
class AppLogger {
  const AppLogger._();

  static const String _defaultName = 'Cicatriza';

  static void info(String message, {String name = _defaultName}) {
    developer.log(message, name: name, level: 800);
  }

  static void warning(String message, {String name = _defaultName}) {
    developer.log(message, name: name, level: 900);
  }

  static void error(
    String message, {
    String name = _defaultName,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
