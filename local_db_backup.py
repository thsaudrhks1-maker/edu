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
    
    print(f"🚀 [LOCAL] DB 백업 시작: {container_name} -> {output_file}")
    
    # 윈도우 PowerShell의 리다이렉션(>) 인코딩 문제를 피하기 위해 
    # stdout을 직접 캡처하여 파이썬에서 UTF-8로 저장합니다.
    command = ["docker", "exec", "-i", container_name, "pg_dump", "-U", db_user, "-d", db_name, "--no-owner", "--no-privileges", "--no-comments"]
    
    try:
        # stdout을 캡처하여 바로 파일에 씁니다.
        with open(output_file, "w", encoding="utf-8") as f:
            result = subprocess.run(command, stdout=f, stderr=subprocess.PIPE, text=False, check=True)
        
        print(f"✅ 백업 성공: {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"❌ 백업 실패: {e.stderr.decode() if e.stderr else str(e)}")
    except Exception as e:
        print(f"❌ 에러 발생: {str(e)}")

if __name__ == "__main__":
    backup()
