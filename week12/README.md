# 12주차 - GitHub Actions

## 실습 목표

GitHub Actions를 이용하여 CI 파이프라인을 구축하고,
코드 검사, 단위 테스트, Docker 이미지 빌드 및 게시를 자동화한다.

또한 의도적인 오류를 발생시켜 CI가 문제를 탐지하는지 확인하고,
브랜치 보호 규칙을 이용하여 잘못된 코드의 병합을 차단한다.

## 실습 1. GitHub Actions CI 구축

### 1-1. 자동화 테스트 작성
- guestbook/tests/test_app.py 작성
- /healthz 엔드포인트 응답 검사
- 방명록 글 등록 및 조회 기능 테스트

### 1-2. CI 워크플로 작성
- .github/workflows/build.yml 작성
- Push 및 Pull Request 이벤트에 자동 실행
- Ruff를 이용한 코드 검사
- unittest를 이용한 기능 테스트
- Docker Buildx 이미지 빌드
- GHCR 이미지 자동 게시

### 1-3. 실행 결과
- PR #9에서 CI 검사 통과
- main 병합 후 이미지 자동 빌드
- GHCR에 latest 및 커밋 해시 태그 게시

## 실습 2. CI 오류 탐지

### 2-1. 문법 오류 탐지
- 잘못된 Python 함수 선언 추가
- 코드 검사 실패 확인
- 오류 수정 후 CI 성공 확인

### 2-2. 린트 오류 탐지
- 정의되지 않은 변수 APP_TITL 사용
- Python 문법 검사는 통과
- Ruff F821 오류 탐지 확인
- 수정 후 CI 성공 확인

### 2-3. 단위 테스트 실패
- /healthz 응답 코드를 200에서 500으로 변경
- 기능 테스트에서 AssertionError 확인
- HTTP 200으로 복구 후 CI 성공 확인

## 실습 3. 브랜치 보호

- main 브랜치에 Ruleset 적용
- Pull Request를 통한 병합 요구
- build 상태 검사를 필수 조건으로 설정
- 잘못된 코드를 포함한 PR #11 생성
- CI 실패 시 Squash and merge 비활성화 확인

## GitHub 검증 자료

| 항목 | GitHub 증거 |
| --- | --- |
| 최초 CI 구축 | [PR #9](https://github.com/Dino1121/devops/pull/9) |
| 오류 탐지 및 수정 | [PR #10](https://github.com/Dino1121/devops/pull/10) |
| 브랜치 보호 실험 | [PR #11](https://github.com/Dino1121/devops/pull/11) |
| CI 실행 기록 | [GitHub Actions](https://github.com/Dino1121/devops/actions) |
| Docker 이미지 | [GitHub Packages](https://github.com/Dino1121?tab=packages) |

## 실습 스크린샷

실습 과정에서 저장한 증거 이미지는
[screenshots 폴더](./screenshots/)에서 확인할 수 있다.

## 실습 결과

GitHub Actions를 통해 코드 검사, 단위 테스트,
컨테이너 이미지 빌드 및 게시를 자동화하였다.

의도적인 문법 오류, 변수 오타, 기능 테스트 실패를 통해
CI 파이프라인의 오류 탐지 기능을 확인하였다.

또한 브랜치 보호 규칙을 적용하여
CI 검사에 실패한 PR이 main에 병합되지 않도록 설정하였다.
