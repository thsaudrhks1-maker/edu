import os
import subprocess
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

def backup():
    # 서버 환경 변수에서 DB 정보 가져오기
    db_user = os.getenv("DB_USER", "postgres")
    db_pass = os.getenv("DB_PASSWORD", "0000")
    db_name = os.getenv("DB_NAME", "edu")
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5432") # 서버 기본 포트가 다를 수 있음

    date_str = datetime.now().strftime("%Y%m%d_%H%M")
    backup_file = f"backups/server_db_backup_{date_str}.sql"
    
    os.makedirs("backups", exist_ok=True)
    os.environ["PGPASSWORD"] = db_pass
    
    command = f"pg_dump -U {db_user} -h {db_host} -p {db_port} -d {db_name} -O -x > {backup_file}"
    
    print(f"Backing up real server database: {db_name} on {db_host}:{db_port}...")
    try:
        subprocess.run(command, shell=True, check=True)
        print(f"Server Backup Successful: {backup_file}")
    except subprocess.CalledProcessError as e:
        print(f"Server Backup Failed: {e}")

if __name__ == "__main__":
    backup()
