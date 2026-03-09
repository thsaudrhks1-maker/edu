# ========================================================
# EDU Project - Git Based Deployment Script (Final)
# ========================================================

param ([string]$CommitMessage = "Update: Final deploy sync for EDU project")

# 1. 설정 및 경로
$DOMAIN = "edu.sogething.com"
$SSH_KEY = "C:\Users\P6\.ssh\id_rsa"
$SSH_USER = "ubuntu"
$SSH_HOST = "168.107.52.201"
$REMOTE_PATH = "/home/ubuntu/edu"

Write-Host "=== Starting EDU Project Deployment ($DOMAIN) ===" -ForegroundColor Cyan

# 2. 로컬 빌드
Write-Host "[1/3] Building Frontend Locally..." -ForegroundColor Yellow
cd front
npm run build
if ($LASTEXITCODE -ne 0) { Write-Error "Build failed!"; exit }
cd ..

# 3. Git Push
Write-Host "[2/3] Pushing code to server via Git..." -ForegroundColor Yellow
git add .
git commit -m "$CommitMessage"
git push origin main

# 4. 서버 원격 명령어 실행
Write-Host "[3/3] Updating remote server (Executing deploy.sh)..." -ForegroundColor Yellow

$RemoteCommand = @"
    if [ ! -d "$REMOTE_PATH/.git" ]; then
        echo '[Initial Setup] Cloning repository...'
        rm -rf $REMOTE_PATH
        git clone https://github.com/thsaudrhks1-maker/edu.git $REMOTE_PATH
    fi
    cd $REMOTE_PATH
    echo '--- [Server] Syncing latest code ---'
    git fetch --all && git reset --hard origin/main
    echo '--- [Server] Running deploy.sh ---'
    chmod +x ./scripts/deploy.sh
    ./scripts/deploy.sh
"@

# 개행을 처리하여 안정적으로 전달
$NormalizedCommand = "bash -c '" + $RemoteCommand.Replace("`r", "").Replace("`n", " ; ") + "'"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "$NormalizedCommand"

Write-Host "`n=== Deployment Process Finished! ===" -ForegroundColor Green
