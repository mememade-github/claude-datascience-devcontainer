#!/bin/bash
# =============================================================================
# Claude DataScience DevContainer — Environment Setup (postCreateCommand)
# =============================================================================
set -e

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

STEP_TOTAL=5
STEP=0
step() { STEP=$((STEP + 1)); echo "[${STEP}/${STEP_TOTAL}] $1"; }

echo "=============================================="
echo "  Claude DataScience DevContainer Setup"
echo "=============================================="
echo ""

# =============================================================================
# 1. Docker 소켓 + Workspace 권한
# =============================================================================
step "권한 설정..."

if [ -S /var/run/docker.sock ]; then
    sudo chown root:docker /var/run/docker.sock 2>/dev/null || true
fi

WS="/workspaces"
find "$WS" -maxdepth 3 -name ".git" -type d 2>/dev/null | while read gitdir; do
    repo=$(dirname "$gitdir")
    git -C "$repo" config core.filemode false 2>/dev/null || true
done

# 명령 히스토리
if [ -d /commandhistory ]; then
    export HISTFILE=/commandhistory/.bash_history
    touch "$HISTFILE" 2>/dev/null || true
fi
echo "      완료"

# =============================================================================
# 2. SSH (선택사항)
# =============================================================================
step "SSH 설정..."
SSH_DIR="${HOME}/.ssh"
if [ -d "$SSH_DIR" ]; then
    chmod 700 "$SSH_DIR" 2>/dev/null || true
    find "$SSH_DIR" -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null || true
    find "$SSH_DIR" -type f -name "known_hosts*" -exec chmod 644 {} \; 2>/dev/null || true
    find "$SSH_DIR" -type f ! -name "*.pub" ! -name "known_hosts*" ! -name "config" -exec chmod 600 {} \; 2>/dev/null || true
    [ -f "$SSH_DIR/config" ] && chmod 644 "$SSH_DIR/config" 2>/dev/null || true
    echo "      SSH 키 발견됨"
else
    echo "      SSH 없음 (선택사항)"
fi

# =============================================================================
# 3. MCP: Context7
# =============================================================================
step "MCP: Context7..."
export HOME=${HOME:-/home/vscode}
export NVM_DIR=${NVM_DIR:-${HOME}/.nvm}
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

CLAUDE_CONFIG="${HOME}/.claude.json"

if ! command -v jq &>/dev/null; then
    echo "      WARN: jq 미설치 — MCP 설정 건너뜀"
else
    if [ ! -f "$CLAUDE_CONFIG" ]; then
        echo '{"mcpServers":{}}' > "$CLAUDE_CONFIG"
    fi

    # Context7 (라이브러리 문서 검색)
    jq '.mcpServers.context7 = {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {}
    }' "$CLAUDE_CONFIG" > /tmp/claude.json.tmp && mv /tmp/claude.json.tmp "$CLAUDE_CONFIG"

    echo "      context7: OK"
fi

# =============================================================================
# 4. MCP: Serena (코드 인텔리전스 — Dockerfile에서 사전 설치됨)
# =============================================================================
step "MCP: Serena..."
SERENA_DIR="${HOME}/work/serena"
UV_PATH=$(command -v uv 2>/dev/null || echo "${HOME}/.local/bin/uv")

if ! command -v jq &>/dev/null; then
    echo "      WARN: jq 미설치 — 건너뜀"
elif [ ! -d "$SERENA_DIR" ]; then
    echo "      WARN: Serena 미설치 ($SERENA_DIR 없음)"
elif [ ! -x "$UV_PATH" ]; then
    echo "      WARN: uv 미설치"
else
    jq --arg uv "$UV_PATH" --arg dir "$SERENA_DIR" '.mcpServers.serena = {
      "type": "stdio",
      "command": $uv,
      "args": ["run", "--directory", $dir, "serena-mcp-server", "--context", "claude-ds-devcontainer", "--project-from-cwd"],
      "env": {}
    }' "$CLAUDE_CONFIG" > /tmp/claude.json.tmp && mv /tmp/claude.json.tmp "$CLAUDE_CONFIG"
    echo "      serena: OK"
fi

# =============================================================================
# 5. Data Science 환경 확인
# =============================================================================
step "Data Science 환경 확인..."
CONDA_DIR="${HOME}/miniconda3"

if [ -d "$CONDA_DIR" ]; then
    . "${CONDA_DIR}/etc/profile.d/conda.sh"

    # conda env 확인
    if conda env list 2>/dev/null | grep -q "^ds "; then
        echo "      conda env 'ds': OK"
    else
        echo "      WARN: conda env 'ds' 없음"
    fi

    # Jupyter kernel 확인
    if conda run -n ds python -m jupyter kernelspec list 2>/dev/null | grep -q "ds"; then
        echo "      Jupyter kernel 'ds': OK"
    else
        echo "      WARN: Jupyter kernel 'ds' 없음 — 등록 시도..."
        conda run -n ds python -m ipykernel install --user --name ds --display-name "Python (ds)" 2>/dev/null || true
    fi
else
    echo "      WARN: Miniconda 미설치 ($CONDA_DIR 없음)"
fi

# =============================================================================
# Project-specific setup (파일 분리)
# 프로젝트별 커스텀 설정은 setup-env.project.sh에 작성.
# =============================================================================
PROJECT_SETUP="/usr/local/bin/setup-env.project.sh"
if [ -f "$PROJECT_SETUP" ]; then
    echo ""
    echo "--- Project Setup ---"
    source "$PROJECT_SETUP"
fi

# =============================================================================
# 완료
# =============================================================================
echo ""
echo "=============================================="
echo "  Setup Complete!"
echo "=============================================="
echo ""
echo "MCP: $(jq -r '.mcpServers | keys | join(", ")' "$CLAUDE_CONFIG" 2>/dev/null || echo "unknown")"
echo ""
echo "시작:  claude"
echo ""
echo "Data Science:"
echo "  conda activate ds              # DS 환경 활성화"
echo "  jupyter lab --ip=0.0.0.0       # JupyterLab 시작 (포트 8888)"
echo "  python -c 'import torch; print(torch.__version__)'  # PyTorch 확인"
echo ""
