# Modelo de Dados da Aplicação CICATRIZA

Este documento define a estrutura de dados oficial da aplicação **Cicatriza**, conforme o **Documento de Regras de Negócio (DRN)** e os **Requisitos Funcionais (RF)**. Ele deve ser usado como **referência técnica** para desenvolvedores e assistentes de codificação (como o GitHub Copilot), garantindo consistência entre o backend (Firebase/Firestore), o frontend (Flutter) e o banco local (Isar/Sqflite).

---

## 1. Visão Geral
- **Banco principal:** Firestore (modo NoSQL, hierárquico)
- **Armazenamento de mídia:** Firebase Storage
- **Funções automáticas:** Cloud Functions (Node.js 20)
- **Banco local (offline):** Isar ou Sqflite
- **Sincronização:** Fila de operações + resolução por `updatedAt`

Cada estomaterapeuta (usuário) possui seu próprio escopo de dados e ACL (`ownerId`, `acl.roles`). A estrutura hierárquica segue o modelo:

```
users/{userId}
 └── patients/{patientId}
      └── wounds/{woundId}
           ├── assessments/{assessmentId}
           └── media/{mediaId}
appointments/{appointmentId}
transfers/{transferId}
```

---

## 2. Estruturas de Dados (Firestore)

### 2.1 users/{userId}
Perfil do estomaterapeuta.
```json
{
  "displayName": "string",
  "email": "string",
  "photoURL": "string|null",
  "crmCofen": "string|null",
  "specialty": "string|default:'Estomaterapia'",
  "timezone": "string|default:'America/Sao_Paulo'",
  "ownerId": "string",  // UID do próprio usuário
  "acl": { "roles": { "{userId}": "owner" } },
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### 2.2 patients/{patientId}
Cadastro de paciente vinculado ao estomaterapeuta.
```json
{
  "ownerId": "string",
  "fullName": "string",
  "identifier": "string|null",
  "gender": "enum(male,female,other,unknown)",
  "birthDate": "string(YYYY-MM-DD)|null",
  "ageYears": "number|null",
  "weightKg": "number|null",
  "nutrition": "enum(good,poor)|null",
  "mobility": "enum(good,low)|null",
  "smoker": { "isSmoker": "bool", "cigsPerDay": "number|null" },
  "alcoholUnitsPerWeek": "number|null",
  "comorbidities": "string|null",
  "medications": "string|null",
  "contact": { "phone": "string|null", "email": "string|null" },
  "address": { "city": "string|null", "state": "string|null" },
  "acl": { "roles": { "{userId}": "owner|editor|viewer" } },
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "deletedAt": "timestamp|null"
}
```

### 2.3 wounds/{woundId}
Feridas do paciente.
```json
{
  "ownerId": "string",
  "patientId": "string",
  "type": "enum(ulcera_venosa,lpp,queimadura,cirurgica,outros)",
  "onsetDuration": { "value": "number", "unit": "enum(days,weeks,months)" },
  "location": { "bodyMapZone": "string", "x": "number", "y": "number" },
  "sizeMm": { "length": "number", "width": "number", "depth": "number" },
  "painLevel": "number(0..10)",
  "previousTreatments": "string|null",
  "status": "enum(na,melhorando,estagnada,piorando)",
  "biofilmSuspect": "bool|default:false",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "deletedAt": "timestamp|null"
}
```

### 2.4 assessments/{assessmentId}
Avaliações clínicas por ferida.
```json
{
  "ownerId": "string",
  "patientId": "string",
  "woundId": "string",
  "date": "string(YYYY-MM-DD)",
  "woundBed": {
    "tissuePct": { "granulation": "number", "epithelial": "number", "slough": "number", "necrotic": "number" },
    "exudate": { "level": "enum(dry,low,medium,high)", "type": "enum(clear,cloudy,purulent,pink_red,thick,thin)", "accumulation": "bool" },
    "infection": { "hasInfection": "bool", "signs": ["enum(pain,erythema,warmth,oedema,malodour,friable_granulation,abscess,cellulitis,pyrexia)"] }
  },
  "woundEdge": { "maceration": "bool", "dehydration": "bool", "undermining": "bool", "epibole": "bool" },
  "periwoundSkin": { "maceration": "bool", "excoriation": "bool", "xerosis": "bool", "hyperkeratosis": "bool", "callus": "bool", "eczema": "bool" },
  "sizeMm": { "length": "number", "width": "number", "depth": "number" },
  "painLevel": "number(0..10)",
  "managementGoals": ["enum(remove_nonviable,manage_exudate,manage_bacterial_load,rehydrate_bed,protect_gran_epith,protect_periwound)"],
  "treatmentChoice": { "dressingType": "string", "brand": "string|null", "rationale": "string" },
  "woundStatus": "enum(primeira_avaliacao,piorando,estagnada,melhorando,na)",
  "nextReview": { "date": "string(YYYY-MM-DD)", "mainGoal": "string" },
  "computed": { "areaMm2": "number", "volumeMm3": "number", "evolutionPct": "number", "statusSuggestion": "enum(piorando,estagnada,melhorando)" },
  "attachmentsCount": "number",
  "notes": "string|null",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "deletedAt": "timestamp|null"
}
```

### 2.5 media/{mediaId}
Metadados de arquivos de imagem/vídeo.
```json
{
  "ownerId": "string",
  "patientId": "string",
  "woundId": "string",
  "assessmentId": "string|null",
  "type": "enum(image,video)",
  "storagePath": "string",
  "width": "number|null",
  "height": "number|null",
  "takenAt": "string|null",
  "exif": { "device": "string|null", "flash": "bool|null" },
  "thumbnails": { "512": "string|null", "1024": "string|null" },
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### 2.6 appointments/{appointmentId}
Agendamentos e lembretes clínicos.
```json
{
  "ownerId": "string",
  "patientId": "string",
  "woundId": "string|null",
  "assessmentId": "string|null",
  "start": "string(ISO8601)",
  "end": "string(ISO8601)",
  "location": "string|null",
  "source": "enum(in_app,google,outlook)",
  "status": "enum(scheduled,done,canceled)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### 2.7 transfers/{transferId}
Controle de transferência e compartilhamento de pacientes.
```json
{
  "patientId": "string",
  "fromUserId": "string",
  "toUserId": "string",
  "mode": "enum(transfer,share)",
  "role": "enum(viewer,editor,owner)",
  "status": "enum(pending,accepted,rejected,canceled)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "justification": "string|null"
}
```

---

## 3. Banco Local (Isar/Sqflite)
Entidades equivalentes a Firestore com `remoteId` e `syncState`.
- **PatientLocal**: espelha `patients`
- **WoundLocal**: espelha `wounds`
- **AssessmentLocal**: espelha `assessments`
- **MediaLocal**: controla upload pendente
- **AppointmentLocal**: agenda offline

Cada registro contém `createdAt`, `updatedAt`, `deletedAt` e um campo de controle `syncState` (`pending|synced|error`).

---

## 4. Cloud Functions
- **onAssessmentCreate** → Calcula área/volume/evolução, detecta biofilme, agenda reavaliação.
- **onStorageFinalize** → Gera thumbnails e atualiza `attachmentsCount`.
- **scheduleReviewReminder** → Dispara lembretes diários de reavaliação.
- **onTransferRequested** → Controla ACL e notificações de compartilhamento.

---

## 5. Regras de Segurança (Firestore/Storage)
- Acesso restrito por `ownerId` e `acl.roles`.
- `painLevel ∈ [0..10]` e `nextReview.date > hoje` validados no app/Function.
- Soft delete via `deletedAt`.
- Storage acessível apenas pelo `uid` dono do path `users/{uid}`.

---

## 6. Índices Firestore
Consultas principais:
- Histórico de avaliações → `collectionGroup: assessments`, ordenado por `date DESC`.
- Monitoramento de feridas → `collectionGroup: wounds`, filtro por `status`.
- Agenda → `collection: appointments`, ordenado por `start`.

---

## 7. Enumerações e Catálogos
| Enum | Valores | Regra |
|------|----------|-------|
| gender | male, female, other, unknown | RN-P03 |
| woundStatus | primeira_avaliacao, piorando, estagnada, melhorando, na | RF09 |
| exudateLevel | dry, low, medium, high | RF04 |
| woundType | ulcera_venosa, lpp, queimadura, cirurgica, outros | RF03 |
| managementGoals | remove_nonviable, manage_exudate, manage_bacterial_load, rehydrate_bed, protect_gran_epith, protect_periwound | RF07 |

---

## 8. Boas Práticas de Implementação
- Usar **UUID v4** para todos os IDs locais/offline.
- Garantir `FieldValue.serverTimestamp()` para `createdAt/updatedAt`.
- Controlar upload resiliente de mídia.
- Implementar observadores Firestore com `withConverter()`.
- Garantir que Copilot e outros assistentes usem este documento como **fonte de schema**.

---

**Última revisão:** Outubro/2025  
**Responsável:** Mateus Carlos Oliveira da Silva  
**Fonte:** DRN_Cicatriza.md e requisitos_avaliacao_ferida.md

