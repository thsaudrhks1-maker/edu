import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

def restore():
    # .env에서 DB 정보 가져오기 (Docker 인수로 활용)
    db_user = os.getenv("DB_USER", "postgres")
    db_name = os.getenv("DB_NAME", "edu")
    container_name = os.getenv("DB_CONTAINER_NAME", "edu_db")

    input_file = "local_db.sql"
    
    # 컨테이너 내부의 툴을 이용하므로 호스트에 DB 툴이 설치되어 있지 않아도 됩니다.
    # docker exec -i는 표준 입력을 리다이렉션으로 받을 수 있게 해줍니다.
    
    # 1. 기존 DB 삭제 후 재생성 (완전 덮어씌우기를 위해 권장)
    drop_db_cmd = f"docker exec -i {container_name} dropdb -U {db_user} {db_name} --if-exists"
    create_db_cmd = f"docker exec -i {container_name} createdb -U {db_user} {db_name}"
    
    # 2. 로컬에서 전송된 dump 파일을 psql로 밀어넣기
    # < {input_file} 부분은 쉘에서 파일을 읽어 컨테이너 내부로 보내는 역할을 합니다.
    restore_cmd = f"docker exec -i {container_name} psql -U {db_user} -d {db_name} < {input_file}"
    
    print(f"Restoring server database ({db_name}) from {input_file} via Docker...")
    try:
        # DB 초기화 및 데이터 복원 실행
        subprocess.run(drop_db_cmd, shell=True, check=True)
        subprocess.run(create_db_cmd, shell=True, check=True)
        subprocess.run(restore_cmd, shell=True, check=True)
        print("Restore Successful: Database synchronized with local version.")
    except subprocess.CalledProcessError as e:
        print(f"Restore Failed: {e}")

if __name__ == "__main__":
    restore()
