FROM python:3.12-slim

# Install system dependencies needed for psycopg2 / pgvector etc.
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv (the package manager ACI uses)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

WORKDIR /app

# Copy dependency files first (for Docker layer caching)
COPY pyproject.toml uv.lock* ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy the rest of the source code
COPY . .

# Expose the port Railway will assign via $PORT
EXPOSE 8000

# Start the FastAPI server
CMD uv run uvicorn aci.server.app:app --host 0.0.0.0 --port ${PORT:-8000}
