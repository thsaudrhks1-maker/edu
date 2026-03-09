# ============================================================
# Oracle Cloud Server Deployment Script
# ============================================================

# 1. SSH Configuration
$SSH_KEY_PATH = "C:\Users\P6\.ssh\id_rsa"
$SSH_USER = "ubuntu"
$SSH_HOST = "168.107.52.201"
$REMOTE_PATH = "/home/ubuntu/edu" # 서버 배포 경로

Write-Host "=== Starting Deployment to Oracle Cloud ($SSH_HOST) ===" -ForegroundColor Cyan

# 2. Local Frontend Build
Write-Host "`n[Step 1] Building Frontend Locally..." -ForegroundColor Yellow
cd front
npm run build
if ($LASTEXITCODE -ne 0) { Write-Error "Frontend build failed!"; exit }
cd ..

# 3. Transfer Files to Server (using scp)
# Note: node_modules, venv, pycache 등은 전송에서 제외합니다.
Write-Host "`n[Step 2] Transferring Files to Server..." -ForegroundColor Yellow

# - Frontend (dist 폴더만)
scp -i $SSH_KEY_PATH -r front/dist/* "${SSH_USER}@${SSH_HOST}:${REMOTE_PATH}/front/dist/"

# - Backend (back 폴더 파일들, __pycache__ 제외 권장)
scp -i $SSH_KEY_PATH -r back/* "${SSH_USER}@${SSH_HOST}:${REMOTE_PATH}/back/"

# - Nginx Config (루트에 있는 파일)
scp -i $SSH_KEY_PATH nginx_edu.sogething.conf "${SSH_USER}@${SSH_HOST}:${REMOTE_PATH}/"

# 4. Remote Server Commands
Write-Host "`n[Step 3] Applying Changes on Server..." -ForegroundColor Yellow

# SSH를 통해 서버에서 실행할 명령어를 정의합니다.
$REMOTE_COMMANDS = @"
    # Nginx 설정 적용
    sudo cp ${REMOTE_PATH}/nginx_edu.sogething.conf /etc/nginx/sites-available/edu.sogething
    sudo ln -sf /etc/nginx/sites-available/edu.sogething /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl reload nginx

    # 백엔드 서비스(FastAPI) 재시작 (Port 8700)
    cd ${REMOTE_PATH}/back
    source ../venv/bin/activate
    pkill -f "uvicorn main:app" || true
    nohup uvicorn main:app --host 0.0.0.0 --port 8700 > backend.log 2>&1 &
    
    echo "Server-side commands executed successfully."
"@

ssh -i $SSH_KEY_PATH "${SSH_USER}@${SSH_HOST}" $REMOTE_COMMANDS

Write-Host "`n=== Deployment Completed Successfully! ===" -ForegroundColor Green
Write-Host "URL: https://edu.sogething.com" -ForegroundColor Blue
