
# 📊 M3 — Profundidade Clínica e Histórico (Passo a passo executável)

> Objetivo do M3: implementar **campos clínicos avançados**, **cálculos automáticos** (área, volume, evolução%), **histórico com gráficos e comparativo de fotos**, além de **alertas clínicos** (piora/suspeita de biofilme) conforme DRN.  
> Duração sugerida: **2 semanas** | Dependência: **M2 concluído**

---

## 0) Escopo e Critérios de Saída (DoD M3)

**Escopo**
1) Campos avançados na **Avaliação**: Leito (percentuais), Exsudato (tipo/nível), Infecção (checklist), Borda, Pele Perilesão.  
2) Cálculos: **área (C×L)**, **volume (C×L×P)**, **evolução%** (com baseline), **status sugerido** (melhora/estável/piora).  
3) Histórico completo com **gráficos** (área/volume/dor), **comparador de fotos**, e **timeline**.  
4) **Alertas**: notificar piora significativa; **sinalizar biofilme** por heurística do DRN.

**DoD**
- Formulário avançado validado (percentuais somam 100%).  
- Gráficos renderizando sem travar; comparador de fotos funcional.  
- Cálculos corretos com testes; status sugerido exibido.  
- Alertas gerados quando critérios atendidos.  
- Testes unit/widget/integr. **verdes**; cobertura ≥ 80% em validadores/cálculos.

---

## 1) Modelo de Dados (extensões)

### 1.1 Firestore — `assessments`
Campos adicionais (exemplos):
```
{
  // já existentes: date, pain, lengthCm, widthCm, depthCm, notes, ...
  "bed": { "granulationPct": 0, "epithelizationPct": 0, "sloughPct": 0, "necrosisPct": 0 },
  "exudate": { "type": "serous|purulent|sanguineous|...", "amount": "none|low|moderate|high", "color": "straw|green|..." },
  "infection": { "odor": true, "erythema": true, "heat": false, "edema": false, "painIncrease": false, "biofilmSigns": true },
  "edge": { "maceration": true, "epibole": false, "undermining": false },
  "perilesion": { "dermatitis": false, "induration": false, "maceration": false, "cellulitis": false },
  // derivados
  "areaCm2": 0.0,
  "volumeCm3": 0.0,
  "evolutionPct": 0.0,
  "statusSuggested": "improved|stable|worsened",
  "flags": { "suspectedBiofilm": false, "worsening": false }
}
```

### 1.2 Índices Firestore
- `assessments`: `(date DESC)` (já no M1)  
- Novo: `(woundId ASC, date DESC)` para histórico eficiente.  
- Opcional: `(statusSuggested ASC, date DESC)` para filtros.

### 1.3 Isar (offline)
Adicionar campos equivalentes + `baselineAreaCm2` em cache por ferida para cálculos locais.

---

## 2) Validações e Regras

### 2.1 Validações de formulário (app)
- Percentuais do **leito** somam **exatamente 100%**.  
- `exudate.amount` requerido se `exudate.type != 'none'`.  
- `infection` checklist pode disparar `flags.suspectedBiofilm`.  
- Campos numéricos positivos; data ≤ hoje; dor 0..10.

### 2.2 Firestore Rules (trecho de reforço)
```
match /users/{uid}/patients/{pid}/wounds/{wid}/assessments/{aid} {
  allow create, update: if request.auth.uid == uid
    && request.resource.data.bed.granulationPct + request.resource.data.bed.epithelizationPct +
       request.resource.data.bed.sloughPct + request.resource.data.bed.necrosisPct == 100
    && request.resource.data.lengthCm > 0 && request.resource.data.widthCm > 0 && request.resource.data.depthCm >= 0
    && request.resource.data.pain >= 0 && request.resource.data.pain <= 10;
}
```

> Observação: para evitar rejeições por arredondamento, usar inteiros 0–100 (sem float).

---

## 3) Cálculos e Heurísticas

### 3.1 Fórmulas
- `areaCm2 = lengthCm * widthCm`  
- `volumeCm3 = lengthCm * widthCm * depthCm`  
- `evolutionPct = ((baselineArea - currentArea) / baselineArea) * 100` (baseline = **primeira avaliação** da ferida com área válida).

### 3.2 Status sugerido
```
if evolutionPct >= 20% em 2 semanas → "improved"
if -10% <= evolutionPct < 20% → "stable"
if evolutionPct < -10% → "worsened"
```
> Ajuste fino pode ser parametrizado no DRN/toggles.

### 3.3 Heurística de biofilme (exemplo simples)
- `infection.biofilmSigns == true` **ou** (odor + dor crescente + exsudato alto) → `flags.suspectedBiofilm = true`.

