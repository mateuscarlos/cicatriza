---
title: "Documento de Regras de Negócio (DRN)"
project: "Cicatriza"
version: "1.0"
author: "Stakeholders do Projeto"
date: "2025-10-16"
status: "Em desenvolvimento"
---

# 📘 Documento de Regras de Negócio (DRN)
**Projeto:** Cicatriza  
**Módulo:** Avaliação de Feridas  
**Stakeholders:** Estomaterapeutas, Equipe de Enfermagem, Equipe Técnica  
**Base:** Formulário físico “Formulário de Avaliação da Ferida (PDF)”  

---

## 🧭 Sumário

- [1. Introdução](#1-introdução)
- [2. Objetivo](#2-objetivo)
- [3. Escopo](#3-escopo)
- [4. Regras de Negócio Gerais](#4-regras-de-negócio-gerais)
- [5. Regras de Negócio Específicas](#5-regras-de-negócio-específicas)
  - [5.1 Identificação do Paciente](#51-identificação-do-paciente)
  - [5.2 Estado Clínico e Hábitos](#52-estado-clínico-e-hábitos)
  - [5.3 Descrição da Ferida](#53-descrição-da-ferida)
  - [5.4 Avaliação da Ferida](#54-avaliação-da-ferida)
  - [5.5 Metas e Tratamentos](#55-metas-e-tratamentos)
  - [5.6 Reavaliação e Evolução](#56-reavaliação-e-evolução)
- [6. Regras de Cálculo e Automação](#6-regras-de-cálculo-e-automação)
- [7. Regras de Validação de Dados](#7-regras-de-validação-de-dados)
- [8. Regras de Acesso e Segurança](#8-regras-de-acesso-e-segurança)
- [9. Regras Futuras e Extensões](#9-regras-futuras-e-extensões)

---

## 1. Introdução

O **Documento de Regras de Negócio (DRN)** define a lógica operacional e os comportamentos padronizados da aplicação **Cicatriza**, garantindo que o sistema reflita corretamente o raciocínio clínico e os fluxos adotados por estomaterapeutas durante a avaliação e acompanhamento de feridas.

---

## 2. Objetivo

Definir as **regras que orientam a execução, validação e automação** dos processos clínicos no aplicativo **Cicatriza**, garantindo padronização, rastreabilidade e coerência entre diferentes usuários e avaliações.

---

## 3. Escopo

Aplica-se aos módulos:
- **Cadastro e Avaliação de Feridas**
- **Histórico de Pacientes**
- **Relatórios e Reavaliações**
- **Sincronização e Exportação de Dados**

---

## 4. Regras de Negócio Gerais

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN01** | Cada paciente é associado a um único estomaterapeuta. | O profissional autenticado tem acesso apenas aos seus pacientes e avaliações. |
| **RN02** | Cada ferida pertence a um paciente. | Não é permitido cadastrar feridas sem vínculo a paciente. |
| **RN03** | Avaliações são versionadas. | Cada nova avaliação gera um novo documento com data e status, sem sobrescrever as anteriores. |
| **RN04** | O histórico é cronológico. | As avaliações são exibidas em ordem decrescente de data. |
| **RN05** | O status da ferida depende dos parâmetros clínicos. | Se houver aumento de área, dor ou exsudato, o status é automaticamente sugerido como “Piora”. |
| **RN06** | Campos obrigatórios devem ser preenchidos antes do envio. | O sistema só permite salvar se todos os campos essenciais estiverem completos. |
| **RN07** | Dados sensíveis são sigilosos. | Apenas o profissional autenticado pode visualizar e editar os dados do paciente. |
| **RN08** | Alterações são auditadas. | Cada alteração deve registrar data, hora e usuário responsável. |

---

## 5. Regras de Negócio Específicas

### 5.1 Identificação do Paciente

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN-P01** | O campo “Nome do Paciente” é obrigatório. | Necessário para vincular a avaliação ao histórico. |
| **RN-P02** | Idade e peso devem ser valores positivos. | Validar faixas aceitáveis: idade (0–120), peso (0–300kg). |
| **RN-P03** | Gênero define anatomia de mapa corporal. | O mapa interativo exibido varia conforme o gênero selecionado. |

---

### 5.2 Estado Clínico e Hábitos

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN-E01** | Estado nutricional e mobilidade impactam risco clínico. | Se ambos forem “Ruins”, exibir alerta de risco aumentado. |
| **RN-E02** | Fumante “Sim” exige campo “quantos por dia”. | Campo obrigatório condicionado. |
| **RN-E03** | Álcool é numérico e limitado a 40 unidades/semana. | Evita valores incorretos. |
| **RN-E04** | Comorbidades e medicações são opcionais, mas recomendadas. | Campos de texto livre sem validação obrigatória. |

---

### 5.3 Descrição da Ferida

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN-F01** | Tipo de ferida deve ser selecionado de lista padrão. | Ex: Úlcera venosa, Lesão por pressão, Queimadura, etc. |
| **RN-F02** | Duração deve ser informada em dias, semanas ou meses. | Campo com máscara de tempo. |
| **RN-F03** | Tamanho deve incluir comprimento, largura e profundidade. | Todos obrigatórios para calcular área e volume. |
| **RN-F04** | Escala de dor é de 0 a 10. | Valores acima de 10 são inválidos. |
| **RN-F05** | Localização é registrada via mapa anatômico. | Deve armazenar coordenadas X/Y do ponto clicado. |

---

### 5.4 Avaliação da Ferida

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN-A01** | Percentuais de tecidos devem somar 100%. | Soma de granulação, esfacelo, necrose e epitelização. |
| **RN-A02** | Se “Infecção = Sim”, exibir checklist de sinais clínicos. | Campos adicionais: odor, calor, edema, etc. |
| **RN-A03** | Exsudato classifica nível e tipo. | Campos obrigatórios quando “Alto” ou “Purulento”. |
| **RN-A04** | Biofilme suspeito ativa alerta. | Se houver “acúmulo de exsudato” e “odor fétido”, marcar suspeita automática. |

---

### 5.5 Metas e Tratamentos

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN-M01** | Deve haver pelo menos uma meta selecionada. | Nenhuma meta = formulário inválido. |
| **RN-M02** | Cobertura e razão são campos obrigatórios. | Descrevem o tratamento adotado. |
| **RN-M03** | O tratamento sugerido depende do tipo de exsudato. | Ex.: Exsudato alto → sugerir cobertura absorvente. |
| **RN-M04** | Alteração de tratamento deve gerar histórico. | Mantém rastreabilidade da conduta. |

---

### 5.6 Reavaliação e Evolução

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN-R01** | A data da próxima visita deve ser futura. | Não pode ser anterior à data atual. |
| **RN-R02** | O status clínico é calculado automaticamente. | Com base em evolução da área e dor. |
| **RN-R03** | O profissional pode ajustar manualmente o status sugerido. | Permite sobreposição com justificativa. |
| **RN-R04** | A evolução é exibida graficamente. | Calculada a partir das avaliações anteriores. |

---

## 6. Regras de Cálculo e Automação

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN-C01** | Área da ferida = comprimento × largura (mm²). | Usado para cálculo de evolução. |
| **RN-C02** | Volume estimado = área × profundidade. | Exibido apenas quando profundidade > 0. |
| **RN-C03** | Evolução (%) = (área anterior - área atual) / área anterior × 100. | Se negativo → “Piora”. |
| **RN-C04** | Tempo de cicatrização estimado = função da taxa de epitelização. | Calculado em background para dashboards. |

---

## 7. Regras de Validação de Dados

- Todos os campos de **identificação, tipo de ferida, dor e tamanho** são obrigatórios.  
- Campos condicionais:
  - “Fumante = Sim” → exigir “quantos por dia”.  
  - “Infecção = Sim” → exigir checklist de sintomas.  
- Nenhum campo percentual pode exceder 100%.  
- Campos de data devem seguir o formato ISO (YYYY-MM-DD).  
- Texto livre deve permitir até 500 caracteres.  

---

## 8. Regras de Acesso e Segurança

| Código | Regra | Descrição |
|--------|--------|-----------|
| **RN-S01** | Apenas o estomaterapeuta autenticado pode acessar seus pacientes. |
| **RN-S02** | Cada documento de avaliação é vinculado ao UID do usuário Firebase. |
| **RN-S03** | Dados são criptografados em trânsito (HTTPS) e em repouso (Firestore). |
| **RN-S04** | Acesso offline é permitido, mas sincronização exige login válido. |
| **RN-S05** | Nenhum dado pode ser compartilhado sem consentimento explícito. |

---

## 9. Regras Futuras e Extensões

- Integração com **modelos de IA clínica** para recomendação de tratamento.  
- Geração automática de alertas de “risco de infecção”.  
- Relatórios de desempenho do tratamento por paciente e por profissional.  
- Integração com **FHIR (HL7)** para interoperabilidade com prontuários eletrônicos.  

---

> **Status Atual:** Documento base de regras de negócio validado pelos stakeholders clínicos.  
> **Próxima Etapa:** Implementação das validações automáticas e fluxos de decisão no backend (Cloud Functions).
