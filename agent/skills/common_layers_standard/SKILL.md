---
name: common_layers_standard
description: utils, clients, core 공통 레이어 사용 및 구성 표준
---

# [공통 레이어 표준] Utils, Clients & Core

이 지침은 기능폴더 이외의 공통 영역(utils, clients, core)의 구성과 사용법을 규정합니다.

## 1. core/ (핵심 인프라)
- 데이터베이스 엔진 설정, 비동기 세션 생성, 인증 필터 등 시스템의 뼈대 로직을 포함합니다.
- 예: `database.py`, `security.py`

## 2. utils/ (공통 유틸리티)
- 특정 도메인에 종속되지 않는 범용 로직을 보관합니다.
- `exceptions.py`: 커스텀 예외 클래스 및 HTTP 예외 처리 래퍼.
- `formatters.py`: 날짜(`datetime`) 변환, JSON 직렬화 커스텀 로직.

## 3. clients/ (외부 API 클라이언트)
- 타 서비스와의 API 통신을 전담합니다.
- YouTube API, PortOne(결제), SMS 인증 등 외부 인터페이스를 캡슐화합니다.
- 비즈니스 로직(Service Layer)에서 이 클라이언트를 호출하여 사용합니다.
