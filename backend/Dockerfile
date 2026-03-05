FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Copy ALL source code
COPY . .

# Install dependencies
RUN uv sync --frozen --no-dev

# Print directory structure at build time so we can see the app layout
RUN find /app/aci -name "*.py" | head -40

# Start the FastAPI server - try common entrypoints
CMD uv run uvicorn aci.server.app:app --host 0.0.0.0 --port ${PORT:-8000}
