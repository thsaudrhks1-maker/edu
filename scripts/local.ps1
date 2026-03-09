# P6IX Production Build & Deploy Script (Template)
Write-Host "=== Starting Deployment Process ===" -ForegroundColor Cyan

# 1. Frontend Build
Write-Host "[1/2] Building Frontend..."
cd front
npm run build
cd ..

# 2. Docker Restart
Write-Host "[2/2] Restarting Containers..."
docker-compose down
docker-compose up -d --build

Write-Host "=== Deployment Complete ===" -ForegroundColor Green
