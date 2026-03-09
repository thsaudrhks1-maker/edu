---
name: database_standard
description: 비동기 Raw SQL 및 Atlas 스키마 관리 표준
---

# [데이터베이스 표준] Async Raw SQL & Atlas Management

이 지침은 데이터베이스 접근 방식과 스키마 동기화 절차를 규정합니다.

## 1. 비동기 SQL 헬퍼 사용
`core.database`에 정의된 다음 함수를 통해서만 DB에 접근하며, ORM을 직접 사용하지 않습니다.
- `fetch_all(sql, params)`: 여러 행을 `list[dict]` 형태로 반환.
- `fetch_one(sql, params)`: 단일 행을 `dict` 형태로 반환.
- `execute(sql, params)`: 단순 실행 (UPDATE, DELETE 등).
- `insert_and_return(sql, params)`: INSERT 수행 후 `RETURNING *` 결과를 반환.

## 2. Atlas 마이그레이션 전수 조사 (Metadata Discovery)
Atlas가 데이터베이스 변경사항을 감지할 수 있도록 모든 도메인의 `model.py`를 다음 위치에 전수 Import 합니다.
- `back/core/database.py` (또는 `back/atlas_schema.py`)
- 새로운 도메인이 추가될 때마다 반드시 위 경로에 모델 Import 구문을 추가해야 자동 마이그레이션이 작동합니다.

## 3. SQL 작성 원칙
- 모든 SQL문은 `sqlalchemy.text()`를 사용하여 작성한다.
- 인자는 반드시 바인드 파라미터(`:name`) 형식을 사용하여 SQL Injection을 방지한다.
