# Configuração de Ambientes GitHub Actions - Cicatriza

## 🔧 Variáveis de Ambiente Necessárias

### Para o repositório GitHub (Settings > Secrets and variables > Actions):

#### **SECRETS** (dados sensíveis):
```bash
# Firebase
FIREBASE_SERVICE_ACCOUNT     # JSON da service account do Firebase
FIREBASE_PROJECT_ID          # ID do projeto Firebase

# Android Signing (apenas para produção)
KEYSTORE_BASE64             # Keystore codificado em base64
KEYSTORE_PASSWORD           # Senha do keystore
KEY_ALIAS                   # Alias da chave
KEY_PASSWORD                # Senha da chave

# Codecov (opcional)
CODECOV_TOKEN               # Token do Codecov para relatórios de cobertura
```

#### **VARIABLES** (dados não sensíveis):
```bash
# Build
FLUTTER_VERSION=3.24.0      # Versão do Flutter
ANDROID_API_LEVEL=34        # Nível da API Android
ANDROID_BUILD_TOOLS=34.0.0  # Versão das build tools
```

## 🎯 Configuração por Ambiente

### **Development Environment**
- **Trigger**: Push para `develop` branch
- **Firebase Project**: `cicatriza-dev`
- **Build Type**: Debug APK
- **Tests**: Completos
- **Security**: Relaxada
- **Deploy**: Automático

### **Production Environment**
- **Trigger**: Tags `v*` ou workflow manual
- **Firebase Project**: `cicatriza-prod`
- **Build Type**: Release APK (assinado)
- **Tests**: Completos + validação de segurança
- **Security**: Rigorosa
- **Deploy**: Manual com aprovação

## 📋 Configuração dos Environments no GitHub

### 1. Criar Environments:
No GitHub Repository → Settings → Environments:

#### **dev**
- **Deployment branches**: `develop`, `main`
- **Environment secrets**: Configurar secrets específicos para dev
- **Required reviewers**: Nenhum (deploy automático)

#### **prod**
- **Deployment branches**: Apenas `main` 
- **Environment secrets**: Configurar secrets específicos para prod
- **Required reviewers**: Adicionar pelo menos 1 revisor
- **Wait timer**: 5 minutos (para review)

### 2. Configurar Branch Protection:
Settings → Branches → Add rule para branch `main`:
- ✅ Require a pull request before merging
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Status checks: `CI Pipeline`
- ✅ Require conversation resolution before merging
- ✅ Restrict pushes that create files larger than 100MB

## 🔐 Configuração Firebase Service Account

### 1. Criar Service Account:
```bash
# No Google Cloud Console do projeto Firebase
gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions" \
    --description="Service account para GitHub Actions CI/CD"

# Adicionar permissões necessárias
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/firebase.admin"

# Criar chave JSON
gcloud iam service-accounts keys create firebase-service-account.json \
    --iam-account=github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

### 2. Configurar no GitHub:
```bash
# Codificar JSON em base64
base64 -i firebase-service-account.json

# Adicionar como secret FIREBASE_SERVICE_ACCOUNT no GitHub
```

## 🔑 Configuração Android Signing

### 1. Criar Keystore:
```bash
keytool -genkey -v -keystore release.keystore -alias cicatriza \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass YOUR_STORE_PASSWORD \
    -keypass YOUR_KEY_PASSWORD
```

### 2. Configurar no GitHub:
```bash
# Codificar keystore em base64
base64 -i release.keystore

# Adicionar secrets no GitHub:
# KEYSTORE_BASE64: (saída do comando acima)
# KEYSTORE_PASSWORD: (senha do keystore)
# KEY_ALIAS: cicatriza
# KEY_PASSWORD: (senha da chave)
```

## 📊 Configuração Codecov (Opcional)

### 1. Acessar codecov.io
### 2. Conectar repositório GitHub  
### 3. Copiar token gerado
### 4. Adicionar como secret `CODECOV_TOKEN`

## 🚀 Workflows Incluídos

### **ci.yml** - Pipeline de Integração Contínua
- **Trigger**: Push/PR para main/develop
- **Jobs**: 
  - Análise de código
  - Testes unitários
  - Validação segurança Firebase
  - Build de validação
  - Testes de integração
- **Artefatos**: APKs de teste

### **cd.yml** - Pipeline de Deploy Contínuo
- **Trigger**: Push para main, Tags v*, Manual
- **Jobs**:
  - Validação pré-deploy
  - Build e assinatura
  - Deploy Firebase
  - Testes pós-deploy
  - Notificação e rollback
- **Artefatos**: APKs de produção, símbolos de debug

### **performance.yml** - Análise de Performance
- **Trigger**: PR, Manual, Schedule semanal
- **Jobs**:
  - Análise de dependências
  - Análise de tamanho
  - Testes de performance
  - Comparação de benchmark
  - Recomendações de otimização

## ✅ Checklist de Configuração

- [ ] Secrets configurados no GitHub
- [ ] Environments criados (dev/prod)
- [ ] Branch protection configurada
- [ ] Firebase Service Account criada
- [ ] Android keystore gerada (produção)
- [ ] Codecov configurado (opcional)
- [ ] Workflows testados em PRs
- [ ] Deploy de desenvolvimento validado
- [ ] Deploy de produção validado

## 🔍 Troubleshooting

### **Build falha com erro de keystore**
- Verificar se KEYSTORE_BASE64 está configurado
- Verificar se senhas estão corretas
- Confirmar que alias está correto

### **Firebase deploy falha**
- Verificar service account permissions
- Confirmar PROJECT_ID correto
- Verificar se regras Firestore são válidas

### **Testes falhando**
- Verificar dependências instaladas
- Confirmar Flutter version consistency
- Verificar se todos os arquivos necessários estão commitados

### **Performance analysis não funciona**
- Verificar se branch base existe
- Confirmar que scripts de performance existem
- Verificar permissions de execução