# Week 05 - Docker 실습

## 1. Docker 개념 및 실행 환경 구축

Docker는 애플리케이션과 실행에 필요한 라이브러리, 설정 등을 이미지로 묶어 서로 다른 환경에서도 일관되게 실행할 수 있도록 도와주는 플랫폼이다.

- **Image**: 컨테이너를 생성하기 위한 읽기 전용 템플릿
- **Container**: 이미지를 기반으로 생성한 실행 인스턴스
- **Registry**: Docker 이미지를 저장하고 공유하는 저장소 (Docker Hub, GHCR 등)
- **Docker Daemon**: Docker Client의 요청을 받아 이미지와 컨테이너를 관리하는 프로세스

VM은 각 가상 머신이 Guest OS를 사용하지만, 컨테이너는 Linux 커널을 공유하고 프로세스를 격리하여 상대적으로 가볍게 실행된다. `namespace`는 프로세스·네트워크·마운트 등의 격리를, `cgroup`은 CPU·메모리 자원의 제어를 담당한다.

Windows에서는 Docker Desktop을 설치하고 **Settings → Resources → WSL Integration**에서 Ubuntu 연동을 활성화한다.

설치 확인 명령:
```bash
docker --version
docker run hello-world
```

로컬에 이미지가 없다면 Registry에서 이미지를 내려받아 컨테이너로 실행한다.

---

## 2. nginx 컨테이너 실행

`nginx` 이미지를 사용하여 웹 서버 컨테이너를 실행하였다.

```bash
docker run -d -p 8080:80 --name web nginx
```

- `-d`: 백그라운드 실행
- `-p 8080:80`: 호스트의 8080 포트를 컨테이너의 80 포트에 연결
- `--name web`: 컨테이너의 이름을 `web`으로 지정
- `nginx`: 사용할 이미지

브라우저에서 `http://localhost:8080`으로 접속하거나 `curl`로 서버 응답을 확인하는 실습이다.

```bash
curl -I http://localhost:8080
docker ps
```

---

## 3. 여러 컨테이너 실행 및 포트 충돌

같은 nginx 이미지를 사용하더라도 여러 개의 컨테이너를 독립적으로 실행할 수 있다.

```bash
docker run -d -p 8081:80 --name web2 nginx
docker run -d -p 8082:80 --name web3 nginx
docker ps
```

컨테이너 내부의 포트가 모두 80이어도 서로 다른 네트워크 공간을 사용하므로 충돌하지 않는다. 다만 호스트 포트와 컨테이너 이름은 중복해서 사용할 수 없다.

```bash
# 이미 사용 중인 호스트 포트: 충돌 발생
docker run -d -p 8080:80 --name web4 nginx

# 이미 사용 중인 이름: 충돌 발생
docker run -d -p 8084:80 --name web nginx
```

---

## 4. Docker 주요 명령어

컨테이너 실행 상태와 로그, 이미지 목록을 확인하고 컨테이너를 정지·삭제하는 명령어를 학습하였다.

| 명령어 | 용도 |
| --- | --- |
| `docker ps` | 실행 중인 컨테이너 확인 |
| `docker ps -a` | 정지된 컨테이너를 포함한 전체 목록 확인 |
| `docker images` | 로컬 이미지 목록 확인 |
| `docker logs web` | 컨테이너 로그 조회 |
| `docker logs -f web` | 로그 실시간 확인 |
| `docker exec -it web sh` | 실행 중인 컨테이너 내부 셸 접속 |
| `docker stop web` | 컨테이너 정지 |
| `docker start web` | 정지된 컨테이너 재시작 |
| `docker rm web` | 정지된 컨테이너 삭제 |
| `docker rm -f web` | 실행 중이어도 강제 삭제 |
| `docker system df` | Docker 디스크 사용량 확인 |

---

## 5. 환경 변수 및 일회용 컨테이너

`-e` 옵션을 사용하면 컨테이너 실행 시 환경 변수를 전달할 수 있다.

```bash
docker run -d -p 8083:80 -e MY_NAME=Kam --name env_test nginx
docker exec env_test env | grep MY_NAME
```

`-it`를 이용한 대화형 셸 실행과 `--rm`을 이용한 일회성 실행도 학습하였다.

```bash
docker run -it --rm ubuntu:24.04 bash
docker run --rm ubuntu:24.04 echo "hi"
docker run --rm python:3.12-slim python -c "print(0.1+0.2)"
```

`--rm`은 컨테이너 실행 종료 시 컨테이너를 자동으로 삭제한다.

---

## 6. 컨테이너별 Python 버전 비교

호스트에 서로 다른 Python 버전을 직접 설치하지 않고, Docker 컨테이너를 통해 실행 환경을 구분할 수 있다.

```bash
docker run --rm python:3.9-slim python --version
docker run --rm python:3.12-slim python --version
```

Python 3.10부터 지원하는 `match-case` 구문을 포함한 `test.py`로 실행 결과를 비교하였다.

```bash
docker run --rm -v "$PWD:/app" -w /app python:3.9-slim python test.py
docker run --rm -v "$PWD:/app" -w /app python:3.12-slim python test.py
```

