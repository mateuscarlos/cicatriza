/// Parâmetros de entrada para o caso de uso de migração em lote
class BatchMigrationInput {
  /// Se verdadeiro, apenas simula a migração sem aplicar mudanças
  final bool dryRun;

  /// Tamanho do lote para processamento em chunks
  final int batchSize;

  /// Se verdadeiro, para na primeira falha encontrada
  final bool stopOnFirstError;

  /// Se verdadeiro, cria backup antes da migração
  final bool createBackup;

  /// Força a migração mesmo se já foi executada
  final bool force;

  /// Versão alvo da estrutura de dados
  final int targetVersion;

  const BatchMigrationInput({
    this.dryRun = false,
    this.batchSize = 10,
    this.stopOnFirstError = false,
    this.createBackup = true,
    this.force = false,
    this.targetVersion = 5,
  });

  @override
  String toString() {
    return 'BatchMigrationInput('
        'dryRun: $dryRun, '
        'batchSize: $batchSize, '
        'stopOnFirstError: $stopOnFirstError, '
        'createBackup: $createBackup, '
        'force: $force, '
        'targetVersion: $targetVersion'
        ')';
  }
}
