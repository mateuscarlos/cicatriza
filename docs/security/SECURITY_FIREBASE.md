# 🔒 Guia de Segurança - Firebase Credentials

**⚠️ ALERTA DE SEGURANÇA CRÍTICO**

Este documento explica como configurar corretamente as credenciais do Firebase **SEM expor API keys** no repositório público.

---

## 🚨 Problema Identificado (05/11/2025)

**Status:** ✅ RESOLVIDO

### Incidente
Google Cloud Platform detectou que a chave de API `AIzaSyDmbo3grB4WcrBswQ0HUNKvS7ylXFvbLgY` do projeto `cicatriza-dev-b1085` foi exposta publicamente em:

```
https://github.com/mateuscarlos/cicatriza/blob/22dc52902f794ba5bc531d0df90eb1d6c7f5446c/android/app/google-services.json
```

### Ações Tomadas

1. ✅ **Adicionado ao .gitignore:**
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - `lib/firebase_options.dart`

2. ✅ **Criado template:**
   - `android/app/google-services.json.template`

3. ✅ **Documentação de segurança:** Este arquivo

4. ⏳ **PENDENTE - Ação Obrigatória do Owner:**
   - [ ] Regenerar API key no Firebase Console
   - [ ] Adicionar restrições de API key
   - [ ] Revisar uso de billing/APIs no GCP Console

---

## 🔑 Regenerar API Key (URGENTE)

### Passo 1: Acessar Google Cloud Console

1. Acesse: https://console.cloud.google.com/
2. Selecione o projeto: `cicatriza-dev-b1085`
3. No menu, vá para: **APIs & Services** > **Credentials**

### Passo 2: Regenerar a Chave Comprometida

1. Encontre a API key: `AIzaSyDmbo3grB4WcrBswQ0HUNKvS7ylXFvbLgY`
2. Clique em **Edit** (ícone de lápis)
3. Clique em **REGENERATE KEY**
4. Confirme a regeneração
5. **Copie a nova chave imediatamente** (não será mostrada novamente)

### Passo 3: Adicionar Restrições de API Key

**Application Restrictions:**
```
Tipo: Android apps
Package name: com.example.cicatriza
SHA-1 certificate fingerprint: 97:79:D9:53:1A:BF:BA:F4:F2:D3:B2:EF:F5:BA:F5:7C:9B:31:F6:16
```

**API Restrictions:**
```
Restringir chave para APIs específicas:
✓ Firebase Installations API
✓ FCM Registration API
✓ Cloud Firestore API
✓ Firebase Storage API
✓ Firebase Authentication
✓ Firebase Analytics
```

### Passo 4: Atualizar Arquivo Local

1. Baixar novo `google-services.json` do Firebase Console:
   - https://console.firebase.google.com/
   - Vá para: **Project Settings** > **General**
   - Na seção **Your apps**, clique em **Download google-services.json**

2. Substituir o arquivo local:
   ```bash
   # NO SEU COMPUTADOR LOCAL (NÃO COMMITAR!)
   cp ~/Downloads/google-services.json android/app/google-services.json
   ```

3. **Verificar que está no .gitignore:**
   ```bash
   git status
   # google-services.json NÃO deve aparecer como "to be committed"
   ```

---

## 🛠️ Setup para Novos Desenvolvedores

### Pré-requisitos
- Acesso ao Firebase Console do projeto
- Acesso ao Google Cloud Console (para restrições)

### Passos de Configuração

#### 1. Obter Credenciais do Firebase

**Android:**
1. Acesse: https://console.firebase.google.com/project/cicatriza-dev-b1085
2. Vá para **Project Settings** (ícone de engrenagem)
3. Na aba **General**, role até **Your apps**
4. Selecione o app Android
5. Clique em **Download google-services.json**
6. Salve em: `android/app/google-services.json`

**iOS (quando configurado):**
1. Mesmo processo, mas baixe `GoogleService-Info.plist`
2. Salve em: `ios/Runner/GoogleService-Info.plist`

#### 2. Configurar Flutter Firebase

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase (gera lib/firebase_options.dart)
flutterfire configure
```

#### 3. Verificar Segurança

```bash
# Confirmar que arquivos NÃO serão commitados
git status

# Se aparecerem, adicionar ao .gitignore:
echo "android/app/google-services.json" >> .gitignore
echo "ios/Runner/GoogleService-Info.plist" >> .gitignore
echo "lib/firebase_options.dart" >> .gitignore
```

---

## 📋 Checklist de Segurança

### Para o Owner do Projeto (Mateus)

- [ ] Regenerar API key comprometida no GCP Console
- [ ] Adicionar restrições de aplicativo (Android package + SHA-1)
- [ ] Adicionar restrições de API (apenas APIs necessárias)
- [ ] Revisar billing/usage no GCP Console
- [ ] Verificar se há cobranças inesperadas
- [ ] Remover google-services.json do histórico do Git (opcional, mas recomendado)

### Para Todos os Desenvolvedores

- [ ] Verificar que `.gitignore` contém os arquivos sensíveis
- [ ] Baixar `google-services.json` do Firebase Console
- [ ] **NUNCA** commitar arquivos com API keys
- [ ] Usar template (`*.json.template`) para referência
- [ ] Configurar Firebase usando `flutterfire configure`

---

## 🔥 Remover do Histórico Git (Opcional mas Recomendado)

**⚠️ ATENÇÃO:** Isso reescreve o histórico do Git. Todos os colaboradores precisarão fazer `git pull --rebase`.

### Opção 1: BFG Repo-Cleaner (Recomendado)

```bash
# Instalar BFG
# Download: https://rtyley.github.io/bfg-repo-cleaner/

