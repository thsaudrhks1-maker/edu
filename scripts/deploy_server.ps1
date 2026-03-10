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

# 1. Git Push
Write-Host "[1/2] Pushing code to server via Git..." -ForegroundColor Yellow
git add .
git commit -m "$CommitMessage"
git push origin main

# 2. Server Commands (PM2 이름 및 경로 완전 수정)
Write-Host "[2/2] Updating server..." -ForegroundColor Yellow

$RemoteCommand = @'
    cd ~/edu &&
    echo "--- Step 1 Updating Code ---" &&
    git fetch --all && 
    git reset --hard origin/main && 
    echo "--- Step 2 Syncing Nginx Config ---" &&
    if [ -f ~/edu/nginx_edu.sogething.conf ]; then
        sudo cp ~/edu/nginx_edu.sogething.conf /etc/nginx/sites-available/edu.sogething &&
        sudo ln -sf /etc/nginx/sites-available/edu.sogething /etc/nginx/sites-enabled/ &&
        sudo nginx -t &&
        sudo systemctl reload nginx;
    else
        echo "Nginx skipping...";
    fi &&
    echo "--- Step 3 Installing Dependencies ---" &&
    if [ ! -d venv ]; then python3 -m venv venv; fi &&
    ./venv/bin/pip install -r back/requirements.txt &&
    cd front && npm install && npm run build && cd .. &&
    echo "--- Step 4 Cleaning & Restarting PM2 Processes ---" &&
    pm2 delete edu-back edu-front npm > /dev/null 2>&1 || true &&
    pm2 start "~/edu/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8700" --name "edu-back" --cwd "~/edu/back" &&
    pm2 start "npm --name edu-front -- run dev -- --host 0.0.0.0 --port 3700" --cwd "~/edu/front" &&
    echo "--- Step 5 Final Status ---" &&
    pm2 list &&
    pm2 save
'@

# 사용자 요청 정규식 처리 방식 (Replace 중복 적용 유지)
$NormalizedCommand = $RemoteCommand.Replace("`r", "").Replace("`n", " ")
$NormalizedCommand = $RemoteCommand.Replace("`r", "").Replace("`n", " ")
ssh -i "$SshKey" "$SshUser@${SshHost}" "$NormalizedCommand"

Write-Host "`nDeployment Completed!" -ForegroundColor Green
Write-Host "Check status: ssh -i '$SshKey' $SshUser@${SshHost} 'pm2 list'" -ForegroundColor Blue
