
# 📆 Plano de Desenvolvimento por Etapas — CICATRIZA

> Documento operacional para guiar a execução do projeto **Cicatriza** (Flutter + Firebase), com visão de fases, sprints, entregáveis, critérios de aceite, riscos e métricas.  
> Última atualização: 16/10/2025

---

## 1) Visão Executiva

- **Objetivo do MVP:** digitalizar o formulário clínico de avaliação de feridas, com cadastro de pacientes, avaliações (com fotos), relatório PDF, agenda básica e transferência simples de paciente.
- **Arquitetura:** Flutter (Clean Architecture + BLoC), Firestore + Storage + Functions, modo **offline-first** com Isar/Sqflite.  
- **Conformidade:** LGPD (consentimento, exportação/remoção), segurança com rules restritivas.  
- **Entrega incremental:** Fases M0→M4; Sprints de 2 semanas.

---

## 2) Fases e Marcos (Roadmap Macro)

| Marco | Foco | Principais Entregas | Evidências de Conclusão |
|------|------|----------------------|--------------------------|
| **M0 — Setup** | Fundação | Repositórios, CI/CD inicial, Firebase `dev`, regras de segurança v1, skeleton Flutter com tema e rotas, autenticação | Build CI “verde”; login funcional; rules com emulador |
| **M1 — Pacientes + Avaliação (Básico)** | Núcleo clínico | CRUD de pacientes, cadastro de ferida, avaliação com campos essenciais, upload de fotos, cache offline | Fluxo completo paciente→avaliação; fotos persistidas; testes de widget |
| **M2 — PDF + Agenda Interna + Transferência** | Operacional | Geração de PDF clínico, agenda e lembretes locais, transferência simples de paciente | PDF fiel, evento de lembrete local, transferência com auditoria |
| **M3 — Campos Clínicos Avançados + Histórico** | Profundidade | Leito/borda/perilesão completos, cálculo de área/volume/evolução, histórico cronológico | Regras de validação aplicadas, gráficos de evolução |
| **M4 — Integrações Externas + Dashboards** | Escala | Google/Microsoft Calendar, relatórios analíticos e dashboards | Sincronização calendário, KPIs no dashboard |

---

## 3) Sprints Detalhadas (2 semanas cada)

### Sprint 1 — **Setup + Autenticação + Base de Pacientes**
**Objetivo:** base do app, login, primeira entidade.
- Flutter app skeleton (tema MD3, navegação, DI).
- Auth Google e Microsoft; criação automática do `profile` no Firestore.
- Tela “Pacientes”: lista, criar/editar, busca local; persistência offline (Isar).
- Regras Firestore/Storage v1; Emuladores; seeds mínimas.
- **Testes:** unit (entities/usecases), widget da lista, integração (auth).

**DoD:**
- Lints sem erros; cobertura ≥ 70%; Crashlytics + Analytics ativos.
- Rules bloqueando cross-user; paths de Storage segregados.

---

### Sprint 2 — **Feridas + Avaliação (campos essenciais) + Upload de Fotos**
**Objetivo:** fluxo paciente → ferida → avaliação com mínimos clínicos.
- Cadastro de ferida (tipo, duração, localização simples, dor).
- Avaliação: data, tamanho (C×L×P), dor, notas mínimas.
- Upload de imagem (câmera/galeria), compressão e progresso; thumbnails via Functions.
- Sincronização offline (fila de operações + `updatedAt`).

**DoD:**
- Foto visível na timeline; retentativas de upload; testes integração Storage.

---

### Sprint 3 — **Relatório PDF + Agenda Interna + Transferência**
**Objetivo:** operacionalidade do dia a dia.
- Geração de **PDF** da avaliação (layout próximo ao formulário), assinatura e logomarca do usuário.
- Agenda “in-app”: criar compromisso vinculado à próxima visita; lembrete local.
- Transferência simples de paciente (convite → aceite); auditoria de ações.
- Exportação de dados do paciente (JSON/PDF) e exclusão (LGPD).

**DoD:**
- PDF baixável/compartilhável; histórico de transferência; testes E2E fluxo completo.

---

### Sprint 4 — **Campos Clínicos Avançados + Cálculos + Histórico**
**Objetivo:** profundidade clínica e consistência dos dados.
- Campos avançados: leito (percentuais somando 100%), exsudato (tipo/nível), infecção (checklist), borda (maceração, epíbole…), pele perilesão.
- Cálculos: área, volume, evolução%, status sugerido; suspeita de biofilme.
- Histórico cronológico (gráficos e comparativo de fotos).

**DoD:**
- Validações e regras de negócio ativas; gráficos renderizando sem travamento.

---

### Sprint 5 — **Integrações Externas + Dashboards + Hardening**
**Objetivo:** polimento e valor analítico.
- Integração Google/Microsoft Calendar (sincronização 1‑way).
- Dashboard do profissional (pacientes ativos, nº avaliações/semana, tempo médio de cicatrização estimado).
- A11y, i18n (pt-BR/en-US), melhoria de performance e consumo Firestore.
- Beta público (Firebase App Distribution) + coleta de feedback.

**DoD:**
- Eventos Analytics preenchendo KPIs; release “beta” entregue; bugs críticos zerados.

---

## 4) Epics → Histórias → Tarefas (exemplo por epic)

### Epic A — Autenticação & Perfil
- **Histórias:** Login Google; Login Microsoft; Criar perfil; Editar perfil; Assinatura digital.
- **Tarefas-chave:** providers, persistência segura, tela perfil, upload de assinatura, rules leitura/edição.

