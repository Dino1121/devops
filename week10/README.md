# Week 10 - 쿠버네티스 배포와 서비스

## 1. 실습 목표

Kubernetes Deployment와 Service를 YAML 파일로 관리하고, 스케일링, 로드밸런싱, 자가 치유, 롤링 업데이트 및 롤백을 수행한다.

## 2. 실습 환경

- OS: Ubuntu (WSL2)
- Container Runtime: Docker Desktop
- Kubernetes: Minikube
- Application: Flask Guestbook
- Container Registry: GitHub Container Registry (GHCR)

## 3. 실습 내용 및 결과

### 3.1 Deployment 및 Service 생성

- `deployment.yaml`을 작성하여 Guestbook 배포
- `service.yaml`을 작성하여 NodePort 서비스 생성
- Service Port: 80
- Target Port: 5000
- NodePort: 30080

설정 파일:
- [deployment.yaml](../guestbook/k8s/deployment.yaml)
- [service.yaml](../guestbook/k8s/service.yaml)

### 3.2 스케일링

Deployment의 replicas를 2에서 5로 변경하고 적용하였다.

- Deployment READY: 5/5
- 모든 Pod가 Running 상태인 것을 확인하였다.

[실행 결과](scaling.txt)

### 3.3 로드밸런싱

Guestbook Service에 반복적으로 HTTP 요청을 전송하였다.

서로 다른 5개 Pod에서 응답이 반환되는 것을 확인하였다.

- guestbook-7595bb7959-wx5zb
- guestbook-7595bb7959-xdd92
- guestbook-7595bb7959-52lc6
- guestbook-7595bb7959-s78bm
- guestbook-7595bb7959-z968d

[실행 결과](load-balancing.txt)

### 3.4 자가 치유 (Self-Healing)

실행 중인 Pod 하나를 강제로 삭제하였다.

- 삭제한 Pod: guestbook-7595bb7959-52lc6
- 새로 생성된 Pod: guestbook-7595bb7959-6bfsq
- 최종 Deployment READY: 5/5

Kubernetes가 새로운 Pod를 생성하여 원하는 복제본 수를 유지하는 것을 확인하였다.

[실행 결과](self-healing.txt)

### 3.5 롤링 업데이트

Guestbook HTML을 수정한 후 v2 이미지를 빌드하여 GHCR에 업로드하였다.

- 기존 이미지: ghcr.io/dino1121/guestbook:v1
- 변경 이미지: ghcr.io/dino1121/guestbook:v2
- 업데이트 결과: successfully rolled out
- 새 Pod 5개 Running
- 배포 이력: Revision 3

[실행 결과](rolling-update.txt)

### 3.6 롤백

`kubectl rollout undo` 명령어를 사용하여 이전 버전으로 복원하였다.

- 롤백 전: guestbook:v2
- 롤백 후: guestbook:v1
- Deployment READY: 5/5
- 롤백 후 Revision: 4

[실행 결과](rollback.txt)

## 4. 최종 결과

| 실습 항목 | 결과 |
|---|---|
| YAML 기반 Deployment | 성공 |
| NodePort Service | 성공 |
| Pod 5개 스케일링 | 성공 |
| 로드밸런싱 | 서로 다른 Pod 5개 확인 |
| Pod 자동 복구 | 성공 |
| v1 → v2 롤링 업데이트 | 성공 |
| v2 → v1 롤백 | 성공 |

## 5. 참고 사항

- 최종 Deployment 설정은 replicas 5개, 이미지 v1이다.
- 롤링 업데이트는 정상 완료되었으나, 전체 업데이트 구간의 HTTP 요청 무중단 여부는 별도로 측정하지 않았다.
- 실습 결과는 week10 디렉터리의 텍스트 파일에 기록하였다.
