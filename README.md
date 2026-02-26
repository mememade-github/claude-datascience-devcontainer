# Claude DataScience DevContainer

Claude Code + 13 Agent System + Miniconda + PyTorch CPU + Jupyter가 포함된 데이터 사이언스 개발 환경.

**필요 조건**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)

---

## 시작하기

### Step 1: 클론 & 빌드

```bash
git clone <repo-url> my-ds-project
cd my-ds-project/.devcontainer
docker compose up -d --build    # 첫 빌드 ~8-10분 (DS 패키지 포함)
```

### Step 2: 컨테이너 진입

```bash
docker exec -it claude-ds-dev bash
```

### Step 3: 환경 확인

```bash
conda activate ds
python -c "import torch; print(torch.__version__)"
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
```

### Step 4: Claude Code 실행

```bash
claude --dangerously-skip-permissions
```

### Step 5: 저장

```bash
git add -A && git commit -m "chore: initialize ds project"
```

---

## VS Code로 사용하기 (권장)

VS Code + Jupyter 노트북 바이브 코딩 환경이 이 템플릿의 핵심입니다.

**추가 필요**: [VS Code](https://code.visualstudio.com/) + [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

1. VS Code로 프로젝트 폴더 열기
2. 좌측 하단 `><` → **Reopen in Container**
3. `.ipynb` 파일 생성 → 커널 "Python (ds)" 선택
4. 터미널에서 `claude` 실행

> VS Code 사용 시 Jupyter 노트북이 자동으로 인식됩니다. 별도 `jupyter lab` 실행 불필요.

---

## 포함 패키지

| 카테고리 | 패키지 |
|----------|--------|
| **코어** | numpy, pandas, scipy, scikit-learn, statsmodels |
| **딥러닝** | pytorch, torchvision, torchaudio (CPU only) |
| **시각화** | matplotlib, seaborn, plotly |
| **Jupyter** | jupyterlab, notebook, ipykernel, ipywidgets |
| **데이터** | sqlalchemy, duckdb, openpyxl, xlsxwriter |
| **유틸** | tqdm, requests, pillow |

## 추가 패키지 설치

```bash
# conda 패키지
conda install -n ds -y xgboost lightgbm

# pip 패키지 (conda에 없는 경우)
conda activate ds && pip install transformers
```

## 포함 사항

| 구성 | 수량 | 내용 |
|------|------|------|
| Agents | 13 | code-reviewer, security-reviewer, debugger, planner, architect 등 |
| Hooks | 12 | 세션 시작, 파괴적 명령 차단, 코드리뷰 자동 트리거, 커밋 전 검증 등 |
| Skills | 8 | /commit, /pr, /verify, /status, /deploy, /build-fix, /eval, /audit |
| MCP | 2 | Context7 (문서 검색), Serena (코드 인텔리전스) |
| Tools | 20+ | ripgrep, fd, fzf, jq, tmux, docker CLI, gh 등 |
| DS | 20+ | numpy, pandas, torch, jupyter, matplotlib, duckdb 등 |

## Runtime 격리

```
Claude Code:    Node.js 20 (locked) + System python3 (Serena/uv)
Data Science:   Miniconda Python 3.12 (conda env: ds) + Jupyter + PyTorch CPU
Project:        nvm project-node (선택)
```

## 포트 변경

`.devcontainer/.env`의 `PORT_*` 값 변경 후 `.devcontainer/devcontainer.json`의 `forwardPorts`도 동일하게 수정. 이후 컨테이너 재빌드.

## Troubleshooting

| 문제 | 해결 |
|------|------|
| 빌드 실패 | `docker compose build --no-cache` (~8-10분) |
| Claude 재인증 | `docker volume ls \| grep claude-config` 확인 |
| MCP 연결 실패 | `rm ~/.claude.json && /usr/local/bin/setup-env.sh` |
| 포트 충돌 | `.env` + `devcontainer.json` 포트 변경 후 재빌드 |
| conda 없음 | `source ~/miniconda3/etc/profile.d/conda.sh` |
| import 에러 | `conda activate ds` 확인 후 패키지 설치 |
| Jupyter kernel 없음 | `conda run -n ds python -m ipykernel install --user --name ds` |
| 이미지 크기 (~4-5GB) | 정상. DS 패키지(PyTorch 등) 포함으로 큰 이미지 |
