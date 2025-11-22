# Guia de Acessibilidade - Cicatriza

## Visão Geral

Este guia documenta as práticas de acessibilidade implementadas no app Cicatriza, seguindo as diretrizes WCAG 2.1 Level AA e Material Design.

## Princípios de Acessibilidade

### 1. Perceptível
Informações e componentes da interface devem ser apresentados de forma que os usuários possam percebê-los.

### 2. Operável
Componentes da interface e navegação devem ser operáveis por todos os usuários.

### 3. Compreensível
Informações e operações da interface devem ser compreensíveis.

### 4. Robusto
O conteúdo deve ser robusto o suficiente para ser interpretado por diversas tecnologias assistivas.

## Padrões Implementados

### Tap Targets (Áreas de Toque)

**Padrão**: Mínimo de 48x48 dp (WCAG 2.1 Level AA: 44x44 dp)

```dart
// Material Design IconButtons já têm 48x48 dp por padrão
IconButton(
  icon: Icon(Icons.save),
  onPressed: _saveProfile,
  iconSize: 24.0, // Icon size dentro do 48x48 dp tap target
)
```

**Testes**:
```dart
testWidgets('should have minimum tap target sizes (48x48 dp)', (tester) async {
  const minTapTargetSize = 48.0;
  final size = tester.getSize(saveButton);
  expect(size.width, greaterThanOrEqualTo(minTapTargetSize));
  expect(size.height, greaterThanOrEqualTo(minTapTargetSize));
});
```

### Contraste de Cores

**Padrão**: WCAG AA requer:
- Texto normal: mínimo 4.5:1
- Texto grande (18pt+): mínimo 3:1
- Componentes UI: mínimo 3:1

**Verificação**: Use Flutter DevTools Accessibility Inspector

```dart
// Exemplo de cores com bom contraste
TextStyle(
  color: Colors.black87, // Contraste ~15:1 com branco
  backgroundColor: Colors.white,
)
```

### Semantic Labels

**Padrão**: Todos os elementos interativos devem ter labels descritivos.

```dart
// Bom exemplo
IconButton(
  icon: Icon(Icons.save),
  onPressed: _saveProfile,
  tooltip: 'Salvar perfil', // Anunciado por screen readers
)

// Imagens devem ter semanticLabel
Image.asset(
  'assets/logo.png',
  semanticLabel: 'Logo do Cicatriza',
)
```

### Navegação por Teclado

**Padrão**: Todos os elementos interativos devem ser acessíveis via teclado/teclado externo.

```dart
// TabBar e TabBarView suportam navegação por teclado automaticamente
TabBar(
  tabs: [
    Tab(text: 'Identificação'),
    Tab(text: 'Contato'),
  ],
)
```

**Ordem de foco**: Use `FocusTraversalOrder` ou `FocusTraversalGroup` para controlar.

### Formulários Acessíveis

**Padrão**: Campos devem ter labels, hints e mensagens de erro claras.

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Nome completo', // Label visível e para screen readers
    hintText: 'Digite seu nome',
    helperText: 'Nome como aparecerá no perfil',
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório'; // Erro acessível
    }
    return null;
  },
)
```

### High Contrast Mode

**Padrão**: UI deve ser utilizável em modo de alto contraste.

```dart
// Detectar high contrast mode
final mediaQuery = MediaQuery.of(context);
final isHighContrast = mediaQuery.highContrast;

// Ajustar UI se necessário
final borderWidth = isHighContrast ? 2.0 : 1.0;
```

**Testes**:
```dart
testWidgets('should handle high contrast mode', (tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(highContrast: true),
      child: MyWidget(),
    ),
  );
  // Verificar que UI funciona
});
```

### Text Scaling

**Padrão**: Suportar até 200% de ampliação sem perda de funcionalidade.

```dart
// Evitar tamanhos fixos
// ❌ Ruim
Text('Hello', style: TextStyle(fontSize: 14))

// ✅ Bom - respeita textScaleFactor
Text('Hello', style: Theme.of(context).textTheme.bodyMedium)
```

**Testes**:
```dart
testWidgets('should handle large text scaling', (tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(textScaleFactor: 2.0),
      child: MyWidget(),
    ),
  );
});
```

### Reduced Motion

**Padrão**: Respeitar preferência de animações reduzidas.

```dart
// Detectar preferência
final disableAnimations = MediaQuery.of(context).disableAnimations;

