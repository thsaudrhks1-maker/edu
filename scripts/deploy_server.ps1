# ./scripts/deploy_server.ps1

# ========================================================
# EDU - Deployment Script (Git & DB Sync)
# ========================================================

param ([string]$CommitMessage = "Update: Deploy EDU project to production")

# 0. 경로 설정
$PROJECT_ROOT = "C:\github\edu"
Set-Location $PROJECT_ROOT
Write-Host "Working Directory: $PROJECT_ROOT" -ForegroundColor Cyan

# .env에서 SSH 정보 및 DB 설정 로드
$EnvPath = Join-Path (Get-Location) ".env"
if (Test-Path $EnvPath) {
    Get-Content $EnvPath | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
            $parts = $line.Split("=", 2)
            $key = $parts[0].Trim()
            $value = $parts[1].Trim().Trim('"').Trim("'")
            if ($key -eq "SSH_KEY_PATH") { $SshKey = $value }
            if ($key -eq "SSH_USER") { $SshUser = $value }
            if ($key -eq "SSH_HOST") { $SshHost = $value }
        }
    }
}

# 기본값 설정 (SSH 설정이 기록된 경우)
if (-not $SshKey) { $SshKey = "C:\Users\P6\.ssh\id_rsa" }
if (-not $SshUser) { $SshUser = "ubuntu" }
if (-not $SshHost) { $SshHost = "168.107.52.201" }

# 1. Local DB Backup
Write-Host "[1/5] Backing up local DB..." -ForegroundColor Yellow
$PythonPath = ".\venv\Scripts\python.exe"
& $PythonPath ".\local_db_backup.py"

if (Test-Path "local_db.sql") {
    Write-Host "[2/5] Sending DB dump to server..." -ForegroundColor Yellow
    scp -i "$SshKey" "local_db.sql" "$SshUser@${SshHost}:~/edu/local_db.sql"
} else {
    Write-Host "Warning: local_db.sql not found!" -ForegroundColor Red
}

# 2. Local Front Build (Optional - for quick update)
Write-Host "[3/5] Building Frontend Locally..." -ForegroundColor Yellow
cd front; npm run build; cd ..

# 3. Git Push
Write-Host "[4/5] Pushing code to server..." -ForegroundColor Yellow
git add .
git commit -m "$CommitMessage"
git push origin main

# 4. Server Commands (안정적인 실행을 위해 임시 스크립트 전송 방식 사용)
Write-Host "[5/5] Updating server..." -ForegroundColor Yellow

$RemoteCommand = @"
    # 프로젝트 폴더가 없으면 생성/클론
    if [ ! -d ~/edu/.git ]; then
        echo "[Initial Setup] Cloning repository into ~/edu..."
        git clone https://github.com/thsaudrhks1-maker/edu.git ~/edu
    fi

    cd ~/edu && 
    echo "[Step 0] Backing up REAL Server DB before update..." &&
    ~/edu/venv/bin/python ~/edu/server_db_backup.py &&
    
    echo "[Step 1] Updating Code (Git Reset)..." &&
    git fetch --all && 
    git reset --hard origin/main && 
    
    echo "[Step 2] Syncing Nginx Config..." &&
    if [ -f ~/edu/nginx_edu.sogething.conf ]; then
        sudo cp ~/edu/nginx_edu.sogething.conf /etc/nginx/sites-available/edu.sogething &&
        sudo ln -sf /etc/nginx/sites-available/edu.sogething /etc/nginx/sites-enabled/
        sudo nginx -t && sudo systemctl reload nginx
    else
        echo "⚠️ Nginx config file not found, skipping..."
    fi

    echo "[Step 3] Restoring DB from Local Dump..." &&
    ~/edu/venv/bin/python ~/edu/scripts/server_restore_local.py

    echo "[Step 4] Installing Dependencies & Building & PM2 Processes..." &&
    chmod +x ./scripts/deploy.sh
    ./scripts/deploy.sh
"@

# 임시 파일 생성 및 실행 (개행 문자 문제 해결)
$TempScript = "remote_deploy_run.sh"
$RemoteCommand | Out-File -FilePath $TempScript -Encoding utf8
scp -i "$SshKey" $TempScript "$SshUser@${SshHost}:/tmp/$TempScript"
ssh -i "$SshKey" "$SshUser@${SshHost}" "bash /tmp/$TempScript"
Remove-Item $TempScript

Write-Host "=== Deployment Completed ===" -ForegroundColor Green
Write-Host "Check status: ssh -i '$SshKey' $SshUser@${SshHost} 'pm2 list'" -ForegroundColor Blue
