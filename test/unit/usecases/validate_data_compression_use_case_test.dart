import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../lib/domain/entities/patient.dart';
import '../../../lib/domain/repositories/patient_repository.dart';
import '../../../lib/domain/usecases/migration/validate_data_compression_use_case_v2.dart';
import '../../../lib/domain/value_objects/contato_emergencia.dart';
import '../../../lib/domain/value_objects/endereco.dart';
import '../../../lib/domain/value_objects/consentimentos.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  group('ValidateDataCompressionUseCase', () {
    late ValidateDataCompressionUseCase useCase;
    late MockPatientRepository mockPatientRepository;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUp(() {
      mockPatientRepository = MockPatientRepository();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      useCase = ValidateDataCompressionUseCase(
        patientRepository: mockPatientRepository,
        auth: mockFirebaseAuth,
      );
    });

    group('execute', () {
      test(
        'deve retornar erro quando usuário não estiver autenticado',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          final result = await useCase.execute(
            const ValidateCompressionInput(),
          );

          // Assert
          expect(result.isFailure, true);
          expect(
            result.fold(
              onSuccess: (data) => false,
              onFailure: (error) => error is ValidationError,
            ),
            true,
          );
        },
      );

      test(
        'deve retornar warning quando não há pacientes para testar',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn('user123');
          when(mockPatientRepository.getPatients()).thenAnswer((_) async => []);

          // Act
          final result = await useCase.execute(
            const ValidateCompressionInput(),
          );

          // Assert
          expect(result.isSuccess, true);
          final validationResult = result.fold(
            onSuccess: (data) => data,
            onFailure: (error) => null,
          );

          expect(validationResult?.overallResult, ValidationStatus.warning);
          expect(
            validationResult?.issues.first,
            'Nenhum paciente encontrado para teste',
          );
        },
      );

      test('deve validar compressão de dados clínicos com sucesso', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('user123');

        final testPatient = Patient(
          id: 'patient1',
          ownerId: 'user123',
          pacienteId: 'patient1',
          name: 'João Silva',
          nameLowercase: 'joão silva',
          birthDate: DateTime(1980, 1, 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          consentimentos: Consentimentos.padrao(),
          status: StatusPaciente.ativo,
          versao: 5,
          contatoEmergencia: ContatoEmergencia(
            nome: 'Maria Silva',
            telefone: '11999999999',
            parentesco: 'Esposa',
          ),
          endereco: Endereco(
            cep: '01234-567',
            logradouro: 'Rua das Flores',
            numero: '123',
            bairro: 'Centro',
            cidade: 'São Paulo',
            estado: 'SP',
          ),
          alergias: ['Dipirona', 'Penicilina'],
          comorbidades: ['Diabetes', 'Hipertensão'],
          tags: ['Prioridade', 'Acompanhamento'],
        );

        when(
          mockPatientRepository.getPatients(),
        ).thenAnswer((_) async => [testPatient]);

        // Act
        final result = await useCase.execute(
          const ValidateCompressionInput(maxPatientsToTest: 1),
        );

        // Assert
        expect(result.isSuccess, true);
        final validationResult = result.fold(
          onSuccess: (data) => data,
          onFailure: (error) => null,
        );

        expect(validationResult?.overallResult, ValidationStatus.success);
        expect(validationResult?.testedPatients.length, 1);

        final patientTest = validationResult?.testedPatients.first;
        expect(patientTest?.patientId, 'patient1');
        expect(patientTest?.hasSignificantData, true);
        expect(patientTest?.success, true);
        expect(patientTest?.compressionStats.originalSize, greaterThan(0));
        expect(patientTest?.compressionStats.compressedSize, greaterThan(0));
      });

      test(
        'deve detectar quando paciente não tem dados clínicos significativos',
        () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn('user123');

          final basicPatient = Patient(
            id: 'patient2',
            ownerId: 'user123',
            pacienteId: 'patient2',
            name: 'Ana Santos',
            nameLowercase: 'ana santos',
            birthDate: DateTime(1990, 1, 1),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            consentimentos: Consentimentos.padrao(),
            status: StatusPaciente.ativo,
            versao: 5,
            // Sem dados clínicos significativos
          );

          when(
            mockPatientRepository.getPatients(),
          ).thenAnswer((_) async => [basicPatient]);

          // Act
          final result = await useCase.execute(
            const ValidateCompressionInput(),
          );

          // Assert
          expect(result.isSuccess, true);
          final validationResult = result.fold(
            onSuccess: (data) => data,
            onFailure: (error) => null,
          );

          final patientTest = validationResult?.testedPatients.first;
          expect(patientTest?.hasSignificantData, false);
          expect(patientTest?.compressionStats.patientsWithCompression, 0);
          expect(patientTest?.compressionStats.patientsWithoutCompression, 1);
        },
      );

      test('deve limitar número de pacientes testados', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('user123');

        final patients = List.generate(
          20,
          (index) => Patient(
            id: 'patient$index',
            ownerId: 'user123',
            pacienteId: 'patient$index',
            name: 'Paciente $index',
            nameLowercase: 'paciente $index',
            birthDate: DateTime(1980 + index, 1, 1),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            consentimentos: Consentimentos.padrao(),
            status: StatusPaciente.ativo,
            versao: 5,
          ),
        );

        when(
          mockPatientRepository.getPatients(),
        ).thenAnswer((_) async => patients);

        // Act
        final result = await useCase.execute(
          const ValidateCompressionInput(maxPatientsToTest: 5),
        );

        // Assert
        expect(result.isSuccess, true);
        final validationResult = result.fold(
          onSuccess: (data) => data,
          onFailure: (error) => null,
        );

        expect(validationResult?.testedPatients.length, 5);
      });

      test('deve testar apenas pacientes especificados por ID', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('user123');

        final patients = [
          Patient(
            id: 'patient1',
            ownerId: 'user123',
            pacienteId: 'patient1',
            name: 'Paciente 1',
            nameLowercase: 'paciente 1',
            birthDate: DateTime(1980, 1, 1),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            consentimentos: Consentimentos.padrao(),
            status: StatusPaciente.ativo,
            versao: 5,
          ),
          Patient(
            id: 'patient2',
            ownerId: 'user123',
            pacienteId: 'patient2',
            name: 'Paciente 2',
            nameLowercase: 'paciente 2',
            birthDate: DateTime(1985, 1, 1),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            consentimentos: Consentimentos.padrao(),
            status: StatusPaciente.ativo,
            versao: 5,
          ),
        ];

        when(
          mockPatientRepository.getPatients(),
        ).thenAnswer((_) async => patients);

        // Act
        final result = await useCase.execute(
          const ValidateCompressionInput(patientIds: ['patient1']),
        );

        // Assert
        expect(result.isSuccess, true);
        final validationResult = result.fold(
          onSuccess: (data) => data,
          onFailure: (error) => null,
        );

        expect(validationResult?.testedPatients.length, 1);
        expect(validationResult?.testedPatients.first.patientId, 'patient1');
      });
    });

    group('CompressionStats', () {
      test('deve calcular estatísticas combinadas corretamente', () {
        // Arrange
        final stats1 = CompressionStats(
          originalSize: 1000,
          compressedSize: 500,
          compressionRatio: 2.0,
          compressionTime: Duration(milliseconds: 10),
          decompressionTime: Duration(milliseconds: 5),
          patientsWithCompression: 1,
          patientsWithoutCompression: 0,
        );

        final stats2 = CompressionStats(
          originalSize: 2000,
          compressedSize: 800,
          compressionRatio: 2.5,
          compressionTime: Duration(milliseconds: 20),
          decompressionTime: Duration(milliseconds: 10),
          patientsWithCompression: 1,
          patientsWithoutCompression: 1,
        );

        // Act
        final combined = stats1.combine(stats2);

        // Assert
        expect(combined.originalSize, 3000);
        expect(combined.compressedSize, 1300);
        expect(combined.compressionRatio, 2.25); // Média dos ratios
        expect(combined.compressionTime, Duration(milliseconds: 30));
        expect(combined.decompressionTime, Duration(milliseconds: 15));
        expect(combined.patientsWithCompression, 2);
        expect(combined.patientsWithoutCompression, 1);
        expect(combined.totalPatients, 3);
      });

      test('deve calcular percentual de economia de espaço corretamente', () {
        // Arrange
        final stats = CompressionStats(
          originalSize: 1000,
          compressedSize: 250,
          compressionRatio: 4.0,
          compressionTime: Duration.zero,
          decompressionTime: Duration.zero,
          patientsWithCompression: 1,
          patientsWithoutCompression: 0,
        );

        // Act & Assert
        expect(stats.spaceSavingsPercent, 75.0); // 75% de economia
      });
    });
  });
}
