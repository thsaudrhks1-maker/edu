# ========================================================
# EDU Project - Git Based Deployment Script
# ========================================================

param ([string]$CommitMessage = "Update: Deploy edu project to production")

# 1. 설정 및 경로
$DOMAIN = "edu.sogething.com"
$SSH_KEY = "C:\Users\P6\.ssh\id_rsa"
$SSH_USER = "ubuntu"
$SSH_HOST = "168.107.52.201"
$REMOTE_PATH = "~/edu"

Write-Host "=== Starting EDU Project Deployment ($DOMAIN) ===" -ForegroundColor Cyan

# 2. 로컬 빌드 (선택 사항: 서버 부하 방지용)
Write-Host "[1/3] Building Frontend Locally..." -ForegroundColor Yellow
cd front
npm run build
if ($LASTEXITCODE -ne 0) { Write-Error "Build failed!"; exit }
cd ..

# 3. Git Push (전송 속도 및 안정성 확보)
Write-Host "[2/3] Pushing code to server via Git..." -ForegroundColor Yellow
git add .
git commit -m "$CommitMessage"
git push origin main

# 4. 서버 원격 명령어 실행
Write-Host "[3/3] Updating remote server..." -ForegroundColor Yellow

$RemoteCommand = @"
    cd $REMOTE_PATH && 
    echo '[Step 1] Syncing Code (Git Reset)...' &&
    git fetch --all && 
    git reset --hard origin/main && 
    
    echo '[Step 2] Applying Nginx & Service Updates...' &&
    chmod +x ./scripts/deploy.sh &&
    ./scripts/deploy.sh
"@

# SSH 명령 전송 (개행 제거 처리)
$NormalizedCommand = $RemoteCommand.Replace("`r", "").Replace("`n", " ")
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "$NormalizedCommand"

Write-Host "`n=== Deployment Completed Successfully! ===" -ForegroundColor Green
Write-Host "URL: https://$DOMAIN" -ForegroundColor Blue
