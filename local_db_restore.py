import os
import subprocess
from dotenv import load_dotenv

def run_local_restore():
    """사용자님 스타일: 로컬 psql.exe를 활용한 완격한 데이터 복구 (통합 버전)"""
    load_dotenv()
    
    # 1. .env 설정 로드 (로컬 개발 환경 기준)
    db_user = os.getenv("DB_USER", "postgres")
    db_pw = os.getenv("DB_PASSWORD", "0000")
    db_name = os.getenv("DB_NAME", "edu")
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5700") 
    container_name = os.getenv("DB_CONTAINER_NAME", "edu_db")
    
    # 로컬 백업 파일 확인
    local_seed = "local_db.sql"
    if not os.path.exists(local_seed):
        print(f"❌ 복구할 파일이 없습니다: {local_seed}")
        return False

    print(f"🚀 [LOCAL] DB 복구 시작: {local_seed} -> {db_name}")
    
    # 환경변수에 비밀번호 설정 (psql 자동 로그인)
    os.environ["PGPASSWORD"] = db_pw

    try:
        # A. 세션 종료 및 DB 초기화 (이건 Docker exec를 활용해 확실히 처리)
        # DBeaver 접속 중에도 초기화되도록 세션을 강제 종료합니다.
        print("💡 DB 세션 종료 및 초기화 중...")
        kill_cmd = [
            "docker", "exec", "-i", container_name, "psql", 
            "-U", db_user, "-d", "postgres", "-c", 
            f"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{db_name}' AND pid <> pg_backend_pid();"
        ]
        subprocess.run(kill_cmd, capture_output=True)
        
        # 기존 DB 방 폭파 후 재생성
        subprocess.run(f"docker exec -i {container_name} dropdb -U {db_user} --if-exists {db_name}", shell=True, check=True)
        subprocess.run(f"docker exec -i {container_name} createdb -U {db_user} {db_name}", shell=True, check=True)

        # B. 사용자님이 주신 psql 방식 그대로 데이터 복구
        # 시스템의 psql.exe를 경로 우선순위에 따라 찾습니다.
        psql_path = r"C:\Program Files\PostgreSQL\17\bin\psql.exe"
        if not os.path.exists(psql_path):
            psql_path = r"C:\Program Files\PostgreSQL\16\bin\psql.exe" # 16버전 폴백
            if not os.path.exists(psql_path):
                psql_path = "psql" # 시스템 PATH에 의존
        
        cmd = [
            psql_path,
            "-h", db_host,
            "-p", db_port,
            "-U", db_user,
            "-d", db_name,
            "-f", local_seed
        ]
        
        # 데이터 복구 명령 실행
        subprocess.run(cmd, check=True)
        
        print("-" * 50)
        print("✅ [LOCAL] DB 복구 완료!")
        print(f"🔗 데이터 원천: {local_seed}")
        print("-" * 50)
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ 복구 실패: {e}")
        return False
    except Exception as e:
        print(f"❌ 에러 발생: {str(e)}")
        return False

if __name__ == "__main__":
    run_local_restore()
