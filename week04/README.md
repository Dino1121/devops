# Week 04 - 자동화·협업 및 네트워크 실습

## 1. 파일 검색과 명령어 연결

Linux에서 필요한 파일과 문자열을 찾고 여러 명령어를 연결하는 방법을 학습하였다.

```bash
find . -type f -name "*.sh"
grep -R -n "exit 1" week03 2>/dev/null
grep -R "exit 1" week03 2>/dev/null | wc -l
```

- `find`: 조건에 맞는 파일 검색
- `grep`: 파일에서 특정 문자열 검색
- `|`: 앞 명령어의 표준 출력을 뒤 명령어의 표준 입력으로 연결
- `wc -l`: 출력된 줄 수 계산

---

## 2. 프로세스 확인

프로그램은 디스크에 저장된 실행 코드이고, 프로세스는 실행 중인 프로그램이다.

```bash
ps aux | head -5
ps aux | grep bash
htop
```

`PID`를 이용해 실행 중인 프로세스를 구분하고 관리하는 방법을 학습하였다.

---

## 3. 백업 스크립트 작성

백업 대상 디렉터리를 압축하고 결과 로그를 남기는 `backup.sh`를 작성하였다.

사용한 명령어:

```bash
cd ~/devops/week04
./backup.sh test
ls backups/*.tar.gz
```

스크립트 주요 기능:

- 첫 번째 인자로 백업할 폴더를 전달하며, 생략하면 `test`를 사용한다.
- 백업 파일명을 날짜·시간 및 PID를 이용하여 생성한다.
- `tar -czf`로 `.tar.gz` 파일을 생성한다.
- 백업 완료 여부와 파일 크기를 확인한다.
- 백업 기록을 `backups/backup.log`에 저장한다.

[backup.sh 코드](https://github.com/Dino1121/devops/blob/main/week04/backup.sh)

---

## 4. 백업 확인과 Git 추적 제외

압축 파일의 내용을 확인하고 필요할 때 복원하는 명령어를 학습하였다.

```bash
tar -tzf backups/파일명.tar.gz
tar -xzf backups/파일명.tar.gz
```

백업 결과물은 소스코드와 별도로 관리하도록 `.gitignore`를 이용해 Git 추적 대상에서 제외하는 방법을 학습하였다.

---

## 5. Git 브랜치와 Pull Request

별도의 브랜치에서 `backup.sh`의 로그 기록 기능을 다루고 Pull Request를 생성하여 병합하는 협업 과정을 실습하였다.

명령어 예시:

```bash
git switch -c feature/backup-log
git add week04/backup.sh
git commit -m "Add backup log"
git push -u origin feature/backup-log

gh pr create --title "백업 로그 기록 기능 추가"   --body "백업 일시와 파일명을 기록합니다."   --base main
```

PR을 사용하면 `main`에 즉시 반영하지 않고 변경사항을 검토한 뒤 Merge할 수 있다.

---

## 6. Conflict 발생과 해결

서로 다른 브랜치에서 같은 줄을 변경하면 Git이 어느 변경을 선택할지 결정하지 못해 충돌이 발생할 수 있다.

충돌 표시 예시:

```text
<<<<<<< HEAD
현재 브랜치의 내용
=======
병합 대상 브랜치의 내용
>>>>>>> origin/main
```

충돌 구간을 직접 수정하고 표시를 제거한 뒤, 수정한 파일을 커밋하여 Merge하는 흐름을 학습하였다.

```bash
git status
git add week04/backup.sh
git commit -m "Resolve merge conflict"
git push
```

---

## 7. IP·포트·DNS

네트워크 통신에 필요한 개념을 학습하였다.

- **IP 주소**: 네트워크에서 장치를 식별하는 주소
- **포트**: 장치 내부에서 서비스를 구분하는 번호
- **DNS**: 도메인 이름에 대응하는 IP 주소를 조회
- **NAT**: 사설 IP를 사용하는 장치가 외부 네트워크와 통신할 수 있게 주소를 변환
- **localhost (`127.0.0.1`)**: 현재 컴퓨터 자신을 가리키는 주소

네트워크 확인 명령어:

```bash
ip addr
ping -c 4 8.8.8.8
dig cs.inhatc.ac.kr
curl -I https://google.com
ss -tlnp
```

`ping` 실패만으로 웹 서비스가 중단되었다고 판단할 수는 없다.

---

## 8. 로컬 웹 서버와 포트 충돌

Python의 기본 HTTP 서버를 이용해 로컬 웹 페이지를 제공하는 실습을 진행하였다.

```bash
python3 -m http.server 8080
```

브라우저에서 `http://localhost:8080`으로 접속하고 `curl`로 HTTP 응답을 확인하는 방식이다.

```bash
curl http://localhost:8080
curl -I http://localhost:8080
```

이미 사용 중인 `8080` 포트에 다른 서버를 실행하면 포트 충돌이 발생한다. 다른 포트를 사용하거나 기존 서버의 프로세스를 종료하여 해결할 수 있다.

```bash
python3 -m http.server 8000
ss -tlnp | grep 8080
kill <PID>
```

`0.0.0.0`에 바인딩하는 것은 모든 네트워크 인터페이스에서 연결을 받도록 설정한다는 의미이고, 실제 외부 접속 가능 여부는 방화벽 및 네트워크 설정에도 영향을 받는다.

---

## 9. 정리

이번 실습을 통해 다음 내용을 학습하였다.

- `find`, `grep`, 파이프를 이용한 파일 및 텍스트 검색 방법을 익혔다.
- 프로세스와 PID의 의미를 이해하였다.
- `backup.sh`로 압축 백업과 로그 기록을 자동화하였다.
- 브랜치 → PR → 충돌 해결 → Merge의 협업 흐름을 학습하였다.
- IP, 포트, DNS, NAT의 역할을 이해하였다.
- `curl`, `dig`, `ss` 등을 이용한 네트워크 상태 확인과 웹 서버 포트 충돌 해결 방법을 익혔다.
