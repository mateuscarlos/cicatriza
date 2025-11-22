
# 🗂️ M2 — Operacionalidade e Continuidade (PDF, Agenda e Transferência)

> Objetivo do M2: disponibilizar **Relatório PDF** fiel ao formulário, **Agenda interna** com lembretes locais, **Transferência de paciente** entre estomaterapeutas e **auditoria/LGPD** (exportar e excluir).  
> Duração sugerida: **2 semanas** | Dependência: **M1 concluído**

---

## 0) Escopo e Critérios de Saída (DoD do M2)

**Escopo**  
1) Geração de **PDF** da avaliação/paciente (inclui fotos, assinatura e logotipo do usuário).  
2) **Agenda in-app** com criação/edição de compromissos e lembretes locais.  
3) **Transferência** de paciente (convite → aceite) com atualização de ACLs.  
4) **Auditoria** (logs de transferências/exports) + **LGPD** (exportar JSON/PDF e exclusão).

**DoD**  
- PDF gerado e compartilhável (A4, metadados, numeração de páginas).  
- Agenda funcional com lembretes locais e status (pendente/concluído).  
- Transferência ok entre dois usuários reais (DEV) com auditoria.  
- Exportação JSON/PDF e exclusão do paciente (com confirmação).  
- Testes integração/E2E dos fluxos acima (verde).

---

## 1) Modelo de Dados (extensões do Firestore)

```
users/{uid}
  appointments/{appointmentId}
    (patientId, woundId?, title, notes, startAt, endAt, status, createdAt, updatedAt)
  transfers/{transferId}
    (patientId, fromUid, toUid, status[pending|accepted|rejected|revoked], createdAt, decidedAt)
  audit/{auditId}
    (action, entity, entityId, actorUid, targetUid?, meta, createdAt)
# pacientes/feridas/avaliacoes mantêm a estrutura do M1
```

**Observações**  
- `appointments.status`: `pending|done|cancelled`.  
- `audit.action`: `transfer_request`, `transfer_accept`, `transfer_reject`, `export_pdf`, `export_json`, `patient_delete`.  
- Guardar `meta` com hashes/refs (ex.: `pdfPath`, `exportSize`).

---

## 2) Regras de Segurança (refinos do M2)

### 2.1 Firestore Rules (trechos)
```
// Agenda (somente dono)
match /users/{uid}/appointments/{id} {
  allow read, write: if request.auth.uid == uid
    && request.resource.data.startAt < request.resource.data.endAt;
}

// Transferências (somente dono cria/gerencia)
match /users/{uid}/transfers/{id} {
  allow create: if request.auth.uid == uid;
  allow read: if request.auth.uid == uid || request.auth.uid == resource.data.toUid;
  allow update: if (
      // remetente pode revogar enquanto pendente
      (request.auth.uid == uid && resource.data.status == 'pending')
      ||
      // destinatário pode aceitar/rejeitar
      (request.auth.uid == resource.data.toUid && request.resource.data.status in ['accepted','rejected'])
  );
}
```

### 2.2 Storage Rules (PDF/exports)
```
match /users/{uid}/reports/{allPaths=**} {
  allow read, write: if request.auth != null && request.auth.uid == uid;
}
match /users/{uid}/exports/{allPaths=**} {
  allow read, write: if request.auth != null && request.auth.uid == uid;
}
```

---

## 3) Cloud Functions (PDF, ACLs e auditoria)

### 3.1 Dependências
```bash
cd cicatriza_functions
npm i pdfkit
```

### 3.2 PDF — `generateAssessmentPdf` (HTTP callable ou on-demand)
**Fluxo sugerido:**
1. App chama callable com `{ patientId, woundId, assessmentId }`.  
2. Function lê dados (Firestorm) e monta documento com **PDFKit**.  
3. Salva em `users/{uid}/reports/{assessmentId}.pdf` no Storage.  
4. Retorna `downloadUrl` e cria `audit` com `action=export_pdf`.

**Pseudo‑código:**
```ts
export const generateAssessmentPdf = functions.https.onCall(async (data, ctx) => {
  const uid = ctx.auth?.uid;
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login required');

  const { patientId, woundId, assessmentId } = data;
  // 1) Ler documentos
  // 2) Montar PDF (layout a partir do formulário)
  // 3) Upload para Storage em users/{uid}/reports/...
  // 4) Gravar audit { action:'export_pdf', entity:'assessment', entityId: assessmentId, actorUid: uid }
  return { downloadUrl };
});
```

### 3.3 Transferência — callable `requestTransfer`, `decideTransfer`
- `requestTransfer({ patientId, toUid })` cria `transfers/pending`.  
- `decideTransfer({ transferId, decision })` aceita/rejeita, move/duplica registro do paciente sob `toUid` e **atualiza ACLs** (se necessário).  
- Gravar `audit` para `transfer_request/accept/reject`.  

