# Contribuindo para o Cicatriza

Obrigado pelo interesse em contribuir para o projeto Cicatriza! Este guia contém informações sobre como contribuir de forma efetiva.

## 🚀 Começando

### Pré-requisitos

Antes de contribuir, certifique-se de ter:

- Flutter SDK (versão mais recente)
- Java JDK 21
- Git configurado
- Editor de código (VS Code recomendado)

Siga as instruções de instalação no [README.md](README.md) para configurar o ambiente.

## 📋 Processo de Contribuição

### 1. Fork e Clone

```bash
# Fork o repositório no GitHub
# Depois clone seu fork
git clone https://github.com/SEU_USERNAME/cicatriza.git
cd cicatriza

# Adicione o repositório original como upstream
git remote add upstream https://github.com/mateuscarlos/cicatriza.git
```

### 2. Configuração do Ambiente

```bash
# Instale as dependências
flutter pub get

# Verifique se tudo está funcionando
flutter doctor
flutter analyze
flutter test
```

### 3. Criação de Branch

Use nomes descritivos para suas branches:

```bash
# Para novas funcionalidades
git checkout -b feature/nome-da-funcionalidade

# Para correções de bugs
git checkout -b fix/descricao-do-bug

# Para documentação
git checkout -b docs/descricao-da-mudanca

# Para refatoração
git checkout -b refactor/descricao-da-refatoracao
```

### 4. Desenvolvimento

- Siga os padrões de código Dart/Flutter
- Escreva testes para novas funcionalidades
- Documente código complexo
- Use o [CHECKLIST.md](docs/project_management/CHECKLIST.md) como referência

### 5. Commits

Seguimos o padrão [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Tipos de commit
feat: nova funcionalidade
fix: correção de bug
docs: documentação
style: formatação (não afeta lógica)
refactor: refatoração de código
test: adicionar/modificar testes
chore: tarefas de manutenção

# Exemplos
git commit -m "feat: adiciona tela de avaliação de feridas"
git commit -m "fix: corrige crash ao carregar imagem"
git commit -m "docs: atualiza README com instruções de instalação"
```

### 6. Pull Request

```bash
# Sincronize com o repositório principal
git fetch upstream
git rebase upstream/develop

# Push da sua branch
git push origin sua-branch

# Abra PR no GitHub para branch 'develop'
```

## 🏗️ Estrutura do Projeto

```text
lib/
├── core/
│   ├── constants/     # Constantes globais
│   ├── di/           # Injeção de dependência
│   ├── env/          # Configurações de ambiente
│   ├── routing/      # Roteamento da aplicação
│   ├── theme/        # Temas e estilos
│   └── utils/        # Utilitários globais
├── data/
│   ├── datasources/  # Fontes de dados (API, local)
│   ├── models/       # Modelos de dados
│   └── repositories/ # Implementação de repositórios
├── domain/
│   ├── entities/     # Entidades de negócio
│   ├── repositories/ # Contratos de repositórios
│   └── usecases/     # Casos de uso
└── presentation/
    ├── blocs/        # Gerenciamento de estado (BLoC)
    ├── pages/        # Telas da aplicação
    └── widgets/      # Widgets reutilizáveis
```

## 📝 Padrões de Código

### Nomenclatura

```dart
// Classes: PascalCase
class WoundAssessment {}

// Variáveis e funções: camelCase
String patientName = '';
void calculateWoundArea() {}

// Constantes: SCREAMING_SNAKE_CASE
const String API_BASE_URL = '';

// Arquivos: snake_case
wound_assessment_page.dart
```

### Organização de Imports

```dart
// 1. Dart core
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 4. Local imports
import '../models/wound.dart';
import '../widgets/wound_widget.dart';
```

### Documentação

```dart
/// Calcula a área da ferida baseada nas dimensões fornecidas.
///
/// [length] comprimento da ferida em centímetros
/// [width] largura da ferida em centímetros
/// 
/// Retorna a área em cm²
double calculateWoundArea(double length, double width) {
  return length * width;
}
```

## 🧪 Testes

### Estrutura de Testes

```text
test/
├── unit/           # Testes unitários
├── widget/         # Testes de widgets
└── integration/    # Testes de integração
```

### Executando Testes

```bash
# Todos os testes
flutter test

# Com cobertura
flutter test --coverage

# Testes específicos
flutter test test/unit/wound_test.dart
```

### Exemplo de Teste

```dart
group('WoundAssessment', () {
  test('should calculate area correctly', () {
    // Arrange
    const length = 5.0;
    const width = 3.0;
    
    // Act
    final area = calculateWoundArea(length, width);
    
    // Assert
    expect(area, equals(15.0));
  });
});
```

## 🎨 UI/UX Guidelines

### Design System

- Use os componentes do Material Design 3
- Mantenha consistência visual
- Considere acessibilidade (contrast ratio, semantics)
- Teste em diferentes tamanhos de tela

### Cores e Temas

```dart
// Use cores do tema
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.secondary

// Evite cores hardcoded
Container(color: Colors.blue) // ❌
Container(color: Theme.of(context).primaryColor) // ✅
```

## 🔍 Code Review

### O que Procuramos

- **Funcionalidade**: O código faz o que deveria fazer?
- **Legibilidade**: Outros desenvolvedores conseguem entender?
- **Performance**: Há gargalos ou ineficiências?
- **Testes**: A funcionalidade está adequadamente testada?
- **Segurança**: Há vulnerabilidades potenciais?

### Dicas para PR

- Mantenha PRs pequenos e focados
- Descreva claramente o que foi mudado
- Inclua screenshots para mudanças de UI
- Referencie issues relacionadas

## 🐛 Reportando Bugs

### Informações Necessárias

- Versão do Flutter (`flutter --version`)
- Sistema operacional
- Dispositivo/emulador usado
- Passos para reproduzir
- Comportamento esperado vs atual
- Screenshots/logs se aplicável

### Template de Issue

```markdown
**Descrição do Bug**
Descrição clara do que aconteceu.

**Passos para Reproduzir**
1. Vá para '...'
2. Clique em '....'
3. Role para baixo até '....'
4. Veja o erro

**Comportamento Esperado**
Descrição do que deveria acontecer.

**Screenshots**
Se aplicável, adicione screenshots.

**Informações do Ambiente:**
- Flutter version: [ex: 3.x.x]
- Dart version: [ex: 3.x.x]
- OS: [ex: Windows 11, macOS 14, Ubuntu 22.04]
- Device: [ex: Pixel 6, iPhone 14, Chrome browser]
```

## 💡 Sugestões de Funcionalidades

Para sugerir novas funcionalidades:

1. Verifique se já não existe uma issue similar
2. Descreva o problema que a funcionalidade resolve
3. Proponha uma solução
4. Considere alternativas
5. Adicione mockups se for relacionado à UI

## ❓ Dúvidas

- Abra uma [Discussion](https://github.com/mateuscarlos/cicatriza/discussions)
- Entre em contato via [email ou slack]
- Consulte a documentação no [link da wiki]

## 📜 Código de Conduta

Este projeto segue o [Contributor Covenant](https://www.contributor-covenant.org/). 
Ao participar, você deve seguir este código. Reporte comportamentos inaceitáveis para [email do maintainer].

---

Obrigado por contribuir! 🎉