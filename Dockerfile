# Build frontend assets
FROM node:22-slim AS node-builder
WORKDIR /app
COPY package.json ./
RUN npm install
COPY vite.config.js ./
COPY frontend/ ./frontend/
COPY templates/ ./templates/
RUN npm run build

# First, build the application in the `/app` directory
FROM ghcr.io/astral-sh/uv:0.11.15-trixie-slim AS builder
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

# Omit development dependencies
ENV UV_NO_DEV=1

# Configure the Python directory so it is consistent
ENV UV_PYTHON_INSTALL_DIR=/python

# Only use the managed Python version
ENV UV_PYTHON_PREFERENCE=only-managed

# Install Python before the project for caching
RUN uv python install 3.14

WORKDIR /app
COPY pyproject.toml /app/
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --no-install-project
COPY . /app
COPY --from=node-builder /app/static ./static
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync

# Then, use a final image without uv
FROM debian:trixie-slim

# Set environment variables for production
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/app/.venv/bin:$PATH"

# Install runtime dependencies only
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Setup a non-root user
RUN groupadd --system --gid 999 nonroot \
 && useradd --system --gid 999 --uid 999 --create-home nonroot

# Copy the Python version
COPY --from=builder /python /python

# Copy the application from the builder
COPY --from=builder --chown=nonroot:nonroot /app /app

# Use the non-root user to run our application
USER nonroot

# Use `/app` as the working directory
WORKDIR /app

ENV DJANGO_SETTINGS_MODULE=myproject.settings \
    DEBUG=False \
    SECRET_KEY=collectstatic-placeholder \
    ALLOWED_HOSTS=localhost

RUN python manage.py collectstatic --noinput

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000').read()" || exit 1

CMD ["sh", "-c", "gunicorn myproject.wsgi:application --bind 0.0.0.0:${PORT:-8000} --workers 2 --timeout 30 --access-logfile -"]