### 3.4 Exportação JSON — callable `exportPatientJson`
- Lê o grafo (paciente → feridas → avaliações → mídia).  
- Gera JSON, salva em `users/{uid}/exports/{patientId}.json` e registra `audit`.  

### 3.5 Exclusão LGPD — callable `deletePatient`
- Verifica ownership e dependências; apaga subcoleções `wounds/assessments/media` e arquivos no Storage (prefixo do paciente).  
- Registra `audit` `patient_delete`.

---

## 4) App Flutter — Telas e Fluxos

### 4.1 Relatórios (PDF)
- **AssessmentReportPage**: mostra card com dados principais + botão “Gerar PDF”.  
- Ao acionar, exibir loading + callback com `downloadUrl` para **share** (Android/iOS).  
- Adicionar **metadados** (paciente, avaliação, data de export).

### 4.2 Agenda
- **AppointmentsPage**: lista por data, filtros (status), criar/editar.  
- Campos: título, paciente/ferida, início/fim, notas, lembrete (min antes).  
- **Notificações locais** usando `flutter_local_notifications`.  
- Alterar status para `done/cancelled` com gesto rápido.

### 4.3 Transferência
- **TransferStartPage**: escolher paciente e informar e-mail/UID do destinatário.  
- **TransferInboxPage**: listar convites recebidos (aceitar/rejeitar).  
- Ao aceitar: feedback e navegação para o paciente transferido.

### 4.4 Exportação/Exclusão (LGPD)
- Botões na **PatientDetailPage**: “Exportar (JSON/PDF)” e “Excluir paciente”.  
- Confirmação 2 etapas (nome do paciente) antes de excluir.

---

## 5) Integrações no App (serviços)

- `PdfService` → chama callable `generateAssessmentPdf`.  
- `AppointmentsRepository` (CRUD Firestore + lembretes locais).  
- `TransferService` → `requestTransfer` e `decideTransfer`.  
- `ExportService` → `exportPatientJson`, `deletePatient`.  
- `AuditRepository` → grava eventos locais (para telemetry) e Firestore (Functions).

---

## 6) UX e Acessibilidade

- Cards de avaliação com **preview** das fotos (thumbnail) e CTA “PDF”.  
- Agenda com **empty state** e atalhos “Nova visita para este paciente”.  
- Transferência com estado claro **(pendente/aceito/rejeitado)** e toasts.  
- Textos legíveis, áreas de toque ≥ 44px, contraste adequado; dark mode.

---

## 7) Testes

### 7.1 Unit
- Mapeamento de DTOs para PDF (formatters), validação de datas de agenda.  
- Regras de estado na transferência (somente pending pode ser revogada).

### 7.2 Integração (emuladores)
- Gerar PDF e recuperar `downloadUrl`.  
- Criar/editar/remover compromisso + lembrete local simulado.  
- Transferir paciente entre `uidA` e `uidB` (feliz e rejeitado).  
- Exportar JSON e executar exclusão LGPD (assert em Storage/Firestore).

### 7.3 E2E
- Cenário completo: criar paciente → avaliação → gerar PDF → agendar visita → transferir paciente → aceitar → visualizar no destinatário.

---

## 8) CI (ampliação para M2)

- Job para testar **Cloud Functions** (unit + emuladores).  
- Publicar **artefatos**: exemplo de PDF gerado nos testes.  
- Cobertura alvo ≥ 80% nas funções relacionadas a M2.

---

## 9) Observabilidade e Auditoria

- Eventos Analytics: `pdf_export_click`, `appointment_create`, `transfer_request`, `transfer_accept`.  
- Logs em Functions (tempo de render do PDF, tamanho do arquivo).  
- Painel temporário (Crashlytics/Analytics dashboard) para monitorar falhas.

---

## 10) Checklist de Saída (DoD M2)

- [ ] PDF (A4) com fotos, assinatura e logotipo; arquivo no Storage e **share** no app.  
- [ ] Agenda com lembretes locais funcionando.  
- [ ] Transferência entre contas real (DEV) com auditoria.  
- [ ] Exportação JSON/PDF e exclusão LGPD testadas.  
- [ ] Testes unit/integr/E2E **verdes** e cobertura ≥ 80% (Functions M2).  
- [ ] Documentação `docs/README_M2.md` com instruções e troubleshooting.  

---

## 11) Riscos & Mitigações (M2)

| Risco | Impacto | Mitigação |
|---|---|---|
| PDF pesado/lento | Alto | Paginação, JPEG qualidade 75, lazy load de imagens |
| Falha em lembretes locais | Médio | Testes em background, re-agendamento em boot |
| Transferência parcial | Alto | Transações/Batch no Firestore; idempotência |
| Vazam dados em export | Alto | Filtrar campos sensíveis; checagem de permissão |
| Custos de Storage | Médio | Compressão, expirar exports antigos via TTL job |

---
