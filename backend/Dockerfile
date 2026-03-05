FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv by copying the binary directly from the official uv image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Copy ALL source code first (hatchling needs the aci package present to build)
COPY . .

# Install dependencies (no editable install issues since source is present)
RUN uv sync --frozen --no-dev

# Start the FastAPI server
CMD uv run uvicorn aci.server.app:app --host 0.0.0.0 --port ${PORT:-8000}
