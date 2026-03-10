import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

def restore():
    # 서버측 전용 복구 스크립트 (Linux Docker 환경용)
    db_user = os.getenv("DB_USER", "postgres")
    db_name = os.getenv("DB_NAME", "edu")
    container_name = os.getenv("DB_CONTAINER_NAME", "edu_db")
    input_file = "local_db.sql"
    
    if not os.path.exists(input_file):
        print(f"❌ 복구 파일 없음: {input_file}")
        return False

    print(f"🚀 [SERVER] DB 동기화 시작: {input_file} -> {db_name}")

    try:
        # A. 활성 세션 강제 종료 (DB 초기화 성공을 위해 필수)
        print("💡 활성 세션 종료 중...")
        kill_cmd = [
            "docker", "exec", "-i", container_name, "psql", 
            "-U", db_user, "-d", "postgres", "-c",
            f"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{db_name}' AND pid <> pg_backend_pid();"
        ]
        subprocess.run(kill_cmd, capture_output=True)

        # B. DB 초기화 (기존 방 폭파 후 재생성)
        print(f"💡 기존 '{db_name}' 데이터베이스 초기화 중...")
        subprocess.run(["docker", "exec", "-i", container_name, "dropdb", "-U", db_user, "--if-exists", db_name], check=True)
        subprocess.run(["docker", "exec", "-i", container_name, "createdb", "-U", db_user, db_name], check=True)

        # C. 데이터 복구 (docker-exec -i와 stdin 사용으로 특수문자 깨짐 방지)
        print(f"💡 데이터 복구 진행 중...")
        with open(input_file, 'rb') as f:
            restore_cmd = ["docker", "exec", "-i", container_name, "psql", "-U", db_user, "-d", db_name]
            subprocess.run(restore_cmd, stdin=f, check=True)

        print("-" * 50)
        print("✅ [SERVER] DB 동기화 완료!")
        print("-" * 50)
        return True

    except subprocess.CalledProcessError as e:
        print(f"❌ 복구 실패: {e}")
        return False
    except Exception as e:
        print(f"❌ 치명적 에러: {str(e)}")
        return False

if __name__ == "__main__":
    restore()
