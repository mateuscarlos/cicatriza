# 📘 Marco 0 (M0) - Fundação e Setup

> **Status:** ✅ COMPLETO  
> **Duração:** 2 semanas  
> **Data de conclusão:** Novembro 2025

## 🎯 Objetivo do Marco

Estabelecer a **base técnica e operacional** do aplicativo Cicatriza, incluindo:
- Arquitetura limpa e escalável
- Ambiente Firebase configurado
- Autenticação funcional
- CI/CD básico
- Regras de segurança
- Observabilidade inicial

---

## ✅ Checklist de Conclusão (DoD)

| Item | Status | Observações |
|------|--------|-------------|
| Login Google funcionando | ✅ | OAuth configurado e testado |
| Perfil criado em `users/{uid}` | ✅ | Automático no primeiro login |
| Regras Firestore/Storage | ✅ | Validações completas implementadas |
| Estrutura Flutter (tema/rotas/DI/BLoC) | ✅ | Clean Architecture aplicada |
| **CI/CD (GitHub Actions)** | ✅ | **Analyze + Test + Format** |
| **Firebase Analytics** | ✅ | **Eventos principais implementados** |
| Firebase Crashlytics | ✅ | Captura de erros configurada |
| Documentação M0 | ✅ | Este arquivo |

---

## 🏗️ Arquitetura

### Clean Architecture

```
lib/
├── core/                    # Configurações centrais
│   ├── config/             # Configurações (Google Sign-In, etc)
│   ├── di/                 # Dependency Injection (GetIt)
│   ├── routing/            # Rotas e navegação
│   ├── services/           # Serviços (Analytics, Connectivity)
│   ├── theme/              # Tema Material 3
│   └── utils/              # Utilitários (Logger)
├── domain/                  # Camada de domínio
│   ├── entities/           # Entidades de negócio
│   └── repositories/       # Interfaces de repositórios
├── data/                    # Camada de dados
│   ├── datasources/        # Fontes de dados (Firestore, SQLite)
│   ├── models/             # Models para serialização
│   └── repositories/       # Implementações de repositórios
└── presentation/            # Camada de apresentação
    ├── blocs/              # BLoC (estado)
    ├── pages/              # Telas
    └── widgets/            # Widgets reutilizáveis
```

---

## 🚀 Setup do Ambiente

### Pré-requisitos

- **Flutter SDK:** >= 3.22.0
- **Dart SDK:** >= 3.9.2
- **Java JDK:** 21 (para Android)
- **Node.js:** >= 18 (para Functions)
- **Firebase CLI:** `npm install -g firebase-tools`

### Instalação

```bash
# 1. Clone o repositório
git checkout https://github.com/mateuscarlos/cicatriza.git
cd cicatriza

# 2. Instale dependências Flutter
flutter pub get

# 3. (Opcional) Instale dependências das Functions
cd functions
npm install
cd ..

# 4. Configure Firebase (se necessário)
firebase login
firebase use cicatriza-dev-b1085
```

### Configuração do Firebase

Os arquivos de configuração já estão incluídos:
- **Android:** `android/app/google-services.json`
- **iOS:** `ios/Runner/GoogleService-Info.plist`
- **Web/Flutter:** `lib/firebase_options.dart`

---

## ▶️ Executando o Projeto

### Desenvolvimento

```bash
# Executar no emulador/dispositivo
flutter run

# Executar com hot reload
flutter run --debug

# Executar em modo release
flutter run --release
```

### Emuladores Firebase (Opcional)

```bash
# Iniciar emuladores (Auth, Firestore, Storage, Functions)
firebase emulators:start

# Com UI
firebase emulators:start --only auth,firestore,storage

# Acessar UI
open http://localhost:4000
```

---

## 🧪 Testes

### Executar Testes

```bash
# Todos os testes
flutter test

# Com cobertura
flutter test --coverage

# Testes específicos
flutter test test/firestore_rules_test.dart

# Análise estática
flutter analyze

# Verificar formatação
flutter format --set-exit-if-changed .
```

### Cobertura Atual

- **Unit Tests:** Validações de regras Firestore
- **Widget Tests:** Stub básico (a expandir em M1)
- **Integration Tests:** Pendente para M1

---

## 🔐 Autenticação

### Google Sign-In

**Status:** ✅ Funcionando

#### Configuração OAuth

1. **Android:**
   - SHA-1 configurado no Firebase Console
   - `google-services.json` atualizado

2. **iOS:**
   - URL Scheme configurado
   - `GoogleService-Info.plist` atualizado

3. **Web:**
   - Client ID configurado em `firebase_options.dart`

#### Fluxo de Login

```dart
// 1. Usuário clica em "Entrar com Google"
context.read<AuthBloc>().add(AuthGoogleSignInRequested());

// 2. Google Sign-In abre
// 3. Após sucesso, perfil é criado/atualizado em users/{uid}
// 4. Analytics registra evento 'login_success'
// 5. Navegação automática para /home
```

---

## 📊 Firebase Analytics

### Eventos Implementados

| Evento | Parâmetros | Quando Dispara |
|--------|-----------|----------------|
| `login` | `method: 'google'` | Login bem-sucedido |
| `logout` | - | Usuário faz logout |
| `patient_create` | `timestamp` | Novo paciente criado |
| `wound_create` | `wound_type`, `timestamp` | Nova ferida criada |
| `assessment_create` | `pain_level`, `has_photos` | Nova avaliação criada |
| `photo_upload` | `photo_count` | Fotos enviadas |

