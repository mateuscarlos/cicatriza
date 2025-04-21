# Requisitos do Aplicativo Cicatriza

## Visão Geral
O Cicatriza é um aplicativo móvel desenvolvido para profissionais de saúde responsáveis pelo acompanhamento de lesões em pacientes, como feridas pós-operatórias, pé diabético e condições similares. O aplicativo visa facilitar o registro, acompanhamento e tratamento de feridas utilizando a metodologia do Triângulo de Avaliação de Feridas.

## Requisitos Funcionais

### Autenticação e Usuários
- RF01: O sistema deve permitir login de usuários (profissionais de saúde) utilizando conta Google
- RF02: O sistema deve armazenar informações de usuários no Firestore
- RF03: O sistema deve garantir que apenas profissionais de saúde autorizados tenham acesso ao aplicativo

### Gestão de Pacientes
- RF04: O sistema deve permitir cadastro de pacientes com informações pessoais (nome, CPF, endereço)
- RF05: O sistema deve permitir registro de informações médicas dos pacientes (alergias, comorbidades)
- RF06: O sistema deve permitir registro de informações de contexto social do paciente
- RF07: O sistema deve exibir lista de pacientes em formato de cards
- RF08: Cada card deve mostrar nome do paciente, tratamento atual e data da próxima visita
- RF09: O sistema deve permitir acesso aos detalhes do paciente a partir do card

### Avaliação de Feridas
- RF10: O sistema deve permitir cadastro de feridas para cada paciente
- RF11: O sistema deve fornecer uma silhueta humana interativa para seleção da localização da ferida
- RF12: A silhueta humana deve permitir rotação entre visão frontal e posterior
- RF13: O sistema deve implementar formulários de avaliação baseados no Triângulo de Avaliação de Feridas:
  - RF13.1: Formulário de avaliação do leito da ferida
  - RF13.2: Formulário de avaliação da borda da ferida
  - RF13.3: Formulário de avaliação da pele perilesão
- RF14: O sistema deve permitir adicionar fotografias às avaliações de feridas
- RF15: O sistema deve permitir registro de status da ferida (piora, estagnada, melhorando)

### Plano de Tratamento
- RF16: O sistema deve permitir registro de metas de tratamento
- RF17: O sistema deve permitir registro de plano de tratamento
- RF18: O sistema deve permitir registro de plano de reavaliação
- RF19: O sistema deve permitir criação de prescrições para o paciente
- RF20: O sistema deve permitir impressão de prescrições

### Integração com Serviços Google
- RF21: O sistema deve integrar com Google Agenda para agendamento de visitas
- RF22: O sistema deve integrar com Google Drive para armazenamento de fotografias e documentos

### Histórico e Acompanhamento
- RF23: O sistema deve organizar informações de atendimento por data
- RF24: O sistema deve exibir histórico de atendimentos em formato de cards
- RF25: O sistema deve permitir visualização de evolução do tratamento ao longo do tempo

## Requisitos Não Funcionais

### Tecnologia
- RNF01: O aplicativo deve ser desenvolvido em React Native
- RNF02: O aplicativo deve utilizar Expo Router para navegação
- RNF03: O aplicativo deve utilizar UI Kitten como biblioteca de componentes
- RNF04: O aplicativo deve utilizar Firestore como banco de dados

### Usabilidade
- RNF05: A interface deve ser intuitiva e de fácil utilização para profissionais de saúde
- RNF06: O aplicativo deve funcionar em dispositivos Android e iOS
- RNF07: O aplicativo deve ser responsivo para diferentes tamanhos de tela

### Desempenho
- RNF08: O aplicativo deve responder em tempo aceitável mesmo com conexão de internet limitada
- RNF09: O aplicativo deve permitir uso offline com sincronização posterior

### Segurança
- RNF10: O aplicativo deve garantir a confidencialidade dos dados dos pacientes
- RNF11: O aplicativo deve implementar autenticação segura
- RNF12: O aplicativo deve cumprir requisitos de proteção de dados de saúde

### Manutenibilidade
- RNF13: O código deve ser modular e bem documentado
- RNF14: O aplicativo deve permitir atualizações e expansões futuras

## Fluxo Principal do Aplicativo

1. Profissional de saúde faz login usando conta Google
2. Sistema exibe lista de pacientes em formato de cards
3. Profissional seleciona paciente existente ou cadastra novo paciente
4. Para novo paciente:
   - Preenche formulário de cadastro com dados pessoais e médicos
   - Salva paciente ou prossegue para cadastro de feridas
5. Para cadastro de feridas:
   - Seleciona localização na silhueta humana interativa
   - Preenche formulários de avaliação (leito, borda, pele perilesão)
   - Adiciona fotografias (opcional)
   - Salva informações da ferida
6. Prossegue para tela de tratamentos e metas:
   - Registra status da ferida
   - Define metas de tratamento
   - Estabelece plano de tratamento
   - Define plano de reavaliação
7. Opcionalmente cria prescrições para o paciente
8. Salva todas as informações e retorna à lista de pacientes

## Integrações Externas

### Firebase/Firestore
- Autenticação de usuários
- Armazenamento de dados de pacientes e avaliações

### Google Agenda
- Agendamento de visitas e reavaliações
- Notificações de compromissos

### Google Drive
- Armazenamento de fotografias das feridas
- Armazenamento de documentos relacionados ao tratamento
