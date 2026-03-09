import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

def backup():
    # .env에서 DB 정보 가져오기
    db_user = os.getenv("DB_USER", "postgres")
    db_pass = os.getenv("DB_PASSWORD", "0000")
    db_name = os.getenv("DB_NAME", "edu")
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5700")

    output_file = "local_db.sql"
    
    # pg_dump를 통해 백업 실행 (비밀번호는 환경 변수로 설정)
    os.environ["PGPASSWORD"] = db_pass
    command = f"pg_dump -U {db_user} -h {db_host} -p {db_port} -d {db_name} -O -x > {output_file}"
    
    print(f"Backing up local database: {db_name} on {db_host}:{db_port}...")
    try:
        subprocess.run(command, shell=True, check=True)
        print(f"Backup Successful: {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"Backup Failed: {e}")

if __name__ == "__main__":
    backup()
