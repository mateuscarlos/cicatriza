# ⚠️ AÇÃO URGENTE NECESSÁRIA - Segurança Firebase

**Data:** 05 de novembro de 2025  
**Prioridade:** 🔴 CRÍTICA

---

## 🚨 Situação

A API key do Firebase foi **exposta publicamente** no GitHub e precisa ser **regenerada imediatamente** pelo owner do projeto.

### API Key Comprometida

```
AIzaSyDmbo3grB4WcrBswQ0HUNKvS7ylXFvbLgY
```

**Projeto:** cicatriza-dev-b1085  
**Exposto em:** https://github.com/mateuscarlos/cicatriza (commit 22dc529)

---

## ✅ Ações Já Tomadas (05/11/2025)

1. ✅ Removido `google-services.json` do Git tracking
2. ✅ Adicionado arquivos sensíveis ao `.gitignore`
3. ✅ Criado template de referência (`google-services.json.template`)
4. ✅ Criado documentação completa (`docs/SECURITY_FIREBASE.md`)
5. ✅ Criado script de verificação (`check_firebase_security.ps1`)
6. ✅ Commit de segurança criado (75047c1)

---

## 🔥 AÇÕES PENDENTES (OWNER - Mateus Carlos)

### 1. Regenerar API Key (URGENTE - 5 minutos)

1. Acesse: https://console.cloud.google.com/apis/credentials?project=cicatriza-dev-b1085
2. Encontre a API key: `AIzaSyDmbo3grB4WcrBswQ0HUNKvS7ylXFvbLgY`
3. Clique em **Edit** (ícone de lápis)
4. Clique em **REGENERATE KEY**
5. **Copie a nova chave** (será necessária para baixar novo google-services.json)

### 2. Adicionar Restrições de API (URGENTE - 3 minutos)

**Application Restrictions:**
- Tipo: **Android apps**
- Package name: `com.example.cicatriza`
- SHA-1: `97:79:D9:53:1A:BF:BA:F4:F2:D3:B2:EF:F5:BA:F5:7C:9B:31:F6:16`

**API Restrictions:**
- Restringir para:
  - ✓ Firebase Installations API
  - ✓ FCM Registration API
  - ✓ Cloud Firestore API
  - ✓ Firebase Storage API
  - ✓ Firebase Authentication
  - ✓ Firebase Analytics

### 3. Baixar Novo google-services.json (2 minutos)

1. Acesse: https://console.firebase.google.com/project/cicatriza-dev-b1085/settings/general
2. Na seção **Your apps**, selecione o app Android
3. Clique em **Download google-services.json**
4. Salve em: `android/app/google-services.json` (local, NÃO commitar!)

### 4. Revisar Billing/Usage (5 minutos)

1. Acesse: https://console.cloud.google.com/billing?project=cicatriza-dev-b1085
2. Verifique se há cobranças inesperadas
3. Acesse: https://console.cloud.google.com/apis/dashboard?project=cicatriza-dev-b1085
4. Verifique uso de APIs

### 5. Configurar Alertas de Orçamento (Opcional - 3 minutos)

1. Acesse: https://console.cloud.google.com/billing/budgets
2. Create Budget
3. Configure:
   - Budget amount: $10/mês
   - Threshold: 50%, 80%, 100%
   - Email: seu-email@example.com

---

## 📚 Documentação Completa

Ver: **`docs/SECURITY_FIREBASE.md`**

Este documento contém:
- ✅ Passo-a-passo detalhado de regeneração
- ✅ Instruções de setup para novos desenvolvedores
- ✅ Como remover do histórico Git (opcional)
- ✅ Boas práticas de segurança
- ✅ Monitoramento contínuo
- ✅ Procedimentos de emergência

---

## 🔄 Próximos Passos Após Correção

### Para Owner (Após regenerar)

1. Confirmar que nova API key está funcionando:
   ```bash
   flutter clean
   flutter run
   ```

2. Push do commit de segurança:
   ```bash
   git push origin Inicio_m2
   ```

3. Comunicar equipe sobre novas credenciais

### Para Desenvolvedores

1. Baixar novo `google-services.json` do Firebase Console
2. Colocar em `android/app/google-services.json` (local only!)
3. **NUNCA commitar** este arquivo
4. Usar `check_firebase_security.ps1` antes de commits

---

## 🛡️ Verificação de Segurança

Execute antes de qualquer commit:

```powershell
.\check_firebase_security.ps1
```

Deve mostrar:
```
✅ google-services.json está protegido
✅ GoogleService-Info.plist está no .gitignore
✅ firebase_options.dart está no .gitignore
✅ Verificação de segurança passou!
```

---

## ⏰ Timeline de Ações

| Ação | Prioridade | Tempo | Status |
|------|-----------|-------|--------|
| Remover do Git | 🔴 Crítica | 2 min | ✅ FEITO |
| Adicionar .gitignore | 🔴 Crítica | 1 min | ✅ FEITO |
| Criar documentação | 🟡 Alta | 10 min | ✅ FEITO |
| **Regenerar API key** | 🔴 **Crítica** | 5 min | ⏳ **PENDENTE** |
| **Adicionar restrições** | 🔴 **Crítica** | 3 min | ⏳ **PENDENTE** |
| **Baixar novo google-services.json** | 🔴 **Crítica** | 2 min | ⏳ **PENDENTE** |
| Revisar billing | 🟡 Alta | 5 min | ⏳ PENDENTE |
| Configurar alertas | 🟢 Média | 3 min | ⏳ PENDENTE |
| Remover do histórico Git | 🟢 Baixa | 15 min | ⏳ OPCIONAL |

**Total tempo crítico:** ~10 minutos

---

## 📞 Suporte

**Google Cloud Security:**
- Console: https://console.cloud.google.com/
- Notificações: Cloud Logging

**Firebase Support:**
- Console: https://console.firebase.google.com/
- Docs: https://firebase.google.com/docs/projects/api-keys

---

## ✅ Checklist Rápido

- [x] google-services.json removido do Git
- [x] Adicionado ao .gitignore
- [x] Template criado
- [x] Documentação completa
- [x] Script de verificação
- [x] Commit de segurança
- [ ] **API key regenerada** ← FAZER AGORA
- [ ] **Restrições adicionadas** ← FAZER AGORA
- [ ] **Novo google-services.json baixado** ← FAZER AGORA
- [ ] Billing revisado
- [ ] Alertas configurados
- [ ] Equipe notificada

---

**PRÓXIMA AÇÃO:** Regenerar API key agora! (5 minutos)  
**URL:** https://console.cloud.google.com/apis/credentials?project=cicatriza-dev-b1085

---

**Última atualização:** 05 de novembro de 2025  
**Commit:** 75047c1  
**Status:** Proteções implementadas, aguardando regeneração de API key
