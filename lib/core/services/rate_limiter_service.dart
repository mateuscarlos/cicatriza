import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para implementar rate limiting de requisições
class RateLimiterService {
  static const String _prefixKey = 'rate_limit_';

  /// Verifica se a ação está dentro do limite de taxa
  ///
  /// [action] - Nome da ação (ex: 'login', 'password_reset')
  /// [maxAttempts] - Número máximo de tentativas
  /// [windowSeconds] - Janela de tempo em segundos
  ///
  /// Retorna true se a ação pode ser executada, false caso contrário
  Future<bool> canPerformAction({
    required String action,
    required int maxAttempts,
    required int windowSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixKey$action';

    // Recupera tentativas anteriores
    final attemptsJson = prefs.getStringList(key) ?? [];
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowStart = now - (windowSeconds * 1000);

    // Filtra apenas tentativas dentro da janela de tempo
    final recentAttempts = attemptsJson
        .map((e) => int.parse(e))
        .where((timestamp) => timestamp > windowStart)
        .toList();

    // Verifica se atingiu o limite
    if (recentAttempts.length >= maxAttempts) {
      return false;
    }

    return true;
  }

  /// Registra uma tentativa de ação
  Future<void> recordAttempt(String action) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixKey$action';

    final attemptsJson = prefs.getStringList(key) ?? [];
    attemptsJson.add(DateTime.now().millisecondsSinceEpoch.toString());

    await prefs.setStringList(key, attemptsJson);
  }

  /// Limpa o histórico de tentativas de uma ação
  Future<void> clearAttempts(String action) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixKey$action';
    await prefs.remove(key);
  }

  /// Obtém o tempo restante até que a ação possa ser executada novamente
  ///
  /// Retorna null se a ação pode ser executada agora
  /// Retorna Duration com tempo restante caso contrário
  Future<Duration?> getTimeUntilNextAttempt({
    required String action,
    required int maxAttempts,
    required int windowSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixKey$action';

    final attemptsJson = prefs.getStringList(key) ?? [];
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowStart = now - (windowSeconds * 1000);

    final recentAttempts = attemptsJson
        .map((e) => int.parse(e))
        .where((timestamp) => timestamp > windowStart)
        .toList();

    if (recentAttempts.length < maxAttempts) {
      return null; // Pode executar agora
    }

    // Encontra a tentativa mais antiga dentro da janela
    recentAttempts.sort();
    final oldestAttempt = recentAttempts.first;
    final windowEnd = oldestAttempt + (windowSeconds * 1000);
    final remaining = windowEnd - now;

    return Duration(milliseconds: remaining);
  }
}

/// Limites de taxa padrão para ações comuns
class RateLimits {
  /// Login: 5 tentativas a cada 15 minutos
  static const loginMaxAttempts = 5;
  static const loginWindowSeconds = 900; // 15 minutos

  /// Reset de senha: 3 tentativas a cada hora
  static const passwordResetMaxAttempts = 3;
  static const passwordResetWindowSeconds = 3600; // 1 hora

  /// Atualização de perfil: 10 tentativas a cada 5 minutos
  static const profileUpdateMaxAttempts = 10;
  static const profileUpdateWindowSeconds = 300; // 5 minutos

  /// Upload de arquivo: 20 tentativas a cada 10 minutos
  static const fileUploadMaxAttempts = 20;
  static const fileUploadWindowSeconds = 600; // 10 minutos
}
