# -------- BUILDER STAGE --------
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

WORKDIR /app
ADD . /app

# Install Python deps into /app/.venv
RUN uv sync --frozen --no-dev


# -------- RUNTIME STAGE --------
FROM python:3.12-slim-bookworm

# Create non-root user
RUN groupadd -r app && useradd -r -g app app

# Copy built application
COPY --from=builder --chown=app:app /app /app

# Runtime system deps (minimal)
RUN apt-get update && apt-get install -y \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

ENV PATH="/app/.venv/bin:$PATH"

USER app
WORKDIR /app

EXPOSE 3000

# Run MCP in SSE mode
CMD ["postgres-mcp", "--transport", "sse", "--sse-host", "0.0.0.0", "--sse-port", "3000"]
