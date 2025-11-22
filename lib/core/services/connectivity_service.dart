import 'package:connectivity_plus/connectivity_plus.dart';

/// Serviço para verificar conectividade com a internet
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Verifica se há conexão com a internet
  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }

  /// Monitora mudanças de conectividade
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet,
      );
    });
  }
}
