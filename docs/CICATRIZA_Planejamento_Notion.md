# 🩹 CICATRIZA - Planejamento da Aplicação

## 📌 Visão Geral

Aplicativo mobile para **estomaterapeutas e especialistas em tratamentos de lesão**.  
Objetivos:

- Registro de atendimentos e evolução de lesões
- Acompanhamento de pacientes e agendamento de visitas
- Exportação de prescrições
- Envio de documentos aos pacientes
- Monitoramento do status das lesões

## 🎯 Objetivos Principais

- ✅ Eficiência no fluxo de registros
- ✅ Segurança com controle de acessos
- ✅ Interface intuitiva e responsiva
- ✅ Arquitetura modular e escalável

## 👥 Público-Alvo

- Estomaterapeutas
- Profissionais de saúde (enfermagem, fisioterapia, médicos)
- Clínicas e consultórios de cuidado ambulatorial ou domiciliar

## 🏗️ Arquitetura de Alto Nível

```
[Mobile App] ↔ [Firebase Auth/Firestore/Storage] ↔ [Cloud Functions]
```

## 🧠 Tecnologias

| Camada           | Ferramenta                                 |
|------------------|---------------------------------------------|
| App              | React Native + Expo                         |
| Estilo           | Tamagui + Reanimated                        |
| Navegação        | React Navigation                            |
| Autenticação     | Firebase Auth (Email, Google, Microsoft)    |
| Banco de Dados   | Cloud Firestore                             |
| Arquivos         | Firebase Storage                            |
| Lógicas          | Cloud Functions                             |
| Notificações     | Firebase Cloud Messaging                    |
| E-mail           | SendGrid via Cloud Functions                |
| Análises         | Firebase Analytics / Crashlytics            |
| Testes           | Jest, Testing Library, Detox                |
| CI/CD            | GitHub Actions + Expo EAS                   |

## 📁 Estrutura de Pastas

```plaintext
/src
  /assets
  /components
  /contexts
  /hooks
  /navigation
  /screens
  /services
  /utils
  /styles
  App.tsx
```

## 🔐 Autenticação & Segurança

- Fluxo de login, cadastro e recuperação de senha
- Login com Google e Microsoft
- Claims customizadas para controle de acesso
- Regras de segurança no Firestore

## 📊 Modelagem de Dados (Firestore)

- `users` → info do usuário
- `patients` → dados do paciente
- `visits` → atendimentos
- `prescriptions` → receitas
- `documents` → arquivos enviados
- `lesions` → evolução de lesões

## 🧭 Navegação

- Stack inicial: Login > App
- Tabs: Dashboard | Pacientes | Agendamentos | Perfil
- Stacks internas para navegação detalhada

## 🎨 Design System (Tamagui)

- Tokens: cores, espaçamentos, tipografia
- Componentes: Button, Input, Modal, Card
- Documentação visual com Storybook

## 🧠 Gerenciamento de Estado

- AuthContext
- Zustand ou React Query
- Armazenamento local leve

## 🔁 Integrações Firebase

- Regras por role
- Cloud Functions para notificações e envio de e-mail
- Firestore com sync offline

## ⚙️ Funcionalidades do MVP

- [ ] Cadastro/Login (e-mail e OAuth)
- [ ] Listagem de pacientes
- [ ] Registro de visitas com anexos
- [ ] Agendamento com notificações
- [ ] Exportação de prescrições (PDF)
- [ ] Envio de documentos
- [ ] Monitoramento de lesões com fotos e status

## 🔔 Notificações

- [ ] Push (FCM) para lembretes de consulta
- [ ] E-mails via SendGrid (agendamentos, confirmações)
- [ ] Alertas in-app com modais e banners

## 🚀 Performance e Monitoramento

- [ ] Firebase Performance
- [ ] Crashlytics
- [ ] Logs por Cloud Logging

## 🧪 Testes

- [ ] ESLint + Prettier
- [ ] Unit (Jest)
- [ ] Componentes (Testing Library)
- [ ] E2E (Detox)

## 🚧 CI/CD

- [ ] Pipeline GitHub Actions
- [ ] Build automático via EAS CLI
- [ ] Deploy em beta no TestFlight / Google Play Internal

## 🧱 Arquitetura e Boas Práticas

- Clean Architecture (UI → domain → data)
- SOLID no frontend
- Componentização e reutilização
- Acessibilidade
- Documentação em README + Roadmap

## 📆 Roadmap MVP

1. [ ] Autenticação e perfil
2. [ ] CRUD de pacientes
3. [ ] Registro de visitas
4. [ ] Agendamento de consultas
5. [ ] Prescrição em PDF

## 📚 Referências

- [React Native](https://reactnative.dev)
- [Expo](https://docs.expo.dev)
- [Firebase](https://firebase.google.com/docs)
- [Tamagui](https://tamagui.dev)
- [React Navigation](https://reactnavigation.org)
- [Detox](https://wix.github.io/Detox/)
