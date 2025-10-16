# 🩹 Projeto Cicatriza — Documento de Planejamento e Desenvolvimento

## 📘 Visão Geral
O **Cicatriza** é um aplicativo mobile multiplataforma (Android e iOS) voltado para **estomaterapeutas** e **profissionais de saúde especializados no tratamento de feridas**. O objetivo é oferecer uma ferramenta completa para **cadastro de pacientes**, **avaliação de feridas**, **registro clínico fotográfico**, **acompanhamento evolutivo**, **prescrições**, **geração de relatórios** e **comunicação entre profissionais**.

O aplicativo segue a filosofia **Offline-First**, com sincronização automática via **Firebase**, garantindo que o profissional possa atuar mesmo em locais sem conectividade. Toda a arquitetura segue princípios de **Clean Architecture**, **SOLID**, **DDD** e **Boas Práticas de Engenharia de Software**.

---

## 🧱 Arquitetura da Solução

### 🔹 Camadas Principais (Clean Architecture)

```
lib/
  app/                → Bootstrap, inicialização, tema e injeção de dependências
  core/               → Constantes, utilitários, erros, tema global e tokens
  features/
    auth/             → Autenticação (Google, Microsoft)
    patients/         → Gestão de pacientes (CRUD + filtros)
    wounds/           → Registro de feridas, avaliações, fotos e evolução
    scheduler/        → Agenda e lembretes
    reports/          → Geração e exportação de relatórios PDF
  services/           → Serviços de sistema (camera, storage, analytics, notifications)
assets/
  images/ icons/ lottie/
test/ integration_test/
```

### 🔹 Tecnologias Utilizadas

| Categoria | Tecnologia | Descrição |
|------------|-------------|------------|
| **Frontend** | Flutter 3.x | Framework principal multiplataforma |
| **Gerência de Estado** | BLoC / Cubit | Fluxo de eventos e estados reativos |
| **Backend (Serverless)** | Firebase | Firestore, Storage, Functions, Auth, Crashlytics, Remote Config |
| **Offline DB** | Isar / Sqflite | Armazenamento local persistente |
| **CI/CD** | GitHub Actions + Fastlane | Automação de builds, testes e deploys |
| **Analytics e Observabilidade** | Firebase Analytics + Crashlytics | Métricas de uso e estabilidade |
| **Design System** | Material Design 3 (MD3) | UI/UX consistente e acessível |

---

## ☁️ Estrutura de Dados — Firestore

### 🔸 Coleções e Subcoleções

```
/users/{userId}
  ├── profile: { name, email, photoURL, createdAt }
  ├── patients/{patientId}
  │     ├── demographics: { name, birthDate, gender, contact }
  │     ├── wounds/{woundId}
  │     │     ├── details: { type, location, startDate, status }
  │     │     ├── assessments/{assessmentId}
  │     │     │     ├── dataClinica: { tissue, exudate, infection, pain, notes }
  │     │     │     ├── measures: { length, width, depth }
  │     │     │     ├── treatmentPlan: { goal, procedures, materials }
  │     │     │     ├── photos: [url, metadata]
  │     │     │     └── nextVisitAt
  │     └── prescriptions/{prescriptionId}
  └── logs/{logId}
```

### 🔸 Storage Structure
```
/users/{userId}/patients/{patientId}/wounds/{woundId}/{photoId}.jpg
```

### 🔸 Índices e Consultas
- `patients` indexado por `updatedAt`, `name_lowercase`
- `wounds` indexado por `updatedAt`, `status`
- `assessments` indexado por `date`, `woundId`

---

## 🔒 Segurança e LGPD

### 🔹 Regras de Acesso (Security Rules)
- Cada documento pertence exclusivamente ao `request.auth.uid`.
- Operações CRUD restritas ao proprietário.
- Uploads em Storage vinculados ao caminho do usuário.
- Logs de auditoria automáticos via Cloud Functions.

### 🔹 Conformidade LGPD
- Consentimento de paciente armazenado digitalmente (arquivo anexo).
- Retenção mínima de dados (apenas para acompanhamento clínico).
- Opção de exportar e remover dados do paciente (“Right to Erasure”).

---

## 🧩 Requisitos Funcionais

### 1. Autenticação e Cadastro
- Login via Google e Microsoft.
- Gerenciamento de sessão com persistência segura.
- Cadastro automático no Firestore após autenticação.

### 2. Pacientes
- CRUD completo de pacientes.
- Campos: nome, idade, sexo, contato, comorbidades, alergias, responsável.
- Sincronização offline e filtro por nome ou status.

### 3. Lesões
- Registro de novas lesões por paciente.
- Campos: localização anatômica, tipo, início, status, observações.
- Suporte a imagens capturadas com câmera.

### 4. Avaliações de Feridas
- Medidas (C × L × P), dor (0–10), tecido, exsudato, infecção, borda e perilesão.
- Plano terapêutico, metas, evolução e observações clínicas.
- Histórico completo e visualização temporal.

### 5. Relatórios
- Exportação de relatórios em PDF.
- Opções: por paciente, por lesão, por período.
- Geração via Cloud Functions (serverless render).

### 6. Agenda e Lembretes
- Cadastro de próxima visita com notificação push.
- Sincronização com Google Calendar (fase 2).

---

## ⚙️ Requisitos Não Funcionais

