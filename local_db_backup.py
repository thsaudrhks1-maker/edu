import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

def backup():
    # .env에서 DB 정보 가져오기
    db_user = os.getenv("DB_USER", "postgres")
    db_name = os.getenv("DB_NAME", "edu")
    container_name = os.getenv("DB_CONTAINER_NAME", "edu_db")

    output_file = "local_db.sql"
    
    print(f"🚀 [LOCAL] DB 백업 시작: {container_name} -> {output_file}")
    
    # pg_dump 명령 실행
    command = ["docker", "exec", "-i", container_name, "pg_dump", "-U", db_user, "-d", db_name, "--no-owner", "--no-privileges", "--no-comments"]
    
    try:
        # Popen으로 출력을 한 줄씩 읽어서 필터링합니다.
        with open(output_file, "w", encoding="utf-8") as f:
            process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding='utf-8')
            
            for line in process.stdout:
                # \restrict 또는 \unrestrict로 시작하는 줄은 아예 파일에 쓰지 않습니다.
                clean_line = line.strip()
                if not clean_line.startswith('\\restrict') and not clean_line.startswith('\\unrestrict'):
                    f.write(line)
            
            process.wait()
            
        if process.returncode == 0:
            print(f"✅ 백업 성공: {output_file} (쓰레기 구문 자동 제거됨)")
        else:
            stderr = process.stderr.read()
            print(f"❌ 백업 실패: {stderr}")
            
    except Exception as e:
        print(f"❌ 에러 발생: {str(e)}")

if __name__ == "__main__":
    backup()
