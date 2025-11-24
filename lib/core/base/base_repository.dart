import '../utils/app_logger.dart';

/// Resultado base que encapsula sucesso ou falha de operações
sealed class Result<T> {
  const Result();

  /// Cria um resultado de sucesso
  const factory Result.success(T data) = Success<T>;

  /// Cria um resultado de erro
  const factory Result.failure(String message, [Exception? exception]) =
      Failure<T>;

  /// Verifica se o resultado é sucesso
  bool get isSuccess => this is Success<T>;

  /// Verifica se o resultado é falha
  bool get isFailure => this is Failure<T>;

  /// Obtém dados se sucesso, caso contrário lança exceção
  T get data {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    throw StateError('Tentando acessar dados de um resultado de falha');
  }

  /// Obtém erro se falha, caso contrário retorna null
  String? get error {
    if (this is Failure<T>) {
      return (this as Failure<T>).message;
    }
    return null;
  }

  /// Transforma o resultado aplicando uma função aos dados de sucesso
  Result<U> map<U>(U Function(T) transform) {
    return switch (this) {
      Success<T>(:final data) => Result.success(transform(data)),
      Failure<T>(:final message, :final exception) => Result.failure(
        message,
        exception,
      ),
    };
  }

  /// Permite encadeamento de operações que podem falhar
  Result<U> flatMap<U>(Result<U> Function(T) transform) {
    return switch (this) {
      Success<T>(:final data) => transform(data),
      Failure<T>(:final message, :final exception) => Result.failure(
        message,
        exception,
      ),
    };
  }
}

/// Resultado de sucesso
final class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);
}

/// Resultado de falha
final class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const Failure(this.message, [this.exception]);
}

/// Classe base para todos os repositórios
///
/// Fornece funcionalidades comuns como:
/// - Tratamento padronizado de erros
/// - Logging consistente
/// - Métricas de performance
abstract base class BaseRepository {
  /// Nome do repositório (usado para logging)
  String get repositoryName;

  /// Executa operação com tratamento de erro padronizado
  ///
  Future<Result<T>> executeOperation<T>(
    Future<T> Function() operation, {
    required String operationName,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      AppLogger.info('[$repositoryName] Iniciando $operationName');

      final result = await operation();

      stopwatch.stop();
      AppLogger.info(
        '[$repositoryName] $operationName concluída com sucesso em ${stopwatch.elapsedMilliseconds}ms',
      );

      return Result.success(result);
    } on Exception catch (e, stackTrace) {
      stopwatch.stop();

      final message = _getErrorMessage(e);
      AppLogger.error(
        '[$repositoryName] Erro em $operationName: $message (${stopwatch.elapsedMilliseconds}ms)',
        error: e,
        stackTrace: stackTrace,
      );

      return Result.failure(message, e);
    }
  }

  /// Executa operação síncrona com tratamento de erro
  Result<T> executeSyncOperation<T>(
    T Function() operation, {
    required String operationName,
  }) {
    try {
      AppLogger.info('[$repositoryName] Executando $operationName');

      final result = operation();

      AppLogger.info('[$repositoryName] $operationName concluída com sucesso');

      return Result.success(result);
    } on Exception catch (e, stackTrace) {
      final message = _getErrorMessage(e);
      AppLogger.error(
        '[$repositoryName] Erro em $operationName: $message',
        error: e,
        stackTrace: stackTrace,
      );

      return Result.failure(message, e);
    }
  }

  /// Extrai mensagem de erro amigável da exceção
  String _getErrorMessage(Exception e) {
    return switch (e) {
      ArgumentError(:final message) => 'Parâmetros inválidos: $message',
      StateError(:final message) => 'Estado inválido: $message',
      FormatException(:final message) => 'Formato de dados inválido: $message',
      _ => e.toString(),
    };
  }

  /// Valida se parâmetros obrigatórios não são nulos
  void validateRequired(Map<String, dynamic> params) {
    final nullParams = params.entries
        .where((entry) => entry.value == null)
        .map((entry) => entry.key)
        .toList();

    if (nullParams.isNotEmpty) {
      throw ArgumentError(
        'Parâmetros obrigatórios são nulos: ${nullParams.join(', ')}',
      );
    }
  }

  /// Valida se string não está vazia
  void validateNotEmpty(String? value, String paramName) {
    if (value?.trim().isEmpty ?? true) {
      throw ArgumentError('$paramName não pode estar vazio');
    }
  }
}
