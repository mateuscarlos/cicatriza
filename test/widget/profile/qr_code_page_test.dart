import 'dart:async';
import 'dart:io';
import 'package:cicatriza/domain/entities/user_profile.dart';
import 'package:cicatriza/presentation/pages/profile/qr_code_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient extends Fake implements HttpClient {
  @override
  set autoUncompress(bool value) {}

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MockHttpClientRequest();
  }
}

class MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }
}

class MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

final kTransparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testProfile = UserProfile(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Dr. Test',
    crmCofen: '123456-SP',
    specialty: 'Dermatologia',
    institution: 'Hospital Teste',
    role: 'Médico',
    photoURL: 'https://example.com/photo.jpg',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    ownerId: '123',
  );

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: QrCodePage(profile: testProfile),
      ),
    );
  }

  group('QrCodePage', () {
    setUp(() {
      // Set a large screen size to avoid scrolling issues
      final TestWidgetsFlutterBinding binding =
          TestWidgetsFlutterBinding.ensureInitialized();
      binding.window.physicalSizeTestValue = const Size(1080, 2400);
      binding.window.devicePixelRatioTestValue = 1.0;
    });

    tearDown(() {
      final TestWidgetsFlutterBinding binding =
          TestWidgetsFlutterBinding.ensureInitialized();
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    testWidgets('renders correctly with profile data', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify AppBar title
      expect(find.text('QR Code do Perfil'), findsOneWidget);

      // Verify Profile Info in Header
      expect(find.text('Dr. Test'), findsOneWidget);
      expect(find.text('Dermatologia'), findsOneWidget);

      // Verify QR Code is present
      expect(find.byType(QrImageView), findsOneWidget);

      // Verify Detailed Info
      expect(find.text('Informações Profissionais'), findsOneWidget);
      expect(find.text('123456-SP'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Hospital Teste'), findsOneWidget);
      expect(find.text('Médico'), findsOneWidget);
    });

    testWidgets('shows snackbar when share button is pressed', (tester) async {
      // Mock Clipboard
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (
            methodCall,
          ) async {
            if (methodCall.method == 'Clipboard.setData') {
              log.add(methodCall);
            }
            return null;
          });

      await tester.pumpWidget(createWidgetUnderTest());

      // Tap share button in AppBar
      await tester.tap(find.byIcon(Icons.share));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(seconds: 2)); // Finish animation

      // Verify SnackBar
      expect(
        find.text('Informações copiadas para a área de transferência'),
        findsOneWidget,
      );

      // Verify Clipboard was called
      expect(log, isNotEmpty);
      expect(log.first.method, 'Clipboard.setData');
      final data = log.first.arguments as Map;
      expect(data['text'], contains('Dr. Test'));
      expect(data['text'], contains('123456-SP'));
    });

    testWidgets('shows snackbar when copy button is pressed', (tester) async {
      // Mock Clipboard
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (
            methodCall,
          ) async {
            if (methodCall.method == 'Clipboard.setData') {
              log.add(methodCall);
            }
            return null;
          });

      await tester.pumpWidget(createWidgetUnderTest());

      // Tap copy button (should be visible with large screen)
      final buttonFinder = find.text('Copiar Informações');
      await tester.tap(buttonFinder);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Verify SnackBar
      expect(
        find.text('Informações copiadas para a área de transferência'),
        findsOneWidget,
      );
      // Verify Clipboard was called
      expect(log, isNotEmpty);
    });

    testWidgets('shows "in development" snackbar when save button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap save button (should be visible with large screen)
      final buttonFinder = find.text('Salvar QR Code');
      await tester.tap(buttonFinder);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Verify SnackBar
      expect(find.text('Funcionalidade em desenvolvimento'), findsOneWidget);
    });

    testWidgets('renders correctly with missing optional data', (tester) async {
      final partialProfile = UserProfile(
        uid: '123',
        email: 'test@example.com',
        specialty: 'Enfermagem',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ownerId: '123',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: QrCodePage(profile: partialProfile),
          ),
        ),
      );

      expect(find.text('Nome não informado'), findsOneWidget);
      expect(find.text('Não informado'), findsAtLeastNWidgets(1)); // CRM
      expect(find.text('Enfermagem'), findsOneWidget);
    });
  });
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    // Return transparent image for any png request to be safe
    if (key.contains('.png')) {
      return ByteData.view(Uint8List.fromList(kTransparentImage).buffer);
    }
    return ByteData(0);
  }
}
