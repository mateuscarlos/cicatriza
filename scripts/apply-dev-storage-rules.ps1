# Script para aplicar regras de desenvolvimento do Firebase Storage
# Execute este arquivo no PowerShell para configurar regras mais permissivas durante o desenvolvimento

Write-Host "🔧 Configurando regras de desenvolvimento do Firebase Storage..." -ForegroundColor Yellow

# Verificar se Firebase CLI está instalado
try {
    $firebaseVersion = firebase --version
    Write-Host "✅ Firebase CLI encontrado: $firebaseVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Firebase CLI não encontrado. Instale primeiro:" -ForegroundColor Red
    Write-Host "npm install -g firebase-tools" -ForegroundColor White
    exit 1
}

# Fazer backup das regras atuais
if (Test-Path "storage.rules") {
    Copy-Item "storage.rules" "storage.rules.backup" -Force
    Write-Host "📄 Backup das regras atuais criado: storage.rules.backup" -ForegroundColor Cyan
}

# Aplicar regras de desenvolvimento
if (Test-Path "storage.rules.dev") {
    Copy-Item "storage.rules.dev" "storage.rules" -Force
    Write-Host "🔄 Regras de desenvolvimento aplicadas" -ForegroundColor Green
    
    # Deploy das regras
    Write-Host "🚀 Aplicando regras no Firebase..." -ForegroundColor Yellow
    firebase deploy --only storage
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Regras de desenvolvimento aplicadas com sucesso!" -ForegroundColor Green
        Write-Host "" 
        Write-Host "⚠️  IMPORTANTE: Estas são regras PERMISSIVAS para desenvolvimento." -ForegroundColor Yellow
        Write-Host "   Antes de ir para produção, restaure as regras originais:" -ForegroundColor Yellow
        Write-Host "   Copy-Item storage.rules.backup storage.rules -Force" -ForegroundColor White
        Write-Host "   firebase deploy --only storage" -ForegroundColor White
    } else {
        Write-Host "❌ Erro ao aplicar regras. Verifique sua configuração do Firebase." -ForegroundColor Red
    }
} else {
    Write-Host "❌ Arquivo storage.rules.dev não encontrado!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Para reverter para as regras de produção:" -ForegroundColor Cyan
Write-Host "Copy-Item storage.rules.backup storage.rules -Force" -ForegroundColor White
Write-Host "firebase deploy --only storage" -ForegroundColor White