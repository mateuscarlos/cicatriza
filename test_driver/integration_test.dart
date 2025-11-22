import 'package:integration_test/integration_test_driver.dart';

/// Driver para executar testes de integração.
///
/// Para executar os testes:
/// ```
/// flutter test integration_test/profile_flow_test.dart
/// ```
///
/// Para executar em um dispositivo específico:
/// ```
/// flutter drive \
///   --driver=test_driver/integration_test.dart \
///   --target=integration_test/profile_flow_test.dart \
///   -d <device_id>
/// ```
Future<void> main() => integrationDriver();