### Uso Programático

```dart
final analytics = sl<AnalyticsService>();

// Registrar login
await analytics.logLoginSuccess('google');

// Registrar criação de paciente
await analytics.logPatientCreated();

// Definir ID do usuário
await analytics.setUserId(user.uid);
```

---

## 🔒 Regras de Segurança

### Firestore Rules

Localização: `firestore.rules`

**Princípios:**
- Apenas usuários autenticados podem acessar dados
- Owner (uid) tem controle total sobre seus dados
- ACL (roles) permite compartilhamento (viewer/editor/owner)
- Validações de schema obrigatórias

**Exemplo - Pacientes:**

```javascript
match /users/{uid}/patients/{pid} {
  // Apenas owner ou usuários com ACL
  allow read: if isOwner(uid) || hasRole(uid, pid, ['viewer', 'editor']);
  
  // Criar: validar campos obrigatórios
  allow create: if isOwner(uid) && validatePatient(request.resource.data);
}
```

### Storage Rules

Localização: `storage.rules`

**Restrições:**
- Fotos: máximo 10MB, formato image/*
- Vídeos: máximo 200MB, formato video/*
- Path obrigatório: `users/{uid}/patients/{pid}/...`
- Metadados obrigatórios: `ownerId`, `patientId`, `woundId`

---

## 🔍 Observabilidade

### Firebase Crashlytics

**Configurado para capturar:**
- Erros fatais do Flutter (`FlutterError.onError`)
- Erros de plataforma (`PlatformDispatcher.onError`)
- Exceções não tratadas

### App Logger

Classe customizada: `core/utils/app_logger.dart`

```dart
AppLogger.info('Mensagem informativa');
AppLogger.error('Erro crítico', error: e, stackTrace: st);
AppLogger.warning('Aviso');
```

---

## 🎨 UI/UX

### Material 3 Design System

- **Tema:** Light + Dark mode (auto-detect)
- **Fonte:** Google Fonts - Inter
- **Cores:** Definidas em `core/theme/app_theme.dart`

### Componentes Reutilizáveis

- `FormSection` - Seções de formulário com título
- `NumberField` - Campo numérico com validação
- `PainSlider` - Slider de dor 0-10 com cores

---

## 🔄 CI/CD

### GitHub Actions

Workflow: `.github/workflows/ci.yml`

**Jobs:**

1. **analyze-and-test**
   - ✅ `flutter analyze` (sem warnings)
   - ✅ `flutter test --coverage`
   - ✅ `flutter format --check`
   - Upload de cobertura para Codecov

2. **build-android**
   - Build APK debug
   - Upload artifact (retém 7 dias)

**Triggers:**
- Push em `main`, `validacao_m0_m1`, `develop`
- Pull Requests para `main`

---

## 📦 Dependências Principais

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.15.2
  firebase_auth: ^5.3.4
  firebase_analytics: ^11.6.0
  firebase_crashlytics: ^4.0.4
  cloud_firestore: ^5.4.4
  firebase_storage: ^12.3.5
  
  # Autenticação
  google_sign_in: ^7.2.0
  
  # Estado
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  
  # DI
  get_it: ^8.2.0
  
  # Offline
  sqflite: ^2.3.3+1
  shared_preferences: ^2.5.3
  connectivity_plus: ^6.1.1
  
  # UI
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
```

---

## 🐛 Troubleshooting

### Erro: "Firebase not initialized"

```bash
# Verificar firebase_options.dart existe
ls lib/firebase_options.dart

# Regenerar se necessário
flutterfire configure
```

### Erro: Google Sign-In falha no Android

```bash
# 1. Verificar SHA-1 no Firebase Console
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey

# 2. Baixar google-services.json atualizado
# 3. Limpar build
flutter clean
flutter pub get
```

### Erro: "JDK version not compatible"

```bash
# Verificar versão Java
java -version  # Deve ser 21

# Configurar JAVA_HOME (Windows)
setx JAVA_HOME "C:\Program Files\Java\jdk-21"

# Configurar JAVA_HOME (macOS/Linux)
export JAVA_HOME=/path/to/jdk-21
```

---

## 📚 Documentação Adicional

- **Modelo de Dados:** `docs/modelo_dados_cicatriza.md`
- **Plano de Execução:** `docs/cicatriza_plano_execucao.md`
- **Marcos Detalhados:** `docs/cicatriza_marcos_detalhados.md`
- **UI/UX:** `docs/UI-UX/UIUX_Cicatriza_Telas.md`

---

## 🚦 Próximos Passos (M1)

1. ✅ Completar upload de fotos para Firebase Storage
2. ✅ Gerar thumbnails automáticos (Function já pronta)
3. ✅ Implementar testes de integração com emuladores
4. ✅ Expandir cobertura de testes (meta: 75%)
5. ✅ Documentar fluxo completo em `README_M1.md`

---

## 👥 Equipe

- **Tech Lead:** Responsável por arquitetura e decisões técnicas
- **Mobile Developer:** Implementação Flutter
- **Backend Developer:** Cloud Functions e regras Firebase

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](../LICENSE) para mais detalhes.

---

**Última atualização:** Novembro 2025  
**Versão:** 1.0.0  
**Marco:** M0 - Fundação e Setup ✅