### 3.4 Pseudocódigo (app/Function)
```ts
function calculateDerived(a, baselineArea) {
  const area = a.lengthCm * a.widthCm;
  const volume = area * a.depthCm;
  const evo = baselineArea > 0 ? ((baselineArea - area) / baselineArea) * 100 : 0;
  let status = 'stable';
  if (evo >= 20) status = 'improved';
  else if (evo < -10) status = 'worsened';

  const suspectedBiofilm = a.infection?.biofilmSigns === true
    || ((a.infection?.odor === true) && (a.exudate?.amount === 'high') && (a.painIncrease === true));

  return { area, volume, evo, status, suspectedBiofilm };
}
```

---

## 4) Cloud Functions (opcional para consistência)

### 4.1 Trigger `onAssessmentWrite`
- Ao **criar/atualizar** avaliação:  
  1) Buscar baseline da ferida;  
  2) Recalcular derivados;  
  3) Persistir `areaCm2`, `volumeCm3`, `evolutionPct`, `statusSuggested`, `flags`.

### 4.2 Trigger `onWoundFirstAssessment`
- Ao detectar **primeira avaliação válida**, gravar `baselineAreaCm2` no documento da ferida para agilizar cálculos futuros.

> Em dispositivos offline, os mesmos cálculos existem no app e serão conciliados pelo último write (LWW).

---

## 5) App Flutter — UI/UX

### 5.1 Formulário avançado (Avaliação)
- **Seções**: Medidas | Leito (4 sliders % com soma) | Exsudato | Infecção | Borda | Pele perilesão | Notas.  
- **Componente** `FieldPercentQuadruple` com **soma dinâmica** (badge verde=100%, vermelho≠100%).  
- **Infecção** com checklist e tooltip (educacional).

### 5.2 Histórico (Timeline)
- Linha do tempo por avaliação (data, dor, mini‑cards das fotos, badges de status).  
- Ações rápidas: abrir **PDF**, **comparar fotos**, **ver gráfico**.

### 5.3 Gráficos
- **Área (cm²)** por data (linha)  
- **Volume (cm³)** por data (linha)  
- **Dor (0–10)** por data (linha/step)  
- Indicador de baseline e **marcação** quando status muda.

> Implementar renderização assíncrona e paginação para não travar a UI.

### 5.4 Comparador de fotos
- Duas imagens lado a lado (ou deslize com máscara).  
- Exibir data/medidas; zoom/pan.

---

## 6) BLoCs e Serviços

- `AssessmentAdvancedBloc`: estado do formulário avançado + validações.  
- `HistoryBloc`: carrega avaliações paginadas e calcula séries.  
- `ChartsService`: fornece datasets/markers prontos.  
- `AlertService`: avalia regras e dispara banners/notificações internas.

---

## 7) Performance e Sincronização

- Carregamento incremental do histórico (paginado por data).  
- Cache local de séries calculadas (Isar) com **invalidação por updatedAt**.  
- Evitar recomputar gráficos em cada rebuild (memoization).  
- Thumbnails já prontos (M1); carregar imagens sob demanda.

---

## 8) Testes

### 8.1 Unit
- Soma 100% do leito; validadores de exsudato/infecção; fórmulas de área/volume/evolução; status sugerido; heurística de biofilme.

### 8.2 Widget
- Form avançado: bloqueio de salvar quando soma ≠ 100%; tooltips; erros.  
- Timeline: paginação; render estável com muitas avaliações.

### 8.3 Integração
- Criar várias avaliações (com baseline) e verificar derivados persistidos.  
- Alterar medidas para provocar **piora** e validar alerta.  
- Consistência entre app e Function (quando online).

### 8.4 E2E (cenário)
- Paciente → ferida → 3 avaliações com medidas distintas → ver gráficos → comparar fotos → ver status sugerido mudar.

---

## 9) CI/CD

- Job de testes com **coverage ≥ 80%** para domain/data e validadores.  
- Lint sem warnings; build debug opcional.  
- Artefatos: snapshot dos gráficos (golden tests) se aplicável.

---

## 10) Checklist de Saída (DoD M3)

- 🚩 Formulário avançado entregue com validações (100% leito).  
- 📐 Cálculos corretos e persistidos (área, volume, evolução%, status).  
- 🕒 Histórico paginado + gráficos (área, volume, dor).  
- 🖼️ Comparador de fotos funcional.  
- 🔔 Alertas de piora / suspeita de biofilme sinalizados.  
- ✅ Testes unit/widget/integr. verdes; cobertura ≥ 80%.  
- 📝 Documentação `docs/README_M3.md` atualizada.

---

## 11) Riscos & Mitigações (M3)

| Risco | Impacto | Mitigação |
|---|---|---|
| Form complexo (erros do usuário) | Alto | Dividir em seções, validação incremental, feedback em tempo real |
| Recalcular séries em excesso | Médio | Cache + memoization + paginação |
| Divergência app vs. Function | Médio | Identificar campos derivados; última escrita vence; reconciliation |
| Gráficos pesados (device low-end) | Médio | Simplificar pontos, limitar período padrão, lazy rendering |
| Alertas falsos positivos | Baixo | Ajustar thresholds no DRN; feature flag |

---
