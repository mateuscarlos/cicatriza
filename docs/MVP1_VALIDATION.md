# MVP1 - Validação de Fluxo Completo

## Objetivo
Validar o fluxo completo desde o login do estomaterapeuta até o cadastro de uma lesão, garantindo que a aplicação esteja pronta para demonstração ao cliente.

## Fluxo a ser Validado

### 1. Login do Estomaterapeuta
**Tela:** LoginPage (`/login`)

**Ações:**
- [ ] Aplicativo inicia na tela de login
- [ ] Exibe logo da aplicação
- [ ] Botões de login Google e Microsoft visíveis
- [ ] Ao clicar em qualquer botão SSO, navega para lista de pacientes

**Observações MVP:**
- Autenticação real não implementada neste MVP
- Navegação direta para simular login bem-sucedido

---

### 2. Lista de Pacientes
**Tela:** PacientesListPage (`/patients`)

**Ações:**
- [ ] Lista de pacientes carrega (pode estar vazia inicialmente)
- [ ] Barra de busca funcional
- [ ] Toggle "Mostrar arquivados" funcional
- [ ] FAB "Novo Paciente" visível
- [ ] Ao clicar em "Novo Paciente", dialog de cadastro abre

**Funcionalidades a testar:**
- [ ] Criar novo paciente com dados válidos
- [ ] Validação de campos obrigatórios (nome, data nascimento)
- [ ] Cálculo automático da idade após salvar
- [ ] Paciente aparece na lista após criação
- [ ] Ao tocar em um paciente, navega para lista de feridas

---

### 3. Lista de Feridas/Lesões
**Tela:** WoundsListPage (`/wounds/:patientId`)

**Ações:**
- [ ] Título mostra "Feridas de [Nome do Paciente]"
- [ ] Lista de feridas do paciente (vazia se primeira visita)
- [ ] FAB "Nova Ferida" visível
- [ ] Ao clicar em "Nova Ferida", dialog de cadastro abre

**Funcionalidades a testar:**
- [ ] Criar nova ferida com dados válidos
  - Localização anatômica (obrigatório)
  - Tipo de ferida (obrigatório)
  - Causa (opcional)
  - Descrição (opcional)
- [ ] Ferida aparece na lista com status "ativa" (chip verde)
- [ ] Card mostra localização e tipo
- [ ] Menu de ações (⋮) funcional
- [ ] Ao tocar em "Nova Avaliação", navega para formulário

---

### 4. Cadastro de Avaliação
**Tela:** AssessmentCreatePage (`/assessment/create`)

**Ações:**
- [ ] Título mostra dados do paciente e ferida
- [ ] Formulário completo visível com todas as seções

**Campos a validar:**

#### 4.1 Medições
- [ ] **Comprimento (cm)**: aceita decimais, obrigatório, > 0
- [ ] **Largura (cm)**: aceita decimais, obrigatório, > 0
- [ ] **Profundidade (cm)**: aceita decimais, obrigatório, > 0

#### 4.2 Dor
- [ ] Slider funcional de 0 a 10
- [ ] Feedback visual por cor (verde → vermelho)
- [ ] Labels descritivos aparecem

#### 4.3 Características da Ferida
- [ ] **Leito da ferida**: dropdown com opções (vermelho, amarelo, preto, misto)
- [ ] **Exsudato**: dropdown com opções (ausente, escasso, moderado, abundante)
- [ ] **Borda**: dropdown com opções (íntegra, eritematosa, descamativa, macerada, fibrótica)

#### 4.4 Data e Observações
- [ ] Campo de data com valor padrão (hoje)
- [ ] DatePicker funcional
- [ ] Validação: data não pode ser futura
- [ ] Campo de observações (opcional)

#### 4.5 Salvar
- [ ] Botão "Salvar Avaliação" habilitado quando formulário válido
- [ ] Ao salvar com sucesso, mostra feedback (SnackBar)
- [ ] Navega de volta para lista de feridas
- [ ] Avaliação vinculada à ferida correta

---

## Critérios de DoD (Definition of Done)

