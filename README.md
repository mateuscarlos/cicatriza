# Cicatriza

> ⚠️ **ALERTA DE SEGURANÇA:** Firebase API key foi exposta e precisa ser regenerada.  
> **Owner:** Ver [`docs/project_management/SECURITY_ACTION_REQUIRED.md`](docs/project_management/SECURITY_ACTION_REQUIRED.md) para ações urgentes.  
> **Desenvolvedores:** Ver [`docs/security/SECURITY_FIREBASE.md`](docs/security/SECURITY_FIREBASE.md) para setup seguro.

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

## Instruções de instalação por sistema operacional

As instruções a seguir cobrem instalação do Flutter, JDK 21 e variáveis de ambiente em Windows, macOS e Linux.

### Windows

1. Instale o Flutter seguindo as instruções oficiais: [Windows install guide](https://docs.flutter.dev/get-started/install/windows)
2. Instale o JDK 21 (Temurin/Adoptium ou outro fornecedor). Por exemplo, baixe o ZIP e extraia em `C:\jdk-21` ou use o instalador.
3. Configure a variável de sistema `JAVA_HOME` apontando para o diretório do JDK (ex: `C:\jdk-21`).
   - Abra "Editar variáveis de ambiente do sistema" → Variáveis de ambiente → Novo (ou editar `JAVA_HOME`) → selecione o caminho do JDK
   - Adicione `%JAVA_HOME%\bin` ao `Path` se necessário.
4. Opcional: copie `.vscode/settings.json.example` para `.vscode/settings.json` e atualize os caminhos se preferir configurações por workspace.

Comandos úteis (PowerShell):

```powershell
# Exemplo para setar JAVA_HOME temporariamente na sessão
$env:JAVA_HOME = 'C:\jdk-21'
$env:Path = "$env:JAVA_HOME\\bin;" + $env:Path
flutter doctor
```

### macOS

1. Instale o Flutter seguindo: [macOS install guide](https://docs.flutter.dev/get-started/install/macos)
2. Instale o JDK 21 (por exemplo usando Homebrew + Temurin):

```bash
brew install --cask temurin
# ou para um JDK 21 específico, instale a versão correta e aponte o JAVA_HOME
```

3. Configure `JAVA_HOME` adicionando ao seu shell profile (ex: `~/.zshrc`):

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v21)
export PATH="$JAVA_HOME/bin:$PATH"
```

4. Verifique com:

```bash
java -version
flutter doctor
```

### Linux (Debian/Ubuntu exemplo)

1. Instale o Flutter: [Linux install guide](https://docs.flutter.dev/get-started/install/linux)
2. Instale o JDK 21 (Temurin recomendado):

```bash
#wget https://github.com/adoptium/temurin21-binaries/releases/latest/download/OpenJDK21U-jdk_x64_linux_hotspot_21.0.8_9.tar.gz
sudo tar -xzf OpenJDK21U-jdk_x64_linux_hotspot_21.0.8_9.tar.gz -C /opt/
sudo ln -s /opt/jdk-21.0.8+9 /opt/jdk21
```

3. Configure `JAVA_HOME` (ex: `~/.bashrc` ou `~/.profile`):

```bash
export JAVA_HOME="/opt/jdk21"
export PATH="$JAVA_HOME/bin:$PATH"
```

4. Verifique com:

```bash
java -version
flutter doctor
```

## Executando e buildando o projeto

Após instalar e configurar as ferramentas, execute:

```bash
flutter pub get
flutter run            # para rodar em modo debug
```

Builds de produção:

```bash
# Android
flutter build apk --release

# iOS (apenas macOS com Xcode configurado)
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
