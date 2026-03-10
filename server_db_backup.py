import os
import subprocess
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

def backup():
    # .env에서 DB 정보 가져오기 (서버 Docker 컨테이너 기준)
    db_user = os.getenv("DB_USER", "postgres")
    db_name = os.getenv("DB_NAME", "edu")
    container_name = os.getenv("DB_CONTAINER_NAME", "edu_db")

    date_str = datetime.now().strftime("%Y%m%d_%H%M")
    backup_file = f"backups/server_db_backup_{date_str}.sql"
    
    os.makedirs("backups", exist_ok=True)
    
    # Docker exec를 실행하여 DB 덤프를 생성합니다.
    # 서버의 Docker 컨테이너에 접속하여 pg_dump를 출력하고 파일로 리다이렉션합니다.
    command = f"docker exec -t {container_name} pg_dump -U {db_user} -d {db_name} -O -x > {backup_file}"
    
    print(f"Backing up real server database from Docker container: {container_name}...")
    try:
        # 쉘 리다이렉션(>)을 통한 백업 파일 생성을 위해 shell=True 사용
        subprocess.run(command, shell=True, check=True)
        print(f"Server Backup Successful: {backup_file}")
    except subprocess.CalledProcessError as e:
        print(f"Server Backup Failed: {e}")

if __name__ == "__main__":
    backup()
