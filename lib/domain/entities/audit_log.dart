import 'package:equatable/equatable.dart';

/// Entidade que representa um log de auditoria de acesso
class AuditLog extends Equatable {
  final String id;
  final String userId;
  final String action;
  final DateTime timestamp;
  final String deviceId;
  final String deviceName;
  final String deviceType; // 'android', 'ios', 'web', 'desktop'
  final String? ipAddress;
  final String? location;
  final Map<String, dynamic>? metadata;

  const AuditLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.timestamp,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    this.ipAddress,
    this.location,
    this.metadata,
  });

  /// Cria uma cópia do log com campos modificados
  AuditLog copyWith({
    String? id,
    String? userId,
    String? action,
    DateTime? timestamp,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
    String? location,
    Map<String, dynamic>? metadata,
  }) {
    return AuditLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      ipAddress: ipAddress ?? this.ipAddress,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converte o log para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'ipAddress': ipAddress,
      'location': location,
      'metadata': metadata,
    };
  }

  /// Cria um log a partir de JSON
  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'] as String,
      userId: json['userId'] as String,
      action: json['action'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      deviceType: json['deviceType'] as String,
      ipAddress: json['ipAddress'] as String?,
      location: json['location'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    action,
    timestamp,
    deviceId,
    deviceName,
    deviceType,
    ipAddress,
    location,
    metadata,
  ];
}

/// Ações de auditoria disponíveis
class AuditAction {
  static const String login = 'login';
  static const String logout = 'logout';
  static const String loginFailed = 'login_failed';
  static const String profileUpdate = 'profile_update';
  static const String passwordChange = 'password_change';
  static const String passwordReset = 'password_reset';
  static const String accountDelete = 'account_delete';
  static const String dataExport = 'data_export';
  static const String sessionRevoked = 'session_revoked';
}
