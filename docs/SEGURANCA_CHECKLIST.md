# ✅ Checklist de Ativação - Módulo de Segurança

Use este checklist para ativar todas as funcionalidades de segurança implementadas.

## 📋 Pré-requisitos

- [ ] Todas as dependências instaladas (`flutter pub get` executado)
- [ ] Firebase configurado no projeto
- [ ] Projeto compilando sem erros

## 🔧 1. Configurar Injeção de Dependências

**Arquivo**: `lib/core/di/service_locator.dart`

```dart
- [ ] Importar serviços de segurança
- [ ] Registrar EncryptionService
- [ ] Registrar RateLimiterService  
- [ ] Registrar SessionService (precisa SharedPreferences)
- [ ] Registrar AuditRepository
- [ ] Atualizar factory do AuthBloc com novos parâmetros
```

**Código de referência**: Ver `docs/SEGURANCA_RESUMO.md`, seção "Registrar Serviços"

## 🔐 2. Atualizar AuthBloc

**Arquivo**: `lib/presentation/blocs/auth_bloc.dart`

```dart
- [ ] Adicionar AuditRepository como dependência
- [ ] Adicionar SessionService como dependência
- [ ] Adicionar RateLimiterService como dependência
- [ ] Atualizar construtor
```

### 2.1 Modificar método `_onEmailSignInRequested`

```dart
- [ ] Adicionar verificação de rate limit ANTES do login
- [ ] Registrar tentativa no rate limiter (sucesso ou falha)
- [ ] Criar sessão após login bem-sucedido
- [ ] Verificar se é novo dispositivo
- [ ] Registrar dispositivo como conhecido se novo
- [ ] Registrar no audit log (login ou loginFailed)
- [ ] Limpar rate limit após sucesso
```

### 2.2 Modificar método `_onGoogleSignInRequested`

```dart
- [ ] Aplicar mesmas verificações do email login
```

### 2.3 Modificar método `_onSignOutRequested`

```dart
- [ ] Registrar logout no audit log
- [ ] Encerrar sessão atual
- [ ] Depois chamar signOut() normalmente
```

### 2.4 Modificar método `_onPasswordResetRequested`

```dart
- [ ] Adicionar verificação de rate limit
- [ ] Registrar tentativa
- [ ] Registrar no audit log
```

**Código de referência**: Ver `lib/presentation/blocs/auth_bloc_with_security.dart`

## 📱 3. Adicionar Rota de Sessões Ativas

**Arquivo**: `lib/core/routing/app_routes.dart`

```dart
- [ ] Adicionar constante activeSessions = '/active-sessions'
- [ ] Adicionar GoRoute para ActiveSessionsPage
- [ ] Passar userId como extra
```

## ⚙️ 4. Adicionar Menu nas Configurações

**Arquivo**: `lib/presentation/pages/settings_page.dart`

```dart
- [ ] Adicionar ListTile "Sessões Ativas"
- [ ] Ícone: Icons.devices
- [ ] Navegação para ActiveSessionsPage com userId
```

## 🔒 5. Implementar Criptografia no Perfil

**Arquivo**: `lib/data/repositories/profile_repository_impl.dart` (ou similar)

### 5.1 Método de salvar perfil

```dart
- [ ] Injetar EncryptionService
- [ ] Criptografar crmCofen antes de salvar
- [ ] Criptografar phone antes de salvar
- [ ] Criptografar address antes de salvar
- [ ] Salvar perfil criptografado no Firestore
```

### 5.2 Método de carregar perfil

```dart
- [ ] Carregar perfil do Firestore
- [ ] Descriptografar crmCofen
- [ ] Descriptografar phone
- [ ] Descriptografar address
- [ ] Retornar perfil descriptografado
```

**Código de referência**: Ver `docs/SEGURANCA_RESUMO.md`, seção "Criptografar Dados no Perfil"

## 📝 6. Testar Funcionalidades

### 6.1 Rate Limiting

```dart
- [ ] Tentar fazer login 6 vezes com senha errada
- [ ] Verificar se mensagem de "aguarde X minutos" aparece
- [ ] Aguardar tempo e tentar novamente
- [ ] Confirmar que funciona após espera
```

### 6.2 Sessões Ativas

```dart
- [ ] Fazer login no app
- [ ] Navegar para "Sessões Ativas" nas configurações
- [ ] Verificar se dispositivo atual aparece marcado
- [ ] Fazer login em outro dispositivo (se possível)
- [ ] Verificar se ambas as sessões aparecem
- [ ] Testar revogar sessão individual
- [ ] Testar "Deslogar de todos"
```

### 6.3 Detecção de Novo Dispositivo

