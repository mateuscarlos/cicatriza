import 'dart:convert';

/// Represents a queued write that still needs to be synchronized with Firestore.
class SyncOperation {
  const SyncOperation({
    required this.id,
    required this.entity,
    required this.type,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
  });

  final int? id;
  final String entity;
  final SyncOperationType type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;

  SyncOperation copyWith({
    int? id,
    Map<String, dynamic>? payload,
    int? retryCount,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      entity: entity,
      type: type,
      payload: payload ?? this.payload,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'entity': entity,
      'operation': type.code,
      'payload': jsonEncode(payload),
      'created_at': createdAt.millisecondsSinceEpoch,
      'retry_count': retryCount,
    };
  }

  static SyncOperation fromMap(Map<String, Object?> map) {
    return SyncOperation(
      id: map['id'] as int?,
      entity: map['entity'] as String,
      type: syncOperationTypeFromCode(map['operation'] as String),
      payload: jsonDecode(map['payload'] as String) as Map<String, dynamic>,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      retryCount: map['retry_count'] as int? ?? 0,
    );
  }
}

/// Supported operations for the sync queue.
enum SyncOperationType { create, update, delete }

extension SyncOperationTypeMapper on SyncOperationType {
  String get code {
    switch (this) {
      case SyncOperationType.create:
        return 'create';
      case SyncOperationType.update:
        return 'update';
      case SyncOperationType.delete:
        return 'delete';
    }
  }
}

SyncOperationType syncOperationTypeFromCode(String code) {
  switch (code) {
    case 'create':
      return SyncOperationType.create;
    case 'update':
      return SyncOperationType.update;
    case 'delete':
      return SyncOperationType.delete;
    default:
      throw ArgumentError.value(code, 'code', 'Unsupported sync operation');
  }
}
