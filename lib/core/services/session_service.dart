import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Entidade que representa uma sessão ativa
class ActiveSession {
  final String sessionId;
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final DateTime createdAt;
  final DateTime lastAccessAt;
  final bool isCurrentDevice;

  const ActiveSession({
    required this.sessionId,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.createdAt,
    required this.lastAccessAt,
    required this.isCurrentDevice,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'createdAt': createdAt.toIso8601String(),
      'lastAccessAt': lastAccessAt.toIso8601String(),
    };
  }

  factory ActiveSession.fromJson(
    Map<String, dynamic> json,
    String currentDeviceId,
  ) {
    return ActiveSession(
      sessionId: json['sessionId'] as String,
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      deviceType: json['deviceType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAccessAt: DateTime.parse(json['lastAccessAt'] as String),
      isCurrentDevice: json['deviceId'] == currentDeviceId,
    );
  }
}

/// Serviço para gerenciamento de sessões e detecção de novos dispositivos
class SessionService {
  static const String _deviceIdKey = 'device_id';
  static const String _knownDevicesKey = 'known_devices';

  final FirebaseFirestore _firestore;
  final DeviceInfoPlugin _deviceInfo;
  final SharedPreferences _prefs;
  final Uuid _uuid;

  SessionService({
    required SharedPreferences prefs, FirebaseFirestore? firestore,
    DeviceInfoPlugin? deviceInfo,
    Uuid? uuid,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
       _prefs = prefs,
       _uuid = uuid ?? const Uuid();

  /// Obtém ou cria um ID único para o dispositivo
  Future<String> getDeviceId() async {
    String? deviceId = _prefs.getString(_deviceIdKey);

    if (deviceId == null) {
      deviceId = _uuid.v4();
      await _prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  /// Verifica se é um novo dispositivo
  Future<bool> isNewDevice() async {
    final deviceId = await getDeviceId();
    final knownDevices = _prefs.getStringList(_knownDevicesKey) ?? [];
    return !knownDevices.contains(deviceId);
  }

  /// Registra o dispositivo como conhecido
  Future<void> registerDevice() async {
    final deviceId = await getDeviceId();
    final knownDevices = _prefs.getStringList(_knownDevicesKey) ?? [];

    if (!knownDevices.contains(deviceId)) {
      knownDevices.add(deviceId);
      await _prefs.setStringList(_knownDevicesKey, knownDevices);
    }
  }

  /// Cria uma nova sessão no Firestore
  Future<void> createSession(String userId) async {
    try {
      final deviceId = await getDeviceId();
      final deviceInfo = await _getDeviceInfo();
      final sessionId = _uuid.v4();

      final session = ActiveSession(
        sessionId: sessionId,
        deviceId: deviceId,
        deviceName: deviceInfo['deviceName'] as String,
        deviceType: deviceInfo['deviceType'] as String,
        createdAt: DateTime.now(),
        lastAccessAt: DateTime.now(),
        isCurrentDevice: true,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .set(session.toJson());

      // Salva o sessionId localmente
      await _prefs.setString('current_session_id', sessionId);
    } catch (e) {
      print('Erro ao criar sessão: $e');
    }
  }

  /// Atualiza o timestamp de último acesso da sessão
  Future<void> updateSessionAccess(String userId) async {
    try {
      final sessionId = _prefs.getString('current_session_id');
      if (sessionId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .update({'lastAccessAt': DateTime.now().toIso8601String()});
    } catch (e) {
      print('Erro ao atualizar sessão: $e');
    }
  }

  /// Obtém todas as sessões ativas do usuário
  Future<List<ActiveSession>> getActiveSessions(String userId) async {
    try {
      final currentDeviceId = await getDeviceId();
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .where('lastAccessAt', isGreaterThan: cutoffDate.toIso8601String())
          .get();

      return snapshot.docs
          .map((doc) => ActiveSession.fromJson(doc.data(), currentDeviceId))
          .toList()
        ..sort((a, b) => b.lastAccessAt.compareTo(a.lastAccessAt));
    } catch (e) {
      print('Erro ao buscar sessões ativas: $e');
      return [];
    }
  }

  /// Revoga uma sessão específica
  Future<void> revokeSession(String userId, String sessionId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .delete();
    } catch (e) {
      print('Erro ao revogar sessão: $e');
    }
  }

  /// Revoga todas as sessões exceto a atual
  Future<void> revokeAllOtherSessions(String userId) async {
    try {
      final currentSessionId = _prefs.getString('current_session_id');
      if (currentSessionId == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        if (doc.id != currentSessionId) {
          batch.delete(doc.reference);
        }
      }

      await batch.commit();
    } catch (e) {
      print('Erro ao revogar todas as sessões: $e');
    }
  }

  /// Remove a sessão atual ao fazer logout
  Future<void> endCurrentSession(String userId) async {
    try {
      final sessionId = _prefs.getString('current_session_id');
      if (sessionId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .delete();

      await _prefs.remove('current_session_id');
    } catch (e) {
      print('Erro ao encerrar sessão: $e');
    }
  }

  /// Limpa sessões antigas (mais de 30 dias sem acesso)
  Future<void> cleanOldSessions(String userId) async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .where('lastAccessAt', isLessThan: cutoffDate.toIso8601String())
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Erro ao limpar sessões antigas: $e');
    }
  }

  /// Obtém informações do dispositivo
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return {
          'deviceName': '${info.manufacturer} ${info.model}',
          'deviceType': 'android',
        };
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return {
          'deviceName': '${info.name} (${info.model})',
          'deviceType': 'ios',
        };
      } else if (Platform.isWindows) {
        final info = await _deviceInfo.windowsInfo;
        return {'deviceName': info.computerName, 'deviceType': 'windows'};
      } else if (Platform.isMacOS) {
        final info = await _deviceInfo.macOsInfo;
        return {'deviceName': info.computerName, 'deviceType': 'macos'};
      } else if (Platform.isLinux) {
        final info = await _deviceInfo.linuxInfo;
        return {'deviceName': info.prettyName, 'deviceType': 'linux'};
      }
    } catch (e) {
      print('Erro ao obter informações do dispositivo: $e');
    }

    return {'deviceName': 'Unknown Device', 'deviceType': 'unknown'};
  }
}
