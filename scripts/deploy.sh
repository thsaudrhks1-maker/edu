#!/bin/bash

# 설정
PROJECT_DIR=~/smart_security
BACK_PORT=8600
FRONT_PORT=3600

echo "🚀 Starting Deployment Process..."

# 프로젝트 디렉토리로 이동
cd $PROJECT_DIR || exit

# 1. Backend Setup (가상환경 및 라이브러리 설치)
echo "--- [Backend] Setting up dependencies ---"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "Created virtual environment."
fi

source venv/bin/activate
pip install -r requirements.txt

# 2. Frontend Setup (패키지 설치)
echo "--- [Frontend] Installing dependencies ---"
cd front
npm install
cd ..

# 3. PM2 Process Management (서버 재시작)
echo "--- [PM2] Managing Processes ---"

# Smart-Back (Backend: 8500)
# 이미 떠있으면 reload, 없으면 start
pm2 describe smart-back > /dev/null
if [ $? -eq 0 ]; then
    echo "Reloading smart-back..."
    pm2 reload smart-back
else
    echo "Starting smart-back..."
    # venv 내부의 uvicorn을 절대 경로로 실행
    pm2 start "$PROJECT_DIR/venv/bin/uvicorn back.main:app --host 0.0.0.0 --port $BACK_PORT" --name "smart-back"
fi

# Smart-Front (Frontend: 3500)
pm2 describe smart-front > /dev/null
if [ $? -eq 0 ]; then
    echo "Restarting smart-front..."
    pm2 restart smart-front
else
    echo "Starting smart-front..."
    cd front
    # 개발 서버(vite) 모드로 실행. 배포용 빌드(serve)가 필요하면 변경 가능.
    pm2 start "npm run dev -- --host 0.0.0.0 --port $FRONT_PORT" --name "smart-front"
    cd ..
fi

echo "✨ Deployment Completed! (Front: $FRONT_PORT, Back: $BACK_PORT)"
pm2 save
