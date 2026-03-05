FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    awscli \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

COPY . .

RUN uv sync --frozen --no-dev

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
