# PROJECT.md — DataScience Domain Context

> Data Science 프로젝트 템플릿.
> 거버넌스 규칙: [CLAUDE.md](CLAUDE.md)
> 명령어/절차: [REFERENCE.md](REFERENCE.md)

---

## Pre-installed DS Packages

### 코어

| Package | Version | 용도 |
|---------|---------|------|
| numpy | latest | 수치 계산 |
| pandas | latest | 데이터 조작 |
| scipy | latest | 과학 계산 |
| scikit-learn | latest | 머신러닝 |
| statsmodels | latest | 통계 모델링 |

### 딥러닝

| Package | Version | 용도 |
|---------|---------|------|
| pytorch | latest (CPU) | 딥러닝 프레임워크 |
| torchvision | latest | 이미지 처리 |
| torchaudio | latest | 오디오 처리 |

### 시각화

| Package | 용도 |
|---------|------|
| matplotlib | 기본 차트 |
| seaborn | 통계 시각화 |
| plotly | 인터랙티브 차트 |

### Jupyter

| Package | 용도 |
|---------|------|
| jupyterlab | 노트북 IDE |
| notebook | 클래식 노트북 |
| ipykernel | Jupyter 커널 |
| ipywidgets | 인터랙티브 위젯 |

### 데이터/유틸

| Package | 용도 |
|---------|------|
| sqlalchemy | DB ORM |
| duckdb | 임베디드 분석 DB |
| tqdm | 프로그레스 바 |
| requests | HTTP 클라이언트 |
| pillow | 이미지 처리 |
| openpyxl | Excel 읽기 |
| xlsxwriter | Excel 쓰기 |

## Directory Convention

```
/workspaces/
├── notebooks/          # Jupyter 노트북 (.ipynb)
│   ├── 01-eda.ipynb   # 탐색적 데이터 분석
│   ├── 02-model.ipynb # 모델링
│   └── ...
├── data/
│   ├── raw/           # 원본 데이터 (gitignored)
│   └── processed/     # 전처리 데이터 (gitignored)
├── models/            # 학습된 모델 (gitignored)
├── src/               # 재사용 가능한 Python 코드
│   ├── __init__.py
│   ├── data.py        # 데이터 로딩/전처리
│   ├── features.py    # 피처 엔지니어링
│   ├── model.py       # 모델 정의/학습
│   └── evaluate.py    # 평가 메트릭
├── outputs/           # 결과물 (차트, 리포트)
└── tests/             # 테스트
```

## Services

| Service | Port | Health Check |
|---------|------|--------------|
| JupyterLab | 8888 | http://localhost:8888 |

## MCP Servers

| Server | 용도 |
|--------|------|
| Context7 | 라이브러리 문서 검색 |
| Serena | 코드 인텔리전스 (Python) |

## Environment

- **Runtime**: Miniconda Python 3.12 (conda env: ds)
- **Secrets**: `.devcontainer/.env`

---

*Customize this file for your project. Delete template placeholders.*
