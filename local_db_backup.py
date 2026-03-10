import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

def backup():
    # .env에서 DB 정보 가져오기 (Docker 내부 접속용)
    db_user = os.getenv("DB_USER", "postgres")
    db_name = os.getenv("DB_NAME", "edu")
    container_name = os.getenv("DB_CONTAINER_NAME", "edu_db")

    output_file = "local_db.sql"
    
    # Docker exec를 통해 컨테이너 내부의 pg_dump 실행
    # -U와 -d는 컨테이너 내부의 DB 설정을 따릅니다.
    command = f"docker exec -t {container_name} pg_dump -U {db_user} -d {db_name} -O -x > {output_file}"
    
    print(f"Backing up local database from Docker container: {container_name}...")
    try:
        # PowerShell/Bash 환경에서 리다이렉션(>) 처리를 위해 shell=True 사용
        subprocess.run(command, shell=True, check=True)
        print(f"Backup Successful: {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"Backup Failed: {e}")

if __name__ == "__main__":
    backup()
