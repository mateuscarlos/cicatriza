
# 📈 M4 — Integrações, Dashboards e Otimização Final (Passo a passo executável)

> Objetivo do M4: entregar **integrações externas de calendário (Google/Microsoft)** em modo **1‑way**, **dashboards** com KPIs clínico‑operacionais, **i18n/A11y**, polimento de performance/UX e **Beta público** via Firebase App Distribution.  
> Duração sugerida: **2 semanas** | Dependência: **M3 concluído**

---

## 0) Escopo e Critérios de Saída (DoD do M4)

**Escopo**
1) **Integração de calendário** (1‑way): criar/atualizar eventos no Google/Microsoft Calendar a partir da agenda interna.  
2) **Dashboards**: KPIs por estomaterapeuta (pacientes ativos, avaliações/semana, tempo médio de cicatrização, status de feridas, top sinais de infecção/biofilme).  
3) **i18n/A11y**: pt‑BR/en‑US, labels/semântica acessível, foco/teclas, contraste.  
4) **Otimização**: performance (recomposição, cache, imagens), consumo Firestore, cold‑start.  
5) **Beta público**: pipeline de distribuição e coleta de feedback (form + logs).

**DoD**
- Eventos da agenda sincronizando **1‑way** para o calendário externo escolhido.  
- Dashboards renderizando dados em tempo quase‑real (máx. 5 min defasagem).  
- App acessível (checagens básicas de A11y) e internacionalizado (pt‑BR/en‑US).  
- Build Beta distribuído com instruções de testes e canal de feedback.  
- Testes unit/integr. e checklist de release **verdes**.

---

## 1) Integração de Calendário (Google/Microsoft)

### 1.1 Autorização (OAuth 2.0)
- Fluxo **on‑demand**: o usuário opta por conectar Google/Microsoft Calendar.  
- Guardar **tokens** seguros (usando `flutter_secure_storage` no app); **NUNCA** salvar o secret.  
- Scopes mínimos:  
  - Google: `https://www.googleapis.com/auth/calendar.events`  
  - Microsoft (Graph): `Calendars.ReadWrite`

### 1.2 Modelo de dados (extensão)
```
users/{uid}
  integrations/calendar
    provider: "google"|"microsoft"|null
    connectedAt: timestamp
    refreshToken: encrypted              // armazenado no device; no Firestore, somente referência/estado
    lastSyncAt: timestamp
  appointments/{id}
    external:
      provider: "google"|"microsoft"|null
      eventId: string|null
      lastPushedAt: timestamp|null
      status: "ok"|"error"|null
```

> **Privacidade:** tokens/refresh devem permanecer **no dispositivo**; caso precise de push via Cloud Functions, usar **Link Token** temporário ou uma **Cloud Function callable** que receba o token do app no momento da operação.

### 1.3 Serviço de sincronização (app)
- `CalendarSyncService`:
  - `connect(provider)` → fluxo OAuth + persistência local do token.  
  - `pushAppointment(appointment)` → cria/atualiza evento externo; grava `external.eventId/status`.  
  - `disconnect()` → revoga token e zera estado.

### 1.4 Mapeamento de campos
- Título, descrição (incluir paciente/ferida), início/fim, lembrete (min antes).  
- `location` opcional; incluir link interno (deep link) para o app.

### 1.5 Retentativas e erros
- Backoff exponencial para erros transitórios (HTTP 5xx, rate limit).  
- Logs de falhas (Crashlytics) e banner “Sincronização pendente”.

---

## 2) Dashboards (KPIs)

### 2.1 KPIs prioritários
- **Pacientes ativos** (≥1 avaliação nos últimos 30 dias).  
- **Avaliações/semana** (últimas 8 semanas).  
- **Tempo médio de cicatrização** (da 1ª avaliação até status “cicatrizada”).  
- **Distribuição de status sugerido** (improved/stable/worsened).  
- **Sinais de infecção/biofilme** (contagem/percentual por período).

### 2.2 Fontes de dados
- Firestore: coleções de `patients`, `wounds`, `assessments`.  
- Analytics: eventos `assessment_create`, `photo_upload`, `pdf_export`, etc., para **telemetria de uso** (não clínico).

### 2.3 Agregação
- **Device‑side** (MVP): consultas paginadas + agregação local (Isar cache).  
- **Function (opcional)**: `getKpisSummary({ from, to })` para cálculos pesados e resposta cacheada (TTL 5 min).

