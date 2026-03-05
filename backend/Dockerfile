FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Copy everything (make sure .dockerignore isn't blocking source)
COPY . .

# Install dependencies
RUN uv sync --frozen --no-dev

# Verify the server module exists
RUN uv run python -c "import aci.server; print('aci.server found')" || \
    (echo "=== CONTENTS OF /app/aci ===" && find /app/aci -type f -name "*.py" && exit 1)

CMD uv run uvicorn aci.server.app:app --host 0.0.0.0 --port ${PORT:-8000}
