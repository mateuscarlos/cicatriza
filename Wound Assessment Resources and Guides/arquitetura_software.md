# Arquitetura do Software - Aplicativo Cicatriza

## Visão Geral da Arquitetura

O Cicatriza é um aplicativo móvel desenvolvido em React Native utilizando o Expo, com uma arquitetura baseada em componentes e integração com serviços do Google (Firebase, Google Drive e Google Agenda). A arquitetura foi projetada para ser modular, escalável e de fácil manutenção, permitindo o desenvolvimento ágil e a adição de novas funcionalidades no futuro.

## Diagrama de Arquitetura

```
+------------------------------------------+
|                                          |
|             Aplicativo Cicatriza         |
|                                          |
+------------------------------------------+
                    |
        +-----------+-----------+
        |                       |
+-------v-------+      +--------v--------+
|               |      |                 |
|  Frontend     |      |  Backend        |
|  (React Native|      |  (Firebase)     |
|   + Expo)     |      |                 |
|               |      |                 |
+-------+-------+      +--------+--------+
        |                       |
        |                       |
+-------v-------+      +--------v--------+
|               |      |                 |
| UI Components |      | Cloud Services  |
| (UI Kitten)   |      | - Firestore     |
|               |      | - Authentication|
|               |      | - Storage       |
+-------+-------+      +--------+--------+
        |                       |
        |                       |
+-------v-------+      +--------v--------+
|               |      |                 |
| State         |      | External APIs   |
| Management    |      | - Google Drive  |
| (Context API) |      | - Google Agenda |
|               |      |                 |
+---------------+      +-----------------+
```

## Camadas da Arquitetura

### 1. Camada de Apresentação (Frontend)

A camada de apresentação é responsável pela interface do usuário e interação com o usuário. Utiliza React Native com Expo para desenvolvimento multiplataforma e UI Kitten para componentes de interface.

#### Tecnologias:
- **React Native**: Framework para desenvolvimento de aplicativos móveis multiplataforma
- **Expo**: Plataforma para desenvolvimento e distribuição de aplicativos React Native
- **Expo Router**: Sistema de navegação baseado em arquivos para aplicativos Expo
- **UI Kitten**: Biblioteca de componentes UI para React Native

#### Componentes Principais:
- **Telas (Screens)**: Componentes de alto nível que representam as diferentes telas do aplicativo
- **Componentes de UI**: Elementos reutilizáveis da interface do usuário
- **Navegação**: Gerenciamento de rotas e navegação entre telas
- **Formulários**: Componentes para entrada e validação de dados
- **SVG Interativo**: Componente da silhueta humana para seleção de áreas do corpo

### 2. Camada de Gerenciamento de Estado

Responsável por gerenciar o estado da aplicação, incluindo dados de usuário, pacientes e feridas.

#### Tecnologias:
- **Context API**: API nativa do React para gerenciamento de estado
- **Hooks**: Funcionalidades do React para gerenciamento de estado e ciclo de vida

#### Componentes Principais:
- **Contextos**: Provedores de estado para diferentes domínios da aplicação
- **Hooks Personalizados**: Funções para acesso e manipulação de estado
- **Serviços**: Funções para operações de negócio e comunicação com APIs

### 3. Camada de Serviços (Backend)

Responsável pela comunicação com serviços externos, armazenamento de dados e autenticação.

#### Tecnologias:
- **Firebase**: Plataforma de desenvolvimento de aplicativos
  - **Firestore**: Banco de dados NoSQL para armazenamento de dados
  - **Authentication**: Serviço de autenticação de usuários
  - **Storage**: Armazenamento de arquivos (imagens)
- **Google Drive API**: API para armazenamento e gerenciamento de arquivos
- **Google Calendar API**: API para gerenciamento de agendamentos

#### Componentes Principais:
- **Serviços de Autenticação**: Gerenciamento de login e autenticação de usuários
- **Serviços de Dados**: Operações CRUD para pacientes, feridas e tratamentos
- **Serviços de Armazenamento**: Gerenciamento de imagens e documentos
- **Serviços de Agenda**: Gerenciamento de agendamentos e notificações

