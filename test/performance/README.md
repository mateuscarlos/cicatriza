# Guia de Testes de Performance - Cicatriza

## Visão Geral

Testes de performance garantem que a aplicação mantém responsividade e fluidez sob diversas condições. Este guia documenta métricas, ferramentas e melhores práticas.

## Métricas de Performance

### 1. Build Time (Tempo de Construção)

**Meta**: < 100ms para primeira renderização

```dart
testWidgets('should build quickly', (tester) async {
  final stopwatch = Stopwatch()..start();
  await tester.pumpWidget(MyWidget());
  await tester.pumpAndSettle();
  stopwatch.stop();
  
  expect(stopwatch.elapsed, lessThan(Duration(milliseconds: 100)));
});
```

**Por que importa**: Build lento causa atraso visível ao abrir telas.

### 2. Frame Rate (Taxa de Quadros)

**Meta**: 60 FPS (< 16ms por frame)

```dart
// 60 FPS = 16.67ms por frame
const targetFrameTime = Duration(milliseconds: 16);
```

**Medição**:
- Use `flutter run --profile` e DevTools Performance tab
- Timeline mostra frame time
- Jank (frame drops) aparece em vermelho

### 3. Scroll Performance

**Meta**: Scroll suave sem jank, < 500ms para completar

```dart
testWidgets('should scroll smoothly', (tester) async {
  final scrollable = find.byType(Scrollable);
  await tester.drag(scrollable, Offset(0, -300));
  await tester.pumpAndSettle();
});
```

### 4. Input Response (Resposta a Input)

**Meta**: < 50ms de resposta ao toque/digitação

```dart
testWidgets('should respond to input quickly', (tester) async {
  final stopwatch = Stopwatch()..start();
  await tester.tap(find.byType(Button));
  await tester.pump();
  stopwatch.stop();
  
  expect(stopwatch.elapsed, lessThan(Duration(milliseconds: 50)));
});
```

### 5. Uso de Memória

**Meta**: Crescimento de memória estável, sem memory leaks

**Monitoramento**:
```bash
flutter run --profile
# No DevTools: Memory tab -> Track allocations
```

## Ferramentas de Teste

### 1. Flutter DevTools

**Performance Tab:**

```bash
# Executar em modo profile
flutter run --profile

# Abrir DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

**Análise**:
- Timeline: Visualiza frame rendering
- CPU profiler: Identifica gargalos
- Memory profiler: Detecta leaks
- Network monitor: Analisa requisições

### 2. Testes Automatizados

```bash
# Executar testes de performance
flutter test test/performance/

# Com relatório detalhado
flutter test test/performance/ --reporter=expanded
```

### 3. flutter_driver (Performance profiling)

Para testes mais avançados:

```yaml
dev_dependencies:
  flutter_driver:
    sdk: flutter
```

```dart
import 'package:flutter_driver/flutter_driver.dart';

void main() {
  group('ProfilePage Performance', () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test('measure timeline performance', () async {
      final timeline = await driver!.traceAction(() async {
        await driver!.tap(find.text('Meu Perfil'));
        await Future.delayed(Duration(seconds: 2));
      });

      final summary = TimelineSummary.summarize(timeline);
      
      // Salvar relatório
      await summary.writeSummaryToFile('profile_timeline', pretty: true);
      await summary.writeTimelineToFile('profile_timeline', pretty: true);
    });
  });
}
```

### 4. Benchmark Manual

```dart
import 'package:flutter/foundation.dart';

void benchmarkFunction() {
  final stopwatch = Stopwatch()..start();
  
  // Código a medir
  expensiveOperation();
  
  stopwatch.stop();
  debugPrint('Operation took: ${stopwatch.elapsedMilliseconds}ms');
}
```

## Melhores Práticas

### 1. Evitar Rebuilds Desnecessários

```dart
// ❌ Ruim - rebuild em cada frame
Widget build(BuildContext context) {
  return Container(
    child: ExpensiveWidget(data: DateTime.now()),
  );
}

// ✅ Bom - usa const quando possível
Widget build(BuildContext context) {
  return const Container(
    child: ExpensiveWidget(),
  );
}
```

### 2. Usar ListView.builder para Listas Longas

```dart
// ❌ Ruim - cria todos os widgets de uma vez
ListView(
  children: List.generate(1000, (i) => ListTile(title: Text('$i'))),
)

// ✅ Bom - lazy loading
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) => ListTile(title: Text('$index')),
)
```

### 3. Otimizar Imagens

```dart
// Usar Image.network com caching
Image.network(
  imageUrl,
  cacheWidth: 500, // Limitar tamanho
  cacheHeight: 500,
)

