# 방명록 (Guestbook)

이름과 메시지를 남기면 목록에 쌓이고, 방문자 수를 세는 간단한 웹 앱입니다.

---

## 이 앱이 하는 일

- 이름과 메시지를 남기는 방명록
- 방문자 수 카운트
- 화면에 hostname 표시

## 이 앱의 두 가지 모드

| 모드 | 조건 | 저장 위치 |
|---|---|---|
| **메모리 모드** | `REDIS_HOST` 환경변수 없음 | 프로세스 메모리 (재시작하면 사라짐) |
| **Redis 모드** | `REDIS_HOST` 환경변수 있음 | Redis (영구 저장) |

---

## Docker로 실행하기

```bash
# 이미지 빌드
docker build -t guestbook:v1 .

# 실행 (메모리 모드)
docker run -d -p 8080:5000 --name guestbook guestbook:v1

# 접속
# → http://localhost:8080

# 로그 보기 / 내부 들어가기 / 정리
docker logs guestbook
docker exec -it guestbook sh
docker stop guestbook && docker rm guestbook
```

**환경변수로 커스터마이징**
```bash
docker run -d -p 8080:5000 \
  -e APP_TITLE="홍길동의 방명록" \
  -e THEME_COLOR="#e11d48" \
  guestbook:v1
```

**ghcr.io에 올리기**
```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u 내아이디 --password-stdin
# 또는: gh auth token | docker login ghcr.io -u 내아이디 --password-stdin

docker tag guestbook:v1 ghcr.io/내아이디/guestbook:v1
docker push ghcr.io/내아이디/guestbook:v1
```

**Mac(Apple Silicon)은 멀티 아키텍처로**
```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/내아이디/guestbook:v1 --push .
```

**[심화] 이미지 용량 줄이기**
```bash
docker build -t guestbook:fat .
docker build -f Dockerfile.multistage -t guestbook:slim .
docker images | grep guestbook      # 용량 비교!
```

## docker compose로 실행하기 (웹 + Redis)

```bash
docker compose up -d        # 두 컨테이너가 함께 뜬다
docker compose ps
docker compose logs -f web
# → http://localhost:8080

docker compose down         # 종료 (볼륨은 유지)
docker compose down -v      # 볼륨까지 삭제
```

---

## 파일 구조

```
.
├── app.py
├── requirements.txt
├── templates/index.html
├── Dockerfile
├── Dockerfile.multistage     # [심화] 용량 줄이기
└── .dockerignore
```

## 엔드포인트

| 경로 | 설명 |
|---|---|
| `/` | 방명록 화면 |
| `/add` | 글 등록 (POST) |
| `/api/entries` | JSON 목록 |
| `/healthz` | 헬스체크 (항상 200) |
| `/readyz` | 준비 상태 확인 (Redis 연결 안 되면 503) |

## 설정 (환경변수)

| 변수 | 기본값 | 설명 |
|---|---|---|
| `APP_TITLE` | DevOps 방명록 | 화면 제목 |
| `THEME_COLOR` | #DC143C (크림슨) | 테마 색상 |
| `PORT` | 5000 | 리스닝 포트 |
| `REDIS_HOST` | (없음) | 있으면 Redis 모드 |
| `REDIS_PORT` | 6379 | |
| `REDIS_PASSWORD` | (없음) | |

---

## 아키텍처

사용자 → Kubernetes Service → Guestbook Pods → Redis

## 기술 스택

- Python / Flask
- Redis
- Docker / Docker Compose
- Kubernetes / Minikube
- GitHub Actions / GHCR
- Argo CD

## Kubernetes 실행

저장소 루트에서 실행한다.

```bash
minikube start --driver=docker
kubectl apply -f guestbook/k8s
minikube service guestbook
```

guestbook-secret은 별도로 생성해야 한다.
실제 비밀번호는 Git에 저장하지 않는다.

## CI/CD 및 GitOps 배포

1. 소스 코드 수정
2. Pull Request 생성 및 CI 검사
3. main 브랜치에 Merge
4. GitHub Actions를 통한 이미지 빌드 및 GHCR 게시
5. deployment.yaml의 이미지 태그 변경
6. PR 생성 및 Merge
7. Argo CD를 통한 자동 배포

## Argo CD

- automated: 자동 동기화
- selfHeal: Git에 선언된 상태로 복구
- prune: Git에서 삭제된 리소스를 클러스터에서도 삭제

## 트러블슈팅

### Readiness Probe 503 오류

방명록 Pod에서 Redis 연결을 직접 검사하고,
Deployment를 재시작하여 정상 상태로 복구하였다.

### PR Merge 차단

Branch Protection에 의해 CI 검사가 완료되기 전까지
Merge가 제한되었다. 검사 통과 후 Merge를 진행하였다.

## 실습 기록

- [13주차 GitOps 실습](../week13/)
