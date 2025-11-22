import 'dart:async';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Configuração global para golden tests
///
/// Este arquivo é automaticamente carregado antes de executar
/// qualquer teste na pasta test/golden/
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      // Gera imagens apenas se o teste falhar ou se forçado
      skipGoldenAssertion: () => false,
      // Define o padrão de nomes para os arquivos golden
      fileNameFactory: (String name) => '$name.png',
    ),
  );
}
