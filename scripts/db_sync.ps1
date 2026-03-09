# Atlas Schema Sync Script
# .env의 설정을 동적으로 읽어 동기화를 시도합니다.

Write-Host "Checking .env configuration..." -ForegroundColor Cyan
# .env 파일 로드 (단순 파싱)
$envContent = Get-Content ".env"
$dbUser = ($envContent | Select-String "DB_USER=").ToString().Split("=")[1].Trim()
$dbPass = ($envContent | Select-String "DB_PASSWORD=").ToString().Split("=")[1].Trim()
$dbName = ($envContent | Select-String "DB_NAME=").ToString().Split("=")[1].Trim()
$dbPort = ($envContent | Select-String "DB_PORT=").ToString().Split("=")[1].Trim()

$targetUrl = "postgres://$($dbUser):$($dbPass)@localhost:$($dbPort)/$($dbName)?sslmode=disable"

Write-Host "Target: $targetUrl" -ForegroundColor Gray
# 아틀라스 명령어 결정 (로컬 .exe 우선)
$atlasCmd = if (Test-Path ".\atlas.exe") { ".\atlas.exe" } else { "atlas" }

Write-Host "Using Atlas command: $atlasCmd" -ForegroundColor Gray
Write-Host "Running Atlas Schema Apply..." -ForegroundColor Yellow

# atlas.hcl에 정의된 설정을 사용하여 실행
& $atlasCmd schema apply --env local --url "$targetUrl" --auto-approve

if ($LASTEXITCODE -eq 0) {
    Write-Host "Schema Sync Successful!" -ForegroundColor Green
} else {
    Write-Host "Schema Sync Failed! Please check if DB is running and Atlas CLI is installed." -ForegroundColor Red
}
