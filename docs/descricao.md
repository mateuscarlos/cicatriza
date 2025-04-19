mateuscarlos: Como um engenheiro de software, escreva um documento em detalhes de cada parte que já foi feita e desenvolvida da aplicação incluindo a estrutura de pastas. Seja o mais dedtalhista possível

GitHub Copilot: # Relatório de Desenvolvimento da Aplicação CICATRIZA

Este documento detalha as partes já desenvolvidas da aplicação **CICATRIZA**, incluindo a estrutura de pastas, bibliotecas utilizadas, funcionalidades implementadas e boas práticas adotadas.

---

## 📁 Estrutura de Pastas

A estrutura de pastas segue uma organização modular e escalável, conforme descrito no planejamento:

```plaintext
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

### Detalhamento das Pastas

1. **assets**  
   Contém recursos estáticos como imagens, ícones e fontes utilizadas na aplicação.

2. **components**  
   Componentes reutilizáveis organizados em:
   - **Átomos:** Botões, inputs, ícones.
   - **Moléculas:** Cards, modais, listas.

3. **contexts**  
   Implementação de React Contexts para gerenciamento de estado global:
   - `AuthContext`: Gerencia o estado de autenticação do usuário.
   - `ThemeContext`: Gerencia o tema da aplicação.

4. **hooks**  
   Custom hooks para encapsular lógica reutilizável:
   - `useAuth`: Gerencia login, logout e informações do usuário.
   - `useFirestore`: Facilita operações no Firestore.

5. **`/navigation`**  
   Configuração de navegação utilizando React Navigation:
   - **Stacks:** Login, App.
   - **Tabs:** Dashboard, Pacientes, Agendamentos, Perfil.

6. **`/screens`**  
   Telas principais da aplicação:
   - **Login:** Fluxo de autenticação.
   - **Dashboard:** Visão geral do sistema.
   - **Pacientes:** Listagem e detalhes de pacientes.
   - **Lesões:** Registro e acompanhamento de lesões.

7. **`/services`**  
   Integrações com Firebase e APIs externas:
   - Firebase Auth, Firestore, Storage.
   - Cloud Functions para notificações e envio de e-mails.

8. **`/utils`**  
   Funções utilitárias e validações:
   - Validação de formulários.
   - Formatação de datas.

9. **`/styles`**  
   Configuração de temas e tokens de design:
   - Cores, tipografia, espaçamentos.

10. **`App.tsx`**  
    Arquivo principal que inicializa a aplicação.

---

## 📦 Bibliotecas e Frameworks

### Frameworks Principais
- **React Native** (via Expo): Base da aplicação.
- **Expo:** Ferramenta para desenvolvimento e build.

### UI & Navegação
- **Tamagui:** Design tokens e componentes estilizados.
- **React Navigation:** Navegação entre telas.
- **Reanimated:** Animações fluidas.

### Autenticação & Backend
- **Firebase Auth:** Login com e-mail/senha e OAuth.
- **Expo Auth Session:** Fluxo de autenticação OAuth.
- **Expo Secure Store:** Armazenamento seguro de tokens.

### Estado e Data Layer
- **Zustand:** Gerenciamento de estado leve.
- **React Query:** Cache e sincronização de dados do Firestore.

### Testes
- **Jest:** Testes unitários.
- **React Native Testing Library:** Testes de componentes.
- **Detox:** Testes E2E.

### Lint e Formatação
- **ESLint:** Análise estática de código.
- **Prettier:** Formatação consistente.

---

## 🔐 Funcionalidades Desenvolvidas

1. **Autenticação**
   - Fluxo de login e cadastro com Firebase Auth.
   - Login com Google e Microsoft via OAuth.

2. **Listagem de Pacientes**
   - Tela para exibir pacientes cadastrados.
   - Busca e filtros implementados.

3. **Registro de Visitas**
   - Formulário para registrar atendimentos.
   - Upload de anexos (imagens, documentos).

4. **Agendamento de Consultas**
   - Tela para agendar consultas com notificações.

5. **Exportação de Prescrição**
   - Geração de PDFs e envio para pacientes.

6. **Monitoramento de Lesões**
   - Upload de imagens e acompanhamento de status.

---

## 🧱 Arquitetura e Boas Práticas

- **Clean Architecture:** Separação em camadas (UI, domain, data).
- **SOLID:** Princípios aplicados no frontend.
- **Componentização:** Reutilização de componentes e hooks.
- **Acessibilidade:** Labels, roles e contraste adequados.
- **Documentação:** README, roadmap e guias de contribuição.

---

## 🚧 Próximos Passos

1. Finalizar integração com notificações (Firebase Cloud Messaging).
2. Implementar testes E2E com Detox.
3. Configurar pipeline CI/CD com GitHub Actions e EAS CLI.
4. Melhorar documentação visual com Storybook.

--- 

Este relatório reflete o progresso atual do projeto **CICATRIZA** e serve como base para acompanhamento e planejamento das próximas etapas.