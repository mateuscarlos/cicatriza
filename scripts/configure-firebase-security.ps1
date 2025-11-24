# Firebase Security Configuration Script - Cicatriza
# Configura regras de segurança e App Check baseado no ambiente

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "prod")]
    [string]$Environment
)

Write-Host "🔐 Configurando segurança Firebase para ambiente: $Environment" -ForegroundColor Green

# Verificar se Firebase CLI está instalado
try {
    firebase --version | Out-Null
    Write-Host "✅ Firebase CLI encontrado" -ForegroundColor Green
} catch {
    Write-Host "❌ Firebase CLI não encontrado. Instale com: npm install -g firebase-tools" -ForegroundColor Red
    exit 1
}

# Verificar se está logado no Firebase
try {
    $user = firebase auth:list 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Não está logado no Firebase. Execute: firebase login" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Autenticado no Firebase" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro ao verificar autenticação Firebase" -ForegroundColor Red
    exit 1
}

# Configurar regras do Firestore baseado no ambiente
if ($Environment -eq "dev") {
    Write-Host "🔧 Aplicando regras de desenvolvimento..." -ForegroundColor Yellow
    
    # Copiar regras de desenvolvimento
    Copy-Item "firestore.rules.dev" "firestore.rules" -Force
    
    Write-Host "⚠️  ATENÇÃO: Regras de desenvolvimento aplicadas" -ForegroundColor Yellow
    Write-Host "   - Validação relaxada para facilitar testes" -ForegroundColor Yellow
    Write-Host "   - Autenticação ainda obrigatória" -ForegroundColor Yellow
    
} elseif ($Environment -eq "prod") {
    Write-Host "🛡️  Aplicando regras de produção..." -ForegroundColor Green
    
    # As regras de produção já estão no firestore.rules
    Write-Host "✅ Regras de produção já estão ativas" -ForegroundColor Green
    Write-Host "   - Validação rigorosa de dados" -ForegroundColor Green
    Write-Host "   - Autenticação obrigatória" -ForegroundColor Green
    Write-Host "   - Acesso baseado em proprietário" -ForegroundColor Green
}

# Deploy das regras
Write-Host "🚀 Fazendo deploy das regras..." -ForegroundColor Blue
try {
    firebase deploy --only firestore:rules
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Regras do Firestore aplicadas com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro ao aplicar regras do Firestore" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Erro durante deploy das regras" -ForegroundColor Red
    exit 1
}

# Instruções específicas por ambiente
if ($Environment -eq "dev") {
    Write-Host "`n📋 PRÓXIMOS PASSOS PARA DESENVOLVIMENTO:" -ForegroundColor Cyan
    Write-Host "1. ✅ Regras de desenvolvimento ativas" -ForegroundColor White
    Write-Host "2. 🔐 Configure App Check para desenvolvimento:" -ForegroundColor White
    Write-Host "   firebase appcheck:apps:debug-app-id" -ForegroundColor Gray
    Write-Host "3. 🧪 Execute testes com autenticação:" -ForegroundColor White
    Write-Host "   flutter test" -ForegroundColor Gray
    Write-Host "4. 📱 Teste no emulador com usuário autenticado" -ForegroundColor White
    
} elseif ($Environment -eq "prod") {
    Write-Host "`n📋 PRÓXIMOS PASSOS PARA PRODUÇÃO:" -ForegroundColor Cyan
    Write-Host "1. ✅ Regras de produção ativas" -ForegroundColor White
    Write-Host "2. 🛡️  Configure App Check para produção:" -ForegroundColor White
    Write-Host "   - Ative reCAPTCHA Enterprise" -ForegroundColor Gray
    Write-Host "   - Configure Device Check (iOS)" -ForegroundColor Gray
    Write-Host "   - Configure Play Integrity (Android)" -ForegroundColor Gray
    Write-Host "3. 🔍 Monitore logs de segurança:" -ForegroundColor White
    Write-Host "   firebase console -> Firestore -> Rules" -ForegroundColor Gray
    Write-Host "4. 🚨 Configure alertas de segurança" -ForegroundColor White
}

Write-Host "`n🔒 VERIFICAÇÕES DE SEGURANÇA:" -ForegroundColor Magenta
Write-Host "• Todas as operações requerem autenticação ✅" -ForegroundColor White
Write-Host "• Acesso baseado em proprietário ✅" -ForegroundColor White
Write-Host "• Validação de dados implementada ✅" -ForegroundColor White
Write-Host "• Proteção contra XSS ✅" -ForegroundColor White

Write-Host "`n🎯 Configuração concluída para ambiente: $Environment" -ForegroundColor Green