// Usar animação condicional
AnimatedContainer(
  duration: disableAnimations ? Duration.zero : Duration(milliseconds: 300),
  child: MyWidget(),
)
```

## Ferramentas de Teste

### 1. Flutter DevTools Accessibility Inspector

Ativar no DevTools:
1. Executar app: `flutter run`
2. Abrir DevTools
3. Ir para aba "Accessibility"
4. Clicar em "Enable Semantics"

**Verifica**:
- Semantic tree
- Tap target sizes
- Contraste de cores
- Labels ausentes

### 2. Testes Automatizados

```bash
# Executar testes de acessibilidade
flutter test test/accessibility/

# Com cobertura
flutter test test/accessibility/ --coverage
```

### 3. Screen Readers

**Android**: TalkBack
1. Settings → Accessibility → TalkBack
2. Ativar TalkBack
3. Testar navegação por gestos

**iOS**: VoiceOver
1. Settings → Accessibility → VoiceOver
2. Ativar VoiceOver
3. Testar navegação por gestos

**Comandos TalkBack**:
- Deslizar direita: próximo elemento
- Deslizar esquerda: elemento anterior
- Toque duplo: ativar elemento
- Dois dedos: scroll

### 4. guidepup_test (Avançado)

Para testes automatizados com screen readers:

```yaml
dev_dependencies:
  guidepup_test: ^0.1.0
```

## Checklist de Acessibilidade

### Antes de cada release:

- [ ] Todos os botões têm tooltips ou semantic labels
- [ ] Tap targets ≥ 48x48 dp
- [ ] Formulários têm labels e mensagens de erro
- [ ] Imagens têm semanticLabel
- [ ] Contraste verificado no DevTools
- [ ] Testado com TalkBack/VoiceOver
- [ ] Testado com 200% text scale
- [ ] Testado em high contrast mode
- [ ] Navegação por teclado funciona
- [ ] Testes automatizados passando

### Por componente:

- [ ] Semantic tree correto
- [ ] Focus order lógico
- [ ] Announcements para ações assíncronas
- [ ] Estados (loading, error, success) anunciados
- [ ] Modals têm foco inicial correto

## Melhores Práticas

### 1. Use Material Components

Componentes do Material Design já vêm com acessibilidade:

```dart
// ✅ Bom - acessibilidade inclusa
ElevatedButton(
  onPressed: _action,
  child: Text('Salvar'),
)

// ❌ Evitar - requer implementação manual
GestureDetector(
  onTap: _action,
  child: Container(child: Text('Salvar')),
)
```

### 2. Forneça Feedback

```dart
// Sucesso
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Perfil salvo com sucesso'),
    // Anunciado automaticamente para screen readers
  ),
);

// Loading
Semantics(
  label: 'Carregando perfil',
  child: CircularProgressIndicator(),
)
```

### 3. Use ExcludeSemantics quando necessário

```dart
// Ocultar elementos decorativos
ExcludeSemantics(
  child: Image.asset('decorative_pattern.png'),
)
```

### 4. Agrupe informações relacionadas

```dart
Semantics(
  label: 'Dr. João Silva, CRM 12345, Especialidade: Enfermagem',
  child: Column(
    children: [
      Text('Dr. João Silva'),
      Text('CRM 12345'),
      Text('Especialidade: Enfermagem'),
    ],
  ),
)
```

## Recursos Adicionais

### Documentação

- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

### Ferramentas

- [Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Color Blind Simulator](https://www.color-blindness.com/coblis-color-blindness-simulator/)
- [WAVE Browser Extension](https://wave.webaim.org/extension/)

### Testes

- [Flutter Accessibility Testing](https://docs.flutter.dev/cookbook/testing/widget/accessibility)
- [Android Accessibility Scanner](https://support.google.com/accessibility/android/answer/6376570)

## Contato

Para questões sobre acessibilidade:
- Criar issue no repositório com label `accessibility`
- Mencionar @accessibility-team nas PRs

---

**Última atualização**: Novembro 2025
**Versão WCAG**: 2.1 Level AA
**Versão Material Design**: 3.0
