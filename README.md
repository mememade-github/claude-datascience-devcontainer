# Claude DataScience DevContainer

Claude Code + 13 Agent System + Miniconda + PyTorch CPU + Jupyter 데이터 사이언스 개발 환경.

---

## 필요 조건

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) + [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

---

## 시작하기

### 1. 클론

```bash
git clone <repo-url> my-ds-project
```

### 2. VS Code에서 열기

1. VS Code → File → Open Folder → `my-ds-project` 선택
2. `Ctrl+Shift+P` → **Dev Containers: Reopen in Container**
3. 첫 빌드 ~8-10분 (DS 패키지 포함)

### 3. Claude Code 실행

```bash
# 새 세션 시작 (권한 프롬프트 없이 자동 승인)
claude --dangerously-skip-permissions

# 이전 세션 이어서 작업
claude --dangerously-skip-permissions --continue
```

> `--dangerously-skip-permissions`: 파일 수정, 명령 실행 등 모든 도구를 승인 없이 허용합니다.
> `--continue`: 마지막 대화 컨텍스트를 이어받아 계속합니다.

### 4. Jupyter 사용

```bash
# VS Code에서: .ipynb 파일 생성 → 커널 "Python (ds)" 선택 (자동 인식, 별도 실행 불필요)

# 브라우저에서 JupyterLab 사용 시:
conda activate ds
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
```

### 5. 저장

```bash
git add -A && git commit -m "chore: initialize ds project"
```

---

## VS Code 연결 방식

| 방식 | 설정 적용 | 워크스페이스 | 확장 |
|------|----------|-------------|------|
| **Reopen in Container** (권장) | devcontainer.json 전체 적용 | `/workspaces/` 자동 | Jupyter 등 자동 설치 |
| **Attach to Running Container** | 미적용 | 수동 Open Folder 필요 | 수동 설치 필요 |

**Reopen in Container 접근:**
1. VS Code에서 프로젝트 폴더를 **로컬로** 열기 (File → Open Folder)
2. `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

> Attach는 이미 실행 중인 컨테이너에 단순 연결합니다. devcontainer.json 설정(워크스페이스 경로, 확장, 포트 포워딩)이 적용되지 않습니다.

---

## 포함 패키지

| 카테고리 | 패키지 |
|----------|--------|
| **코어** | numpy, pandas, scipy, scikit-learn, statsmodels |
| **딥러닝** | pytorch, torchvision, torchaudio (CPU) |
| **시각화** | matplotlib, seaborn, plotly |
| **Jupyter** | jupyterlab, notebook, ipykernel, ipywidgets |
| **데이터** | sqlalchemy, duckdb, openpyxl, xlsxwriter |
| **유틸** | tqdm, requests, pillow |

## 추가 패키지 설치

```bash
conda install -n ds -y xgboost lightgbm
conda activate ds && pip install transformers   # conda에 없는 경우
```

## 포함 사항

| 구성 | 수량 |
|------|------|
| Agents | 13 (code-reviewer, debugger, planner, architect 등) |
| Hooks | 12 (세션 시작, 파괴적 명령 차단, 코드리뷰, 커밋 전 검증 등) |
| Skills | 8 (/commit, /pr, /verify, /status, /deploy, /build-fix, /eval, /audit) |
| MCP | 2 (Context7, Serena) |
| Tools | 20+ (ripgrep, fd, fzf, jq, tmux, docker CLI, gh 등) |
| DS | 20+ (numpy, pandas, torch, jupyter, matplotlib, duckdb 등) |

## Runtime 격리

```
Claude Code:    Node.js 20 (locked) + System python3 (Serena/uv)
Data Science:   Miniconda Python 3.12 (conda env: ds)
Project:        nvm project-node (선택)
```

## 포트

| 변수 | 기본값 | 용도 |
|------|--------|------|
| PORT_APP | 3000 | 앱 |
| PORT_API | 8080 | API |
| PORT_DB | 5432 | DB |
| PORT_EXTRA | 8888 | JupyterLab |

변경: `.devcontainer/.env`의 `PORT_*` 수정 + `devcontainer.json`의 `forwardPorts` 동기화 → 컨테이너 재빌드.

## Troubleshooting

| 문제 | 해결 |
|------|------|
| 빌드 실패 | `docker compose build --no-cache` |
| 파일이 안 보임 | "Reopen in Container" 사용 (Attach 아님) |
| Reopen 메뉴 없음 | Dev Containers 확장 설치 확인 |
| conda 없음 | `source ~/miniconda3/etc/profile.d/conda.sh` |
| import 에러 | `conda activate ds` 확인 |
| Jupyter kernel 없음 | `conda run -n ds python -m ipykernel install --user --name ds` |
| Claude 재인증 | `docker volume ls \| grep claude-config` |
| MCP 연결 실패 | `rm ~/.claude.json && /usr/local/bin/setup-env.sh` |
| 포트 충돌 | `.env` + `devcontainer.json` 포트 변경 후 재빌드 |
