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
        # A. 세션 종료 및 DB 초기화
        subprocess.run(["docker", "exec", "-i", container_name, "psql", "-U", db_user, "-d", "postgres", "-c", f"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{db_name}' AND pid <> pg_backend_pid();"], capture_output=True)
        subprocess.run(["docker", "exec", "-i", container_name, "dropdb", "-U", db_user, "--if-exists", db_name], check=True)
        subprocess.run(["docker", "exec", "-i", container_name, "createdb", "-U", db_user, db_name], check=True)

        # B. 데이터 필터링 및 복구
        # \restrict, \unrestrict 등 psql이 모르는 명령어를 싹 거르고 보냅니다.
        print(f"💡 데이터 정화 및 복구 진행 중...")
        with open(input_file, 'r', encoding='utf-8') as f:
            sql_lines = [line for line in f if not line.strip().startswith('\\restrict') and not line.strip().startswith('\\unrestrict')]
            clean_sql = "".join(sql_lines)

        restore_cmd = ["docker", "exec", "-i", container_name, "psql", "-U", db_user, "-d", db_name]
        proc = subprocess.Popen(restore_cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding='utf-8')
        stdout, stderr = proc.communicate(input=clean_sql)

        if proc.returncode == 0:
            print("-" * 50)
            print("✅ [SERVER] DB 동기화 완료! (쓰레기 구문 제거됨)")
            print("-" * 50)
            return True
        else:
            print(f"❌ 복구 오류: {stderr}")
            return False

    except Exception as e:
        print(f"❌ 치명적 에러: {str(e)}")
        return False

if __name__ == "__main__":
    restore()