### Funcionalidade
- [x] Fluxo completo implementado: login → pacientes → feridas → avaliação
- [x] CRUD de pacientes funcional
- [x] CRUD de feridas funcional
- [x] Criação de avaliação funcional
- [x] Navegação entre telas funciona corretamente
- [x] Validações de negócio implementadas

### UI/UX
- [x] Material 3 Design System aplicado
- [x] Componentes reutilizáveis criados (FormSection, NumberField, PainSlider)
- [x] Feedback visual apropriado (loading, success, error)
- [x] Responsividade básica
- [x] Elementos interativos claros (FABs, botões, cards)

### Arquitetura
- [x] BLoC pattern implementado corretamente
- [x] Separação de camadas (presentation, domain, data)
- [x] Dependency injection configurada (GetIt)
- [x] Roteamento com named routes

### Qualidade de Código
- [x] Código organizado e legível
- [x] Nomenclatura consistente em português (domínio clínico)
- [ ] Sem erros de compilação críticos (erros em docs/entidades não usadas são aceitáveis)
- [x] Componentes modulares e reutilizáveis

### Preparação para Cliente
- [ ] Branch MVP1 criada e testada
- [ ] Fluxo completo validado manualmente
- [ ] Documentação de validação completa (este documento)
- [ ] README atualizado com instruções de execução

---

## Problemas Conhecidos (Backlog para próximas iterações)

### Não Bloqueantes para MVP1
1. **Autenticação**: SSO não implementado, usando navegação direta
2. **Persistência**: Dados apenas em memória (sem Firebase/Isar)
3. **Sync offline**: Não implementado
4. **Upload de fotos**: Não implementado
5. **Edição de registros**: Apenas criação implementada
6. **Freezed entities**: Erros nas entidades não utilizadas (patient.dart, wound.dart, etc.)

### Para M1 Completo (próximas sprints)
- Implementar autenticação Firebase
- Integrar Firebase Firestore para persistência
- Implementar Isar para offline-first
- Adicionar upload de fotos com compressão
- Completar CRUDs (edição e exclusão)
- Implementar sincronização robusta
- Testes automatizados (unit, widget, integração)

---

## Checklist de Execução

### Pré-requisitos
- [ ] Flutter instalado (versão estável)
- [ ] Emulador Android ou dispositivo físico conectado
- [ ] Dependências instaladas (`flutter pub get`)

### Execução do Teste
1. [ ] Checkout da branch mvp1: `git checkout mvp1`
2. [ ] Limpar build: `flutter clean && flutter pub get`
3. [ ] Executar app: `flutter run`
4. [ ] Seguir o fluxo descrito acima
5. [ ] Marcar cada item validado

### Critérios de Aprovação
- Todos os itens do fluxo principal marcados como ✅
- Nenhum crash ou erro crítico durante o fluxo
- UX fluida e compreensível
- Cliente consegue entender o conceito da aplicação

---

## Notas de Implementação

### Modificações para MVP
- **LoginPage**: Botões SSO navegam diretamente para `/patients` sem autenticação
- **PatientBloc**: Usando lista em memória (mock) ao invés de Firebase
- **WoundBloc**: Usando lista em memória (mock) ao invés de Firebase
- **AssessmentBloc**: Usando lista em memória (mock) ao invés de Firebase

### Validações Implementadas
- **Dor**: 0-10 (inteiro)
- **Medidas**: > 0 cm (decimal)
- **Data**: ≤ hoje
- **Campos obrigatórios**: nome paciente, data nascimento, localização ferida, tipo ferida

---

## Próximos Passos Após Validação

1. ✅ **MVP1 Aprovado** → Demonstrar ao cliente
2. Coletar feedback do cliente
3. Priorizar backlog com base no feedback
4. Iniciar implementação M1 completo:
   - Firebase Authentication
   - Firestore integration
   - Isar offline storage
   - Sync layer
5. Implementar testes automatizados
6. Preparar para M2 (funcionalidades avançadas)

---

**Data de criação:** 2024
**Branch:** mvp1
**Status:** 🟡 Em validação
