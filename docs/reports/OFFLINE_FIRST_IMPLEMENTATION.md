# Implementação de Arquitetura Offline-First - Cicatriza

## 📋 Resumo das Alterações

Este documento descreve as alterações implementadas para garantir que a aplicação Cicatriza opere com uma arquitetura **offline-first**, onde todos os dados são salvos localmente primeiro e sincronizados com o Firebase quando há conectividade.

---

## ✅ Arquitetura Já Implementada

A aplicação **já possuía** uma implementação offline-first robusta nos seguintes repositórios:

### Repositórios Offline-First Existentes:

1. **`PatientRepositoryOffline`** - Gerenciamento de pacientes
2. **`WoundRepositoryOffline`** - Gerenciamento de feridas  
3. **`AssessmentRepositoryOffline`** - Gerenciamento de avaliações
4. **`MediaRepositoryOffline`** - Gerenciamento de mídias/fotos

### Padrão Implementado:

Todos seguem o mesmo padrão:
- ✅ Salvam dados no **SQLite local primeiro**
- ✅ Enfileiram operações de sincronização na tabela `sync_ops`
- ✅ Tentam sincronizar com Firestore quando há conectividade
- ✅ Gerenciam retry automático em caso de falha
- ✅ Suportam operações offline completas

---

## 🆕 Novas Implementações

### 1. **SyncService** (`lib/core/services/sync_service.dart`)

Serviço centralizado para gerenciar sincronização offline-first:

#### Funcionalidades:
- ✅ **Sincronização periódica automática** (a cada 5 minutos)
- ✅ **Sincronização ao reconectar** - monitora mudanças de conectividade
- ✅ **Processamento de fila** - processa operações pendentes com retry
- ✅ **Estatísticas de sincronização** - monitora estado da fila
- ✅ **Limpeza de operações falhadas** - remove operações que excederam tentativas máximas

#### Uso:
```dart
final syncService = SyncService();

// Iniciar sincronização periódica
syncService.startPeriodicSync();

// Sincronizar manualmente
final result = await syncService.syncAll();

// Obter estatísticas
final stats = await syncService.getStats();

// Parar sincronização
syncService.stopPeriodicSync();
```

---

### 2. **LocalStorageService** (`lib/core/services/local_storage_service.dart`)

Serviço para gerenciar armazenamento local de imagens:

#### Funcionalidades:
- ✅ **Solicita permissões de armazenamento** - compatível com Android 13+
- ✅ **Salva imagens localmente** - antes de fazer upload
- ✅ **Gerencia diretório de imagens** - organizado em `wound_images/`
- ✅ **Verifica e deleta imagens**
- ✅ **Fornece estatísticas** - quantidade e tamanho das imagens

#### Uso:
```dart
final storageService = LocalStorageService();

// Solicitar permissão
final hasPermission = await storageService.requestStoragePermission();

// Salvar imagem localmente
final localPath = await storageService.saveImageLocally(
  sourcePath: '/path/to/image.jpg',
  fileName: 'wound_123.jpg',
);

// Obter informações de armazenamento
final info = await storageService.getStorageInfo();
print('Total de imagens: ${info.totalImages}');
print('Tamanho total: ${info.totalSizeMB} MB');
```

---

## 📦 Dependências Adicionadas

### `pubspec.yaml`:
```yaml
dependencies:
  permission_handler: ^11.3.1  # Gerenciamento de permissões
```

---

## 🔧 Permissões Android

### `android/app/src/main/AndroidManifest.xml`:

Adicionadas permissões para:
- ✅ **Câmera** - captura de fotos
- ✅ **Internet e conectividade** - sincronização
- ✅ **Armazenamento** - salvar imagens localmente
  - Android ≤ 12: `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`
  - Android ≥ 13: `READ_MEDIA_IMAGES` (permissão granular)

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
                 android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
                 android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

---

## 🔄 Fluxo de Dados Offline-First

### Salvamento de Dados:

