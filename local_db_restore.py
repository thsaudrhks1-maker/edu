import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

def restore():
    # .env에서 DB 정보 가져오기 (로컬 Docker 기준)
    db_user = os.getenv("DB_USER", "postgres")
    db_name = os.getenv("DB_NAME", "edu")
    container_name = os.getenv("DB_CONTAINER_NAME", "edu_db")

    input_file = "local_db.sql"
    
    # 로컬 Docker 컨테이너의 DB를 동기화하기 위해 초기화 및 복원 수행
    drop_db_cmd = f"docker exec -i {container_name} dropdb -U {db_user} {db_name} --if-exists"
    create_db_cmd = f"docker exec -i {container_name} createdb -U {db_user} {db_name}"
    restore_cmd = f"docker exec -i {container_name} psql -U {db_user} -d {db_name} < {input_file}"
    
    print(f"Restoring LOCAL database ({db_name}) from {input_file} via Docker...")
    try:
        subprocess.run(drop_db_cmd, shell=True, check=True)
        subprocess.run(create_db_cmd, shell=True, check=True)
        subprocess.run(restore_cmd, shell=True, check=True)
        print("Local DB Restore Successful.")
    except subprocess.CalledProcessError as e:
        print(f"Local DB Restore Failed: {e}")

if __name__ == "__main__":
    restore()
