---
name: backend_architecture
description: P6IX 프로젝트의 기능 중심 레이어드 아키텍처 표준
---

# [백엔드 아키텍처 표준] Functional Layered Architecture

이 지침은 백엔드 코드 작성 시 폴더 구조와 각 파일의 역할을 강제합니다. 계층이 너무 깊어지지 않도록 기능(도메인)별로 폴더를 구성합니다.

## 1. 폴더 구조 예시
`back/{기능명}/`
- `router.py`: 외부 요청(Request)을 받아 입력값을 검증하고 결과(Response)를 반환.
- `service.py`: 핵심 비즈니스 로직 및 트랜잭션 단위 처리. 복수의 Repository 호출 가능.
- `repository.py`: Raw SQL을 사용하여 데이터베이스 I/O 전담.
- `model.py`: SQLAlchemy 테이블 정의 (Atlas 마이그레이션용).
- `schema.py`: Pydantic 기반의 데이터 유효성 검사 객체 정의.

## 2. 코드 가이드
- **Router**: FastAPI의 `APIRouter`를 사용하며, 비즈니스 로직은 반드시 `Service`로 위임한다.
- **Service**: `Repository` 객체를 주입받아 사용하며, 도메인 간의 로직 결합이 발생할 때 여기서 처리한다.
- **Repository**: `core.database`의 비동기 헬퍼를 사용하여 Raw SQL만 기술한다.
- **Model**: `core.database.Base`를 상속받아 테이블 명과 컬럼을 정의한다.
