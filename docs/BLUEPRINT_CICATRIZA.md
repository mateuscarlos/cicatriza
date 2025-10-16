# 📘 Blueprint do Projeto – CICATRIZA

## 🩹 Visão Geral

O **Cicatriza** é um aplicativo mobile (Android e iOS) voltado para **estomaterapeutas**.  
Sua missão é **digitalizar e padronizar o processo de avaliação, acompanhamento e gestão de feridas**,  
facilitando o registro, a comunicação entre profissionais e a geração de relatórios clínicos.

---

## 🎯 Objetivos do Projeto

- Digitalizar o **formulário de avaliação de feridas** (PDF anexo) em formato interativo.
- Permitir o **cadastro individual** do estomaterapeuta com acesso exclusivo aos seus pacientes.
- Oferecer **cadastro de pacientes**, **agendamento**, **acompanhamento de evolução** e **relatórios**.
- Possibilitar a **transferência de pacientes** entre profissionais de forma segura.
- Integrar o app com **agenda e e-mail** (Google / Microsoft).
- Funcionar **offline-first**, sincronizando com a nuvem (Firebase/Firestore).

---

## 👥 Personas

### Estomaterapeuta
- Cadastra-se individualmente.
- Registra e acompanha pacientes.
- Agenda atendimentos e gera relatórios.
- Pode transferir pacientes para outro estomaterapeuta.

### Estomaterapeuta Receptor
- Recebe pacientes transferidos.
- Visualiza histórico completo.
- Dá continuidade ao tratamento.

### Paciente (acesso indireto)
- Tem dados registrados mediante consentimento (LGPD).
- Recebe relatórios e prescrições por e-mail.

---

## 🧩 Requisitos Funcionais

### 1. Autenticação & Perfil
- Cadastro com e-mail/senha ou OAuth (Google/Microsoft).
- Perfil com assinatura e dados de contato.
- Edição e exclusão de conta.

### 2. Pacientes
- CRUD completo (nome, idade, gênero, peso, contatos).
- Registro de consentimento (LGPD).
- Histórico de avaliações.

### 3. Avaliação de Lesão (Baseada no PDF)
- Cabeçalho: data, paciente, identificação.
- Anamnese: idade, peso, mobilidade, nutrição, hábitos, comorbidades, medicações.
- Descrição: tipo, duração, tamanho, profundidade, dor, localização.
- Leito da ferida: porcentagens de granulação, epitelização, necrose, esfacelo; tipo e nível de exsudato.
- Sinais de infecção: locais e sistêmicos.
- Borda da ferida: maceração, desidratação, descolamento, epíbole.
- Pele perilesão: maceração, escoriação, xerose, hiperqueratose, calo, eczema.
- Status: piora, estagnada, melhorando (não aplicável na primeira avaliação).
- Metas de gerenciamento: remoção de tecido inviável, manejo de exsudato, controle bacteriano, hidratação, proteção de tecidos.
- Tratamento e cobertura: tipo, nome comercial, motivo da escolha.
- Plano de reavaliação: data e objetivo da próxima visita.
- Captura de imagens e comparação com fotos anteriores.

### 4. Agenda & Notificações
- Agendamento de visitas e lembretes.
- Integração com Google Calendar / Microsoft 365.
- Notificações push e lembretes locais.

### 5. Relatórios
- Relatórios por paciente (evolução temporal).
- Relatórios por estomaterapeuta (indicadores de produtividade).
- Geração em PDF com logo e assinatura digital.

### 6. Transferência de Pacientes
- Fluxo de convite/aceite.
- Confirmação de consentimento.
- Auditoria de transferência.

### 7. Mídia & Anexos
- Upload de fotos das lesões (com posição e marcação corporal).
- Comparativo visual de evolução.
- Armazenamento em Firebase Storage.

### 8. Operação Offline
- Coleta de dados e imagens sem conexão.
- Sincronização automática ao reconectar.

---

## ⚙️ Requisitos Não Funcionais

| Categoria | Requisito |
|------------|------------|
| **Segurança** | Criptografia de dados em trânsito e repouso; autenticação segura (Firebase Auth). |
| **LGPD** | Consentimento do paciente, direito à exclusão e exportação de dados. |
| **Usabilidade** | Interface responsiva, intuitiva e com acessibilidade. |
| **Desempenho** | Sincronização < 5 segundos; imagens otimizadas. |
| **Disponibilidade** | Alta confiabilidade e redundância no Firebase. |
| **Observabilidade** | Crashlytics, monitoramento e logs estruturados. |

---

## 🧠 Escopo do MVP

### Fase 1 (6–8 semanas)
1. Autenticação e perfil do estomaterapeuta.  
2. CRUD de pacientes.  
3. Avaliação de feridas (base PDF).  
4. Upload de fotos.  
5. Agenda interna com notificações.  
6. Relatório básico em PDF.  
7. Transferência de paciente (versão simples).

### Fase 2
- Integração completa com Google/Microsoft Calendar e e-mail.
- Dashboards e relatórios analíticos.
- Catálogo de coberturas/prescrições.
- Mapa corporal interativo (SVG/3D).
- Sincronização offline avançada (Isar/Sqflite).

