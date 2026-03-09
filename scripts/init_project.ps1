Write-Host "=== P6IX Project Initialization Started ===" -ForegroundColor Cyan

# 1. Virtual Environment
if (-Not (Test-Path "venv")) {
    Write-Host "Creating Virtual Environment at root..."
    python -m venv venv
}

# 2. Backend Setup
Write-Host "Installing Backend Dependencies..."
.\venv\Scripts\python -m pip install --upgrade pip
.\venv\Scripts\pip install -r back/requirements.txt

# 3. Frontend Setup
Write-Host "Installing Frontend Dependencies..."
Set-Location front
npm install
Set-Location ..

# 4. Success Message
Write-Host "=== Initialization Complete! ===" -ForegroundColor Green
Write-Host "To start backend: .\venv\Scripts\python -m app.main"
Write-Host "To start frontend: cd front; npm run dev"
