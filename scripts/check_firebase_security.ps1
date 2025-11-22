#!/usr/bin/env pwsh
# Script auxiliar para verificar segurança do Firebase antes de commit

Write-Host "🔒 Verificando segurança do Firebase..." -ForegroundColor Cyan

$hasIssues = $false

# Verificar se google-services.json está presente mas NÃO está no .gitignore
if (Test-Path "android/app/google-services.json") {
    $gitStatus = git status --porcelain android/app/google-services.json 2>&1
    # Ignorar se está marcado para exclusão (D)
    if ($gitStatus -match "^D\s+" -or $gitStatus -match "^!!") {
        Write-Host "✅ google-services.json está protegido (excluído do Git ou no .gitignore)" -ForegroundColor Green
    } elseif ($gitStatus) {
        Write-Host "❌ ERRO: google-services.json está sendo rastreado pelo Git!" -ForegroundColor Red
        Write-Host "   Execute: git rm --cached android/app/google-services.json" -ForegroundColor Yellow
        $hasIssues = $true
    } else {
        Write-Host "✅ google-services.json está no .gitignore" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  google-services.json não encontrado (use o template para criar)" -ForegroundColor Yellow
}

# Verificar se GoogleService-Info.plist está presente mas NÃO está no .gitignore
if (Test-Path "ios/Runner/GoogleService-Info.plist") {
    $gitStatus = git status --porcelain ios/Runner/GoogleService-Info.plist 2>&1
    if ($gitStatus -and $gitStatus -notmatch "^!!") {
        Write-Host "❌ ERRO: GoogleService-Info.plist está sendo rastreado pelo Git!" -ForegroundColor Red
        Write-Host "   Execute: git rm --cached ios/Runner/GoogleService-Info.plist" -ForegroundColor Yellow
        $hasIssues = $true
    } else {
        Write-Host "✅ GoogleService-Info.plist está no .gitignore" -ForegroundColor Green
    }
}

# Verificar se firebase_options.dart está presente mas NÃO está no .gitignore
if (Test-Path "lib/firebase_options.dart") {
    $gitStatus = git status --porcelain lib/firebase_options.dart 2>&1
    if ($gitStatus -and $gitStatus -notmatch "^!!") {
        Write-Host "❌ ERRO: firebase_options.dart está sendo rastreado pelo Git!" -ForegroundColor Red
        Write-Host "   Execute: git rm --cached lib/firebase_options.dart" -ForegroundColor Yellow
        $hasIssues = $true
    } else {
        Write-Host "✅ firebase_options.dart está no .gitignore" -ForegroundColor Green
    }
}

# Verificar se há API keys expostas em arquivos staged
$stagedFiles = git diff --cached --name-only
foreach ($file in $stagedFiles) {
    # Ignorar arquivos que estão sendo deletados
    $fileStatus = git status --porcelain $file
    if ($fileStatus -match "^D\s+") {
        continue
    }
    
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if ($content -match "AIza[0-9A-Za-z_-]{35}") {
            Write-Host "❌ ERRO: API Key do Google encontrada em $file" -ForegroundColor Red
            Write-Host "   NUNCA commitar API keys!" -ForegroundColor Yellow
            $hasIssues = $true
        }
    }
}

Write-Host ""
if ($hasIssues) {
    Write-Host "❌ Problemas de segurança encontrados!" -ForegroundColor Red
    Write-Host "   Leia: docs/SECURITY_FIREBASE.md" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ Verificação de segurança passou!" -ForegroundColor Green
    Write-Host "   Arquivos sensíveis estão protegidos." -ForegroundColor Gray
    exit 0
}
