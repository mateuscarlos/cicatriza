
# 🩹 M1 — Módulo Clínico Básico (Passo a passo executável)

> Objetivo do M1: habilitar o **fluxo clínico básico** (Paciente → Ferida → Avaliação → Foto) com **offline‑first**, validações essenciais, upload de imagens com compressão e **thumbnails** via Cloud Function.  
> Duração sugerida: **2 semanas** | Dono: **Eng. Mobile Líder** | Dependência: **M0 concluído**

---

## 0) Escopo e Critérios de Saída (DoD do M1)

**Escopo**  
1) CRUD de **Pacientes** completo (listar, buscar, criar/editar, arquivar).  
2) **Feridas**: criação/edição (tipo, localização, duração).  
3) **Avaliações** (essenciais): data, dor (0–10), medidas C×L×P, notas.  
4) **Fotos**: captura/galeria, compressão local, upload com progresso, **thumbnail** automático.  
5) **Offline‑first**: Isar/Sqflite espelhando dados + fila transacional de sync.  
6) **Regras de validação** mínimas em app e Functions.

**DoD**  
- Fluxo completo funcionando **online e offline**, com sync resiliente.  
- Fotos com **thumbnail** e visualização na timeline.  
- Validações: `pain ∈ [0..10]`, `C,L,P > 0`, `date ≤ hoje`.  
- Regras de segurança ok; índices Firestore criados.  
- Testes: unit, widget e integração com emuladores (verde).

---

## 1) Modelo de Dados (Firestore + Isar)

### 1.1 Firestore (estrutura)
```
users/{uid}
  patients/{pid}
    (name, birthDate, archived, updatedAt, name_lowercase)
    wounds/{wid}
      (type, locationSimple, onsetDays, status, updatedAt)
      assessments/{aid}
        (date, pain, lengthCm, widthCm, depthCm, notes, updatedAt)
        media/{mid}
          (downloadUrl, storagePath, width, height, thumbUrl, createdAt)
```

### 1.2 Isar (espelho offline)
- Tabelas: `Patient`, `Wound`, `Assessment`, `Media`, `SyncOp` (fila).  
- Campos obrigatórios idênticos ao Firestore + `syncState` (pending/synced/failed) e `updatedAt`.  
- Chaves de busca local: `Patient.nameLowercase`, `updatedAt`.

### 1.3 Índices Firestore
Crie/valide os índices compostos:
- `patients`: `(name_lowercase ASC, updatedAt DESC)`
- `wounds`: `(updatedAt DESC, status ASC)`
- `assessments`: `(date DESC)`

> Dica: registre os índices em `firestore.indexes.json` e **commite**.

---

## 2) Regras e Validações

### 2.1 Regras de negócio (app/Function)
- **Dor**: inteiro de 0 a 10.  
- **Medidas**: `lengthCm`, `widthCm`, `depthCm` > 0.  
- **Data**: `date` não pode ser futura (> hoje).  
- **Notas**: sanitização básica (comprimento máx., sem HTML).

### 2.2 Firestore Rules (refino M1)
```
// adicionar validações mínimas por campos essenciais (exemplo por path)
match /users/{uid}/patients/{pid}/wounds/{wid}/assessments/{aid} {
  allow read, write: if request.auth.uid == uid
    && request.resource.data.keys().hasAll(['date','pain','lengthCm','widthCm','depthCm'])
    && (request.resource.data.pain is int && request.resource.data.pain >= 0 && request.resource.data.pain <= 10)
    && (request.resource.data.lengthCm > 0 && request.resource.data.widthCm > 0 && request.resource.data.depthCm > 0);
}
```

