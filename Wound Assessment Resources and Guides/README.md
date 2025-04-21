# Documentação do Aplicativo Cicatriza

## Índice

1. [Requisitos do Aplicativo](#requisitos-do-aplicativo)
2. [Arquitetura do Software](#arquitetura-do-software)
3. [Roadmap de Desenvolvimento](#roadmap-de-desenvolvimento)
4. [Componente SVG da Silhueta Humana](#componente-svg-da-silhueta-humana)
5. [Formulários de Avaliação de Feridas](#formulários-de-avaliação-de-feridas)
6. [Fluxo Completo da Aplicação](#fluxo-completo-da-aplicação)
7. [Conclusão](#conclusão)

## Introdução

Este documento apresenta a documentação completa do aplicativo Cicatriza, uma solução desenvolvida para profissionais de saúde responsáveis pelo acompanhamento de lesões em pacientes. O aplicativo utiliza a metodologia do Triângulo de Avaliação de Feridas para uma abordagem holística no tratamento de feridas.

A documentação inclui os requisitos do aplicativo, arquitetura do software, roadmap de desenvolvimento, componente SVG da silhueta humana, formulários de avaliação de feridas e o fluxo completo da aplicação.

## Requisitos do Aplicativo

Os requisitos detalhados do aplicativo Cicatriza estão disponíveis no arquivo [requisitos_aplicativo.md](requisitos_aplicativo.md). Este documento inclui:

- Visão geral do aplicativo
- Requisitos funcionais
- Requisitos não funcionais
- Fluxo principal do aplicativo
- Integrações externas

## Arquitetura do Software

A arquitetura do software está documentada no arquivo [arquitetura_software.md](arquitetura_software.md). Este documento inclui:

- Visão geral da arquitetura
- Diagrama de arquitetura
- Camadas da arquitetura
- Modelo de dados
- Estrutura de diretórios
- Tecnologias utilizadas
- Padrões de design e arquitetura
- Considerações de segurança e escalabilidade

## Roadmap de Desenvolvimento

O roadmap de desenvolvimento está disponível no arquivo [roadmap_desenvolvimento.md](roadmap_desenvolvimento.md). Este documento inclui:

- Visão geral do roadmap
- Fases de desenvolvimento
- Cronograma resumido
- Dependências e riscos
- Estratégia de implementação

## Componente SVG da Silhueta Humana

O componente SVG da silhueta humana foi implementado no arquivo [human_figure_svg.js](human_figure_svg.js). Este componente:

- Exibe uma silhueta humana interativa
- Permite rotação entre visão frontal e posterior
- Permite seleção de áreas específicas do corpo
- Notifica quando uma área é selecionada

### Funcionalidades do Componente SVG

- **Rotação da Silhueta**: Alterna entre visão frontal e posterior
- **Seleção de Áreas**: Permite selecionar áreas específicas do corpo
- **Feedback Visual**: Destaca a área selecionada
- **Integração com Formulários**: Fornece dados para os formulários de avaliação

## Formulários de Avaliação de Feridas

Os formulários de avaliação de feridas foram implementados seguindo a metodologia do Triângulo de Avaliação de Feridas:

1. **Avaliação do Leito da Ferida** ([wound_bed_assessment_form.js](wound_bed_assessment_form.js))
   - Tipo de tecido (granulação, necrótico, esfacelo, epitelização)
   - Exsudato (tipo, nível, acúmulo)
   - Infecção (local, sistêmica, biofilme)

2. **Avaliação da Borda da Ferida** ([wound_edge_assessment_form.js](wound_edge_assessment_form.js))
   - Maceração
   - Desidratação
   - Descolamento (posição, extensão)
   - Epíbole (borda enrolada)

3. **Avaliação da Pele Perilesão** ([peri_wound_skin_assessment_form.js](peri_wound_skin_assessment_form.js))
   - Maceração
   - Escoriação
   - Pele seca (xerose)
   - Hiperqueratose
   - Calo
   - Eczema

### Características dos Formulários

- **Validação de Dados**: Verifica a consistência dos dados inseridos
- **Feedback Visual**: Fornece feedback imediato ao usuário
- **Ajuda Contextual**: Inclui descrições e dicas para cada campo
- **Navegação Intuitiva**: Fluxo lógico entre os formulários

## Fluxo Completo da Aplicação

O fluxo completo da aplicação está documentado no arquivo [fluxo_aplicacao.md](fluxo_aplicacao.md). Este documento inclui:

- Visão geral do fluxo
- Detalhamento de cada etapa do fluxo
- Integrações com serviços externos
- Considerações de usabilidade e segurança

### Principais Etapas do Fluxo

1. **Login e Autenticação**
2. **Lista de Pacientes**
3. **Cadastro de Paciente**
4. **Detalhes do Paciente**
5. **Cadastro de Ferida**
6. **Avaliação da Ferida**
   - Avaliação do Leito da Ferida
   - Avaliação da Borda da Ferida
   - Avaliação da Pele Perilesão
7. **Tratamento e Metas**
8. **Histórico e Acompanhamento**

## Tecnologias Utilizadas

O aplicativo Cicatriza utiliza as seguintes tecnologias:

### Frontend
- **React Native**: Framework para desenvolvimento de aplicativos móveis
- **Expo**: Plataforma para desenvolvimento e distribuição de aplicativos React Native
- **Expo Router**: Sistema de navegação baseado em arquivos
- **UI Kitten**: Biblioteca de componentes UI para React Native
- **React Native SVG**: Biblioteca para trabalhar com gráficos SVG

### Backend e Serviços
- **Firebase**: Plataforma de desenvolvimento de aplicativos
  - **Firestore**: Banco de dados NoSQL
  - **Authentication**: Serviço de autenticação
  - **Storage**: Armazenamento de arquivos
- **Google Drive API**: API para armazenamento e gerenciamento de arquivos
- **Google Calendar API**: API para gerenciamento de agendamentos

## Conclusão

A documentação apresentada fornece uma visão completa do aplicativo Cicatriza, desde seus requisitos até sua implementação técnica. O aplicativo foi projetado para atender às necessidades dos profissionais de saúde no acompanhamento de lesões em pacientes, utilizando a metodologia do Triângulo de Avaliação de Feridas para uma abordagem holística no tratamento.

A arquitetura modular e as integrações com serviços do Google permitem flexibilidade e escalabilidade, possibilitando a evolução contínua da aplicação para atender às necessidades dos usuários e incorporar avanços nas práticas de tratamento de feridas.

O componente SVG da silhueta humana e os formulários de avaliação de feridas foram implementados seguindo as melhores práticas de desenvolvimento e usabilidade, garantindo uma experiência intuitiva e eficiente para os usuários.

O roadmap de desenvolvimento fornece um plano claro para a implementação do aplicativo, com fases bem definidas e estratégias para mitigar riscos potenciais.

Com esta documentação, a equipe de desenvolvimento tem todas as informações necessárias para implementar o aplicativo Cicatriza, garantindo que ele atenda aos requisitos e expectativas dos usuários.
