/// Exceção base para o domínio
///
/// Todas as exceções específicas do domínio devem herdar desta classe,
/// garantindo tratamento consistente de erros de negócio.
abstract class DomainException implements Exception {
  const DomainException(this.message, [this.details]);

  final String message;
  final String? details;

  @override
  String toString() =>
      'DomainException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para violações de regras de negócio
///
/// Lançada quando uma operação viola uma regra específica do domínio,
/// como limites de negócio, estados inválidos, etc.
class BusinessRuleException extends DomainException {
  const BusinessRuleException(super.message, [super.details]);

  @override
  String toString() =>
      'BusinessRuleException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para validações de dados
///
/// Lançada quando dados não atendem aos critérios de validação
/// específicos do domínio.
class ValidationException extends DomainException {
  const ValidationException(super.message, [super.details]);

  @override
  String toString() =>
      'ValidationException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para email inválido
class InvalidEmailException extends ValidationException {
  const InvalidEmailException(super.message, [super.details]);

  @override
  String toString() =>
      'InvalidEmailException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para telefone inválido
class InvalidPhoneException extends ValidationException {
  const InvalidPhoneException(super.message, [super.details]);

  @override
  String toString() =>
      'InvalidPhoneException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para nome inválido
class InvalidNameException extends ValidationException {
  const InvalidNameException(super.message, [super.details]);

  @override
  String toString() =>
      'InvalidNameException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para escala de dor inválida
class InvalidPainScaleException extends ValidationException {
  const InvalidPainScaleException(super.message, [super.details]);

  @override
  String toString() =>
      'InvalidPainScaleException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para dimensões inválidas
class InvalidDimensionsException extends ValidationException {
  const InvalidDimensionsException(super.message, [super.details]);

  @override
  String toString() =>
      'InvalidDimensionsException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para entidade não encontrada
class EntityNotFoundException extends DomainException {
  const EntityNotFoundException(String entityType, String id)
    : super('$entityType com ID "$id" não foi encontrado');

  @override
  String toString() => 'EntityNotFoundException: $message';
}

/// Exceção para operação não permitida
class OperationNotAllowedException extends BusinessRuleException {
  const OperationNotAllowedException(super.message, [super.details]);

  @override
  String toString() =>
      'OperationNotAllowedException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para limite excedido
class LimitExceededException extends BusinessRuleException {
  const LimitExceededException(String resource, int limit, [String? details])
    : super('Limite de $limit $resource excedido', details);

  @override
  String toString() =>
      'LimitExceededException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para duplicação
class DuplicateEntityException extends BusinessRuleException {
  const DuplicateEntityException(
    String entityType,
    String field, [
    String? details,
  ]) : super('$entityType com $field já existe', details);

  @override
  String toString() =>
      'DuplicateEntityException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para estado inválido da entidade
class InvalidEntityStateException extends BusinessRuleException {
  const InvalidEntityStateException(
    String entityType,
    String currentState,
    String operation, [
    String? details,
  ]) : super(
         '$entityType no estado "$currentState" não pode executar "$operation"',
         details,
       );

  @override
  String toString() =>
      'InvalidEntityStateException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para dependências não satisfeitas
class DependencyNotSatisfiedException extends BusinessRuleException {
  const DependencyNotSatisfiedException(
    String operation,
    String dependency, [
    String? details,
  ]) : super('Operação "$operation" requer "$dependency"', details);

  @override
  String toString() =>
      'DependencyNotSatisfiedException: $message${details != null ? ' ($details)' : ''}';
}

/// Exceção para concorrência/conflito de dados
class ConcurrencyException extends BusinessRuleException {
  const ConcurrencyException(String resource, [String? details])
    : super('Conflito de concorrência ao acessar "$resource"', details);

  @override
  String toString() =>
      'ConcurrencyException: $message${details != null ? ' ($details)' : ''}';
}