### 2.3 Storage Rules (refino upload fotos)
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{uid}/{allPaths=**} {
      allow write: if request.auth != null
        && request.auth.uid == uid
        && request.resource.contentType.matches('image/.*')
        && request.resource.size < 10 * 1024 * 1024; // 10MB
      allow read: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

---

## 3) Cloud Functions (thumbnails e metadados)

### 3.1 Dependências
```bash
cd cicatriza_functions
npm i sharp
```

### 3.2 `onStorageFinalize` (pseudo‑código)
```ts
export const onStorageFinalize = functions.storage.object().onFinalize(async (obj) => {
  const path = obj.name || '';
  if (!/^users\/[^/]+\/.*\.(jpg|jpeg|png)$/i.test(path)) return;
  const bucket = admin.storage().bucket(obj.bucket);
  const [file] = await bucket.file(path).download();
  const image = await sharp(file).resize(640).jpeg({ quality: 75 }).toBuffer();
  const thumbPath = path.replace(/(\.[^.]+)$/, '_thumb$1');
  await bucket.file(thumbPath).save(image, { contentType: 'image/jpeg' });

  // Atualiza doc media vinculando thumbUrl (buscar aid/mid pelo path)
  // Ex.: users/{uid}/patients/{pid}/wounds/{wid}/assessments/{aid}/media/{mid}
  // parse do path -> obter refs -> set thumbUrl
});
```

> Sugestão: manter **metadados** no Firestore (`width`, `height`, `size`) para otimizar listagem.

---

## 4) App Flutter — Fluxos e Telas

### 4.1 Telas
- **PacientesListPage**: busca local, ordenação, criar/editar, arquivar.  
- **WoundsListPage** (dentro do paciente): criar/editar ferida.  
- **AssessmentCreatePage**: data, dor (slider 0–10), C×L×P, notas.  
- **PhotoPickerSheet**: câmera/galeria, compressão, preview, progresso.

### 4.2 Componentes reutilizáveis
- `FormSection(title, children)`  
- `NumberField(min/max, suffix: 'cm')`  
- `PainSlider(0..10)`  
- `UploadTile(status: idle/uploading/success/fail, progress%)`

### 4.3 BLoCs principais
- `PatientsBloc`: load/search/create/update/archive.  
- `WoundsBloc`: load/create/update.  
- `AssessmentBloc`: create/update; validações.  
- `MediaBloc`: pick/compress/upload/retry.

### 4.4 Upload com compressão (pseudo)
```dart
final file = await pickImage();
final compressed = await FlutterImageCompress.compressWithFile(
  file.path, minWidth: 1600, minHeight: 1200, quality: 80,
);
await storageRef.putData(compressed, SettableMetadata(contentType: "image/jpeg"));
```

---

## 5) Offline‑first e Sincronização

### 5.1 Isar schemas (exemplo)
- `PatientIsar { id, remoteId, name, birthDate, archived, updatedAt, syncState }`  
- `WoundIsar { id, remoteId, patientId, type, locationSimple, onsetDays, status, updatedAt, syncState }`  
- `AssessmentIsar { id, remoteId, woundId, date, pain, lengthCm, widthCm, depthCm, notes, updatedAt, syncState }`  
- `MediaIsar { id, remoteId, assessmentId, localPath, storagePath, downloadUrl, thumbUrl, updatedAt, syncState }`  
- `SyncOp { id, entity, op(create|update|delete), payload, retryCount }`

### 5.2 Estratégia de sync
- **Fila transacional** (Isar) que processa CRUD quando online.  
- Conflitos: **last‑write‑wins** por `updatedAt`; log de diffs.  
- Retentativa exponencial com `retryCount` e backoff.  
- Operações idempotentes (garantir `remoteId`).

### 5.3 Eventos críticos
- Ao criar avaliação local → enfileirar para Firestore.  
- Ao finalizar upload → gravar `downloadUrl` e criar doc `media`.  
- Ao gerar thumbnail (Function) → atualizar `thumbUrl`.

---

## 6) Navegação e UX

- Fluxo guiado: **Paciente → Ferida → Avaliação → Foto** com breadcrumbs.  
- **Empty states** (sem pacientes/feridas/avaliações) com CTAs diretos.  
- Indicadores de **status de sync** (badge: “offline”, “sincronizando”, “erro”).  
- Acessibilidade: labels e tamanhos mínimos; suporte a dark mode.

---

## 7) Testes

### 7.1 Unit
- Validadores de avaliação (pain, medidas, data).  
- Conversores Firestore ↔ Domain ↔ Isar.

### 7.2 Widget
- Form de Avaliação: renderização, máscaras, erros, sucesso.  
- Lista de Pacientes: busca, ordenação.

### 7.3 Integração (Emuladores)
- Login → criar paciente → ferida → avaliação → upload → thumbnail.  
- Verificar regras (negativo/positivo).

### 7.4 E2E (opcional no M1)
- Happy path completo em dispositivo real.

---

## 8) CI (ampliação para M1)

- Job adicional para **integração com emuladores** (Firestore/Storage/Auth).  
- Artefato de **coverage** publicado; falhar se < 75%.  
- Lint obrigatório sem warnings.  
- (Opcional) Job de build `debug` Android/iOS.

---

## 9) Observabilidade

- Eventos Analytics: `patient_create`, `wound_create`, `assessment_create`, `photo_upload`.  
- Crashlytics: capturar exceções em upload e sync.  
- Logs de função `onStorageFinalize` (dur., tamanho, count thumbnails).

---

## 10) Checklist de Saída (DoD do M1)

- [ ] CRUD de pacientes e feridas funcionando **offline/online**.  
- [ ] Avaliação mínima criada com validações.  
- [ ] Upload de foto com compressão e **thumbnail** visível.  
- [ ] Sincronização robusta com fila e retries.  
- [ ] Índices Firestore criados e rules refinadas.  
- [ ] Testes unit/widget/integr. **verde**; cobertura ≥ 75%.  
- [ ] Documentação atualizada (`docs/README_M1.md`).

---

## 11) Riscos & Mitigações (M1)

| Risco | Impacto | Mitigação |
|---|---|---|
| Upload lento/erroso | Alto | Compressão, chunk, retry exponencial, fila |
| Conflito de dados | Médio | `updatedAt` + LWW, log de diffs |
| Storage indevido | Alto | Rules (mime/size/path), validação no app |
| Vazamento de writes | Médio | Debounce de digitação, batch writes |
| Emulador/CI instável | Médio | Scripts de bootstrap + retries em jobs |

---
