import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/repositories/audit_repository.dart';

/// Implementação do repositório de auditoria
class AuditRepositoryImpl implements AuditRepository {
  final FirebaseFirestore _firestore;
  final DeviceInfoPlugin _deviceInfo;
  final Uuid _uuid;

  AuditRepositoryImpl({
    FirebaseFirestore? firestore,
    DeviceInfoPlugin? deviceInfo,
    Uuid? uuid,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
       _uuid = uuid ?? const Uuid();

  @override
  Future<void> logAction({
    required String userId,
    required String action,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final deviceInfo = await _getDeviceInfo();

      final log = AuditLog(
        id: _uuid.v4(),
        userId: userId,
        action: action,
        timestamp: DateTime.now(),
        deviceId: deviceInfo['deviceId'] as String,
        deviceName: deviceInfo['deviceName'] as String,
        deviceType: deviceInfo['deviceType'] as String,
        metadata: metadata,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('audit_logs')
          .doc(log.id)
          .set(log.toJson());
    } catch (e) {
      // Log silenciosamente para não interromper o fluxo do app
      print('Erro ao registrar log de auditoria: $e');
    }
  }

  @override
  Future<List<AuditLog>> getUserLogs(String userId, {int limit = 50}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('audit_logs')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => AuditLog.fromJson(doc.data())).toList();
    } catch (e) {
      print('Erro ao buscar logs de auditoria: $e');
      return [];
    }
  }

  @override
  Future<List<AuditLog>> getLogsByAction(
    String userId,
    String action, {
    int limit = 20,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('audit_logs')
          .where('action', isEqualTo: action)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => AuditLog.fromJson(doc.data())).toList();
    } catch (e) {
      print('Erro ao buscar logs por ação: $e');
      return [];
    }
  }

  @override
  Future<void> cleanOldLogs(String userId) async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 90));

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('audit_logs')
          .where('timestamp', isLessThan: cutoffDate.toIso8601String())
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Erro ao limpar logs antigos: $e');
    }
  }

  /// Obtém informações do dispositivo
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return {
          'deviceId': info.id,
          'deviceName': '${info.manufacturer} ${info.model}',
          'deviceType': 'android',
        };
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return {
          'deviceId': info.identifierForVendor ?? 'unknown',
          'deviceName': '${info.name} (${info.model})',
          'deviceType': 'ios',
        };
      } else if (Platform.isWindows) {
        final info = await _deviceInfo.windowsInfo;
        return {
          'deviceId': info.deviceId,
          'deviceName': info.computerName,
          'deviceType': 'windows',
        };
      } else if (Platform.isMacOS) {
        final info = await _deviceInfo.macOsInfo;
        return {
          'deviceId': info.systemGUID ?? 'unknown',
          'deviceName': info.computerName,
          'deviceType': 'macos',
        };
      } else if (Platform.isLinux) {
        final info = await _deviceInfo.linuxInfo;
        return {
          'deviceId': info.machineId ?? 'unknown',
          'deviceName': info.prettyName,
          'deviceType': 'linux',
        };
      }
    } catch (e) {
      print('Erro ao obter informações do dispositivo: $e');
    }

    return {
      'deviceId': 'unknown',
      'deviceName': 'Unknown Device',
      'deviceType': 'unknown',
    };
  }
}
