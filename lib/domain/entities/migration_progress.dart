/// Representa o progresso de uma migração de dados
class MigrationProgress {
  final int totalItems;
  final int processedItems;
  final int successfulItems;
  final int failedItems;
  final List<String> errors;
  final String currentStep;
  final DateTime startTime;
  final DateTime? endTime;

  const MigrationProgress({
    required this.totalItems,
    required this.processedItems,
    required this.successfulItems,
    required this.failedItems,
    required this.errors,
    required this.currentStep,
    required this.startTime,
    this.endTime,
  });

  double get progressPercentage {
    if (totalItems == 0) return 0.0;
    return (processedItems / totalItems) * 100;
  }

  bool get isCompleted => processedItems == totalItems;

  bool get hasErrors => failedItems > 0;

  Duration get elapsedTime {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  MigrationProgress copyWith({
    int? totalItems,
    int? processedItems,
    int? successfulItems,
    int? failedItems,
    List<String>? errors,
    String? currentStep,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return MigrationProgress(
      totalItems: totalItems ?? this.totalItems,
      processedItems: processedItems ?? this.processedItems,
      successfulItems: successfulItems ?? this.successfulItems,
      failedItems: failedItems ?? this.failedItems,
      errors: errors ?? this.errors,
      currentStep: currentStep ?? this.currentStep,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  String toString() {
    return 'MigrationProgress('
        'progress: ${progressPercentage.toStringAsFixed(1)}%, '
        'processed: $processedItems/$totalItems, '
        'successful: $successfulItems, '
        'failed: $failedItems, '
        'step: $currentStep'
        ')';
  }
}
