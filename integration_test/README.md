# Guia de Testes de Integração

## Visão Geral

Os testes de integração verificam o fluxo end-to-end da aplicação, incluindo:
- Autenticação (login/logout)
- Navegação entre telas
- Interação com Firebase
- Persistência de dados
- Fluxos completos de usuário

## Pré-requisitos

### 1. Firebase Test Environment

Crie um usuário de teste no Firebase Authentication:

```bash
Email: teste@cicatriza.com
Senha: Teste123!
```

**Importante**: Use um projeto Firebase de teste/desenvolvimento, não produção!

### 2. Configuração do Perfil de Teste

No Firestore, crie um documento de perfil para o usuário de teste:

```
Collection: profiles
Document ID: <uid_do_usuario_teste>
Fields:
  - name: "Dr. Teste Silva"
  - email: "teste@cicatriza.com"
  - professionalId: "CRM 12345"
  - specialty: "Enfermagem"
  - phone: "(11) 98765-4321"
  - createdAt: <timestamp>
  - updatedAt: <timestamp>
```

### 3. Permissões do Firestore

Certifique-se de que as regras do Firestore permitem leitura/escrita para usuários autenticados:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /profiles/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Executando os Testes

### Opção 1: Teste Rápido (Recomendado)

Execute o teste de integração diretamente:

```bash
flutter test integration_test/profile_flow_test.dart
```

### Opção 2: Com Driver (Para dispositivos físicos/emuladores)

1. Inicie um emulador ou conecte um dispositivo físico
2. Liste os dispositivos disponíveis:

```bash
flutter devices
```

3. Execute o teste no dispositivo escolhido:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/profile_flow_test.dart \
  -d <device_id>
```

### Opção 3: Firebase Test Lab (CI/CD)

Para executar em múltiplos dispositivos na nuvem:

1. Configure o projeto no Firebase Console
2. Use o gcloud CLI:

```bash
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
  --device model=Pixel2,version=28,locale=pt_BR,orientation=portrait
```

## Estrutura dos Testes

### profile_flow_test.dart

Contém 4 testes principais:

1. **should navigate to profile page and display user information**
   - Faz login
   - Navega para perfil
   - Verifica elementos da UI

2. **should edit profile name and save changes**
   - Edita o nome do perfil
   - Salva as alterações
   - Verifica feedback de sucesso

3. **should switch between profile tabs**
   - Troca entre tabs de Identificação e Contato
   - Verifica navegação correta

4. **should display QR code when button is tapped**
   - Abre o QR code do perfil
   - Verifica que o dialog aparece

## Timeout e Performance

Os testes de integração têm timeout de **2 minutos** por padrão. Se os testes falharem por timeout:

1. Verifique a conexão com Firebase
2. Certifique-se de que o emulador/dispositivo tem performance adequada
3. Aumente o timeout se necessário:

```dart
timeout: const Timeout(Duration(minutes: 3)),
```

## Depuração

### Logs Detalhados

Ative logs verbosos durante a execução:

```bash
flutter test integration_test/profile_flow_test.dart --verbose
```

### Screenshots

Adicione capturas de tela em pontos críticos:

```dart
await binding.takeScreenshot('profile_page_loaded');
```

### Pausar Execução

Para depurar visualmente:

```dart
await tester.pumpAndSettle();
await Future.delayed(const Duration(seconds: 5)); // Pausa de 5 segundos
```

## Troubleshooting

### Erro: "Não conseguiu encontrar elemento"

- Aumente o tempo de `pumpAndSettle`
- Verifique se a UI está carregando corretamente
- Use `find.byType` em vez de `find.text` para elementos dinâmicos

### Erro: "Firebase authentication failed"

- Verifique as credenciais de teste
- Confirme que o usuário existe no Firebase Authentication
- Verifique a conexão com internet

### Erro: "Timeout waiting for..."

- Aumente o timeout do teste
- Verifique a performance do dispositivo/emulador
- Simplifique o fluxo do teste

## Boas Práticas

1. **Isolamento**: Cada teste deve ser independente
2. **Dados de Teste**: Use dados consistentes e previsíveis
3. **Cleanup**: Restaure o estado inicial após cada teste
4. **Timeout**: Configure timeouts apropriados para operações de rede
5. **Assertions**: Verifique múltiplos aspectos da UI
6. **Documentação**: Comente passos complexos do teste

## Métricas de Sucesso

Os testes de integração devem:
- ✅ Executar em menos de 2 minutos
- ✅ Ter taxa de sucesso > 95%
- ✅ Cobrir fluxos críticos do usuário
- ✅ Detectar regressões de UI
- ✅ Validar integração com Firebase

## Próximos Passos

1. Adicionar testes para outros módulos (Pacientes, Feridas, Avaliações)
2. Integrar com CI/CD pipeline
3. Configurar Firebase Test Lab
4. Implementar testes de performance
5. Adicionar cobertura de testes de acessibilidade
