import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cicatriza/presentation/pages/profile/widgets/profile_form_sections.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
    return MockHttpClientRequest(url);
  }
}

class MockHttpClientRequest extends Fake implements HttpClientRequest {
  final Uri url;
  MockHttpClientRequest(this.url);

  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse(url);
  }
}

class MockHttpClientResponse extends Fake implements HttpClientResponse {
  final Uri url;
  MockHttpClientResponse(this.url);

  @override
  int get statusCode => 200;

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
    String body = '{}';
    if (url.toString().contains('viacep.com.br')) {
      if (url.toString().contains('01001000')) {
        body =
            '{"cep": "01001-000", "logradouro": "Praça da Sé", "complemento": "lado ímpar", "bairro": "Sé", "localidade": "São Paulo", "uf": "SP", "ibge": "3550308", "gia": "1004", "ddd": "11", "siafi": "7107"}';
      } else {
        body = '{"erro": true}';
      }
    }
    return Stream<List<int>>.fromIterable([utf8.encode(body)]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class MockDioAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path.contains('01001000')) {
      return ResponseBody.fromString(
        '{"cep": "01001-000", "logradouro": "Praça da Sé", "complemento": "lado ímpar", "bairro": "Sé", "localidade": "São Paulo", "uf": "SP", "ibge": "3550308", "gia": "1004", "ddd": "11", "siafi": "7107"}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    return ResponseBody.fromString(
      '{"erro": true}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  group('IdentificationSection', () {
    late TextEditingController nameController;
    late TextEditingController crmController;
    late TextEditingController specialtyController;
    late TextEditingController institutionController;
    late TextEditingController roleController;

    setUp(() {
      nameController = TextEditingController();
      crmController = TextEditingController();
      specialtyController = TextEditingController();
      institutionController = TextEditingController();
      roleController = TextEditingController();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: IdentificationSection(
              nameController: nameController,
              crmController: crmController,
              specialtyController: specialtyController,
              institutionController: institutionController,
              roleController: roleController,
            ),
          ),
        ),
      );
    }

