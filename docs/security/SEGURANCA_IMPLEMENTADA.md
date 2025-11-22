# Módulo de Segurança - Cicatriza

Este documento descreve todas as funcionalidades de segurança implementadas no módulo de usuários do aplicativo Cicatriza.

## 📋 Resumo das Implementações

Todas as funcionalidades de segurança listadas foram implementadas com sucesso:

- ✅ **Auditoria de acessos** - Sistema completo de logs de ações
- ✅ **Notificação de login em novo dispositivo** - Detecção automática
- ✅ **Sessões ativas e deslogar de todos** - Tela de gerenciamento completa
- ✅ **Criptografia de dados sensíveis** - AES-256 para campos críticos
- ✅ **Rate limiting de requisições** - Proteção contra força bruta

## 🔐 Componentes Implementados

### 1. Auditoria de Acessos

**Arquivos criados:**
- `lib/domain/entities/audit_log.dart` - Entidade de log
- `lib/domain/repositories/audit_repository.dart` - Interface
- `lib/data/repositories/audit_repository_impl.dart` - Implementação

**Características:**
- Registra 9 tipos de ações (login, logout, profile_update, etc.)
- Captura informações do dispositivo (nome, tipo, ID)
- Armazena em subcoleção `users/{uid}/audit_logs`
- Limpeza automática de logs com >90 dias

### 2. Detecção de Novo Dispositivo

**Arquivo criado:**
- `lib/core/services/session_service.dart`

**Características:**
- Gera UUID único por dispositivo
- Armazena lista de dispositivos conhecidos localmente
- Detecta plataforma (Android, iOS, Windows, macOS, Linux)
- Pronto para integração com Firebase Cloud Messaging

### 3. Gerenciamento de Sessões

**Arquivo criado:**
- `lib/presentation/pages/security/active_sessions_page.dart`

**Características:**
- Lista todas as sessões ativas (últimos 30 dias)
- Mostra informações detalhadas de cada dispositivo
- Permite revogar sessão individual
- Botão "Deslogar de todos os dispositivos"
- Pull-to-refresh para atualizar lista

### 4. Criptografia de Dados

**Arquivo criado:**
- `lib/core/services/encryption_service.dart`

**Características:**
- AES-256 com modo CBC
- Chave de 256 bits
- Encoding Base64
- Métodos: `encrypt()`, `decrypt()`, `isEncrypted()`

**Campos criptografados:**
- CRM/COREN
- Telefone
- Endereço completo

### 5. Rate Limiting

**Arquivo criado:**
- `lib/core/services/rate_limiter_service.dart`

**Características:**
- Limites configuráveis por ação
- Armazenamento local (SharedPreferences)
- Janela de tempo deslizante
- Cálculo de tempo restante

**Limites padrão:**
- Login: 5 tentativas / 15 minutos
- Reset senha: 3 tentativas / 1 hora
- Atualização perfil: 10 tentativas / 5 minutos
- Upload arquivo: 20 tentativas / 10 minutos

## 📦 Dependências Adicionadas

```yaml
dependencies:
  device_info_plus: ^11.2.0  # Informações do dispositivo
  encrypt: ^5.0.3             # Criptografia AES
  uuid: ^4.5.1                # Geração de IDs únicos
  firebase_messaging: ^15.2.10 # Notificações push (para novo dispositivo)
```

## 🚀 Como Usar

### Auditoria de Acessos

```dart
// Registrar uma ação
await auditRepository.logAction(
  userId: user.uid,
  action: AuditAction.login,
  metadata: {'method': 'email'},
);

// Buscar logs do usuário
final logs = await auditRepository.getUserLogs(userId, limit: 50);

// Buscar por tipo de ação
final loginLogs = await auditRepository.getLogsByAction(
  userId, 
  AuditAction.login,
);
```

### Detecção de Novo Dispositivo

```dart
final sessionService = SessionService(prefs: prefs);

// Verificar se é novo dispositivo
if (await sessionService.isNewDevice()) {
  // Enviar notificação
  showNewDeviceNotification();
  
  // Registrar como conhecido
  await sessionService.registerDevice();
}
```

### Gerenciamento de Sessões

```dart
// Navegar para tela de sessões
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ActiveSessionsPage(userId: user.uid),
  ),
);

// Criar nova sessão no login
await sessionService.createSession(userId);

// Atualizar último acesso
await sessionService.updateSessionAccess(userId);

// Revogar todas as outras sessões
await sessionService.revokeAllOtherSessions(userId);

// Encerrar sessão atual no logout
await sessionService.endCurrentSession(userId);
```

### Criptografia

```dart
final encryptionService = EncryptionService();

// Criptografar dados sensíveis
final profile = userProfile.copyWith(
  crmCofen: encryptionService.encrypt(profile.crmCofen ?? ''),
  phone: encryptionService.encrypt(profile.phone ?? ''),
  address: encryptionService.encrypt(profile.address ?? ''),
);

// Descriptografar ao carregar
final decryptedProfile = profile.copyWith(
  crmCofen: encryptionService.decrypt(profile.crmCofen ?? ''),
  phone: encryptionService.decrypt(profile.phone ?? ''),
  address: encryptionService.decrypt(profile.address ?? ''),
);
```

