#!/bin/bash
set -e # Stop on error

PROJECT_DIR=~/edu
BACK_PORT=8700
FRONT_PORT=3700

echo "🚀 Starting EDU Deployment in $PROJECT_DIR"
cd $PROJECT_DIR || exit

# 1. Nginx 설정 동기화
echo "--- [Nginx] Syncing Configuration ---"
if [ -f "nginx_edu.sogething.conf" ]; then
    sudo cp nginx_edu.sogething.conf /etc/nginx/sites-available/edu.sogething
    sudo ln -sf /etc/nginx/sites-available/edu.sogething /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl reload nginx
else
    echo "⚠️ nginx_edu.sogething.conf not found!"
fi

# 2. Backend Setup & PM2 (Port: 8700)
echo "--- [Backend] Managing Processes ---"
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate
pip install -r back/requirements.txt

if pm2 describe edu-back > /dev/null 2>&1; then
    echo "Reloading edu-back..."
    pm2 reload edu-back
else
    echo "Starting edu-back..."
    pm2 start "venv/bin/uvicorn main:app --host 0.0.0.0 --port $BACK_PORT" --name "edu-back" --cwd "$PROJECT_DIR/back"
fi

# 3. Frontend Setup & PM2 (Port: 3700)
echo "--- [Frontend] Managing Processes ---"
pm2 describe edu-front > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Restarting edu-front..."
    pm2 restart edu-front
else
    echo "Starting edu-front..."
    cd front
    pm2 start "npm run dev -- --host 0.0.0.0 --port $FRONT_PORT" --name "edu-front"
    cd ..
fi

echo "✨ Deployment Completed! (Front: $FRONT_PORT, Back: $BACK_PORT)"
pm2 save