# Clonar espelho do repositório
git clone --mirror https://github.com/mateuscarlos/cicatriza.git

# Remover arquivo do histórico
java -jar bfg.jar --delete-files google-services.json cicatriza.git

# Limpar e fazer push
cd cicatriza.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push --force
```

### Opção 2: git filter-branch (Manual)

```bash
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch android/app/google-services.json" \
  --prune-empty --tag-name-filter cat -- --all

git push --force --all
git push --force --tags
```

**Após remover do histórico:**
```bash
# Todos os colaboradores devem fazer:
git fetch origin
git reset --hard origin/main  # ou sua branch principal
```

---

## 📊 Monitoramento de Segurança

### Revisar Periodicamente

1. **API Usage:**
   - https://console.cloud.google.com/apis/dashboard
   - Verificar se há uso inesperado

2. **Billing:**
   - https://console.cloud.google.com/billing
   - Configurar alertas de orçamento

3. **Security Alerts:**
   - https://console.cloud.google.com/security
   - Revisar notificações de segurança

### Configurar Alertas de Orçamento

```
1. Cloud Console > Billing > Budgets & alerts
2. Create Budget
3. Configurar:
   - Budget amount: $10/mês (ou valor esperado)
   - Threshold: 50%, 80%, 100%
   - Email notifications: seu-email@example.com
```

---

## 📚 Documentação de Referência

### Firebase
- Setup Android: https://firebase.google.com/docs/android/setup
- Security Rules: https://firebase.google.com/docs/rules
- API Key Restrictions: https://cloud.google.com/docs/authentication/api-keys

### Google Cloud Platform
- Managing API Keys: https://cloud.google.com/docs/authentication/api-keys
- Security Best Practices: https://cloud.google.com/security/best-practices
- Compromised Credentials: https://cloud.google.com/iam/docs/compromised-credentials

### Git Security
- Removing Sensitive Data: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
- BFG Repo-Cleaner: https://rtyley.github.io/bfg-repo-cleaner/

---

## ⚡ Comandos Rápidos

```bash
# Verificar se arquivo está no .gitignore
git check-ignore android/app/google-services.json
# Deve retornar: android/app/google-services.json

# Ver status sem arquivos ignorados
git status --ignored

# Remover arquivo do stage (se foi adicionado por engano)
git reset HEAD android/app/google-services.json
git restore android/app/google-services.json

# Verificar histórico de commits com arquivo sensível
git log --all --full-history -- android/app/google-services.json
```

---

## 🔐 Boas Práticas de Segurança

### ✅ DO (Faça)

- **Sempre** adicionar arquivos de credenciais ao `.gitignore`
- Usar templates (`.json.template`) para compartilhar estrutura
- Configurar restrições de API key (aplicativo + APIs)
- Revisar billing/usage mensalmente
- Usar variáveis de ambiente para CI/CD
- Documentar processo de setup para novos devs

### ❌ DON'T (Não Faça)

- **NUNCA** commitar arquivos com API keys
- **NUNCA** compartilhar credenciais por email/chat
- **NUNCA** usar mesma API key para dev/prod
- **NUNCA** deixar API keys sem restrições
- **NUNCA** ignorar alertas de segurança do GCP

---

## 🆘 Em Caso de Nova Exposição

1. **Ação Imediata:**
   - Regenerar a chave comprometida (GCP Console > Credentials)
   - Revisar uso recente da API
   - Verificar billing para cobranças inesperadas

2. **Investigação:**
   - Verificar de onde veio a exposição (commit, log, etc.)
   - Remover do Git history se necessário

3. **Prevenção:**
   - Adicionar ao `.gitignore` se ainda não estiver
   - Configurar restrições mais rígidas
   - Educar equipe sobre segurança

4. **Comunicação:**
   - Notificar equipe da exposição
   - Documentar lições aprendidas

---

## 📞 Contatos de Emergência

**Google Cloud Security:**
- Abuse Notifications: Cloud Logging no GCP Console
- Support: https://cloud.google.com/support

**Firebase Support:**
- Console: https://console.firebase.google.com/
- Community: https://firebase.google.com/community

---

**Última atualização:** 05 de novembro de 2025  
**Responsável:** Mateus Carlos (Owner)  
**Status:** ⚠️ API KEY COMPROMETIDA - Ação Urgente Necessária

**PRÓXIMOS PASSOS OBRIGATÓRIOS:**
1. ✅ Arquivos adicionados ao .gitignore
2. ✅ Template criado
3. ⏳ **REGENERAR API KEY** (Owner action required)
4. ⏳ **ADICIONAR RESTRIÇÕES** (Owner action required)
5. ⏳ **REVISAR BILLING** (Owner action required)
