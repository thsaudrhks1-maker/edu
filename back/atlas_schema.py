from core.database import Base
# Atlas 마이그레이션 도구 (atlas-provider-sqlalchemy)는 
# core.database의 Base에 연결된 모든 Metadata를 읽어야 합니다.
# 모든 도메인 모델들을 전수 임포트합니다.

# 1. [SYS] 사용자 및 권한 (Core Domain)
from user.model import User

# 2. [CONTENT] 강의 및 커리큘럼
from course.model import Course
# from lecture.model import Lecture

# 3. [BUSINESS] 결제 및 수강 (Future)
# from payment.model import Payment
# from enrollment.model import Enrollment

import sys

def main():
    try:
        from atlas_provider_sqlalchemy.ddl import print_ddl
        print_ddl("postgresql", [Base])
    except ImportError:
        print("Error: atlas-provider-sqlalchemy not installed", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