| Categoria | Requisito |
|------------|------------|
| **Desempenho** | Tempo de abertura de paciente ≤ 800 ms; Upload de imagem ≤ 3s em 4G |
| **Disponibilidade** | Operação completa offline; sincronização automática ao reconectar |
| **Segurança** | Criptografia TLS; autenticação federada; rules restritivas |
| **Escalabilidade** | Estrutura de dados otimizada para Firestore; índices compostos |
| **Observabilidade** | Eventos de analytics: login, criação, upload, sync, exportação |
| **Acessibilidade** | Labels, contraste, tamanhos responsivos (A11y Ready) |
| **Internacionalização** | pt-BR padrão + en-US disponível |

---

## 🧠 Domínio e Casos de Uso

| Caso de Uso | Descrição | Entradas | Saídas |
|--------------|-----------|-----------|--------|
| `RegistrarPaciente` | Cria ou edita um paciente | Dados demográficos | ID do paciente |
| `RegistrarLesao` | Cria lesão vinculada ao paciente | Localização, tipo | ID da lesão |
| `AvaliarFerida` | Registra avaliação clínica e fotos | Dados clínicos + fotos | ID da avaliação |
| `ExportarRelatorio` | Gera PDF consolidado | Paciente/lesão | URL de download |
| `AgendarVisita` | Define data próxima visita | Data, paciente | Notificação local |

---

## 🧰 DevOps e Infraestrutura

### 🔹 Integração Contínua (CI)
- GitHub Actions com jobs: lint → tests → build → deploy.
- Análise de código: `dart analyze`, `flutter test`, cobertura ≥80%.

### 🔹 Entrega Contínua (CD)
- **Fastlane lanes**:
  - `beta`: build interno (Firebase Distribution)
  - `release`: build assinado e publicação (Play/App Store)
- Ambientes: `dev`, `staging`, `prod`.

### 🔹 Segurança DevOps
- Secret scanning automático.
- Dependabot ativo.
- Variáveis sensíveis via GitHub Secrets.

---

## 🧪 Qualidade e Testes

### 🔸 Tipos de Testes
- **Unitário**: entidades, usecases, validators.
- **Widget**: componentes de UI isolados.
- **Integração**: bloc + repos + firebase emulator.
- **E2E**: cenários completos (login → avaliação → exportação PDF).

### 🔸 Casos Críticos
- Upload cancelado (retry/backoff).
- Edição offline + conflito de sincronização.
- Falha na exportação de relatório (retry em background).
- Remoção de paciente com dados associados.

---

## 📈 Roadmap e Sprints

| Fase | Período | Entregas |
|-------|----------|-----------|
| **Fase 0 — Setup** | Semana 0 | Repositório, Firebase dev, Auth Google/MS, CI inicial |
| **Sprint 1** | Semanas 1–2 | Auth + CRUD Pacientes + Cache Offline + Regras Firestore |
| **Sprint 2** | Semanas 3–4 | CRUD Lesões + Avaliações Básicas + Upload de Imagem |
| **Sprint 3** | Semanas 5–6 | Campos clínicos avançados + Histórico + Agenda |
| **Sprint 4** | Semanas 7–8 | Exportação PDF + Prescrições + Dashboard |
| **Sprint 5** | Semanas 9–10 | A11y + Internacionalização + Beta público |
| **Release 1.0** | Semanas 11–12 | Lançamento nas lojas + documentação final |

---

## ✅ Critérios de Aceite (DoR / DoD)

### **Definition of Ready (DoR)**
- Wireframe e jornada aprovados.
- Campos e regras de negócio definidos.
- Mock de Firestore validado.
- Dependências técnicas resolvidas.

### **Definition of Done (DoD)**
- Código revisado, testado (≥80% cobertura).
- Lints sem erros.
- Analytics e Crashlytics configurados.
- Documentação técnica e de tela atualizadas.
- Demo funcional gravada.

---

## 🧮 Métricas e Observabilidade

### 🔸 Eventos Mínimos
- `login_success`
- `patient_create`
- `wound_create`
- `assessment_create`
- `photo_upload`
- `pdf_export`
- `reminder_set`
- `sync_conflict_resolved`

### 🔸 Dashboards
- Crash-free users (%)
- Tempo médio de sincronização
- Nº de pacientes ativos por usuário
- Nº de avaliações semanais

---

## ⚠️ Riscos e Mitigações

| Risco | Impacto | Mitigação |
|--------|----------|------------|
| Upload de fotos lento | Alto | Compressão + Upload em partes |
| Conflito de sync offline | Médio | Política last-write-wins + diff log |
| Custos do Firestore | Médio | Paginação + índices compostos |
| Problemas de privacidade | Alto | LGPD compliance + consentimento salvo |
| Falha na geração de PDF | Baixo | Retry + fallback local |

---

## 🚀 Próximos Passos
1. Criar repositório oficial `cicatriza_app` e `cicatriza_functions`.
2. Provisionar Firebase Dev/Stage/Prod.
3. Implementar regras iniciais do Firestore/Storage.
4. Subir template Flutter com tema, rotas e auth.
5. Alimentar backlog (Epics/Sprints) no Jira/GitHub Projects.
6. Iniciar Sprint 1 com foco em autenticação e pacientes.

---

## 🧩 Anexos e Documentação Complementar
- **Blueprint Cicatriza** — visão do produto e jornadas.
- **Formulário de Avaliação de Ferida (PDF)** — base clínica do modelo de dados.
- **Wireframes e UI/UX (Figma)** — telas principais.
- **Security Rules v1** — arquivo `.rules` de Firestore/Storage.

---

**Autor:** Mateus Carlos Oliveira da Silva  
**Versão:** 1.0 (Outubro/2025)  
**Licença:** MIT  
**Repositório:** [github.com/mateuscarlos05/cicatriza](https://github.com/mateuscarlos05/cicatriza)

