# Database Schema & Model Research Skill (DB-Schema-Standard)

이 스킬은 에이전트(Antigravity)가 데이터 관련 기능을 개발하거나 SQL 문을 작성할 때, 데이터베이스의 구조와 모델 간의 관계를 정확히 이해하고 코드를 작성하기 위한 지침입니다.

## 1. 개요 (Overview)
- **목적:** Raw SQL 작성 및 데이터 처리 시 모델 정의(SQLAlchemy)와 실제 DB 형상을 일치시키고 오류를 방지함.
- **핵심 원칙:** 코드를 짜기 전, 반드시 `back/core/database.py` 또는 `back/atlas_schema.py`에서 Import된 모든 모델 파일을 전수 조사한다.

## 2. 조사 절차 (Research Process)
에이전트는 데이터 관련 작업(Repository 작성, Service 로직 수정 등)을 시작하기 전 다음 단계를 수행해야 합니다.

1. **모델 리스트 확인:**
   - `back/core/database.py` 하단의 `Models Import` 섹션 또는 `back/atlas_schema.py`를 확인하여 현재 활성화된 도메인 모델들을 파악한다.
2. **모델 상세 분석:**
   - 각 모델 파일(예: `back/user/model.py`, `back/course/model.py`)에 들어가서 다음 정보를 추출한다.
     - **테이블명 (`__tablename__`)**
     - **컬럼명 및 자료형 (Column, Integer, String 등)**
     - **제약 조건 (Primary Key, Unique, Nullable)**
     - **외래 키 (Foreign Key) 및 관계 (Relationship)**
3. **ERD 및 관계 매핑:**
   - 테이블 간의 참조 관계(FK)를 파악하여 SQL JOIN 문이나 데이터 무결성 체크 로직에 반영한다.

## 3. SQL 작성 표준 (SQL Standard)
- **명칭 일치:** 모든 SQL 문(SELECT, INSERT, UPDATE)의 테이블명과 컬럼명은 반드시 분석한 모델 정의와 100% 일치해야 한다.
- **자료형 준수:** 데이터 삽입/수정 시 모델에 정의된 자료형(예: DateTime, Text)에 맞는 포맷을 사용한다.
- **Raw SQL 우선:** ORM보다는 `back/core/database.py`의 `fetch_all`, `execute` 등의 Helper 함수를 사용하는 Raw SQL 작성을 우선한다.

## 4. 모델 변경 시 주의사항
- 새로운 테이블이나 컬럼이 추가된 경우, 반드시 `back/core/database.py` 하단에 Import 문을 추가하고 `db_sync.ps1`을 실행하여 DB를 동기화한 후 개발에 착수한다.
