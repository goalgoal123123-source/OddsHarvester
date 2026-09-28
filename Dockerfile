FROM python:3.11-slim

# 1. 安裝系統基礎工具
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. 安裝 Python 套件管理工具 (uv) 並安裝專案依賴
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev

# 3. 關鍵：下載 Chromium 瀏覽器及其所需的底層系統庫
RUN uv run playwright install --with-deps chromium

# 4. 把專案所有檔案（包含剛才建立的 run_collector.sh）複製進去
COPY . .

# 5. 給執行腳本加上執行權限，並建立存放抓取結果的資料夾
RUN chmod +x run_collector.sh && mkdir -p /app/output

# 6. 指定容器開機時自動執行的動作
CMD ["bash", "run_collector.sh"]
