import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

def restore():
    # .env에서 DB 정보 가져오기
    db_user = os.getenv("DB_USER", "postgres")
    db_pass = os.getenv("DB_PASSWORD", "0000")
    db_name = os.getenv("DB_NAME", "edu")
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5432") # 서버 기본 포트가 다를 수 있음

    input_file = "local_db.sql"
    
    # psql을 통해 복구 실행 (기존 DB 드롭 후 재생성 권장)
    os.environ["PGPASSWORD"] = db_pass
    
    # DB 재생성 (필요할 경우)
    drop_db_cmd = f"dropdb -h {db_host} -p {db_port} -U {db_user} {db_name} --if-exists"
    create_db_cmd = f"createdb -h {db_host} -p {db_port} -U {db_user} {db_name}"
    restore_cmd = f"psql -h {db_host} -p {db_port} -U {db_user} -d {db_name} < {input_file}"
    
    print(f"Restoring server database from local dump: {input_file}...")
    try:
        subprocess.run(drop_db_cmd, shell=True, check=True)
        subprocess.run(create_db_cmd, shell=True, check=True)
        subprocess.run(restore_cmd, shell=True, check=True)
        print("Restore Successful.")
    except subprocess.CalledProcessError as e:
        print(f"Restore Failed: {e}")

if __name__ == "__main__":
    restore()