### Epic B — Pacientes
- **Histórias:** Criar/editar; Listar/Buscar/Ordenar; Consentimento; Exportar/Excluir (LGPD).
- **Tarefas-chave:** Isar espelho, indexação por `name_lowercase`, validador de idade/peso, máscara de datas.

### Epic C — Feridas & Avaliações
- **Histórias:** Criar ferida; Nova avaliação; Upload fotos; Campos clínicos avançados; Cálculos; Histórico.
- **Tarefas-chave:** componentes de formulário (sliders/checklists), validação 100% tecidos, gráficos, comparador de fotos.

### Epic D — Relatórios
- **Histórias:** PDF avaliação; PDF paciente (período); Compartilhar.
- **Tarefas-chave:** Function render (PDFKit), template, thumbnails em Storage, auditoria de downloads.

### Epic E — Agenda & Notificações
- **Histórias:** Próxima visita; Lembrete local; Sincronização com calendário.
- **Tarefas-chave:** tabela `appointments`, canal de notificação, integração Calendar (fase 2).

### Epic F — Transferência
- **Histórias:** Iniciar transferência; Aceitar; Logs; Revogar.
- **Tarefas-chave:** coleção `transfers`, ACLs dinâmicas, push notifications, telas de convite/aceite.

---

## 5) Padrões Técnicos e Arquitetura

- **Camadas:** `domain` (entities/usecases) · `data` (repos/datasources) · `presentation` (BLoC + UI).  
- **Repos:** Firestore + Isar via `Repository Pattern`, conversores `withConverter()`.
- **Offline:** Isar + fila transacional; resolução de conflitos `last-write-wins` + log de difs.
- **Cloud Functions:** `onAssessmentCreate` (cálculos/flags/agenda), `onStorageFinalize` (thumbnails/contagem), `onTransferRequested` (ACL/notify).  
- **Segurança:** Rules por `ownerId` + `acl.roles`; segregação de Storage por `users/{uid}/…`.

---

## 6) Dados & Segurança (Checklist Operacional)

- Estruturas: `users/{uid}/patients/{pid}/wounds/{wid}/assessments/{aid}` + `media`, `appointments`, `transfers`.
- Índices: `patients(updatedAt, name_lowercase)`, `wounds(updatedAt, status)`, `assessments(date)`.
- Validações app/Function: `pain ∈ [0..10]`, percentuais somando 100%, `nextReview > hoje`.
- LGPD: consentimento anexado; exportar/remoção; trilha de auditoria (alterações e transferências).

---

## 7) UI/UX (Padrões de Tela)

- Lista de pacientes; Detalhe do paciente; Lista de feridas; Avaliação (multi‑etapas); Upload/preview de fotos; Agenda; Relatórios; Transferência.
- Componentes reutilizáveis: `FormSection`, `FieldPercentQuadruple`, `ExudatePicker`, `InfectionChecklist`, `BodyMapPicker` (placeholder estático no MVP).

---

## 8) Qualidade, Testes e Observabilidade

- **Testes:** unit (entidades/validadores), widget (componentes), integração (repos + emulador), E2E (fluxo principal).
- **Cobertura:** ≥ 80% nas camadas domain/data; BLoCs críticos com testes.
- **Analytics mínimos:** `patient_create`, `wound_create`, `assessment_create`, `photo_upload`, `pdf_export`, `reminder_set`, `transfer_accept`.
- **Monitoração:** Crash-free users, tempo médio de sync, falhas de upload (%).

---

## 9) DevOps & Entrega

- **CI:** `dart analyze` → `flutter test` (coverage) → build (dev) → deploy Functions (dev).  
- **CD:** Fastlane: `beta` (Distribution) e `release` (stores).  
- **Ambientes:** `dev`, `staging`, `prod`; variáveis via GitHub Secrets.  
- **Checklist Release:** changelog, versionamento semântico, migrações de rules versionadas.

---

## 10) Critérios de Prontidão (DoR) e Conclusão (DoD)

**DoR:** wireframes aprovados; campos e regras definidos; mock Firestore validado; dependências resolvidas.  
**DoD:** código revisado; testes ok; lints zerados; analytics/crashlytics ativos; documentação atualizada; demo gravada.

---

## 11) Riscos & Mitigações

| Risco | Impacto | Mitigação |
|------|---------|-----------|
| Upload lento | Alto | Compressão + chunk + retry exponencial |
| Conflitos offline | Médio | Estrategia LWW + log + aviso ao usuário |
| Custos Firestore | Médio | Paginação, índices compostos, redução de writes |
| Privacidade | Alto | LGPD + consentimento + criptografia + auditoria |
| PDF falhar | Baixo | Retry + fallback local + fila |
| Integração Calendar | Médio | Fase 2; retriable webhooks; feature flag |

---

## 12) Métricas-chave (MVP)

- Tempo médio de avaliação (min)  
- % avaliações com fotos  
- Evolução média (%) por semana  
- Nº pacientes ativos/usuário  
- PDF exports/semana  
- Crash-free users (%)

---

## 13) Anexos Operacionais (para o time)

- **Templates:** JIRA CSV (épicos/histórias), README do monorepo, `.firebaserc`, `firebase.json`, `firestore.rules`, `storage.rules`, `functions/` boilerplate.  
- **Comandos úteis:** emuladores, testes com cobertura, lanes Fastlane, scripts de seed.

---

## 14) Próximos Passos Imediatos

1. Criar `cicatriza_app` e `cicatriza_functions`.  
2. Provisionar Firebase `dev` e configurar emuladores.  
3. Subir skeleton Flutter (tema, rotas, DI, BLoC base).  
4. Implementar Auth (Google/MS) e profile.  
5. Iniciar Epic B (Pacientes) com Isar + Firestore sync.

---

**FIM**
