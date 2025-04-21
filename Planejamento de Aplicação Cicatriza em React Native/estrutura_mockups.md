# Estrutura de Mockups da Aplicação Cicatriza

## Visão Geral
Este documento define a estrutura dos mockups para todas as telas da aplicação Cicatriza, organizados por módulos funcionais e fluxos de navegação. Os mockups serão criados usando TypeScript e Tamagui para representar fielmente a implementação final.

## Módulos da Aplicação

### 1. Autenticação
- Login
- Registro
- Recuperação de Senha

### 2. Pacientes
- Lista de Pacientes
- Detalhes do Paciente
- Cadastro de Paciente
- Edição de Paciente

### 3. Bodyparts (Silhueta Humana)
- Tela Bodyparts (Visualização Frontal/Posterior)
- Componente SVG da Silhueta Humana

### 4. Feridas
- Lista de Feridas
- Detalhes da Ferida
- Cadastro de Ferida
- Edição de Ferida

### 5. Avaliação
- Formulário de Avaliação
- Histórico de Avaliações
- Visualização de Avaliação

### 6. Tratamento
- Plano de Tratamento
- Prescrições
- Agendamento de Reavaliações

### 7. Relatórios
- Geração de Relatórios
- Exportações
- Visualização de Relatórios

## Padrões de Design

### Componentes Comuns
- Cabeçalhos
- Botões de Ação
- Campos de Formulário
- Cards
- Listas
- Modais

### Tema e Estilo
- Paleta de Cores
- Tipografia
- Espaçamento
- Sombras e Elevação

## Fluxos de Navegação

### Fluxo de Cadastro de Paciente e Lesão
1. Lista de Pacientes → Botão "+" → Tela de Cadastro de Paciente
2. Opção A: Botão "Cadastrar Paciente" → Lista de Pacientes
3. Opção B: Botão "Cadastrar Lesão" → Tela Bodyparts → Seleção de Parte do Corpo → Tela de Cadastro de Lesão → Tela Bodyparts → Botão "Concluir" → Detalhes do Paciente

### Fluxo de Visualização e Edição de Lesões
1. Lista de Pacientes → Seleção de Paciente → Detalhes do Paciente → Botão "Visualizar Lesões" → Tela Bodyparts
2. Tela Bodyparts → Seleção de Parte do Corpo com Lesão → Detalhes da Lesão
3. Detalhes da Lesão → Botão "Editar" → Formulário de Edição de Lesão

### Fluxo de Avaliação de Lesão
1. Detalhes da Lesão → Botão "Nova Avaliação" → Formulário de Avaliação → Salvar → Detalhes da Lesão

## Organização dos Arquivos de Mockup

```
mockups/
├── autenticacao/
│   ├── login.tsx
│   ├── registro.tsx
│   └── recuperacao_senha.tsx
├── pacientes/
│   ├── lista_pacientes.tsx
│   ├── detalhes_paciente.tsx
│   ├── cadastro_paciente.tsx
│   └── edicao_paciente.tsx
├── bodyparts/
│   ├── tela_bodyparts.tsx
│   └── componente_silhueta.tsx
├── feridas/
│   ├── lista_feridas.tsx
│   ├── detalhes_ferida.tsx
│   ├── cadastro_ferida.tsx
│   └── edicao_ferida.tsx
├── avaliacao/
│   ├── formulario_avaliacao.tsx
│   ├── historico_avaliacoes.tsx
│   └── visualizacao_avaliacao.tsx
├── tratamento/
│   ├── plano_tratamento.tsx
│   ├── prescricoes.tsx
│   └── agendamento_reavaliacoes.tsx
└── relatorios/
    ├── geracao_relatorios.tsx
    ├── exportacoes.tsx
    └── visualizacao_relatorios.tsx
```

## Próximos Passos
1. Criar mockups para cada tela seguindo a estrutura definida
2. Implementar componentes reutilizáveis
3. Documentar cada mockup com comentários detalhados
4. Compilar documentação de referência para o Visual Studio
