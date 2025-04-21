# Fluxo Completo da Aplicação Cicatriza

## Introdução

Este documento descreve o fluxo completo da aplicação Cicatriza, detalhando a interação do usuário com o sistema, desde o login até o registro e acompanhamento de feridas. O fluxo é baseado na metodologia do Triângulo de Avaliação de Feridas e foi projetado para atender às necessidades dos profissionais de saúde responsáveis pelo acompanhamento de lesões em pacientes.

## Visão Geral do Fluxo

```
+----------------+     +----------------+     +----------------+
|                |     |                |     |                |
|     Login      +---->+  Lista de      +---->+  Detalhes do   |
|                |     |  Pacientes     |     |  Paciente      |
|                |     |                |     |                |
+----------------+     +-------+--------+     +-------+--------+
                               |                      |
                               v                      v
                       +-------+--------+     +-------+--------+
                       |                |     |                |
                       |  Cadastro de   |     |  Cadastro de   |
                       |  Paciente      |     |  Ferida        |
                       |                |     |                |
                       +-------+--------+     +-------+--------+
                                                      |
                                                      v
                                              +-------+--------+
                                              |                |
                                              |  Avaliação     |
                                              |  da Ferida     |
                                              |                |
                                              +-------+--------+
                                                      |
                                                      v
                                              +-------+--------+
                                              |                |
                                              |  Tratamento    |
                                              |  e Metas       |
                                              |                |
                                              +----------------+
```

## Detalhamento do Fluxo

### 1. Login e Autenticação

**Tela de Login**
- O usuário acessa a aplicação e é apresentado à tela de login
- Opções de autenticação:
  - Login com conta Google
- Após autenticação bem-sucedida, o usuário é redirecionado para a lista de pacientes

**Implementação Técnica:**
- Utiliza Firebase Authentication para autenticação com Google
- Armazena dados do usuário no Firestore
- Implementa verificação de perfil profissional

### 2. Lista de Pacientes

**Tela Principal**
- Exibe lista de pacientes em formato de cards
- Cada card mostra:
  - Nome do paciente
  - Tratamento atual
  - Data da próxima visita (se houver)
  - Botão para acessar detalhes do paciente
- No final da lista, há um botão para cadastrar novo paciente
- Barra de pesquisa para filtrar pacientes
- Menu de navegação com acesso a configurações e logout

**Implementação Técnica:**
- Consulta coleção "Patients" no Firestore filtrada pelo ID do usuário logado
- Implementa paginação para carregar pacientes em lotes
- Utiliza componente PatientCard para exibir informações resumidas

### 3. Cadastro de Paciente

**Formulário de Cadastro**
- Campos para informações pessoais:
  - Nome completo
  - CPF (para identificação)
  - Data de nascimento
  - Gênero
  - Endereço completo
  - Telefone e e-mail
- Campos para informações médicas:
  - Estado nutricional
  - Mobilidade
  - Tabagismo (sim/não, quantidade)
  - Consumo de álcool
  - Comorbidades
  - Medicações
  - Alergias
- Campo para informações de contexto social
- Botões de ação:
  - "Salvar Paciente" (retorna para lista de pacientes)
  - "Cadastrar Feridas" (salva paciente e avança para cadastro de feridas)

**Implementação Técnica:**
- Utiliza React Hook Form para gerenciamento do formulário
- Implementa validação de campos com Yup
- Salva dados na coleção "Patients" no Firestore
- Integra com Google Agenda para gerenciamento de visitas

### 4. Detalhes do Paciente

**Tela de Detalhes**
- Exibe informações completas do paciente
- Mostra histórico de atendimentos organizados por data
- Lista de feridas cadastradas para o paciente
- Botões de ação:
  - "Editar Paciente"
  - "Cadastrar Nova Ferida"
  - "Agendar Visita"
- Opção para visualizar prescrições anteriores

**Implementação Técnica:**
- Consulta documento específico na coleção "Patients"
- Consulta coleção "Wounds" filtrada pelo ID do paciente
- Consulta coleção "Appointments" para exibir agendamentos
- Implementa integração com Google Agenda para visualização de compromissos

### 5. Cadastro de Ferida

**Seleção de Localização**
- Exibe componente SVG da silhueta humana
- Permite rotação entre visão frontal e posterior
- Usuário seleciona a área do corpo onde está localizada a ferida
- Após seleção, exibe formulário de informações básicas da ferida

**Formulário de Informações Básicas**
- Campos para informações da ferida:
  - Tipo de ferida
  - Duração
  - Tratamentos anteriores
  - Tamanho (comprimento, largura, profundidade)
  - Nível de dor (escala de 0 a 10)
- Botão "Continuar para Avaliação"

**Implementação Técnica:**
- Utiliza componente HumanFigureSvg para seleção de área
- Armazena coordenadas e identificador da área selecionada
- Salva dados básicos na coleção "Wounds" no Firestore
- Cria relacionamento com o paciente através do campo patientId

### 6. Avaliação da Ferida

**Fluxo de Avaliação**
- Implementa o Triângulo de Avaliação de Feridas com três formulários sequenciais:

**6.1. Avaliação do Leito da Ferida**
- Campos para tipo de tecido (percentuais):
  - Granulação
  - Necrótico
  - Esfacelo
  - Epitelização
- Campos para exsudato:
  - Tipo (fino/aquoso, espesso, claro, turvo, rosa/vermelho, purulento)
  - Nível (seco, baixo, médio, alto)
  - Acúmulo de exsudato (sim/não)
