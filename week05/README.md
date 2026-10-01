# 5주차 - Docker

## 핵심 내용

- Docker는 애플리케이션과 실행 환경을 컨테이너로 묶어 다른 환경에서도 동일하게 실행할 수 있도록 도와준다.
- VM은 각각 Guest OS를 사용하지만, Container는 Host OS의 커널을 공유해서 더 가볍다.
- Image는 Container를 만들기 위한 템플릿이고, Container는 Image를 실행한 인스턴스이다.
- `namespace`는 프로세스, 네트워크 등을 격리하고, `cgroup`은 CPU, 메모리 사용량을 제한한다.

## 주요 명령어

```bash
docker run -d -p 8080:80 --name web nginx
docker ps
docker ps -a
docker images
docker logs web
docker stop web
docker rm web

## GitHub 작업 흐름
Issue → Branch → Commit/Push → Pull Request → Merge