### 2.4 UI/UX (Flutter)
- Cards com números e variação (%) vs. período anterior.  
- Gráficos (Recharts/Charts) simples: linhas/barras/pizza.  
- Filtros por período: 7/30/90 dias.  
- Skeletons e lazy loading para suavizar.

---

## 3) i18n e Acessibilidade

### 3.1 i18n
- `flutter_localizations` + `intl`.  
- Pastas `l10n/arb` com `app_pt.arb` e `app_en.arb`.  
- Processo: chaves semânticas, `Intl.message`, script para validação de traduções.

### 3.2 A11y
- Semântica em componentes interativos; `Semantics` + `ExcludeSemantics` quando necessário.  
- Tamanhos mínimos de toque (≥44px), contraste AA, navegação por teclado (em web/desktop).  
- Labels descritivos em botões, `alt` para imagens (fotos clínicas **não precisam de alt** além de “Foto clínica — data”).

---

## 4) Performance e Custos

- **Firestore**: consultas com índices, paginação, leve uso de `where`/`orderBy`; reduzir documentos derivados.  
- **Imagens**: preferir **thumbnails** em listas (M1) e lazy load em detalhes.  
- **Cold start**: pré‑carregar dependências com DI e evitar `await` desnecessários antes do `runApp`.  
- **Cache**: Isar para KPIs; invalidar por `updatedAt` e janela de tempo.  
- **Medir**: tempo de render de dashboards, consumo de docs/leitura por sessão.

---

## 5) App Distribution (Beta Público)

### 5.1 Pipeline
- **Fastlane** + GitHub Actions: lane `beta` gera build e envia para **Firebase App Distribution**.  
- Lista de testadores; release notes com **roteiro de teste** (M2/M3/M4).

### 5.2 Coleta de feedback
- Link para formulário (ex.: Google Forms) no menu “Feedback”.  
- Capturar `deviceInfo`, `appVersion`, `featureArea`.  
- Eventos `beta_feedback_open` e `beta_feedback_submit` no Analytics.

---

## 6) Testes

### 6.1 Unit
- `CalendarSyncService` (mocks de SDKs); formatação de dados e mapeamento de erros.  
- `KpiService` de agregação (local e via Function).  
- i18n: presença de chaves obrigatórias.

### 6.2 Integração
- Sincronizar evento criado/editado/cancelado em `appointments` → calendário externo.  
- Carregar KPIs com dados fictícios nos emuladores; validar cálculos.  
- Alternar idioma e verificar telas principais.

### 6.3 E2E
- Fluxo: criar avaliação → gerar agenda → sincronizar → ver no calendário → abrir dashboards.  
- Sanidade de acessibilidade com `flutter_driver`/`integration_test` + checagem de Semantics.

---

## 7) CI/CD (ampliação M4)

- Workflow com **matriz** (Android/iOS) e build Beta automático em `main`.  
- Job de smoke test que:  
  1) carrega dados seed nos emuladores,  
  2) executa testes de agregação,  
  3) valida i18n (chaves faltantes).  
- Publicar artefatos: JSON de KPIs de teste e screenshots dos dashboards.

---

## 8) Checklist de Saída (DoD M4)

- [ ] Sincronização 1‑way de agenda com Google/Microsoft Calendar.  
- [ ] Dashboards renderizando KPIs principais com atualização ≤ 5 min.  
- [ ] App internacionalizado (pt‑BR/en‑US) e com validações básicas de A11y.  
- [ ] Otimizações de performance aplicadas (imagens, consultas, cache).  
- [ ] Build Beta publicado no App Distribution com roteiro de teste e canal de feedback.  
- [ ] Documentação `docs/README_M4.md` atualizada.

---

## 9) Riscos & Mitigações (M4)

| Risco | Impacto | Mitigação |
|---|---|---|
| OAuth/Scopes rejeitados | Alto | Solicitar somente escopos mínimos; telas claras; fallback sem integração |
| Rate limit APIs | Médio | Backoff exponencial, retry‑after, limitar re‑sync |
| KPIs lentos em device | Médio | Function de agregação com cache; amostragem de dados |
| Traduções incompletas | Médio | CI valida chaves; fallback para en‑US |
| A11y inconsistente | Médio | Checklist por tela; testes de Semantics no CI |

---
