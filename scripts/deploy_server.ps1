# ./scripts/deploy_server.ps1
param ([string]$CommitMessage = "Update: Deploy edu project to production")

# 0. 경로 및 환경 설정
$PROJECT_NAME = "edu"
$DOMAIN = "edu.sogething.com"
Set-Location "C:\github\edu"
Write-Host "Working Directory: C:\github\edu" -ForegroundColor Cyan

# .env 파일에서 SSH 정보 읽기
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

# 기본값 (누락 시 대비)
if (-not $SshKey) { $SshKey = "C:\Users\P6\.ssh\id_rsa" }
if (-not $SshUser) { $SshUser = "ubuntu" }
if (-not $SshHost) { $SshHost = "168.107.52.201" }

# 1. DB 백업 (사용자 요청으로 일단 스킵하지만 구조는 유지)
# Write-Host "[1/4] Backing up local DB..."
# & ".\venv\Scripts\python.exe" ".\local_db_backup.py"

# 2. Git Push
Write-Host "[2/4] Pushing code to server via Git..." -ForegroundColor Yellow
git add .
git commit -m "$CommitMessage"
git push origin main

# 3. Server Commands (사용자 패턴 그대로 이식)
Write-Host "[3/4] Updating server..." -ForegroundColor Yellow

$RemoteCommand = @'
    cd ~/edu &&
    echo "[Step 1] Updating Code (Git Reset)..." &&
    git fetch --all && 
    git reset --hard origin/main && 
    
    echo "[Step 2] Syncing Nginx Config..." &&
    if [ -f ~/edu/nginx_edu.sogething.conf ]; then
        sudo cp ~/edu/nginx_edu.sogething.conf /etc/nginx/sites-available/edu.sogething &&
        sudo ln -sf /etc/nginx/sites-available/edu.sogething /etc/nginx/sites-enabled/ &&
        sudo nginx -t &&
        sudo systemctl reload nginx;
    else
        echo "⚠️ Nginx config file not found, skipping...";
    fi || echo "⚠️ Nginx check failed (likely SSL cert), proceeding to next steps..." &&

    echo "[Step 3] Installing Dependencies & Building (Backend)..." &&
    [ ! -d "venv" ] && python3 -m venv venv &&
    ./venv/bin/pip install -r back/requirements.txt &&

    echo "[Step 4] Installing Dependencies & Building (Frontend)..." &&
    cd front &&
    npm install &&
    npm run build &&
    cd .. &&

    echo "[Step 5] Managing PM2 Processes (edu-back & edu-front)..." &&
    # 백엔드: 있으면 reload, 없으면 start
    if pm2 describe edu-back > /dev/null 2>&1; then
        pm2 reload edu-back;
    else
        pm2 start "./venv/bin/uvicorn main:app --host 0.0.0.0 --port 8700" --name "edu-back" --cwd "~/edu/back";
    fi &&

    # 프론트엔드: 있으면 restart, 없으면 start (3700포트)
    if pm2 describe edu-front > /dev/null 2>&1; then
        pm2 restart edu-front;
    else
        cd front && pm2 start "npm run dev -- --host 0.0.0.0 --port 3700" --name "edu-front" && cd ..;
    fi &&
    
    echo "[Step 6] Final Status..." &&
    pm2 list
'@

# 사용자 요청 정규식 처리 방식 (중복 Replace 포함 패턴 유지)
$NormalizedCommand = $RemoteCommand.Replace("`r", "").Replace("`n", " ")
$NormalizedCommand = $RemoteCommand.Replace("`r", "").Replace("`n", " ")
ssh -i "$SshKey" "$SshUser@${SshHost}" "$NormalizedCommand"

Write-Host "`nDeployment Completed!" -ForegroundColor Green
Write-Host "Check status: ssh -i '$SshKey' $SshUser@${SshHost} 'pm2 list'" -ForegroundColor Blue
