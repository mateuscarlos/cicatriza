# CICATRIZA - Plano de Aplicação

## 1. Visão Geral

Aplicativo móvel **CICATRIZA** para estomaterapeutas e especialistas em tratamentos de lesão. Objetivos:

- Facilitar registro de atendimentos e evolução de lesões
- Acompanhar pacientes e agendar visitas/consultas
- Exportar prescrições e enviar documentos
- Monitorar status de cada lesão em tempo real

## 2. Objetivos Principais

- **Eficiência:** fluxo rápido de cadastro e consulta de registros  
- **Segurança:** dados sensíveis armazenados com regras de acesso bem definidas  
- **Usabilidade:** interface intuitiva, responsiva e acessível  
- **Escalabilidade:** arquitetura modulada que permita novos módulos no futuro  

## 3. Público-Alvo

- Estomaterapeutas  
- Especialistas em tratamentos de lesão (enfermagem, fisioterapia, médicos)  
- Clínicas e consultórios que ofereçam atendimento domiciliar ou ambulatorial  

## 4. Arquitetura de Alto Nível

```plaintext
[Mobile App] ↔ [Firebase Auth/Firestore/Storage] ↔ [Cloud Functions]
```

## 5. Tecnologias Propostas

| Camada           | Tecnologia                                    |
|------------------|-----------------------------------------------|
| App              | React Native + Expo                           |
| UI / Estilo      | Tamagui (design tokens), Reanimated (animações) |
| Navegação        | React Navigation v6 (Stacks, Tabs)            |
| Autenticação     | Firebase Auth (Email/Password, OAuth Google/Microsoft) |
| Banco de Dados   | Cloud Firestore (NoSQL, offline-first)        |
| Armazenamento    | Firebase Storage (documentos, imagens)        |
| Lógicas/Functions| Cloud Functions (Node.js)                     |
| Notificações     | Firebase Cloud Messaging                      |
| E-mail           | SendGrid via Cloud Functions                  |
| Analytics        | Firebase Analytics, Crashlytics, Performance  |
| Testes           | Jest, React Native Testing Library, Detox     |
| CI/CD            | GitHub Actions, Expo Application Services (EAS) |

## 6. Estrutura de Pastas (Exemplo)

```
/src
  /assets        # Imagens, ícones, fontes
  /components    # Componentes reutilizáveis (Átomos, Moléculas)
  /contexts      # React Contexts (Auth, Theme)
  /hooks         # Custom hooks (useAuth, useFirestore)
  /navigation    # Stacks e Tabs
  /screens       # Telas (Login, Dashboard, Pacientes, Lesões)
  /services      # Integrações Firebase, APIs externas
  /utils         # Funções utilitárias, validações
  /styles        # Tema, tokens, constantes de estilo
  App.tsx
```

## 7. Autenticação e Autorização

- **Fluxos:** cadastro, login, recuperação de senha  
- **OAuth:** Google e Microsoft via Firebase Auth  
- **Permissões:** claims customizadas para roles (estomaterapeuta, admin)  
- **Segurança:** validações no cliente e regras de segurança Firestore  

## 8. Modelagem de Dados (Firestore)

```js
// Exemplo de collections e documentos
/users/{userId}
  - name, email, role, createdAt
/patients/{patientId}
  - name, birthDate, contact, createdBy, createdAt
/visits/{visitId}
  - patientId, date, notes, createdBy
/prescriptions/{prescId}
  - visitId, content (PDF link), createdAt
/documents/{docId}
  - patientId, type, fileUrl, uploadedAt
/lesions/{lesionId}
  - patientId, status, images[], createdAt, updatedAt

```

- Use referências (ids) para relacionar dados  
- Indexar campos de busca frequentes (patientId, date)  

## 9. Navegação

- **Stack Navigator:** Fluxo de Login → App  
- **Bottom Tabs:** Dashboard, Pacientes, Agendamentos, Perfil  
- **Nested Stacks:** dentro de Pacientes (Detalhes, Histórico, Lesões)  

## 10. Design System e Componentes

- **Tamagui:** criar tokens (cores, tipografia, espaçamentos)  
- **Componentes Atômicos:** Button, Input, Card, Modal  
- **Storybook:** documentação e testes visuais  

## 11. Gerenciamento de Estado

- **AuthContext:** estado de autenticação e perfil do usuário  
- **React Query (ou Zustand):** cache de dados Firestore, mutations  
- **Contextualização local:** dados de formulários, tema  

## 12. Integração com Firebase

- **Firestore:** persistência offline, sincronização automática  
- **Security Rules:** regras por role e propriedade do documento  
- **Cloud Functions:** triggers onCreate (notificações, e‑mails), REST APIs  

## 13. Funcionalidades Principais

1. **Cadastro/Login** (e-mail/senha e OAuth)  
2. **Listagem de Pacientes** (busca e filtros)  
3. **Registro de Atendimento/Visita** (formulário, anexos)  
4. **Agendamento de Consultas** (data/hora, notificações)  
5. **Exportação de Prescrição (PDF)**  
6. **Envio de Documentos ao Paciente** (via storage + link)  
7. **Monitoramento de Lesões** (upload de imagens, status timeline)  

## 14. Notificações e Comunicações

- **Push Notifications:** FCM (lembrar de consulta, novo comentário)  
- **E‑mail:** agendamento, confirmação via SendGrid  
- **In‑App Alerts:** banners, modais  

## 15. Performance e Monitoramento

- **Firebase Performance**: métricas de carregamento  
- **Crashlytics**: relatórios de falhas  
- **Logs estruturados**: console e Stackdriver  

## 16. Testes e Qualidade

- **Linting:** ESLint + Prettier com regras compartilhadas  
- **Unit Tests:** Jest para utilitários e hooks  
- **Component Tests:** React Native Testing Library  
- **E2E:** Detox (Android/iOS simulados)  

## 17. CI/CD

- **GitHub Actions:** lint → test → build  
- **EAS CLI:** publicar internal/external builds  
- **Beta Testing:** TestFlight (iOS), Google Play Internal  

## 18. Melhores Práticas de Arquitetura

- **SOLID** no frontend: separar preocupações  
- **Clean Architecture:** camadas claras (UI, domain, data)  
- **Reutilização:** componentes e hooks genéricos  
- **Acessibilidade:** labels, roles, contraste  
- **Documentação:** README, Contribuição, ROADMAP  

## 19. Roadmap Inicial (MVP)

1. Autenticação + Perfil  
2. CRUD Pacientes + Listagem  
3. Registro de Visitas  
4. Agendamento + Notificações  
5. Exportação de Prescrição  

## 20. Referências

- React Native: <https://reactnative.dev>  
- Expo Docs: <https://docs.expo.dev>  
- Firebase Docs: <https://firebase.google.com/docs>  
- Tamagui: <https://tamagui.dev>  
- React Navigation: <https://reactnavigation.org>  
- Jest & Testing Library  
- Detox E2E  
