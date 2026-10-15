# Week 02 - 실습 환경 구축과 버전 관리 기초

## 1. 서버와 가상화

서버의 역할과 가상화 기술의 차이를 학습하였다.

- **서버(Server)**: 클라이언트의 요청을 받아 서비스나 데이터를 제공하는 하드웨어 또는 소프트웨어이다.
- **베어메탈(Bare Metal)**: 물리 장비에 OS를 설치하고 프로그램을 실행하는 방식이다.
- **하이퍼바이저(Hypervisor)**: 하나의 물리 장비에서 여러 가상 머신을 운영할 수 있게 한다.
- **컨테이너(Container)**: 호스트의 커널을 공유하며 격리된 실행 환경을 제공한다.

---

## 2. WSL2와 Ubuntu 실습 환경

Windows에서 Linux 명령어를 사용하기 위해 WSL2와 Ubuntu 환경을 구성하는 실습을 진행하였다.

사용한 명령어 예시:

```bash
wsl --install
wsl --list --verbose
```

WSL2를 사용하면 Windows 환경에서도 Linux 터미널과 개발 도구를 활용할 수 있다.

---

## 3. Linux 기본 명령어

Ubuntu 터미널에서 파일과 디렉터리를 생성·이동·조회하는 명령어를 실습하였다.

| 명령어 | 용도 |
| --- | --- |
| `pwd` | 현재 작업 디렉터리 확인 |
| `ls`, `ls -l`, `ls -a` | 파일 목록 및 상세 정보 확인 |
| `cd` | 디렉터리 이동 |
| `mkdir` | 디렉터리 생성 |
| `touch` | 파일 생성 |
| `cp`, `mv` | 파일 복사·이동 |
| `cat`, `less` | 파일 내용 확인 |
| `rm`, `rmdir` | 파일·빈 디렉터리 삭제 |
| `whoami`, `uname -a` | 사용자 및 시스템 정보 확인 |

`rm -rf`는 하위 파일까지 강제로 삭제하므로 주의해서 사용해야 한다.

---

## 4. Git 저장소 생성과 커밋

Git으로 파일 변경 내역을 관리하는 기본 흐름을 학습하였다.

사용한 명령어 예시:

```bash
cd ~/devops
git init -b main
mkdir -p week02
echo "Hello, DevOps!" > week02/text.txt
git status
git add week02/text.txt
git commit -m "Add week02 practice"
git log --oneline
```

- `git init`: 로컬 Git 저장소 초기화
- `git status`: 변경 및 스테이징 상태 확인
- `git add`: 다음 커밋에 포함할 변경사항을 스테이징
- `git commit`: 변경사항을 하나의 버전으로 기록
- `git log`: 커밋 기록 확인

[실습 파일 text.txt](https://github.com/Dino1121/devops/blob/main/week02/text.txt)

---

## 5. 버전 비교와 브랜치

커밋 이력을 비교하고 브랜치를 나누어 독립적으로 작업하는 방법을 학습하였다.

```bash
git diff
git log --oneline
git switch -c hi
git branch
git switch main
```

브랜치를 사용하면 `main`의 작업 내용을 유지하면서 새로운 변경사항을 별도로 관리할 수 있다.

---

## 6. GitHub에 저장소 공유

로컬 저장소를 GitHub와 연결하고 작업 내용을 Push하는 과정을 학습하였다.

```bash
gh auth login
git remote -v
git push -u origin main
```

Git은 로컬 버전 관리 도구이고 GitHub는 Git 저장소를 원격으로 공유하고 협업하는 플랫폼이다.

[DevOps GitHub 저장소](https://github.com/Dino1121/devops)

---

## 7. 정리

이번 실습을 통해 다음 내용을 학습하였다.

- 서버, 가상 머신, 컨테이너의 개념과 차이를 이해하였다.
- WSL2와 Ubuntu를 활용하는 Linux 개발 환경을 익혔다.
- 기본 Linux 명령어로 파일과 디렉터리를 관리하는 방법을 배웠다.
- `add → commit → log`로 이어지는 Git 버전 관리 흐름을 학습하였다.
- 브랜치를 이용한 독립 작업과 GitHub를 통한 원격 공유 방법을 익혔다.
