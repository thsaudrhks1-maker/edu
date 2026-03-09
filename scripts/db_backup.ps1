# P6IX Database Backup Script
$DATE = Get-Date -Format "yyyyMMdd_HHmm"
$BACKUP_FILE = "backups/p6ix_backup_$DATE.sql"

if (-Not (Test-Path "backups")) {
    mkdir backups
}

Write-Host "Starting Database Backup..." -ForegroundColor Cyan
# Docker-compose를 통한 PostgreSQL 백업 예시
docker exec p6ix_db pg_dump -U postgres p6ix > $BACKUP_FILE

if ($LASTEXITCODE -eq 0) {
    Write-Host "Backup Successful: $BACKUP_FILE" -ForegroundColor Green
} else {
    Write-Host "Backup Failed!" -ForegroundColor Red
}

# docker-compose up -d
# docker-compose down