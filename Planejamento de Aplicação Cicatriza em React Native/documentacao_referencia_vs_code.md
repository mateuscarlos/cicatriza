# Documentação de Referência para Desenvolvimento da Aplicação Cicatriza

Esta documentação serve como referência completa para o desenvolvimento da aplicação Cicatriza no Visual Studio Code. Ela contém informações sobre a estrutura do projeto, componentes, fluxos de navegação e padrões de implementação.

## Índice

1. [Visão Geral](#visão-geral)
2. [Tecnologias Utilizadas](#tecnologias-utilizadas)
3. [Estrutura de Diretórios](#estrutura-de-diretórios)
4. [Fluxos de Navegação](#fluxos-de-navegação)
5. [Componentes Principais](#componentes-principais)
6. [Módulos Funcionais](#módulos-funcionais)
7. [Integração com Firebase](#integração-com-firebase)
8. [Guia de Estilo](#guia-de-estilo)
9. [Boas Práticas](#boas-práticas)
10. [Testes](#testes)

## Visão Geral

A aplicação Cicatriza é uma ferramenta para gerenciamento de lesões por profissionais estomaterapeutas. Ela permite o cadastro de pacientes, registro e acompanhamento de lesões, avaliações periódicas, planos de tratamento, e geração de relatórios e prescrições.

A aplicação utiliza uma silhueta humana interativa para facilitar o registro da localização das lesões, permitindo uma visualização intuitiva das áreas afetadas.

## Tecnologias Utilizadas

- **React Native**: Framework para desenvolvimento mobile
- **TypeScript**: Linguagem de programação com tipagem estática
- **Expo SDK 52**: Plataforma para desenvolvimento React Native
- **Expo Router 4**: Sistema de navegação baseado em arquivos
- **Tamagui**: Biblioteca de UI de alta performance
- **React Query**: Gerenciamento de estado do servidor e sincronização de dados
- **Zustand**: Gerenciamento de estado global
- **Firebase 11.6.0**: Backend como serviço (Firestore, Authentication, Storage)
- **React Native SVG**: Para renderização da silhueta humana interativa
- **Expo Haptics**: Para feedback tátil
- **SendGrid**: Para envio de e-mails e relatórios

## Estrutura de Diretórios

```
/app                      # Diretório principal para Expo Router
  /(auth)                 # Rotas de autenticação
    /login.tsx            # Tela de login
    /registro.tsx         # Tela de registro
    /recuperar-senha.tsx  # Tela de recuperação de senha
  /(app)                  # Rotas protegidas (após autenticação)
    /(tabs)               # Navegação por abas
      /index.tsx          # Tab inicial (dashboard)
      /pacientes.tsx      # Tab de lista de pacientes
      /relatorios.tsx     # Tab de relatórios
    /pacientes            # Rotas relacionadas a pacientes
      /[id].tsx           # Detalhes do paciente
      /[id]/editar.tsx    # Edição de paciente
      /[id]/bodyparts.tsx # Tela de silhueta humana
      /novo.tsx           # Cadastro de novo paciente
    /pacientes/[id]/lesoes # Rotas relacionadas a lesões
      /[lesaoId].tsx      # Detalhes da lesão
      /[lesaoId]/editar.tsx # Edição de lesão
      /nova.tsx           # Cadastro de nova lesão
    /pacientes/[id]/lesoes/[lesaoId]/avaliacoes # Rotas de avaliações
      /[avaliacaoId].tsx  # Detalhes da avaliação
      /nova.tsx           # Nova avaliação
    /pacientes/[id]/lesoes/[lesaoId]/tratamento # Rotas de tratamento
      /index.tsx          # Plano de tratamento
  /_layout.tsx            # Layout principal da aplicação

/components               # Componentes reutilizáveis
  /ui                     # Componentes de UI genéricos
  /forms                  # Componentes de formulário
  /layout                 # Componentes de layout
  /bodyparts              # Componentes da silhueta humana

/constants                # Constantes da aplicação
  /bodyRegions.ts         # Definição das regiões anatômicas
  /theme.ts               # Configurações de tema
  /validation.ts          # Regras de validação

/hooks                    # Hooks personalizados
  /useAuth.ts             # Hook de autenticação
  /usePacientes.ts        # Hook para gerenciamento de pacientes
  /useFeridas.ts          # Hook para gerenciamento de feridas
  /useAvaliacoes.ts       # Hook para gerenciamento de avaliações
  /useTratamentos.ts      # Hook para gerenciamento de tratamentos
  /useOfflineSync.ts      # Hook para sincronização offline

/services                 # Serviços da aplicação
  /firebase               # Configuração e serviços do Firebase
  /storage                # Serviços de armazenamento local
  /api                    # Serviços de API

/utils                    # Funções utilitárias
  /formatters.ts          # Formatadores de dados
  /validators.ts          # Validadores de dados
  /calculations.ts        # Cálculos específicos da aplicação

/assets                   # Recursos estáticos
  /images                 # Imagens
  /icons                  # Ícones
  /fonts                  # Fontes

/types                    # Definições de tipos TypeScript
  /index.ts               # Tipos globais
  /models.ts              # Modelos de dados
```

## Fluxos de Navegação

### Fluxo de Autenticação

1. **Login**: Entrada na aplicação
2. **Registro**: Criação de nova conta
3. **Recuperação de Senha**: Processo de recuperação de senha

### Fluxo de Pacientes

1. **Lista de Pacientes**: Visualização e busca de pacientes
2. **Cadastro de Paciente**: Registro de novo paciente
   - Opção 1: Salvar e retornar à lista
   - Opção 2: Salvar e cadastrar lesão (direciona para Bodyparts)
3. **Detalhes do Paciente**: Visualização de informações do paciente e suas lesões
4. **Edição de Paciente**: Atualização de dados do paciente

### Fluxo de Lesões

1. **Bodyparts**: Seleção da localização da lesão na silhueta humana
   - Visualização de lesões existentes (destacadas em vermelho)
   - Alternância entre vistas frontal e posterior
2. **Cadastro de Lesão**: Registro de nova lesão
3. **Detalhes da Lesão**: Visualização de informações da lesão, avaliações e tratamento
4. **Edição de Lesão**: Atualização de dados da lesão

### Fluxo de Avaliações

1. **Nova Avaliação**: Registro de avaliação da lesão
2. **Detalhes da Avaliação**: Visualização de informações da avaliação

### Fluxo de Tratamento

1. **Plano de Tratamento**: Criação ou atualização do plano de tratamento

## Componentes Principais

### BodySilhouette

Componente central da aplicação que renderiza a silhueta humana interativa. Permite selecionar regiões anatômicas e destaca áreas com lesões cadastradas.

```typescript
// Exemplo de uso do componente BodySilhouette
<BodySilhouette
  view="front" // ou "back"
  regionsWithWounds={['leg_right_lower', 'foot_left']}
  onRegionPress={(regionId) => handleRegionPress(regionId)}
  highlightColor="#FF3B30"
  baseColor="#E5E5EA"
/>
```

Propriedades:
- `view`: Vista da silhueta ('front' ou 'back')
- `regionsWithWounds`: Array de IDs das regiões com lesões cadastradas
- `onRegionPress`: Callback chamado quando uma região é pressionada
- `highlightColor`: Cor para destacar regiões com lesões
- `baseColor`: Cor base para regiões sem lesões

### FormField

Componente reutilizável para campos de formulário com validação.

```typescript
// Exemplo de uso do componente FormField
<FormField
  label="Nome Completo"
  required
  error={errors.nome}
  renderInput={(props) => (
    <Input
      {...props}
      value={form.nome}
      onChangeText={(text) => atualizarForm('nome', text)}
      placeholder="Nome do paciente"
      icon={<User size={18} color="$textSecondary" />}
    />
  )}
/>
```

### StatusBadge

Componente para exibir o status da lesão com cor apropriada.

```typescript
// Exemplo de uso do componente StatusBadge
<StatusBadge status="active" /> // Exibe "Ativa" em vermelho
<StatusBadge status="healing" /> // Exibe "Em cicatrização" em amarelo
<StatusBadge status="healed" /> // Exibe "Cicatrizada" em verde
```

## Módulos Funcionais

### Módulo de Autenticação

Responsável pelo login, registro e recuperação de senha. Utiliza Firebase Authentication para gerenciamento de usuários.

Hooks principais:
- `useAuth`: Gerencia o estado de autenticação e fornece métodos para login, logout, registro e recuperação de senha.

### Módulo de Pacientes

Gerencia o cadastro, visualização, edição e exclusão de pacientes.

Hooks principais:
- `usePacientes`: Fornece métodos para operações CRUD de pacientes e consultas.

Exemplo de uso:
```typescript
const { pacientes, isLoading, error, addPaciente, updatePaciente, deletePaciente } = usePacientes();
```

### Módulo de Feridas (Lesões)

Gerencia o cadastro, visualização, edição e exclusão de lesões, incluindo a interação com a silhueta humana.

Hooks principais:
- `useFeridas`: Fornece métodos para operações CRUD de lesões e consultas.
- `useBodyRegions`: Gerencia a interação com as regiões anatômicas da silhueta.

### Módulo de Avaliações

Gerencia o registro e visualização de avaliações periódicas das lesões.

Hooks principais:
- `useAvaliacoes`: Fornece métodos para operações CRUD de avaliações e consultas.

### Módulo de Tratamento

Gerencia os planos de tratamento das lesões.

Hooks principais:
- `useTratamentos`: Fornece métodos para operações CRUD de tratamentos e consultas.

### Módulo de Relatórios

Gerencia a geração e exportação de relatórios e prescrições.

Hooks principais:
- `useRelatorios`: Fornece métodos para geração e exportação de relatórios.

## Integração com Firebase

### Configuração

A configuração do Firebase está no arquivo `services/firebase/config.ts`. As credenciais são obtidas do arquivo `google-services.json` para Android e configurações equivalentes para iOS.

### Firestore

Estrutura do banco de dados:

```
/users/{userId}                      # Informações do usuário
/pacientes/{pacienteId}              # Informações do paciente
/feridas/{feridaId}                  # Informações da ferida
  - pacienteId: referência           # Referência ao paciente
/avaliacoes/{avaliacaoId}            # Informações da avaliação
  - feridaId: referência             # Referência à ferida
/tratamentos/{tratamentoId}          # Informações do tratamento
  - feridaId: referência             # Referência à ferida
```

### Storage

Estrutura de armazenamento:

```
/users/{userId}/profile.jpg          # Foto de perfil do usuário
/pacientes/{pacienteId}/profile.jpg  # Foto do paciente
/feridas/{feridaId}/images/{imageId} # Imagens da ferida
/avaliacoes/{avaliacaoId}/images/{imageId} # Imagens da avaliação
```

### Autenticação

Métodos de autenticação habilitados:
- E-mail e senha
- Google (opcional)

## Guia de Estilo

### Tema

A aplicação utiliza o tema do Tamagui com as seguintes personalizações:

```typescript
// Exemplo simplificado do tema
const theme = createTheme({
  background: '#FFFFFF',
  backgroundSecondary: '#F2F2F7',
  text: '#000000',
  textSecondary: '#8E8E93',
  primary: '#007AFF',
  secondary: '#5856D6',
  success: '#34C759',
  warning: '#FF9500',
  danger: '#FF3B30',
  borderColor: '#C7C7CC',
  // ... outras cores e tokens
});
```

### Componentes de UI

A aplicação utiliza os componentes do Tamagui com estilos consistentes:

- **Botões**: Tamanhos padronizados ($3, $4, $5)
- **Inputs**: Altura e padding consistentes
- **Cards**: Bordas arredondadas e sombras sutis
- **Tipografia**: Hierarquia clara com H1, H2, Text

### Ícones

A aplicação utiliza os ícones do pacote `@tamagui/lucide-icons` com tamanhos padronizados:
- Ícones pequenos: 16px
- Ícones médios: 18px
- Ícones grandes: 24px

## Boas Práticas

### Nomenclatura

- **Arquivos**: Utilizar kebab-case para arquivos de componentes (ex: `patient-card.tsx`)
- **Componentes**: Utilizar PascalCase para nomes de componentes (ex: `PatientCard`)
- **Hooks**: Utilizar camelCase com prefixo "use" (ex: `usePacientes`)
- **Funções**: Utilizar camelCase (ex: `formatarData`)
- **Constantes**: Utilizar SNAKE_CASE para constantes globais (ex: `MAX_FILE_SIZE`)

### Organização de Código

- Separar lógica de negócio (hooks) da interface (componentes)
- Utilizar componentes pequenos e reutilizáveis
- Manter arquivos com menos de 300 linhas quando possível
- Agrupar imports por categoria (React, bibliotecas externas, componentes internos)

### Performance

- Utilizar `React.memo` para componentes que não mudam frequentemente
- Utilizar `useMemo` e `useCallback` para otimizar renderizações
- Implementar virtualização para listas longas
- Otimizar imagens antes de upload

### Offline First

A aplicação implementa uma estratégia "offline-first" utilizando:
- Cache local com React Query
- Sincronização em segundo plano quando a conexão é restabelecida
- Indicadores visuais de estado de sincronização

## Testes

### Testes Unitários

Utilizar Jest e React Testing Library para testes unitários de componentes e hooks.

```typescript
// Exemplo de teste unitário para um componente
describe('PatientCard', () => {
  it('renders patient information correctly', () => {
    const patient = {
      id: '1',
      nome: 'Maria Silva',
      // ... outros dados
    };
    
    const { getByText } = render(<PatientCard patient={patient} />);
    
    expect(getByText('Maria Silva')).toBeInTheDocument();
  });
});
```

### Testes de Integração

Utilizar Detox para testes de integração em dispositivos reais ou emuladores.

```typescript
// Exemplo de teste de integração
describe('Patient Flow', () => {
  it('should create a new patient', async () => {
    await element(by.id('add-patient-button')).tap();
    await element(by.id('name-input')).typeText('João Silva');
    // ... preencher outros campos
    await element(by.id('save-button')).tap();
    
    await expect(element(by.text('João Silva'))).toBeVisible();
  });
});
```

### Testes Manuais

Checklist para testes manuais:
- Verificar fluxos principais em diferentes dispositivos
- Testar em condições de rede instável
- Verificar comportamento offline
- Testar acessibilidade
- Verificar desempenho em dispositivos de baixo desempenho
