# Validação dos Marcos M0 e M1

## M0 - ✅ COMPLETO (100%)

### Implementações Concluídas

✅ **Login Google funcionando**: Implementado em `lib/data/repositories/auth_repository_impl.dart` com OAuth configurado via `GoogleSignInConfig`. Cria perfil automaticamente em `users/{uid}` no primeiro login. Analytics registra evento `login_success`.

✅ **Firebase Analytics inicializado e funcional**: Serviço `AnalyticsService` criado em `lib/core/services/analytics_service.dart`. Integrado com AuthBloc e PatientBloc. Eventos implementados: `login`, `logout`, `patient_create`, `wound_create`, `assessment_create`, `photo_upload`.

✅ **CI/CD configurado**: Pipeline GitHub Actions em `.github/workflows/ci.yml` com:
- Flutter analyze (sem warnings)
- Flutter test com cobertura
- Verificação de formatação
- Build APK debug
- Upload de artifacts

✅ **Regras de segurança testadas**: 
- `firestore.rules` com validações completas (schema, ACL, ownerId)
- `storage.rules` com limites de tamanho e tipo
- Índices em `firestore.indexes.json`
- Testes de validação em `test/firestore_rules_test.dart`

✅ **Observabilidade completa**: 
- Crashlytics capturando erros fatais e de plataforma
- Analytics rastreando eventos principais
- Logger customizado `AppLogger`

✅ **Documentação M0**: Arquivo `docs/README_M0.md` completo com setup, troubleshooting, arquitetura e comandos.

### Decisões Técnicas

🔄 **Login Microsoft REMOVIDO**: Decisão de manter apenas Google Sign-In no M0. Microsoft OAuth será considerado para marcos futuros se necessário. Removido:
- Método `signInWithMicrosoft()` da interface e implementação
- Evento `AuthMicrosoftSignInRequested`
- Handler `_onMicrosoftSignInRequested` no AuthBloc
- Botão de login Microsoft da UI

### DoD M0 - Checklist Final

- [x] Login Google funcionando
- [x] Perfil criado em `users/{uid}`  
- [x] Regras Firestore/Storage aplicadas e testadas
- [x] Estrutura Flutter (tema/rotas/DI/BLoC)
- [x] CI (analyze + test) verde
- [x] Firebase Analytics inicializado
- [x] Crashlytics configurado
- [x] Documentação `README_M0.md`

**Status M0:** ✅ **COMPLETO - 100%**

---

## M1 - ⚠️ PARCIALMENTE COMPLETO (70%)

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
