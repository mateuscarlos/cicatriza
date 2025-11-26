/// Interface base para todos os casos de uso do domínio.
///
/// Define o contrato padrão que todos os Use Cases devem seguir,
/// garantindo consistência e testabilidade em toda a aplicação.
///
/// Parâmetros de tipo:
/// - [Input]: Tipo dos dados de entrada necessários para executar o caso de uso
/// - [Output]: Tipo dos dados retornados pela execução do caso de uso
///
/// Exemplo de uso:
/// ```dart
/// class CreatePatientUseCase implements UseCase<CreatePatientInput, Patient> {
///   @override
///   Future<Result<Patient>> execute(CreatePatientInput input) async {
///     // Implementação do caso de uso
///   }
/// }
/// ```
abstract class UseCase<Input, Output> {
  /// Executa o caso de uso com os dados de entrada fornecidos.
  ///
  /// Retorna um [Result] que encapsula o sucesso ou falha da operação,
  /// permitindo tratamento de erros de forma explícita e type-safe.
  ///
  /// [input] - Os dados necessários para executar o caso de uso
  ///
  /// Retorna:
  /// - `Result<Output>` com o resultado da operação ou erro específico
  Future<Result<Output>> execute(Input input);
}

/// Representa o resultado de uma operação que pode ser bem-sucedida ou falhar.
///
/// Implementa o padrão Either/Result para tratamento explícito de erros
/// sem uso de exceções, melhorando a previsibilidade do código.
sealed class Result<T> {
  const Result();

  /// Indica se a operação foi bem-sucedida
  bool get isSuccess => this is Success<T>;

  /// Indica se a operação falhou
  bool get isFailure => this is Failure<T>;

  /// Obtém o valor em caso de sucesso, ou null se falhou
  T? get valueOrNull => switch (this) {
    Success<T>(value: final value) => value,
    Failure<T>() => null,
  };

  /// Obtém o erro em caso de falha, ou null se bem-sucedido
  UseCaseError? get errorOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(error: final error) => error,
  };

  /// Transforma o valor em caso de sucesso, mantendo falhas inalteradas
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(value: final value) => Success(transform(value)),
      Failure<T>(error: final error) => Failure(error),
    };
  }

  /// Executa uma função se a operação foi bem-sucedida
  Result<T> onSuccess(void Function(T value) callback) {
    if (this case Success<T>(value: final value)) {
      callback(value);
    }
    return this;
  }

  /// Executa uma função se a operação falhou
  Result<T> onFailure(void Function(UseCaseError error) callback) {
    if (this case Failure<T>(error: final error)) {
      callback(error);
    }
    return this;
  }

  /// Executa uma operação assíncrona em cadeia se bem-sucedido
  Future<Result<R>> andThen<R>(
    Future<Result<R>> Function(T value) operation,
  ) async {
    return switch (this) {
      Success<T>(value: final value) => await operation(value),
      Failure<T>(error: final error) => Failure(error),
    };
  }
}

/// Resultado de sucesso de um caso de uso
final class Success<T> extends Result<T> {
  /// O valor resultado da operação bem-sucedida
  final T value;

  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Resultado de falha de um caso de uso
final class Failure<T> extends Result<T> {
  /// O erro que causou a falha
  final UseCaseError error;

  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

/// Hierarquia de erros específicos para casos de uso.
///
/// Permite tratamento diferenciado de tipos de erro e maior expressividade
/// nas operações de domínio, facilitando debugging e user experience.
sealed class UseCaseError {
  /// Mensagem descritiva do erro
  final String message;

  /// Código opcional do erro para identificação programática
  final String? code;

  const UseCaseError(this.message, {this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UseCaseError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() =>
      'UseCaseError($message${code != null ? ', code: $code' : ''})';
}

/// Erro de validação de entrada
final class ValidationError extends UseCaseError {
  /// Campo específico que falhou na validação
  final String? field;

  const ValidationError(super.message, {super.code, this.field});

  @override
  String toString() =>
      'ValidationError($message'
      '${field != null ? ', field: $field' : ''}'
      '${code != null ? ', code: $code' : ''})';
}

/// Erro de entidade não encontrada
final class NotFoundError extends UseCaseError {
  /// Tipo da entidade não encontrada
  final String entityType;

  /// ID da entidade que não foi encontrada
  final String? entityId;

  const NotFoundError(
    this.entityType,
    super.message, {
    super.code,
    this.entityId,
  });

  factory NotFoundError.withId(String entityType, String id) => NotFoundError(
    entityType,
    '$entityType com ID "$id" não encontrado',
    entityId: id,
  );

  @override
  String toString() =>
      'NotFoundError($entityType: $message'
      '${entityId != null ? ', id: $entityId' : ''}'
      '${code != null ? ', code: $code' : ''})';
}

/// Erro de conflito de estado ou regra de negócio
final class ConflictError extends UseCaseError {
  const ConflictError(super.message, {super.code});

  @override
  String toString() =>
      'ConflictError($message'
      '${code != null ? ', code: $code' : ''})';
}

/// Erro interno do sistema ou infraestrutura
final class SystemError extends UseCaseError {
  /// Exceção original que causou o erro, se disponível
  final Exception? cause;

  const SystemError(super.message, {super.code, this.cause});

  @override
  String toString() =>
      'SystemError($message'
      '${cause != null ? ', cause: $cause' : ''}'
      '${code != null ? ', code: $code' : ''})';
}

/// Extensões utilitárias para criação rápida de Results
extension ResultExtensions on Object {
  /// Cria um Result de sucesso
  Result<T> success<T>() => Success(this as T);
}

extension ResultFactory on Object? {
  /// Cria um Result de sucesso com o valor
  static Result<T> success<T>(T value) => Success(value);

  /// Cria um Result de falha com o erro
  static Result<T> failure<T>(UseCaseError error) => Failure(error);
}