    testWidgets('renders all fields correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Identificação Profissional'), findsOneWidget);
      expect(find.text('Nome Completo'), findsOneWidget);
      expect(find.text('Registro Profissional (CRM/COREN)'), findsOneWidget);
      expect(find.text('Especialidade'), findsOneWidget);
      expect(find.text('Instituição / Clínica'), findsOneWidget);
      expect(find.text('Cargo / Função'), findsOneWidget);
    });

    testWidgets('validates name field', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the form field
      final nameField = find.widgetWithText(TextFormField, 'Nome Completo');

      // Enter invalid name (too short)
      await tester.enterText(nameField, 'Ab');
      await tester.pump();

      // Trigger validation (usually happens on form submit, but here we can check if validator logic works by wrapping in Form)
      // Since IdentificationSection is just a widget, we need to wrap it in a Form to trigger validation

      // Re-pump with Form
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: IdentificationSection(
                  nameController: nameController,
                  crmController: crmController,
                  specialtyController: specialtyController,
                  institutionController: institutionController,
                  roleController: roleController,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome Completo'),
        'Ab',
      );
      await tester.pump();
      expect(
        find.text('Nome deve ter pelo menos 3 caracteres'),
        findsOneWidget,
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome Completo'),
        'Valid Name',
      );
      await tester.pump();
      expect(find.text('Nome deve ter pelo menos 3 caracteres'), findsNothing);
    });

    testWidgets('validates CRM field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: IdentificationSection(
                  nameController: nameController,
                  crmController: crmController,
                  specialtyController: specialtyController,
                  institutionController: institutionController,
                  roleController: roleController,
                ),
              ),
            ),
          ),
        ),
      );

      final crmField = find.widgetWithText(
        TextFormField,
        'Registro Profissional (CRM/COREN)',
      );

      await tester.enterText(crmField, '123');
      await tester.pump();
      expect(find.text('Formato inválido. Use: 123456-UF'), findsOneWidget);

      await tester.enterText(crmField, '123456-SP');
      await tester.pump();
      expect(find.text('Formato inválido. Use: 123456-UF'), findsNothing);
    });

    testWidgets('validates name with numbers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: IdentificationSection(
                  nameController: nameController,
                  crmController: crmController,
                  specialtyController: specialtyController,
                  institutionController: institutionController,
                  roleController: roleController,
                ),
              ),
            ),
          ),
        ),
      );

      final nameField = find.widgetWithText(TextFormField, 'Nome Completo');
      await tester.enterText(nameField, 'User 123');
      await tester.pump();
      expect(
        find.text('Nome não pode conter números ou caracteres especiais'),
        findsOneWidget,
      );
    });

    testWidgets('validates empty fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: IdentificationSection(
                  nameController: nameController,
                  crmController: crmController,
                  specialtyController: specialtyController,
                  institutionController: institutionController,
                  roleController: roleController,
                ),
              ),
            ),
          ),
        ),
      );

      // Trigger validation by entering empty text
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome Completo'),
        '',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Registro Profissional (CRM/COREN)'),
        '',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Especialidade'),
        '',
      );
      await tester.pump();

      expect(find.text('Por favor, insira seu nome completo'), findsOneWidget);
      expect(
        find.text('Por favor, insira seu registro profissional'),
        findsOneWidget,
      );
      expect(find.text('Por favor, insira sua especialidade'), findsOneWidget);
    });
  });

  group('ContactSection', () {
    late TextEditingController emailController;
    late TextEditingController phoneController;
    late TextEditingController cepController;
    late TextEditingController addressController;

    setUp(() {
      emailController = TextEditingController();
      phoneController = TextEditingController();
      cepController = TextEditingController();
      addressController = TextEditingController();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ContactSection(
              emailController: emailController,
              phoneController: phoneController,
              cepController: cepController,
              addressController: addressController,
            ),
          ),
        ),
      );
    }

    testWidgets('renders all fields correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Contato e Comunicação'), findsOneWidget);
      expect(find.text('E-mail Profissional'), findsOneWidget);
      expect(find.text('Telefone (WhatsApp)'), findsOneWidget);
      expect(find.text('CEP'), findsOneWidget);
      expect(find.text('Endereço'), findsOneWidget);
    });

    testWidgets('validates phone field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: ContactSection(
                  emailController: emailController,
                  phoneController: phoneController,
                  cepController: cepController,
                  addressController: addressController,
                ),
              ),
            ),
          ),
        ),
      );

      final phoneField = find.widgetWithText(
        TextFormField,
        'Telefone (WhatsApp)',
      );

      await tester.enterText(phoneField, '123');
      await tester.pump();
      expect(find.text('Telefone inválido'), findsOneWidget);

      // Use plain digits to avoid formatter issues in test environment
      await tester.enterText(phoneField, '11999999999');
      await tester.pump();
      expect(find.text('Telefone inválido'), findsNothing);
    });

    testWidgets('searches CEP successfully', (tester) async {
      final dio = Dio();
      dio.httpClientAdapter = MockDioAdapter();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactSection(
                emailController: emailController,
                phoneController: phoneController,
                cepController: cepController,
                addressController: addressController,
                dio: dio,
              ),
            ),
          ),
        ),
      );

      final cepField = find.widgetWithText(TextFormField, 'CEP');

      // Enter valid CEP (01001-000)
      await tester.enterText(cepField, '01001000');
      await tester.pump(); // Trigger onChanged

      // Wait for async operation
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify address field is updated
      expect(addressController.text, contains('Praça da Sé'));
      expect(find.text('CEP encontrado!'), findsOneWidget);
    });
    testWidgets('handles CEP not found', (tester) async {
      final dio = Dio();
      dio.httpClientAdapter = MockDioAdapter();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactSection(
                emailController: emailController,
                phoneController: phoneController,
                cepController: cepController,
                addressController: addressController,
                dio: dio,
              ),
            ),
          ),
        ),
      );

      final cepField = find.widgetWithText(TextFormField, 'CEP');

      // Enter unknown CEP
      await tester.enterText(cepField, '99999999');
      await tester.pump();

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('CEP não encontrado'), findsOneWidget);
    });
  });
}