## Modelo de Dados

### Coleções no Firestore

#### 1. Users (Usuários)
```json
{
  "uid": "string",
  "email": "string",
  "displayName": "string",
  "photoURL": "string",
  "profession": "string",
  "specialization": "string",
  "createdAt": "timestamp",
  "lastLogin": "timestamp"
}
```

#### 2. Patients (Pacientes)
```json
{
  "id": "string",
  "userId": "string",
  "name": "string",
  "cpf": "string",
  "birthDate": "timestamp",
  "gender": "string",
  "address": {
    "street": "string",
    "number": "string",
    "complement": "string",
    "neighborhood": "string",
    "city": "string",
    "state": "string",
    "zipCode": "string"
  },
  "phone": "string",
  "email": "string",
  "nutrition": "string",
  "mobility": "string",
  "smoking": "boolean",
  "smokingAmount": "number",
  "alcohol": "number",
  "comorbidities": ["string"],
  "medications": ["string"],
  "allergies": ["string"],
  "socialContext": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "nextVisit": "timestamp"
}
```

#### 3. Wounds (Feridas)
```json
{
  "id": "string",
  "patientId": "string",
  "userId": "string",
  "woundType": "string",
  "location": {
    "bodyPart": "string",
    "side": "string",
    "coordinates": {
      "x": "number",
      "y": "number"
    }
  },
  "duration": "string",
  "previousTreatments": "string",
  "size": {
    "length": "number",
    "width": "number",
    "depth": "number"
  },
  "painLevel": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### 4. WoundAssessments (Avaliações de Feridas)
```json
{
  "id": "string",
  "woundId": "string",
  "userId": "string",
  "date": "timestamp",
  "woundBed": {
    "tissueType": {
      "granulation": "number",
      "necrotic": "number",
      "slough": "number",
      "epithelialization": "number"
    },
    "exudate": {
      "type": "string",
      "level": "string",
      "accumulation": "boolean"
    },
    "infection": {
      "local": ["string"],
      "systemic": ["string"],
      "biofilm": "boolean"
    }
  },
  "woundEdge": {
    "maceration": "boolean",
    "dehydration": "boolean",
    "undermining": {
      "present": "boolean",
      "position": "string",
      "extension": "number"
    },
    "epibole": "boolean"
  },
  "periWoundSkin": {
    "maceration": {
      "present": "boolean",
      "extension": "number"
    },
    "excoriation": {
      "present": "boolean",
      "extension": "number"
    },
    "drySkin": {
      "present": "boolean",
      "extension": "number"
    },
    "hyperkeratosis": {
      "present": "boolean",
      "extension": "number"
    },
    "callus": {
      "present": "boolean",
      "extension": "number"
    },
    "eczema": {
      "present": "boolean",
      "extension": "number"
    }
  },
  "photos": ["string"],
  "status": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### 5. Treatments (Tratamentos)
```json
{
  "id": "string",
  "assessmentId": "string",
  "userId": "string",
  "woundStatus": "string",
  "managementGoals": {
    "woundBed": ["string"],
    "woundEdge": ["string"],
    "periWoundSkin": ["string"]
  },
  "treatmentPlan": {
    "dressing": "string",
    "treatment": "string",
    "reason": "string"
  },
  "reassessmentPlan": {
    "nextVisitDate": "timestamp",
    "mainGoal": "string"
  },
  "prescriptions": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### 6. Appointments (Agendamentos)
```json
{
  "id": "string",
  "patientId": "string",
  "userId": "string",
  "date": "timestamp",
  "duration": "number",
  "type": "string",
  "notes": "string",
  "googleEventId": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Estrutura de Diretórios

```
cicatriza/
├── app/                      # Diretório principal do Expo Router
│   ├── index.js              # Tela inicial (lista de pacientes)
│   ├── login.js              # Tela de login
│   ├── patient/              # Rotas relacionadas a pacientes
│   │   ├── index.js          # Lista de pacientes
│   │   ├── [id].js           # Detalhes do paciente
│   │   ├── new.js            # Cadastro de novo paciente
│   │   └── edit.js           # Edição de paciente
│   ├── wound/                # Rotas relacionadas a feridas
│   │   ├── [id].js           # Detalhes da ferida
│   │   ├── new.js            # Cadastro de nova ferida
│   │   ├── assessment.js     # Avaliação de ferida
│   │   └── treatment.js      # Tratamento e metas
│   └── _layout.js            # Layout comum para todas as telas
├── components/               # Componentes reutilizáveis
│   ├── common/               # Componentes comuns
│   │   ├── Button.js
│   │   ├── Card.js
│   │   ├── Input.js
│   │   └── ...
│   ├── patient/              # Componentes relacionados a pacientes
│   │   ├── PatientCard.js
│   │   ├── PatientForm.js
│   │   └── ...
│   ├── wound/                # Componentes relacionados a feridas
│   │   ├── HumanFigure.js    # Componente SVG da silhueta humana
│   │   ├── WoundBedForm.js
│   │   ├── WoundEdgeForm.js
│   │   ├── PeriWoundSkinForm.js
│   │   └── ...
│   └── treatment/            # Componentes relacionados a tratamentos
│       ├── GoalsForm.js
│       ├── TreatmentForm.js
│       └── ...
├── contexts/                 # Contextos para gerenciamento de estado
│   ├── AuthContext.js
│   ├── PatientContext.js
│   ├── WoundContext.js
│   └── ...
├── hooks/                    # Hooks personalizados
│   ├── useAuth.js
│   ├── usePatients.js
│   ├── useWounds.js
│   └── ...
├── services/                 # Serviços para comunicação com APIs
│   ├── firebase.js           # Configuração do Firebase
│   ├── auth.js               # Serviços de autenticação
│   ├── patient.js            # Serviços relacionados a pacientes
│   ├── wound.js              # Serviços relacionados a feridas
│   ├── treatment.js          # Serviços relacionados a tratamentos
│   ├── googleDrive.js        # Serviços do Google Drive
│   └── googleCalendar.js     # Serviços do Google Calendar
├── utils/                    # Funções utilitárias
│   ├── validation.js         # Validação de formulários
│   ├── formatters.js         # Formatação de dados
│   ├── constants.js          # Constantes da aplicação
│   └── ...
├── assets/                   # Recursos estáticos
│   ├── images/               # Imagens
│   ├── icons/                # Ícones
│   └── ...
├── app.json                  # Configuração do Expo
├── babel.config.js           # Configuração do Babel
├── package.json              # Dependências do projeto
└── README.md                 # Documentação do projeto
```

## Tecnologias Utilizadas

### Frontend
- **React Native**: [https://reactnative.dev/](https://reactnative.dev/)
  - Framework JavaScript para desenvolvimento de aplicativos móveis nativos para Android e iOS
- **Expo**: [https://expo.dev/](https://expo.dev/)
  - Plataforma para desenvolvimento e distribuição de aplicativos React Native
- **Expo Router**: [https://docs.expo.dev/router/introduction/](https://docs.expo.dev/router/introduction/)
  - Sistema de navegação baseado em arquivos para aplicativos Expo
- **UI Kitten**: [https://akveo.github.io/react-native-ui-kitten/](https://akveo.github.io/react-native-ui-kitten/)
  - Biblioteca de componentes UI para React Native
- **React Native SVG**: [https://github.com/react-native-svg/react-native-svg](https://github.com/react-native-svg/react-native-svg)
  - Biblioteca para trabalhar com gráficos SVG em React Native
- **React Hook Form**: [https://react-hook-form.com/](https://react-hook-form.com/)
  - Biblioteca para gerenciamento de formulários em React
- **Yup**: [https://github.com/jquense/yup](https://github.com/jquense/yup)
  - Biblioteca para validação de esquemas
- **Moment.js**: [https://momentjs.com/](https://momentjs.com/)
  - Biblioteca para manipulação de datas

### Backend e Serviços
- **Firebase**: [https://firebase.google.com/](https://firebase.google.com/)
  - Plataforma de desenvolvimento de aplicativos
- **Firestore**: [https://firebase.google.com/docs/firestore](https://firebase.google.com/docs/firestore)
  - Banco de dados NoSQL para armazenamento de dados
- **Firebase Authentication**: [https://firebase.google.com/docs/auth](https://firebase.google.com/docs/auth)
  - Serviço de autenticação de usuários
- **Firebase Storage**: [https://firebase.google.com/docs/storage](https://firebase.google.com/docs/storage)
  - Armazenamento de arquivos (imagens)
- **Google Drive API**: [https://developers.google.com/drive/api](https://developers.google.com/drive/api)
  - API para armazenamento e gerenciamento de arquivos
- **Google Calendar API**: [https://developers.google.com/calendar](https://developers.google.com/calendar)
  - API para gerenciamento de agendamentos

### Ferramentas de Desenvolvimento
- **TypeScript**: [https://www.typescriptlang.org/](https://www.typescriptlang.org/)
  - Superset tipado de JavaScript
- **ESLint**: [https://eslint.org/](https://eslint.org/)
  - Ferramenta de análise de código para identificar problemas
- **Prettier**: [https://prettier.io/](https://prettier.io/)
  - Formatador de código
- **Jest**: [https://jestjs.io/](https://jestjs.io/)
  - Framework de testes para JavaScript
- **React Native Testing Library**: [https://callstack.github.io/react-native-testing-library/](https://callstack.github.io/react-native-testing-library/)
  - Biblioteca de testes para React Native

## Padrões de Design e Arquitetura

### Padrões de Design
- **Component-Based Architecture**: Arquitetura baseada em componentes reutilizáveis
- **Container/Presentational Pattern**: Separação entre componentes de lógica e apresentação
- **Context API Pattern**: Gerenciamento de estado global usando Context API
- **Custom Hooks Pattern**: Encapsulamento de lógica reutilizável em hooks personalizados
- **Service Layer Pattern**: Encapsulamento de lógica de negócios e comunicação com APIs

### Padrões de Arquitetura
- **Flux Architecture**: Fluxo unidirecional de dados
- **Repository Pattern**: Abstração da camada de acesso a dados
- **Dependency Injection**: Injeção de dependências para facilitar testes e manutenção
- **Singleton Pattern**: Instância única para serviços globais

## Considerações de Segurança

- **Autenticação**: Implementação de autenticação segura usando Firebase Authentication
- **Autorização**: Controle de acesso baseado em regras do Firestore
- **Criptografia**: Armazenamento seguro de dados sensíveis
- **Validação de Entrada**: Validação rigorosa de todas as entradas do usuário
- **Proteção de Dados**: Conformidade com regulamentações de proteção de dados de saúde

## Estratégia de Testes

- **Testes Unitários**: Testes de componentes e funções isoladas
- **Testes de Integração**: Testes de interação entre componentes
- **Testes de UI**: Testes de interface do usuário
- **Testes de Regressão**: Garantia de que novas funcionalidades não quebrem funcionalidades existentes
- **Testes de Usabilidade**: Avaliação da experiência do usuário

## Considerações de Escalabilidade

- **Modularidade**: Arquitetura modular para facilitar a adição de novas funcionalidades
- **Lazy Loading**: Carregamento sob demanda de componentes e recursos
- **Otimização de Desempenho**: Estratégias para garantir desempenho em dispositivos de baixo desempenho
- **Offline First**: Suporte a operações offline com sincronização posterior
- **Caching**: Estratégias de cache para reduzir requisições ao servidor

## Conclusão

A arquitetura proposta para o aplicativo Cicatriza foi projetada para atender aos requisitos funcionais e não funcionais identificados, com foco em modularidade, escalabilidade e manutenibilidade. A escolha de tecnologias como React Native, Expo, UI Kitten e Firebase permite o desenvolvimento ágil e a entrega de um produto de alta qualidade para profissionais de saúde responsáveis pelo acompanhamento de lesões em pacientes.