- Campos para infecção:
  - Sinais de infecção local (lista de opções)
  - Sinais de infecção disseminada/sistêmica (lista de opções)
  - Suspeita de biofilme (sim/não)
- Botão "Salvar e Continuar"

**6.2. Avaliação da Borda da Ferida**
- Campos para condições da borda:
  - Maceração (sim/não)
  - Desidratação (sim/não)
  - Descolamento (sim/não, posição, extensão)
  - Epíbole/borda enrolada (sim/não)
- Botão "Salvar e Continuar"

**6.3. Avaliação da Pele Perilesão**
- Campos para condições da pele perilesão:
  - Maceração (sim/não, extensão)
  - Escoriação (sim/não, extensão)
  - Pele seca/xerose (sim/não, extensão)
  - Hiperqueratose (sim/não, extensão)
  - Calo (sim/não, extensão)
  - Eczema (sim/não, extensão)
- Botão "Salvar e Continuar para Tratamento"

**Funcionalidade de Fotografias**
- Em cada etapa da avaliação, permite adicionar fotografias
- Botão para capturar foto com a câmera do dispositivo
- Botão para selecionar foto da galeria
- Exibe miniaturas das fotos adicionadas
- Opção para remover fotos

**Implementação Técnica:**
- Utiliza componentes WoundBedAssessmentForm, WoundEdgeAssessmentForm e PeriWoundSkinAssessmentForm
- Implementa navegação entre formulários mantendo estado
- Salva dados na coleção "WoundAssessments" no Firestore
- Utiliza Firebase Storage para armazenamento de fotografias
- Integra com Google Drive para backup de imagens

### 7. Tratamento e Metas

**Status da Ferida**
- Opções para classificar o estado atual da ferida:
  - Primeira avaliação
  - Piora
  - Estagnada
  - Melhorando

**Gerenciamento de Metas**
- Campos para metas de tratamento baseados na avaliação:
  - Metas para o leito da ferida (lista de opções)
  - Metas para a borda da ferida (lista de opções)
  - Metas para a pele perilesão (lista de opções)
- Campo para metas adicionais (texto livre)

**Plano de Tratamento**
- Campos para registro do tratamento:
  - Tipo de cobertura/nome
  - Tratamento detalhado
  - Razão da escolha da cobertura
- Sugestões de tratamento baseadas nas metas selecionadas

**Plano de Reavaliação**
- Campo para data da próxima visita
- Campo para objetivo principal da próxima avaliação
- Integração com Google Agenda para agendamento

**Prescrições**
- Botão para criar prescrições
- Opções para impressão ou envio digital
- Histórico de prescrições anteriores

**Implementação Técnica:**
- Salva dados na coleção "Treatments" no Firestore
- Implementa lógica para sugestão de tratamentos baseados na avaliação
- Integra com Google Agenda para agendamento de reavaliações
- Utiliza API de impressão para geração de prescrições
- Implementa compartilhamento de documentos via e-mail ou mensagem

### 8. Histórico e Acompanhamento

**Visualização de Histórico**
- Exibe histórico de avaliações e tratamentos por data
- Permite comparação entre avaliações
- Gráficos de evolução da ferida
- Galeria de fotografias com linha do tempo

**Relatórios**
- Geração de relatórios de acompanhamento
- Opções para exportação em PDF
- Compartilhamento com outros profissionais

**Implementação Técnica:**
- Consulta coleções "WoundAssessments" e "Treatments" filtradas por woundId
- Implementa visualizações gráficas com biblioteca de gráficos
- Utiliza Firebase Storage para acesso às fotografias
- Integra com Google Drive para armazenamento de relatórios

## Integrações

### Firebase/Firestore
- Autenticação de usuários
- Armazenamento de dados de pacientes, feridas, avaliações e tratamentos
- Regras de segurança para proteção de dados

### Firebase Storage
- Armazenamento de fotografias das feridas
- Organização de imagens por paciente/ferida/data

### Google Agenda
- Agendamento de visitas e reavaliações
- Notificações de compromissos
- Sincronização com agenda do profissional

### Google Drive
- Backup de fotografias
- Armazenamento de relatórios e prescrições
- Compartilhamento de documentos

## Considerações de Usabilidade

### Navegação
- Barra de navegação inferior para acesso rápido às principais funcionalidades
- Botões de voltar em todas as telas
- Breadcrumbs para indicar localização no fluxo

### Feedback Visual
- Indicadores de progresso durante o fluxo de avaliação
- Mensagens de confirmação após ações importantes
- Alertas para campos obrigatórios não preenchidos

### Modo Offline
- Armazenamento local de dados para uso sem conexão
- Sincronização automática quando conexão for restabelecida
- Indicador de status de sincronização

## Considerações de Segurança

### Proteção de Dados
- Criptografia de dados sensíveis
- Autenticação de dois fatores (opcional)
- Timeout de sessão por inatividade

### Conformidade
- Aderência às regulamentações de proteção de dados de saúde
- Registros de auditoria para acesso a informações sensíveis
- Termos de uso e política de privacidade

## Conclusão

O fluxo da aplicação Cicatriza foi projetado para oferecer uma experiência intuitiva e eficiente para profissionais de saúde no acompanhamento de lesões em pacientes. A implementação da metodologia do Triângulo de Avaliação de Feridas garante uma abordagem completa e padronizada para avaliação e tratamento, contribuindo para melhores resultados clínicos.

A arquitetura modular e as integrações com serviços do Google permitem flexibilidade e escalabilidade, possibilitando a evolução contínua da aplicação para atender às necessidades dos usuários e incorporar avanços nas práticas de tratamento de feridas.
