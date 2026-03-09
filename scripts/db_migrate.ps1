# 1. DB 스키마 업데이트 (atlas.hcl의 local 환경 설정 사용)
# --auto-approve를 넣어 사용자 확인 절차 없이 즉시 반영합니다.
Write-Host "--- Updating Database Schema (Adding video_url column) ---" -ForegroundColor Cyan
.\atlas.exe schema apply --env local --auto-approve

# 2. 강의 데이터 최신화 (Seed 데이터 삽입)
Write-Host "--- Seeding Course Data with Videos ---" -ForegroundColor Cyan
.\venv\Scripts\python.exe back/seed_courses.py

Write-Host "--- All Migration Tasks Completed! ---" -ForegroundColor Green