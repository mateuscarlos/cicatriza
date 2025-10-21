# Validação dos Marcos M0 e M1

## M0

- Login Google/Microsoft ainda não existe: `lib/data/repositories/auth_repository_impl.dart` mantém `signInWithGoogle()` e `signInWithMicrosoft()` lançando `UnimplementedError`, e a tela `lib/presentation/pages/login_page.dart` apenas redireciona com `Navigator.pushReplacementNamed` sem autenticar nem atualizar perfil. Além disso, `lib/core/di/injection_container.dart` desativa explicitamente os serviços Firebase. Com isso, os três itens do DoD (login, perfil em `users/{uid}`, regras testadas via emulador) não são atendidos.
- CI não foi configurada: não há workflows em `.github/workflows`, então o requisito "CI (analyze + test) verde, sem warnings" segue vazio.
- Observabilidade parcial: `lib/main.dart` habilita Crashlytics, mas não há inicialização/uso do `FirebaseAnalytics` prometido no DoD.
- Documentação exigida ausente: nenhum `docs/README_M0.md`, nem scripts de bootstrap descritos.

## M1

- Captura de fotos não sai do aparelho: `CreateAssessmentEvent` carrega `photoPaths`, porém nem o `AssessmentBloc` nem `AssessmentRepositoryOffline` (ou outro ponto) fazem upload para o Storage ou criam documentos `media/{mid}`; assim fica faltando compressão + upload + thumbnail (mesmo com a Function pronta em `functions/src/index.ts`).
- "Offline-first com sync" está incompleto: os repositórios offline (`patient_repository_offline.dart`, `wound_repository_offline.dart`, `assessment_repository_offline.dart`) só tentam sincronizar quando `_hasRemoteAccess` detecta usuário autenticado. Como o login continua inexistente, `_auth.currentUser` é sempre `null`, o owner cai no fallback local e nada sobe para o Firestore — requisito de fluxo online+offline não cumprido.
- Testes do DoD não implementados: `test/widget_test.dart` é apenas um stub e não há unit/widget/integration cobrindo as regras de validação, sync ou autenticação.
- Documentação M1 também faltante: não existe `docs/README_M1.md` com instruções atualizadas.
- Regras e índices evoluídos (`firestore.rules`, `storage.rules`, `firestore.indexes.json`) estão versionados, mas sem automação ou testes instrumentados fica pendente validar se estão realmente aplicados.

## Próximos passos sugeridos

1. Implementar e testar autenticação Google/Microsoft, habilitar criação de perfil e reativar serviços Firebase no DI.
2. Subir pipeline de upload (compressão + Storage + doc `media`) e conectar com a Function de thumbnail.
3. Colocar uma rotina de sync que funcione mesmo quando o app inicia offline, garantindo flush ao Firestore após login.
4. Entregar os READMEs do marco e configurar um workflow básico (`flutter analyze` + `flutter test`) para fechar o DoD.
5. Criar a suíte mínima de testes (unitária para validações, widget para telas-chave e integração com emuladores).
