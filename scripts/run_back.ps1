# Backend Run Script
# back 폴더를 파이썬 경로에 포함시켜 모듈 임포트 문제를 해결합니다.

$env:PYTHONPATH = "back"

Write-Host "Starting P6IX Backend..." -ForegroundColor Cyan
.\venv\Scripts\python.exe back/main.py

# 1. 백엔드 폴더로 이동 (cd 이용)
cd back
# 2. 루트에 있는 가상환경을 활성화하고 uvicorn 실행
..\venv\Scripts\activate; uvicorn main:app --reload --port 8700