```
1. Usuário cria/edita dados
   ↓
2. Salva no SQLite local (instantâneo)
   ↓
3. Enfileira operação de sincronização
   ↓
4. Tenta sincronizar com Firebase imediatamente (se online)
   ↓
5. Se falhar, retry automático via SyncService
```

### Salvamento de Imagens:

```
1. Usuário tira foto ou seleciona imagem
   ↓
2. Salva arquivo localmente (app directory)
   ↓
3. Registra no SQLite com status 'pending'
   ↓
4. Upload em background quando online
   ↓
5. Atualiza registro com URL e status 'completed'
```

---

## 🗄️ Estrutura do Banco SQLite

### Tabelas Principais:

1. **`patients`** - Dados dos pacientes
2. **`wounds`** - Feridas dos pacientes
3. **`assessments`** - Avaliações das feridas
4. **`media`** - Fotos das avaliações
5. **`sync_ops`** - Fila de sincronização

### Tabela `media` (campos relevantes):

```sql
CREATE TABLE media (
  id TEXT PRIMARY KEY,
  assessment_id TEXT NOT NULL,
  local_path TEXT,              -- Caminho local da imagem
  storage_path TEXT NOT NULL,   -- Caminho no Firebase Storage
  download_url TEXT,            -- URL pública após upload
  upload_status TEXT,           -- 'pending', 'uploading', 'completed', 'failed'
  upload_progress REAL,         -- Progresso 0.0 a 1.0
  retry_count INTEGER,          -- Tentativas de upload
  error_message TEXT,           -- Mensagem de erro se falhou
  ...
);
```

---

## 📝 Próximos Passos Recomendados

### Integração com a UI:

1. **Indicador de Status de Sincronização**
   - Mostrar ícone de sincronização na UI
   - Exibir número de itens pendentes

2. **Upload de Fotos em Background**
   - Integrar `LocalStorageService` com o fluxo de captura de fotos
   - Mostrar progresso de upload

3. **Notificações de Sincronização**
   - Alertar usuário quando houver falhas persistentes
   - Notificar quando sincronização for concluída após offline

4. **Configurações de Sincronização**
   - Permitir usuário configurar frequência de sincronização
   - Opção para sincronizar apenas via Wi-Fi

---

## 🧪 Testes Recomendados

1. **Modo Offline Completo**
   - Criar pacientes, feridas e avaliações sem conectividade
   - Verificar se dados aparecem na UI
   - Reconectar e verificar sincronização

2. **Captura de Fotos Offline**
   - Tirar fotos sem conectividade
   - Verificar salvamento local
   - Reconectar e verificar upload

3. **Interrupção de Upload**
   - Iniciar upload de foto
   - Desconectar no meio do processo
   - Reconectar e verificar retry

4. **Conflitos de Dados**
   - Editar mesmo registro em dois dispositivos offline
   - Reconectar ambos e verificar tratamento de conflito

---

## 🐛 Debug e Monitoramento

### Logs Importantes:

Todos os serviços usam `AppLogger` para logs detalhados:

```dart
AppLogger.info('[SyncService] Sincronização concluída: 5 sucessos, 0 falhas');
AppLogger.warning('[LocalStorage] Permissão de armazenamento negada');
AppLogger.error('[MediaRepository] Falha no upload', error: e, stackTrace: st);
```

### Verificar Estado da Sincronização:

```dart
final stats = await syncService.getStats();
print('Operações pendentes: ${stats.totalPending}');
print('Precisa retry: ${stats.needsRetry}');
print('Excedeu máximo: ${stats.overMaxRetries}');
```

---

## ✅ Checklist de Limpeza Realizada

- ✅ `flutter clean` - Cache do Flutter limpo
- ✅ `flutter pub get` - Dependências atualizadas
- ✅ `gradlew clean` - Cache do Gradle limpo
- ✅ Banco SQLite será resetado na próxima execução (código de debug ativo)

---

## 🚀 Executar a Aplicação

```bash
flutter run --debug
```

A aplicação agora está totalmente configurada para operar offline-first! 🎉
