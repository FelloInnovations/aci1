FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

COPY . .

RUN uv sync --frozen --no-dev

# Show exactly what's inside aci/server/
RUN echo "=== FILES IN aci/server/ ===" && \
    find /app/aci/server -type f -name "*.py" | sort

CMD uv run uvicorn aci.server.app:app --host 0.0.0.0 --port ${PORT:-8000}