- Python 3.9: `match` 구문에 대해 `SyntaxError` 발생
- Python 3.12: `two` 출력 (현재 저장소의 `test.py`에는 마지막 `print(value)`도 있어 `2`가 이어서 출력됨)
- `-v "$PWD:/app"`: 호스트의 현재 디렉터리를 컨테이너의 `/app`에 마운트
- `-w /app`: 컨테이너 작업 디렉터리를 `/app`으로 설정

[Python 버전 비교 코드](https://github.com/Dino1121/devops/blob/main/week05/test.py)

---

## 7. nginx 컨테이너 3개 실행 및 페이지 변경

개별 컨테이너를 8091, 8092, 8093 포트로 실행하고 각각의 `index.html`을 수정하여 서로 다른 화면을 표시하는 추가 실습을 진행하였다.

```bash
docker run -d -p 8091:80 --name nginx1 nginx
docker run -d -p 8092:80 --name nginx2 nginx
docker run -d -p 8093:80 --name nginx3 nginx

# 예: nginx1 컨테이너 안에서 기본 페이지 변경
docker exec nginx1 sh -c 'echo "Welcome to nginx1" > /usr/share/nginx/html/index.html'

curl http://localhost:8091
curl http://localhost:8092
curl http://localhost:8093
docker ps
```

위의 `docker exec`는 페이지를 변경하는 방법을 보여주는 예시 명령이다. 각 컨테이너의 화면과 실행 목록은 저장소에 업로드한 캡처로 확인할 수 있다.

- [nginx1 실행 화면](https://github.com/Dino1121/devops/blob/main/week05/images/nginx1.png) ([image](https://github.com/Dino1121/devops/raw/main/week05/images/nginx1.png))
- [nginx2 실행 화면](https://github.com/Dino1121/devops/blob/main/week05/images/nginx2.png) ([image](https://github.com/Dino1121/devops/raw/main/week05/images/nginx2.png))
- [nginx3 실행 화면](https://github.com/Dino1121/devops/blob/main/week05/images/nginx3.png) ([image](https://github.com/Dino1121/devops/raw/main/week05/images/nginx3.png))
- [docker ps 실행 결과](https://github.com/Dino1121/devops/blob/main/week05/images/docker-ps.png) ([image](https://github.com/Dino1121/devops/raw/main/week05/images/docker-ps.png))

실습 후 컨테이너 정리에 사용하는 명령어:

```bash
docker rm -f nginx1 nginx2 nginx3 web web2 web3 env_test 2>/dev/null
```

---

## 8. GitHub Issue 기반 작업 관리

Docker 실습을 하나의 Issue로 정의하고 다음과 같은 협업 흐름을 학습하였다.

`Issue → Branch → 실습 기록 → Commit/Push → Pull Request → Merge → Issue Close`

Issue에는 실습 목표와 완료 조건을 체크리스트로 작성한다. 작업 브랜치에서 README와 실습 결과를 기록한 뒤 Pull Request를 생성한다.

```bash
# 이슈 번호는 실제 GitHub Issue 번호로 변경
ISSUE_NO=6

git switch main
git pull --ff-only
git switch -c "docs/issue-${ISSUE_NO}-docker-start"

# 실습 결과를 작성한 다음
git add week05/
git commit -m "5주차: Docker 실행 환경 및 nginx 확인 (#${ISSUE_NO})"
git push -u origin "docs/issue-${ISSUE_NO}-docker-start"
```

PR 본문에 `Close #이슈번호`를 작성하면 연결된 PR이 기본 브랜치에 병합될 때 해당 Issue가 자동 종료된다.

```bash
gh pr create --title "5주차: Docker" --body "Close #${ISSUE_NO}"
gh pr merge --squash --delete-branch
```

위 명령의 이슈 번호 `6`은 교안 예시이므로 실제 수행 시 본인의 Issue 번호를 사용해야 한다.

---

## 9. 정리

이번 실습을 통해 다음 내용을 확인하였다.

- Docker는 애플리케이션과 실행 환경을 이미지로 묶어 컨테이너로 실행한다.
- VM은 Guest OS를 각각 사용하지만, Linux 컨테이너는 커널을 공유한다.
- 이미지는 컨테이너 생성의 기반이며, 하나의 이미지로 여러 컨테이너를 실행할 수 있다.
- `-d`는 백그라운드 실행, `-p`는 포트 연결, `-e`는 환경 변수 전달에 사용된다.
- 여러 컨테이너가 동일한 내부 포트를 사용하더라도 호스트 포트가 다르면 함께 실행할 수 있다.
- `docker ps`, `logs`, `exec`, `stop`, `rm` 등으로 컨테이너를 관리할 수 있다.
- 서로 다른 Python 버전의 컨테이너로 프로그램 호환성을 비교할 수 있다.
- 컨테이너의 쓰기 계층에 직접 수정한 내용은 해당 컨테이너 삭제 시 사라진다.
- GitHub Issue와 PR을 통해 실습 목표, 결과 및 변경 이력을 관리할 수 있다.