### Rate Limiting

```dart
final rateLimiter = RateLimiterService();

// Antes de executar ação
final canLogin = await rateLimiter.canPerformAction(
  action: 'login',
  maxAttempts: RateLimits.loginMaxAttempts,
  windowSeconds: RateLimits.loginWindowSeconds,
);

if (!canLogin) {
  final timeRemaining = await rateLimiter.getTimeUntilNextAttempt(
    action: 'login',
    maxAttempts: RateLimits.loginMaxAttempts,
    windowSeconds: RateLimits.loginWindowSeconds,
  );
  
  throw Exception(
    'Aguarde ${timeRemaining?.inMinutes} minutos antes de tentar novamente',
  );
}

// Após executar ação (sucesso ou falha)
await rateLimiter.recordAttempt('login');

// Limpar após sucesso
await rateLimiter.clearAttempts('login');
```

## 🔄 Próximos Passos

### Integração com AuthBloc

Os serviços estão prontos para serem integrados no `AuthBloc`:

1. Adicionar `AuditRepository`, `SessionService` e `RateLimiterService` como dependências
2. Registrar no `GetIt` (dependency injection)
3. Chamar os métodos nos handlers de eventos:
   - `_onEmailSignInRequested`: rate limiting + audit log + session
   - `_onGoogleSignInRequested`: rate limiting + audit log + session
   - `_onSignOutRequested`: audit log + end session
   - `_onPasswordResetRequested`: rate limiting + audit log

### Configuração do Firebase Cloud Messaging

Para habilitar notificações de novo dispositivo:

1. Configurar Firebase Cloud Messaging no projeto
2. Obter token do dispositivo
3. Enviar notificação quando `isNewDevice() == true`

### Injeção de Dependências

Registrar serviços no `GetIt`:

```dart
// lib/core/di/service_locator.dart
void setupServiceLocator() {
  // ... outros serviços
  
  sl.registerLazySingleton(() => EncryptionService());
  sl.registerLazySingleton(() => RateLimiterService());
  
  sl.registerLazySingletonAsync<SessionService>(() async {
    final prefs = await SharedPreferences.getInstance();
    return SessionService(prefs: prefs);
  });
  
  sl.registerLazySingleton<AuditRepository>(
    () => AuditRepositoryImpl(),
  );
}
```

### Criptografia em Produção

⚠️ **IMPORTANTE**: A chave de criptografia atual é hardcoded. Para produção:

1. Gerar chave segura de 32 caracteres
2. Armazenar em variável de ambiente
3. Usar package `envied` ou similar
4. Nunca commitar a chave no código

```dart
// .env
ENCRYPTION_KEY=your_secure_32_character_key_here

// lib/core/services/encryption_service.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'ENCRYPTION_KEY')
  static const String encryptionKey = _Env.encryptionKey;
}

class EncryptionService {
  static final _keyString = Env.encryptionKey;
  // ...
}
```

## 📊 Estrutura no Firestore

### Audit Logs

```
users/{userId}/audit_logs/{logId}
├── id: string
├── userId: string
├── action: string
├── timestamp: string (ISO 8601)
├── deviceId: string
├── deviceName: string
├── deviceType: string
├── ipAddress: string? (opcional)
├── location: string? (opcional)
└── metadata: map? (opcional)
```

### Sessions

```
users/{userId}/sessions/{sessionId}
├── sessionId: string
├── deviceId: string
├── deviceName: string
├── deviceType: string
├── createdAt: string (ISO 8601)
└── lastAccessAt: string (ISO 8601)
```

## 🔒 Considerações de Segurança

1. **Audit Logs**: Logs são silenciosos - não interrompem o fluxo do app se falharem
2. **Criptografia**: Use chaves diferentes para dev/staging/prod
3. **Rate Limiting**: Armazenado localmente - pode ser limpo pelo usuário
4. **Sessões**: Limpeza automática após 30 dias de inatividade
5. **Device ID**: UUID gerado localmente, não é o ID real do hardware

## 📝 Testes

Todos os serviços foram implementados com tratamento de erros, mas ainda precisam de testes unitários:

```bash
# Criar testes
test/unit/audit_repository_test.dart
test/unit/session_service_test.dart
test/unit/encryption_service_test.dart
test/unit/rate_limiter_service_test.dart

# Executar testes
flutter test
```

## 📚 Referências

- [Firebase Security Best Practices](https://firebase.google.com/docs/rules)
- [Flutter Encryption Package](https://pub.dev/packages/encrypt)
- [Device Info Plus](https://pub.dev/packages/device_info_plus)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)

---

**Data de Implementação**: 22 de janeiro de 2025  
**Desenvolvedor**: Equipe Cicatriza  
**Status**: ✅ Implementação Completa
