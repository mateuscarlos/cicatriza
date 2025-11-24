# Configuração de Segurança Firebase - Cicatriza

## ATENÇÃO: ARQUIVO DE CONFIGURAÇÃO CRÍTICA

Este arquivo contém instruções para configurar adequadamente os ambientes Firebase do projeto Cicatriza. **NUNCA** commite chaves de API ou configurações sensíveis no repositório.

## 📋 Checklist de Configuração

### 1. Projetos Firebase

Crie dois projetos separados no Firebase Console:

- **Desenvolvimento**: `cicatriza-dev`
- **Produção**: `cicatriza-prod`

### 2. Configuração das Chaves API

#### No arquivo `lib/core/config/firebase_environment_config.dart`:

**⚠️ SUBSTITUA OS VALORES PLACEHOLDER:**

```dart
// DESENVOLVIMENTO - Substitua pelos valores reais do projeto cicatriza-dev
static const FirebaseOptions _developmentOptions = FirebaseOptions(
  apiKey: 'AIza...', // Cole aqui a API Key do projeto de desenvolvimento
  appId: '1:123456789:android:abc123def456', // App ID do projeto dev
  messagingSenderId: '123456789', // Sender ID do projeto dev
  projectId: 'cicatriza-dev', // ID do projeto de desenvolvimento
  storageBucket: 'cicatriza-dev.appspot.com',
  
  // Android específico
  androidClientId: 'xxx.apps.googleusercontent.com', // Client ID Android dev
  
  // iOS específico  
  iosClientId: 'yyy.apps.googleusercontent.com', // Client ID iOS dev
  iosBundleId: 'com.cicatriza.dev',
);

// PRODUÇÃO - Substitua pelos valores reais do projeto cicatriza-prod
static const FirebaseOptions _productionOptions = FirebaseOptions(
  apiKey: 'AIza...', // Cole aqui a API Key do projeto de produção
  appId: '1:987654321:android:xyz789uvw456', // App ID do projeto prod
  messagingSenderId: '987654321', // Sender ID do projeto prod
  projectId: 'cicatriza-prod', // ID do projeto de produção
  storageBucket: 'cicatriza-prod.appspot.com',
  
  // Android específico
  androidClientId: 'xxx-prod.apps.googleusercontent.com', // Client ID Android prod
  
  // iOS específico
  iosClientId: 'yyy-prod.apps.googleusercontent.com', // Client ID iOS prod
  iosBundleId: 'com.cicatriza.app',
);
```

### 3. App Check

#### Para Desenvolvimento:
```bash
# Gerar token de debug
firebase appcheck:apps:debug-token

# No arquivo firebase_environment_config.dart:
'debugToken': 'cole-o-token-de-debug-aqui',
```

#### Para Produção:
1. Ative reCAPTCHA Enterprise no Google Cloud Console
2. Configure Device Check (iOS) e Play Integrity API (Android)
3. Adicione a chave do site reCAPTCHA:
```dart
'siteKey': 'cole-a-chave-do-site-recaptcha-aqui',
```

### 4. Google Sign-In

#### No arquivo `lib/core/config/google_sign_in_config.dart`:

```dart
class GoogleSignInConfig {
  // SUBSTITUA pelos valores reais do Google Cloud Console
  static const String serverClientId = 'xxx-xxx.apps.googleusercontent.com';
  static const String iosClientId = 'yyy-yyy.apps.googleusercontent.com';
  static const String androidClientId = 'zzz-zzz.apps.googleusercontent.com';
}
```

### 5. Arquivos Android

#### `android/app/google-services.json`
- Baixe do Firebase Console (projeto prod)
- Coloque em `android/app/google-services.json`

#### `android/app/google-services-dev.json`  
- Baixe do Firebase Console (projeto dev)
- Coloque em `android/app/google-services-dev.json`

### 6. Arquivos iOS

#### `ios/Runner/GoogleService-Info.plist`
- Baixe do Firebase Console (projeto prod)
- Adicione ao Xcode no target Runner

#### `ios/Runner/GoogleService-Info-dev.plist`
- Baixe do Firebase Console (projeto dev)  
- Adicione ao Xcode no target Runner

## 🔐 Segurança

### Variáveis de Ambiente

Configure as seguintes variáveis:

```bash
# Para desenvolvimento
export FIREBASE_ENV=dev

# Para produção  
export FIREBASE_ENV=prod
```

### Build Scripts

```bash
# Build desenvolvimento
flutter build apk --dart-define=FIREBASE_ENV=dev

# Build produção
flutter build apk --dart-define=FIREBASE_ENV=prod
```

## 🚀 Deploy das Regras

```bash
# Desenvolvimento
./scripts/configure-firebase-security.ps1 -Environment dev

# Produção
./scripts/configure-firebase-security.ps1 -Environment prod
```

## ✅ Validação

Execute para verificar se a configuração está correta:

```dart
// No código Dart
final isValid = FirebaseEnvironmentConfig.validateConfiguration();
print('Configuração válida: $isValid');

final debugInfo = FirebaseEnvironmentConfig.debugInfo;
print('Ambiente: ${debugInfo['environment']}');
print('Projeto: ${debugInfo['projectId']}');
```

## 🚨 IMPORTANTE

1. **NUNCA** commite arquivos `google-services.json` ou `GoogleService-Info.plist`
2. **SEMPRE** use `.gitignore` para excluir arquivos sensíveis
3. **TESTE** em ambiente de desenvolvimento antes de fazer deploy em produção
4. **MONITORE** logs de segurança no Firebase Console
5. **REVISE** as regras do Firestore regularmente

## 📞 Suporte

Em caso de problemas:
1. Verifique os logs da aplicação
2. Consulte o Firebase Console > Authentication > Settings
3. Valide as regras do Firestore no Firebase Console > Firestore > Rules
4. Teste a configuração do App Check no Firebase Console > App Check