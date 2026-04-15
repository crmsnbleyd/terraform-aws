# Stage 1: Build dependencies
FROM python:3.9-slim AS builder

WORKDIR /app

# Install build dependencies if any C-extensions are needed
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     build-essential && \
#     rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install to a specific prefix to make copying easier and cleaner
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Final runtime image
FROM python:3.9-slim

ENV PATH=/home/python/.local/bin:$PATH
ENV FLASK_ENV=development

# Create a non-privileged user for security
RUN groupadd -g 1000 python && \
    useradd -u 1000 -g python -m python

WORKDIR /app

# Copy the installed site-packages from the builder stage
# We copy from the builder's user install directory to the new user's home
COPY --from=builder --chown=python:python /root/.local /home/python/.local
COPY --chown=python:python . .

# Switch to non-root user
USER python

EXPOSE 8080

# Use array syntax for CMD to handle signals (like SIGTERM) correctly
CMD ["gunicorn", "--workers=4", "--bind", "0.0.0.0:8080", "app:app"]
