# ./scripts/deploy_server.ps1
# 이 스크립트는 로컬의 소스 코드와 DB 데이터를 운영 서버(Oracle Cloud)에 완전히 동기화합니다.

# 0. 경로 및 환경 설정
$PROJECT_NAME = "edu"
$DOMAIN = "edu.sogething.com"
Set-Location "C:\github\edu"
Write-Host "Working Directory: C:\github\edu" -ForegroundColor Cyan

# SSH 접속 정보 (직접 관리)
$SshKey = "C:\Users\P6\.ssh\id_rsa"
$SshUser = "ubuntu"
$SshHost = "168.107.52.201"

# 1. Database Sync - Local Backup (로컬 데이터를 SQL로 덤프)
Write-Host "[1/3] Backing up local database..." -ForegroundColor Yellow
# 로컬의 Docker DB 컨테이너에서 데이터를 추출하여 local_db.sql을 생성합니다.
python local_db_backup.py
if ($LASTEXITCODE -ne 0) { Write-Error "Local DB backup failed!"; exit }

# 2. Git Push (로컬 소스 + DB 덤프 전송)
Write-Host "[2/3] Pushing changes to server via Git..." -ForegroundColor Yellow
git add .
git commit -m "Deploy: Update source and database" 2>$null # 커밋할게 없어도 진행
git push origin main

# 3. Remote Server Commands (서버 배포 및 DB 복원)
Write-Host "[3/3] Updating remote server..." -ForegroundColor Yellow

# [Nginx 초기 설정 가이드 주석]
# 1. Oracle Cloud 콘솔(가이아/VCN)에서 80, 443 포트 수신 규칙(Forwarding)을 먼저 추가해야 합니다.
# 2. 서버 내부에서 'sudo apt install nginx' 후 설정을 적용합니다.
# 3. 인증서(certbot) 등 보안 설정을 마친 설정을 /etc/nginx/sites-available/에 등록합니다.
# 4. 아래 스크립트가 해당 설정을 자동으로 동기화하고 nginx를 리로드합니다.

$RemoteCommand = @'
    cd /home/ubuntu/edu &&
    echo "--- Step 0: Ensuring Docker Containers are Running ---" &&
    sudo docker-compose up -d &&
    echo "--- Step 1: Syncing Source Code ---" &&
    git fetch --all && 
    git reset --hard origin/main && 
    echo "--- Step 2: Syncing Nginx Config ---" &&
    if [ -f /home/ubuntu/edu/nginx_edu.sogething.conf ]; then
        sudo cp /home/ubuntu/edu/nginx_edu.sogething.conf /etc/nginx/sites-available/edu.sogething;
        sudo ln -sf /etc/nginx/sites-available/edu.sogething /etc/nginx/sites-enabled/;
        sudo nginx -t && sudo systemctl reload nginx;
    fi;
    echo "--- Step 3: Database Synchronization ---" &&
    python3 server_db_backup.py &&
    python3 server_db_restore.py &&
    echo "--- Step 4: Installing & Building ---" &&
    if [ ! -d venv ]; then python3 -m venv venv; fi &&
    ./venv/bin/pip install -r back/requirements.txt &&
    cd front && npm install && npm run build && cd ..;
    echo "--- Step 5: Restarting Services ---";
    pm2 delete edu-back edu-front npm > /dev/null 2>&1 || true;
    pm2 start /home/ubuntu/edu/venv/bin/python --name edu-back --cwd /home/ubuntu/edu/back -- -m uvicorn main:app --host 0.0.0.0 --port 8700;
    pm2 start npm --name edu-front --cwd /home/ubuntu/edu/front -- run dev -- --host 0.0.0.0 --port 3700;
    pm2 list;
    pm2 save
'@

# 명령어 한 줄 변환 (주석이 이미 제거된 상태이므로 개행만 공백으로 치환)
$NormalizedCommand = $RemoteCommand.Replace("`r", "").Replace("`n", " ")
ssh -i "$SshKey" "$SshUser@${SshHost}" "$NormalizedCommand"

Write-Host "`nDeployment & DB Sync Completed!" -ForegroundColor Green
Write-Host "URL: https://$DOMAIN" -ForegroundColor Blue
