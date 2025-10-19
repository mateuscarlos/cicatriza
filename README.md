# Cicatriza

Um aplicativo Flutter para avaliação e acompanhamento de feridas.

## Pré-requisitos

### Desenvolvimento

- Flutter SDK (versão mais recente)
- Java JDK 21 (necessário para o build Android)
- Android Studio ou VS Code com extensões Flutter/Dart
- Git

### Configuração do Java JDK

O projeto requer Java JDK 21 para compilação Android. Configure seu ambiente:

1. Instale o JDK 21
2. Copie o arquivo `.vscode/settings.json.example` para `.vscode/settings.json`
3. Substitua `CAMINHO_PARA_SEU_JDK_21` pelo caminho real do seu JDK
4. Ou configure a variável `JAVA_HOME` do sistema

## Configuração do Projeto

1. Clone o repositório:

```bash
git clone https://github.com/mateuscarlos/cicatriza.git
cd cicatriza
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Configure o Firebase (se necessário):
   - Adicione seus arquivos `google-services.json` e `GoogleService-Info.plist`
   - Configure as chaves de API necessárias

## Executando o Projeto

### Debug

```bash
flutter run
```

### Build para Produção

```bash
# Android
flutter build apk --release

# iOS (apenas no macOS)
flutter build ios --release
```

## Estrutura do Projeto

```text
lib/
├── core/          # Configurações centrais, constantes, DI
├── data/          # Camada de dados (repositories, datasources, models)
├── domain/        # Camada de domínio (entities, use cases)
└── presentation/  # Camada de apresentação (páginas, widgets, BLoC)
```

## Funcionalidades

- Avaliação de feridas
- Acompanhamento de evolução
- Captura e análise de imagens
- Relatórios e histórico
- Integração com Firebase

## Dependências Principais

- Firebase (Auth, Firestore, Storage)
- Google Sign In
- BLoC para gerenciamento de estado
- Clean Architecture

## Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