```dart
- [ ] Limpar dados do app
- [ ] Fazer login novamente
- [ ] Verificar se sistema detectou como novo dispositivo
- [ ] Confirmar que dispositivo foi registrado
- [ ] Próximo login não deve detectar como novo
```

### 6.4 Criptografia

```dart
- [ ] Atualizar perfil com CRM, telefone e endereço
- [ ] Verificar no Firebase Console se dados estão criptografados
- [ ] Carregar perfil e verificar se dados aparecem corretamente
- [ ] Confirmar que descriptografia funciona
```

### 6.5 Audit Log

```dart
- [ ] Fazer login
- [ ] Fazer logout
- [ ] Atualizar perfil
- [ ] Verificar no Firebase Console se logs foram criados em users/{uid}/audit_logs
- [ ] Confirmar que informações do dispositivo estão corretas
```

## 🔐 7. Segurança da Chave de Criptografia

### Para Produção (OBRIGATÓRIO)

```dart
- [ ] Criar arquivo .env na raiz do projeto
- [ ] Gerar chave segura de 32 caracteres
- [ ] Adicionar ENCRYPTION_KEY=<sua_chave> no .env
- [ ] Instalar envied package: flutter pub add envied dev:envied_generator
- [ ] Atualizar encryption_service.dart para usar Env
- [ ] Adicionar .env ao .gitignore
- [ ] Executar build_runner: flutter pub run build_runner build
- [ ] Verificar que .env NÃO está sendo commitado
- [ ] Documentar chave em local seguro (1Password, Azure Key Vault, etc.)
```

**⚠️ CRÍTICO**: Nunca commitar a chave de produção no Git!

## 🔔 8. Configurar Notificações (Opcional)

### Firebase Cloud Messaging

```dart
- [ ] Seguir guia oficial: https://firebase.google.com/docs/cloud-messaging/flutter/client
- [ ] Configurar AndroidManifest.xml
- [ ] Configurar Info.plist (iOS)
- [ ] Solicitar permissões ao usuário
- [ ] Obter token FCM
- [ ] Armazenar token no perfil do usuário
- [ ] Implementar envio de notificação quando isNewDevice() == true
- [ ] Testar notificação em dispositivo real
```

## 🧪 9. Testes Unitários (Recomendado)

```dart
- [ ] Criar test/unit/audit_repository_test.dart
- [ ] Criar test/unit/session_service_test.dart
- [ ] Criar test/unit/encryption_service_test.dart
- [ ] Criar test/unit/rate_limiter_service_test.dart
- [ ] Executar: flutter test
- [ ] Confirmar cobertura > 80%
```

## 📚 10. Documentação

```dart
- [ ] Ler docs/SEGURANCA_IMPLEMENTADA.md completamente
- [ ] Ler docs/SEGURANCA_ARQUITETURA.md
- [ ] Compartilhar com equipe
- [ ] Adicionar ao README do projeto
```

## 🚀 11. Deploy

### Desenvolvimento

```dart
- [ ] Todas as funcionalidades testadas localmente
- [ ] Sem erros de compilação
- [ ] Logs funcionando corretamente
```

### Staging

```dart
- [ ] Chave de criptografia diferente de produção
- [ ] Testar em dispositivos reais
- [ ] Testar cenários de múltiplos dispositivos
- [ ] Validar Firebase Rules
```

### Produção

```dart
- [ ] Chave de criptografia única e segura
- [ ] Backup da chave em local seguro
- [ ] Firebase Rules configuradas corretamente
- [ ] Notificações configuradas e testadas
- [ ] Monitoramento de logs ativo
- [ ] Plano de rollback definido
```

## ✅ Verificação Final

```dart
- [ ] Rate limiting funciona
- [ ] Sessões ativas aparecem corretamente
- [ ] Revogar sessão funciona
- [ ] Deslogar de todos funciona
- [ ] Criptografia salva dados corretamente
- [ ] Descriptografia carrega dados corretamente
- [ ] Audit logs sendo criados
- [ ] Novo dispositivo detectado
- [ ] Sem erros no console
- [ ] Sem warnings importantes
- [ ] Performance aceitável
- [ ] UX fluida
```

## 🎉 Conclusão

Quando todos os itens estiverem marcados:

1. ✅ Todas as funcionalidades de segurança estão ativas
2. ✅ Sistema está pronto para uso
3. ✅ Aplicação está mais segura

## 📞 Suporte

Se encontrar problemas:

1. Revisar `docs/SEGURANCA_IMPLEMENTADA.md`
2. Verificar `lib/presentation/blocs/auth_bloc_with_security.dart` (exemplo)
3. Consultar Firebase Console para logs
4. Verificar console do Flutter para erros

---

**Última atualização**: 22 de janeiro de 2025  
**Autor**: Equipe Cicatriza  
**Status**: Pronto para uso
