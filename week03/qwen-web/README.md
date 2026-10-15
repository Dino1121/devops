# Week 03 - 셸 스크립팅 실습

## 1. 셸 스크립트와 자동화

반복해서 입력해야 하는 명령어를 셸 스크립트로 묶어 실행하는 방법을 학습하였다.

- 반복 작업의 시간과 실수를 줄일 수 있다.
- `.sh` 파일에 여러 명령어를 작성해 재사용할 수 있다.
- `#!/bin/bash`는 스크립트를 해석할 인터프리터를 지정하는 shebang이다.

실행 권한을 부여한 뒤 스크립트를 실행하는 명령어:

```bash
chmod u+x start.sh
./start.sh
```

---

## 2. Ollama와 Qwen 모델

Ollama를 이용해 로컬에서 Qwen 언어 모델을 실행하는 실습을 진행하였다.

사용한 모델: `qwen3:0.6b`

사용한 명령어:

```bash
ollama pull qwen3:0.6b
ollama list
curl http://127.0.0.1:11434/api/tags
```

- Ollama는 로컬 모델 실행을 위한 서비스를 제공한다.
- Qwen은 질문을 입력받아 텍스트 응답을 생성하는 모델이다.
- `11434`는 Ollama API에 접근할 때 사용하는 기본 포트이다.

---

## 3. Python 웹 채팅 프로그램

제공된 `chat.py`를 이용해 로컬 AI 웹 서비스를 실행하는 실습을 진행하였다.

```bash
cd ~/devops/week03/qwen-web
python3 chat.py
```

웹 브라우저에서 `http://localhost:8000`으로 접근하는 방식이다. Python 웹 프로그램과 Ollama 서버는 별도의 프로세스이므로 각각 실행 상태를 확인해야 한다.

[chat.py 코드](https://github.com/Dino1121/devops/blob/main/week03/qwen-web/chat.py)

---

## 4. 실행 명령어 자동화

프로그램을 실행할 때마다 디렉터리를 이동하고 Python 명령어를 입력하는 작업을 스크립트로 대체하였다.

기본 `start.sh`의 구조:

```bash
#!/bin/bash
cd "$(dirname "$0")" || exit 1
exec python3 chat.py
```

- `$(dirname "$0")`: 현재 실행 중인 스크립트가 있는 디렉터리 확인
- `|| exit 1`: 앞의 명령어가 실패하면 종료
- `exec`: 셸 프로세스를 Python 프로세스로 대체

[실습 start.sh](https://github.com/Dino1121/devops/blob/main/week03/qwen-web/start.sh)

---

## 5. 환경 변수 사용

`export`로 자식 프로세스에 환경 변수를 전달하는 방법을 학습하였다.

```bash
#!/bin/bash
cd "$(dirname "$0")" || exit 1
export MODEL="qwen3:0.6b"
exec ./start.sh
```

웹 서버의 실행 포트를 변경하는 예시:

```bash
export WEB_PORT="8080"
```

환경 변수는 프로그램의 코드를 직접 수정하지 않고 모델이나 포트 같은 실행 설정을 전달하는 데 사용할 수 있다.

[환경 변수 스크립트](https://github.com/Dino1121/devops/blob/main/week03/qwen-web/start_with_export.sh) · [포트 변경 스크립트](https://github.com/Dino1121/devops/blob/main/week03/qwen-web/start_with_export_2.sh)

---

## 6. 조건문과 오류 처리

스크립트 시작 전 필요한 명령어가 설치되어 있는지 확인하는 조건문을 학습하였다.

```bash
if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3를 먼저 설치하세요." >&2
    exit 1
fi
```

- `command -v`: 명령어 사용 가능 여부 확인
- `>/dev/null 2>&1`: 표준 출력과 표준 오류를 숨김
- `>&2`: 오류 메시지를 표준 오류로 출력
- `exit 1`: 실패 상태로 종료

---

## 7. 정리

이번 실습을 통해 다음 내용을 학습하였다.

- Ollama와 Qwen을 사용한 로컬 AI 서비스의 실행 구조를 이해하였다.
- `chat.py` 실행 과정을 셸 스크립트로 자동화하였다.
- Shebang, 실행 권한, 스크립트의 경로 처리 방법을 학습하였다.
- `export`로 실행 환경을 설정하고 포트를 변경하는 방법을 익혔다.
- `if`, `command -v`, 종료 코드를 이용한 오류 처리 방식을 학습하였다.