---

## 🗂️ Modelo de Dados (Firestore)

### Estrutura
```
/estomaterapeutas/{uid}
  nome
  email
  assinatura
  ...
  /pacientes/{pacienteId}
    nome
    genero
    idade
    consentimento
    ...
    /avaliacoes/{avaliacaoId}
      data
      tipoFerida
      duracao
      tamanho
      profundidade
      dor
      localizacao
      ...
      /midias/{midiaId}
        url
        posicao
        hash
```

### Entidades Principais
- **Estomaterapeuta**
  - id, nome, email, assinatura, integrações.
- **Paciente**
  - id, nome, idade, peso, gênero, consentimentos.
- **Avaliacao**
  - id, pacienteId, data, tipo, duração, tamanho, dor, status.
- **LeitoFerida**
  - %granulacao, %epitelizacao, %necrose, %esfacelo, exsudatoTipo, exsudatoNivel.
- **BordaFerida**
  - maceracao, desidratacao, descolamento, epibole.
- **PelePerilesao**
  - maceracao, escoriacao, xerose, hiperqueratose, calo, eczema.
- **StatusPlano**
  - statusFerida, metasGerenciamento, tratamento, cobertura, proximaVisita.
- **Agenda**
  - titulo, pacienteId, dataHora, local, lembretes.
- **Midia**
  - avaliacaoId, url, posicao, metadata.
- **Transferencia**
  - pacienteId, deId, paraId, status, logs.

---

## 🏗️ Arquitetura da Aplicação

### Camadas
- **Apresentação**: Flutter (Material 3, tema claro/escuro).
- **Negócio**: Clean Architecture + BLoC Pattern.
- **Dados**: Repository Pattern + Firestore + Isar (cache offline).
- **Backend Serverless**: Firebase Cloud Functions.

### Infraestrutura
- **Firebase Auth** – autenticação.
- **Firestore** – banco de dados.
- **Storage** – mídias e relatórios.
- **Cloud Functions** – relatórios PDF e integrações.
- **FCM** – notificações push.
- **Crashlytics** – monitoramento de falhas.

---

## 🧰 Tecnologias

| Camada | Tecnologia | Função |
|--------|-------------|--------|
| **Mobile** | Flutter / Dart | Aplicativo Android e iOS |
| **UI** | Material 3 | Design responsivo e acessível |
| **Estado** | BLoC | Gerenciamento de estados |
| **Offline** | Isar / Sqflite | Cache e modo offline |
| **Backend** | Firebase / Firestore | Auth, DB, Storage, Functions |
| **Integrações** | Google API / Microsoft Graph | Agenda, e-mail |
| **Relatórios** | Cloud Functions + PDFKit | Geração de relatórios em PDF |
| **DevOps** | GitHub Actions / Fastlane | Build, CI/CD, distribuição |
| **Monitoramento** | Crashlytics / Sentry | Logs e erros em produção |

---

## 🔒 Segurança e LGPD

- Autenticação individual com Firebase Auth.
- Criptografia TLS e armazenamento seguro no Firestore.
- Controle de acesso por UID.
- Consentimento do paciente obrigatório.
- Logs e auditoria de transferências.
- Exportação e exclusão de dados sob solicitação.

---

## 🔁 Fluxos Principais

### Fluxo 1 – Nova Avaliação
1. Selecionar paciente.  
2. Preencher campos do formulário (com validações).  
3. Anexar fotos.  
4. Registrar metas e plano de reavaliação.  
5. Gerar relatório PDF.

### Fluxo 2 – Reavaliação
1. Carregar última avaliação.  
2. Comparar medidas e fotos.  
3. Atualizar status e metas.  
4. Registrar nova evolução.  

### Fluxo 3 – Transferência de Paciente
1. Estomaterapeuta A inicia transferência.  
2. Estomaterapeuta B aceita convite.  
3. Paciente e histórico são compartilhados.  

---

## 📅 Roadmap de Entregas

| Marco | Entrega | Resultado Esperado |
|-------|----------|--------------------|
| **M0** | Design System, Login e Navegação | App base |
| **M1** | Módulo Pacientes + Avaliação | Fluxo completo de cadastro |
| **M2** | Upload de fotos + Relatórios PDF | Avaliação visual completa |
| **M3** | Agenda + Push + Transferência | Operação funcional |
| **M4** | Integrações Google/Microsoft + Dashboards | App completo e escalável |

---

## 🧾 Próximos Passos

1. Criar **backlog (CSV)** com épicos e histórias.  
2. Modelar **estrutura do Firestore** conforme blueprint.  
3. Gerar **wireframes (Figma)** com base no formulário.  
4. Definir **regras de segurança do Firestore**.  
5. Iniciar desenvolvimento do **Módulo de Autenticação e Pacientes**.

---

**Autor:** Mateus Carlos Oliveira da Silva  
**Versão:** 1.0  
**Data:** 16/10/2025  
**Projeto:** CICATRIZA  
