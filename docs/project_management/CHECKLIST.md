# Checklist de Verificação - Cicatriza

Este checklist deve ser seguido antes de fazer merge de Pull Requests para garantir a qualidade e estabilidade do projeto.

## Verificações Obrigatórias

### 📋 Código e Qualidade

- [ ] Código segue os padrões de formatação (Dart/Flutter)
- [ ] Não há warnings ou errors no `flutter analyze`
- [ ] Código está bem documentado (dartdoc comments)
- [ ] Nomes de variáveis, funções e classes são descritivos
- [ ] Não há código comentado desnecessário ou debug prints
- [ ] Imports estão organizados (dart, flutter, packages, local)

### 🧪 Testes

- [ ] Testes unitários passam (`flutter test`)
- [ ] Testes de widget passam (se aplicável)
- [ ] Testes de integração passam (se aplicável)
- [ ] Cobertura de testes mantida ou melhorada
- [ ] Novos recursos têm testes correspondentes

### 📱 Build e Compatibilidade

- [ ] Build Android funciona (`flutter build apk --debug`)
- [ ] Build iOS funciona (se testável, `flutter build ios --debug`)
- [ ] Aplicativo roda sem crashes em dispositivos/emuladores
- [ ] Funcionalidade testada em diferentes tamanhos de tela
- [ ] Performance aceitável (sem lags perceptíveis)

### 🔧 Configuração e Dependências

- [ ] `pubspec.yaml` atualizado corretamente
- [ ] Dependências são necessárias e estão na versão adequada
- [ ] Não há dependências com vulnerabilidades conhecidas
- [ ] `flutter pub get` executa sem erros
- [ ] Configurações do Firebase estão corretas (se aplicável)

### 📚 Documentação

- [ ] README.md atualizado (se necessário)
- [ ] CHANGELOG.md atualizado (se aplicável)
- [ ] Comentários no código explicam lógica complexa
- [ ] Documentação de API atualizada (se aplicável)

### 🔒 Segurança

- [ ] Não há chaves de API ou segredos hardcoded
- [ ] Validações de entrada adequadas
- [ ] Tratamento de erros apropriado
- [ ] Logs não expõem informações sensíveis

### 🌿 Git e Versionamento

- [ ] Commit messages seguem padrão (feat:, fix:, docs:, etc.)
- [ ] Branch está atualizada com a branch de destino
- [ ] Não há conflitos de merge
- [ ] Histórico de commits está limpo (sem commits de "fix typo")

## Verificações Específicas por Tipo de Mudança

### 🆕 Nova Funcionalidade

- [ ] Funcionalidade está completa e testada
- [ ] UX/UI seguem o design system do projeto
- [ ] Acessibilidade considerada (semantics, contrast)
- [ ] Integração com backend funciona (se aplicável)
- [ ] Estados de loading/error tratados adequadamente

### 🐛 Correção de Bug

- [ ] Bug reproduzido e corrigido
- [ ] Causa raiz identificada e documentada
- [ ] Teste adicionado para prevenir regressão
- [ ] Outras áreas do código verificadas para bugs similares

### 🔧 Refatoração

- [ ] Funcionalidade permanece inalterada
- [ ] Performance mantida ou melhorada
- [ ] Testes existentes ainda passam
- [ ] Código mais legível/maintível

### 📖 Documentação

- [ ] Informações estão precisas e atualizadas
- [ ] Links funcionam corretamente
- [ ] Exemplos de código estão testados
- [ ] Gramática e ortografia verificadas

## Verificações de Deploy

### 🚀 Preparação para Produção

- [ ] Versão incrementada adequadamente
- [ ] Release notes preparadas
- [ ] Configurações de produção verificadas
- [ ] Backup do banco de dados (se aplicável)
- [ ] Rollback plan definido

## Aprovação Final

- [ ] Code review completo por pelo menos 1 desenvolvedor
- [ ] PM/Design aprovaram (para features de UI)
- [ ] Testes manuais realizados
- [ ] Checklist completo ✅

---

## Comandos Úteis

```bash
# Análise estática
flutter analyze

# Testes
flutter test
flutter test --coverage

# Build
flutter build apk --debug
flutter build ios --debug

# Formatação
dart format .

# Atualizar dependências
flutter pub get
flutter pub upgrade --dry-run
```

## Contatos para Dúvidas

- **Tech Lead**: [Nome do Tech Lead]
- **QA**: [Nome do QA]
- **DevOps**: [Nome do DevOps]

---

*Este checklist deve ser usado como referência. Nem todos os itens podem aplicar-se a todas as mudanças.*