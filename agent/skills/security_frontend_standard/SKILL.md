# [보안 및 연동 표준] Security, Environment & Frontend Integration

이 지침은 환경 변수 관리, 에러 처리, 그리고 프론트엔드와의 통신 방식을 규정합니다.

## 1. 전역 환경 변수 관리 (.env)
- 모든 동적 설정(DB Connection, Frontend/Backend 서버 경로, 포트 번호 등)은 루트의 `.env` 파일에서 집중 관리한다.
- 에이전트는 코드 작성 전 `.env` 설정을 확인하고, 필요한 경우 새로운 키를 제안하거나 기존 설정을 활용한다.
- `BACKEND_PORT`, `FRONTEND_PORT`, `API_URL` 등 서버 구성 관련 변수는 반드시 `.env`에 정의한다.
- 모든 비밀키(JWT SECRET, API Key, DB Password)는 반드시 `.env` 파일에서 관리하며 코드에 하드코딩하지 않는다.

## 2. 에러 핸들링 및 로깅
- 사용자에게 시스템 에러(DB Stacktrace 등)를 직접 노출하지 않는다.
- `utils/exceptions.py`를 활용하여 정제된 메시지와 적절한 HTTP 상태 코드를 반환한다.

## 4. 전역 테마 관리 (Theme Management)
- **CSS 변수 활용:** 모든 UI 색상은 `front/src/index.css`에 정의된 CSS 변수(`--bg-main`, `--text-main` 등)를 사용한다.
- **다크/라이트 모드:** `<html>` 또는 `<body>` 태그의 `data-theme` 속성(`light` 또는 `dark`)을 통해 테마를 전환한다.
- **표준 준수:** CSS 파일 내의 `@import` 문은 반드시 파일의 **최상단**에 위치해야 한다.
- **일관성:** 하드코딩된 색상(예: `#ffffff`) 대신 반드시 테마 변수를 사용하여 테마 전환 시 모든 컴포넌트가 동시에 반응하도록 한다.

## 3. 프론트엔드 연동 (api.js)
- React 앱 내의 모든 API 호출은 `front/src/api/api.js`에 정의된 Axios 인스턴스를 사용한다.
- 인터셉터를 통해 JWT 토큰 삽입 및 전역 응답 처리를 수행한다.
