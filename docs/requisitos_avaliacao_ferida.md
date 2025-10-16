---
title: "Requisitos do Módulo de Avaliação de Feridas"
project: "Cicatriza"
version: "1.0"
author: "Stakeholders do Projeto"
date: "2025-10-16"
status: "Em desenvolvimento"
---

# 📘 Documento de Requisitos — Módulo de Avaliação de Feridas  
**Projeto:** Cicatriza  
**Stakeholder:** Especialista em Estomaterapia  
**Origem:** Formulário físico “Formulário de Avaliação da Ferida (PDF)”  
**Data:** 16/10/2025  

---

## 🧭 Sumário

- [🎯 Objetivo](#-objetivo)
- [🧩 Estrutura Geral do Formulário Digital](#-estrutura-geral-do-formulário-digital)
- [🧠 Requisitos Funcionais (RF)](#-requisitos-funcionais-rf)
- [🔐 Requisitos Não Funcionais (RNF)](#-requisitos-não-funcionais-rnf)
- [📊 Modelo de Dados (Resumo)](#-modelo-de-dados-resumo)
- [🧩 Integrações Futuras (Visão de Stakeholder)](#-integrações-futuras-visão-de-stakeholder)

---

## 🎯 Objetivo

Registrar de forma digital e padronizada a **avaliação clínica completa de feridas**, incluindo dados do paciente, características da lesão, histórico, evolução e plano terapêutico.  

O módulo permitirá:

- Registro e acompanhamento de cada ferida por paciente.  
- Comparação de avaliações sucessivas (evolução clínica).  
- Geração de relatórios exportáveis e gráficos de evolução.  
- Armazenamento seguro e compatível com práticas de enfermagem e estomaterapia.

---

## 🧩 Estrutura Geral do Formulário Digital

O formulário deve conter **quatro seções principais**, além de dados de identificação:

| Seção | Descrição |
|-------|------------|
| **Identificação do Paciente** | Dados demográficos e clínicos básicos. |
| **Descrição da Ferida** | Dados da lesão: tipo, duração, tamanho, dor, localização. |
| **Avaliação Clínica da Ferida** | Leito, borda, pele perilesão, tipo de tecido, exsudato, infecção. |
| **Metas de Gerenciamento e Tratamento** | Objetivos terapêuticos, escolha de cobertura e plano de reavaliação. |

---

## 🧠 Requisitos Funcionais (RF)

### RF01 — Cadastro da Avaliação
O sistema deve permitir criar uma **nova avaliação de ferida** associada a um paciente existente.  
**Campos obrigatórios:**
- Data  
- Nome do paciente  
- Identificação (ID interno)  
- Idade  
- Peso  
- Gênero (Masculino/Feminino)

---

### RF02 — Estado Clínico e Hábitos
**Campos:**
- Estado nutricional: `Boa / Ruim`  
- Mobilidade: `Boa / Baixa`  
- Fumante: `Sim / Não / Quantos por dia`  
- Álcool: `Unidades por semana`  
- Comorbidades (texto livre)  
- Medicações (texto livre)

---

### RF03 — Descrição da Ferida
**Campos:**
- Tipo de ferida (selecionável)  
- Duração  
- Tratamentos anteriores  
- Tamanho (comprimento, largura, profundidade em mm)  
- Localização (mapa corporal interativo)  
- Nível de dor (escala 0–10)

---

### RF04 — Avaliação do Leito da Ferida
**Campos:**
- % Granulação  
- % Epitelização  
- % Necrótico  
- % Esfacelo  
- Tipo de tecido  
- Exsudato (Seco / Baixo / Médio / Alto)  
- Infecção (Sim / Não)  
- Aspectos clínicos: Dor, Eritema, Calor local, Edema, Odor, Tecido friável, Atraso na cicatrização, etc.

---

### RF05 — Avaliação da Borda da Ferida
**Campos:**
- Maceração  
- Desidratação  
- Deslocamento  
- Epíbole (borda enrolada)  
- Observações livres

---

### RF06 — Avaliação da Pele Perilesão
**Campos:**
- Maceração  
- Escoriação  
- Xerose  
- Hiperqueratose  
- Calo  
- Eczema

---

### RF07 — Metas de Gerenciamento
**Seleção múltipla:**
- Remover tecido não viável  
- Gerenciar o exsudato  
- Gerenciar carga bacteriana  
- Reidratar o leito da ferida  
- Proteger granulação / epitelização  
- Proteger e reidratar pele perilesional  

---

### RF08 — Escolha do Tratamento
**Campos:**
- Tipo de cobertura (lista pré-cadastrada)  
- Nome comercial  
- Razão da escolha  
- Observações livres

---

### RF09 — Status da Ferida
**Opções:**
- Primeira avaliação  
- Piora  
- Estagnada  
- Melhorando  

---

### RF10 — Plano de Reavaliação
**Campos:**
- Data da próxima visita  
- Principal objetivo da próxima avaliação  

---

### RF11 — Exportação e Relatórios
- Geração de **PDF** da avaliação preenchida  
- Exportação para o histórico do paciente  
- Comparativo de **evolução gráfica** (ex.: % de granulação, epitelização, etc.)

---

## 🔐 Requisitos Não Funcionais (RNF)

| Código | Requisito | Descrição |
|--------|------------|-----------|
| **RNF01** | Armazenamento Seguro | Todos os dados serão armazenados no Firebase Firestore, com autenticação via Firebase Auth. |
| **RNF02** | Acesso Offline | O app deve permitir preenchimento offline com sincronização posterior via Firestore + Isar/Sqflite. |
| **RNF03** | Performance | O formulário deve carregar em <2s e salvar em <3s. |
| **RNF04** | Interface Responsiva | Deve adaptar-se a telas de smartphones e tablets. |
| **RNF05** | Usabilidade | Campos devem possuir máscaras e validações (números, datas, limites). |
| **RNF06** | Privacidade | Dados sensíveis vinculados apenas ao usuário autenticado. |
| **RNF07** | Exportação | O relatório PDF deve manter layout similar ao formulário original. |
| **RNF08** | Interoperabilidade | Estrutura compatível com padrões FHIR para futuras integrações. |

---

## 📊 Modelo de Dados (Resumo)

Coleções no Firestore:
```
usuarios/{uid}/pacientes/{pacienteId}/avaliacoes/{avaliacaoId}
```

### Exemplo de Documento:
```json
{
  "data": "2025-10-16",
  "paciente": {
    "nome": "João Silva",
    "idade": 65,
    "peso": 70,
    "genero": "Masculino"
  },
  "estado_clinico": {
    "nutricao": "Boa",
    "mobilidade": "Baixa",
    "fumante": false,
    "alcool": 2,
    "comorbidades": "Diabetes tipo II",
    "medicacoes": "Metformina"
  },
  "ferida": {
    "tipo": "Úlcera venosa",
    "duracao": "3 meses",
    "tratamentos_anteriores": "Pomadas tópicas",
    "tamanho": {"comprimento": 30, "largura": 25, "profundidade": 5},
    "dor": 7,
    "localizacao": "Perna direita"
  },
  "avaliacao": {
    "leito": {"granulacao": 40, "epitelizacao": 20, "esfacelo": 30, "necro": 10},
    "borda": {"maceracao": true, "desidratacao": false, "epibole": true},
    "pele": {"xerose": true, "eczemas": false}
  },
  "metas": ["Gerenciar exsudato", "Reidratar pele"],
  "tratamento": {
    "cobertura": "Hidrocolóide",
    "razao": "Controle de exsudato"
  },
  "status": "Melhorando",
  "proxima_visita": "2025-10-23",
  "objetivo_proxima": "Verificar redução da área necrótica"
}
```

---

## 🧩 Integrações Futuras (Visão de Stakeholder)

- **Agenda e notificações**: integração com calendário para reavaliações.  
- **Relatórios automáticos**: gráficos de evolução por paciente.  
- **IA assistiva**: sugestões automáticas de cobertura e tratamento.  
- **Compartilhamento seguro**: transmissão entre profissionais (handoff digital).

---

> **Status Atual:** Documento de requisitos validado com base no formulário PDF.  
> Próxima etapa: modelagem das telas (UI/UX) e definição do fluxo de navegação entre etapas do formulário.