// Ou CachedNetworkImage
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 4. Minimizar Computações Pesadas no Build

```dart
// ❌ Ruim - computação no build
Widget build(BuildContext context) {
  final processedData = expensiveComputation(data);
  return Text(processedData);
}

// ✅ Bom - computação fora do build
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late String processedData;
  
  @override
  void initState() {
    super.initState();
    processedData = expensiveComputation(data);
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(processedData);
  }
}
```

### 5. Usar RepaintBoundary para Widgets Complexos

```dart
RepaintBoundary(
  child: ComplexAnimatedWidget(),
)
```

### 6. Profile Antes de Otimizar

```bash
# SEMPRE profile em modo release ou profile
flutter run --profile  # Para debugging
flutter run --release  # Para produção
```

**Nunca** use debug mode para medir performance!

## Benchmarks do ProfilePage

### Resultados Esperados

| Métrica | Meta | Típico |
|---------|------|--------|
| Build inicial | < 100ms | 50-80ms |
| Frame time | < 16ms | 8-12ms |
| Tab switch | < 16ms | 10ms |
| Scroll | < 500ms | 200-300ms |
| Input response | < 50ms | 20-30ms |
| State transition | < 200ms | 100-150ms |
| Button press | < 50ms | 10-20ms |
| Complete flow | < 500ms | 300-400ms |

### Executar Benchmarks

```bash
# Testes de performance
flutter test test/performance/profile_page_performance_test.dart

# Com saída detalhada
flutter test test/performance/profile_page_performance_test.dart --reporter=expanded

# Profile completo com flutter_driver
flutter drive \
  --target=test_driver/app.dart \
  --profile
```

## Otimizações Implementadas no ProfilePage

### 1. Lazy Loading de Tabs

```dart
TabBarView(
  children: [
    // Tabs são construídas apenas quando visíveis
    IdentificationTab(),
    ContactTab(),
  ],
)
```

### 2. Form Controllers Otimizados

```dart
// Reutilizar controllers ao invés de recriar
final _nameController = TextEditingController();

@override
void dispose() {
  _nameController.dispose();
  super.dispose();
}
```

### 3. Estado Imutável com Equatable

```dart
class ProfileState extends Equatable {
  // Equatable previne rebuilds desnecessários
  @override
  List<Object?> get props => [profile, timestamp];
}
```

### 4. Skeleton Loader Eficiente

```dart
// Shimmer com RepaintBoundary
RepaintBoundary(
  child: Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: SkeletonLoader(),
  ),
)
```

## Troubleshooting

### Problema: Build lento

**Diagnóstico**:
```bash
flutter run --profile
# DevTools -> Performance -> Timeline
# Procurar por frames vermelhos
```

**Soluções**:
- Reduzir profundidade da árvore de widgets
- Usar const constructors
- Implementar shouldRebuild em CustomPainter
- Separar widgets complexos

### Problema: Jank durante scroll

**Diagnóstico**:
```bash
flutter run --profile
# Scroll e observe Timeline
```

**Soluções**:
- Usar ListView.builder
- Adicionar RepaintBoundary
- Otimizar imagens com cacheWidth/Height
- Evitar setState durante scroll

### Problema: Memory leak

**Diagnóstico**:
```bash
flutter run --profile
# DevTools -> Memory -> Snapshot
# Navegar pela app e tirar snapshots
```

**Soluções**:
- Dispose controllers e streams
- Cancel subscriptions
- Usar WeakReference quando apropriado
- Verificar circular references

## Integração Contínua

### GitHub Actions - Performance Tests

```yaml
name: Performance Tests

on: [pull_request]

jobs:
  performance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test test/performance/
      - name: Check thresholds
        run: |
          # Script para verificar se métricas estão dentro dos limites
          ./scripts/check_performance.sh
```

## Recursos Adicionais

### Documentação

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Flutter Performance Profiling](https://docs.flutter.dev/perf/ui-performance)
- [Reducing shader compilation jank](https://docs.flutter.dev/perf/shader)

### Ferramentas

- [Flutter DevTools](https://docs.flutter.dev/tools/devtools/overview)
- [flutter_driver](https://api.flutter.dev/flutter/flutter_driver/flutter_driver-library.html)
- [performance_test](https://pub.dev/packages/performance_test)

### Artigos

- [Performance tips for Flutter](https://medium.com/flutter-community/performance-tips-for-flutter-a6c084e0c57c)
- [Optimizing Flutter performance](https://blog.codemagic.io/optimizing-flutter-app-performance/)

---

**Última atualização**: Novembro 2025
**Meta FPS**: 60 FPS (16ms/frame)
**Target Build Time**: < 100ms
