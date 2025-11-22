# Configuração do Firebase App Check

## Configurações no Firebase Console

### 1. Ativar App Check
1. Acesse o [Firebase Console](https://console.firebase.google.com)
2. Selecione seu projeto Cicatriza
3. Vá para **App Check** no menu lateral
4. Clique em **Começar**

### 2. Configurar para Android
1. Selecione seu app Android
2. Escolha **Play Integrity** como provedor
3. Para desenvolvimento, você pode usar **Debug tokens**:
   - Execute o app em modo debug
   - Copie o token de debug dos logs
   - Adicione o token na seção "Debug tokens"

### 3. Configurar para iOS  
1. Selecione seu app iOS
2. Escolha **App Attest** como provedor
3. Para desenvolvimento, adicione debug tokens similares ao Android

### 4. Configurar Serviços Firebase
Após ativar o App Check, configure quais serviços devem usar:

1. **Firestore**: 
   - Vá para Firestore > Rules
   - As regras já devem incluir verificação de autenticação
   
2. **Firebase Storage**:
   - Vá para Storage > Rules  
   - As regras já devem incluir verificação de autenticação

3. **Realtime Database** (se usado):
   - Configure nas regras do Realtime Database

## Configuração na Aplicação Flutter

### Dependências Adicionadas
```yaml
dependencies:
  firebase_app_check: ^0.3.2+4
```

### Implementação
- ✅ `AppCheckService` criado em `lib/core/services/app_check_service.dart`
- ✅ Inicialização configurada no `main.dart`
- ✅ Configuração automática para debug/release

### Como Funciona

#### Modo Debug
- Usa `AndroidProvider.debug` e `AppleProvider.debug`
- Gera tokens de debug que devem ser registrados no Firebase Console
- Ideal para desenvolvimento e testes

#### Modo Release  
- Usa `AndroidProvider.playIntegrity` e `AppleProvider.appAttest`
- Usa verificação real da integridade do app
- Necessário para produção

### Obter Debug Token

1. Execute o app em modo debug
2. Verifique os logs para o token
3. Copie o token e adicione no Firebase Console

### Troubleshooting

#### Erro "App Check token is invalid"
- Verifique se o App Check está ativado no Firebase Console
- Confirme se o debug token foi adicionado (modo debug)
- Verifique se o app está assinado corretamente (modo release)

#### Erro de inicialização
- Confirme se o Firebase foi inicializado antes do App Check
- Verifique se todas as dependências estão atualizadas

## Próximos Passos

1. ✅ Firebase App Check configurado na aplicação
2. ⏳ Registrar debug tokens no Firebase Console
3. ⏳ Testar em modo debug
4. ⏳ Configurar para produção com Play Integrity/App Attest
5. ⏳ Testar funcionalidades do Firestore/Storage com App Check ativo

## Documentação Adicional
- [Firebase App Check Documentation](https://firebase.google.com/docs/app-check)
- [Flutter Firebase App Check](https://firebase.flutter.dev/docs/app-check/overview)