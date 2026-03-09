# [API 미러링 표준] Frontend API Service Mirroring

이 지침은 프론트엔드 API 호출 로직이 백엔드의 도메인 구조를 그대로 따르도록 규정합니다.

## 1. 디렉토리 및 파일 구조
- 프론트엔드의 `src/api/` 폴더는 백엔드의 `back/` 내 각 도메인 폴더 구조를 미러링한다.
- **구조 예시**:
  - `back/user/`  →  `front/src/api/user.js`
  - `back/course/` → `front/src/api/course.js`
- 모든 API 파일은 `src/api/api.js`에 정의된 Axios 인스턴스를 공유한다.

## 2. 네임스페이스 및 명명 규칙
- 각 API 파일은 해당 도메인 이름을 딴 객체(예: `userApi`, `courseApi`)를 export한다.
- 함수 이름은 백엔드 라우터의 기능과 일치시킨다. (예: `login()`, `signup()`, `getAllCourses()`)

## 3. 코드 작성 원칙
- 특정 도메인의 로직을 수정할 때, 백엔드의 해당 도메인 폴더를 먼저 분석한 뒤 프론트엔드의 대응되는 API 파일을 수정한다.
- 새로운 도메인이 백엔드에 추가되면 프론트엔드에도 즉시 대응되는 API 파일을 생성한다.
- 모든 API 호출은 개별 컴포넌트에서 직접 작성하지 않고, 반드시 정의된 API 서비스를 통해서만 호출한다.
