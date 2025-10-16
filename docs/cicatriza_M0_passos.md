
# 🚀 M0 — Fundação e Setup (Passo a passo executável)

> Objetivo do M0: **Base técnica e operacional** do Cicatriza pronta — arquitetura, ambiente Firebase (dev), CI/CD inicial, autenticação (Google/MS), skeleton Flutter (tema/rotas/DI/BLoC), regras de segurança v1 e emuladores funcionais.  
> Duração sugerida: **2 semanas** | Dono: **Tech Lead** | Critérios de saída ao final do doc.

---

## 0) Pré‑requisitos (máquina do dev)
- **Flutter** (>= 3.22) e **Dart** atualizados (`flutter doctor` sem pendências).
- **Android Studio / Xcode** (build + emulador).
- **Node 18+**, **npm**/**pnpm** e **Firebase CLI** (`npm i -g firebase-tools`).
- **Java 17**, **Git**, **fastlane** (opcional nesta fase).
- **Conta Google** para Firebase; acesso ao repositório GitHub.

---

## 1) Repositórios & Estrutura base

### 1.1 Criar monorepo (ou 2 repos)
```bash
mkdir cicatriza && cd cicatriza
git init
```
Estrutura recomendada:
```
cicatriza/
  cicatriza_app/            # Flutter
  cicatriza_functions/      # Cloud Functions (Node/TS)
  .github/workflows/
  docs/
```

### 1.2 Criar app Flutter
```bash
flutter create cicatriza_app
cd cicatriza
flutter pub add get_it freezed freezed_annotation json_serializable build_runner \
  flutter_bloc equatable dio envied envied_generator \
  intl shared_preferences url_launcher firebase_core firebase_auth cloud_firestore \
  firebase_storage firebase_crashlytics firebase_analytics
```

### 1.3 Padrões de projeto
- **Arquitetura**: Clean Architecture + BLoC.
- **Pastas principais (app)**:
```
lib/
  core/           # tema, env, routing, di
  domain/         # entities, repositories, usecases
  data/           # datasources (firestore, storage), models, repos impl
  presentation/   # blocs, pages, widgets
  main.dart
```
- **DI**: `get_it` com um `initDependencies()` central.
- **Rotas mínimas**: `/login`, `/home`, `/patients` (placeholder).

---

## 2) Projeto Firebase (ambiente DEV)

### 2.1 Criar projeto e apps
```bash
firebase login
firebase projects:create cicatriza-dev --display-name "Cicatriza Dev"
firebase use cicatriza-dev
# No console do Firebase: criar apps Android e iOS para cicatriza_app e baixar os configs
```
Coloque `google-services.json` (Android) e `GoogleService-Info.plist` (iOS) nas pastas de plataforma.

### 2.2 Inicializar services
```bash
cd ../
mkdir cicatriza_functions && cd cicatriza_functions
firebase init functions firestore storage emulators
# Functions: TypeScript, ESLint yes
```

### 2.3 Configurar emuladores
No arquivo `firebase.json` (raiz ou pasta functions, conforme init):
```json
{
  "emulators": {
    "auth": {"port": 9099},
    "functions": {"port": 5001},
    "firestore": {"port": 8080},
    "storage": {"port": 9199},
    "ui": {"enabled": true}
  }
}
```
Rodar:
```bash
firebase emulators:start
```

---

## 3) Autenticação (Google/MS) + Perfil

### 3.1 Habilitar provedores
No console do Firebase Auth: **Google** e **Microsoft** (OAuth).  
Salvar client IDs/Secrets no **Firebase** e no app (via `envied` + flavors).

### 3.2 Flutter Auth flow (resumo)
- `AuthRepository` com métodos `signInWithGoogle()`, `signInWithMicrosoft()`, `signOut()`.
- `UserProfileRepository` cria/atualiza `users/{uid}` no login (onboarding mínimo).

**Modelo `UserProfile`** (campos iniciais):
```dart
class UserProfile {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  // add: signatureUrl, clinicName, etc
}
```

**Fluxo**: Login → `onAuthStateChanged` → se novo, criar doc em `users/{uid}` → redirecionar para `/home`.

---

## 4) Regras de Segurança v1 (Firestore + Storage)

### 4.1 Firestore (`firestore.rules`)
```
// Firestore Rules (v1) — foco em ownerId/ACL básica
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isSignedIn() { return request.auth != null; }
    function isOwner(uid) { return request.auth != null && request.auth.uid == uid; }

    match /users/{userId} {
      allow read, write: if isOwner(userId);
      match /patients/{patientId} {
        allow read, write: if isOwner(userId);
        match /wounds/{woundId} {
          allow read, write: if isOwner(userId);
          match /assessments/{assessmentId} {
            allow read, write: if isOwner(userId);
          }
        }
      }
      match /transfers/{transferId} {
        allow read, write: if isOwner(userId);
      }
      match /appointments/{appointmentId} {
        allow read, write: if isOwner(userId);
      }
    }
  }
}
```

### 4.2 Storage (`storage.rules`)
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    function isSignedIn() { return request.auth != null; }
    function isOwnerPath() {
      return isSignedIn() && request.resource != null &&
        request.resource.name.matches('users/' + request.auth.uid + '/.*');
    }
    match /users/{uid}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

> Obs.: Em M2 serão adicionadas ACLs de **transferência**; em M1 validações adicionais por schema.

---

## 5) Cloud Functions (esqueleto)

### 5.1 Setup
```bash
cd cicatriza_functions
npm i
npm i -D typescript ts-node
```
`functions/src/index.ts` (esqueleto):
```ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

export const onUserCreate = functions.auth.user().onCreate(async (user) => {
  // opcional: auditoria ou inicialização de perfil
});

export const onStorageFinalize = functions.storage.object().onFinalize(async (obj) => {
  // TODO: gerar thumbnail para imagens em users/{uid}/...
});
```

---

## 6) Skeleton do App (tema/rotas/DI/BLoC)

### 6.1 Tema & Rotas
- Material 3, dark/light; rotas: `/login`, `/home`, `/patients`.
- `AppRouter` + `Navigator 2.0` (ou `go_router` se preferir).

### 6.2 BLoC
- `AuthBloc` (estado: authenticated/unauthenticated/loading).
- `PatientsBloc` (placeholder).

### 6.3 DI (`get_it`)
- Registrar: `FirebaseAuth`, `FirebaseFirestore`, `FirebaseStorage`, `AuthRepository`, `UserProfileRepository`, BLoCs.

---

## 7) Qualidade & Observabilidade inicial

### 7.1 Lints & formatação
```bash
flutter pub add dev:very_good_analysis
# configurar analysis_options.yaml
```
- Política: **nenhum warning** no CI.

### 7.2 Crashlytics & Analytics
- Ativar no `main.dart` (zonas de erro), `Firebase.initializeApp()` antes do runApp.
- Eventos mínimos: `login_success`, `logout`.

### 7.3 Testes iniciais
- Unit: `AuthRepository` (mocks).
- Widget: tela Login (render e interações básicas).
- Integração: auth + perfil com emulador.

---

## 8) CI/CD (GitHub Actions)

`.github/workflows/ci.yml` (exemplo mínimo):
```yaml
name: ci

on:
  push:
    branches: [ "main" ]
  pull_request:

jobs:
  build-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.0'
      - name: Install deps
        run: |
          cd cicatriza_app
          flutter pub get
      - name: Analyze
        run: |
          cd cicatriza_app
          flutter analyze
      - name: Test
        run: |
          cd cicatriza_app
          flutter test --coverage
```

> Dica: adicionar job opcional para `cicatriza_functions` (lint + build) e publicar cobertura.

---

## 9) Documentação e Scripts

- `docs/README_M0.md`: checklists, comandos para emuladores, troubleshoot OAuth.
- Script `make dev`: subir emuladores + app:
```bash
# exemplo com npm scripts ou Makefile
firebase emulators:start &
cd cicatriza_app && flutter run
```

---

## 10) Checklist de Saída (DoD do M0)

- [ ] Login Google e Microsoft funcionando (em dev).  
- [ ] Perfil do usuário criado/atualizado em `users/{uid}`.  
- [ ] Regras `firestore.rules` e `storage.rules` aplicadas e testadas nos emuladores.  
- [ ] Estrutura Flutter (tema/rotas/DI/BLoC) com páginas `/login`, `/home`, `/patients`.  
- [ ] CI (analyze + test) **verde**, sem warnings.  
- [ ] Crashlytics e Analytics inicializados.  
- [ ] Documentação `docs/README_M0.md` entregue.  

---

## 11) Riscos & Mitigações (M0)

| Risco | Mitigação |
|---|---|
| OAuth falhar em dev | Revisar SHA-1/Bundle ID, usar emulador + configs locais, logs detalhados |
| Rules bloqueando legítimos | Testes de segurança com emuladores, casos positivos/negativos |
| Divergência de pacotes | `flutter pub outdated` semanal + lockfile |
| Instabilidade local | Versionar `.tool-versions`/`asdf` ou `.nvmrc`, scripts de bootstrap |

---

## 12) Entregáveis do M0 (para PR)

1. `cicatriza_app/` com skeleton, DI, Auth flow, lints, testes básicos.  
2. `cicatriza_functions/` com esqueleto e deploy no `dev` (opcional).  
3. `firestore.rules` e `storage.rules` v1.  
4. CI GitHub Actions ativo.  
5. `docs/README_M0.md` com instruções de setup, rodar, testar e publicar.  

---
