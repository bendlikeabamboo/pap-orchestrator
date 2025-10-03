# Use official Superset 5.0.0 image
FROM apache/superset:5.0.0

USER root

# Set environment variables for production
ENV SUPERSET_ENV=production \
    SUPERSET_PORT=8088 \
    SUPERSET_HOME=/app/superset \
    PYTHONUNBUFFERED=1 \
    FLASK_ENV=production

# Install additional Python packages if needed
RUN . /app/.venv/bin/activate && \
    uv pip install \
        psycopg2-binary \
        clickhouse-connect \
        pymssql \
        openpyxl \
        Pillow

# Copy custom Superset config
COPY superset_config.py /app/pythonpath/superset_config.py

# Create a non-root user for security
RUN adduser --disabled-password --gecos '' supersetuser \
    && chown -R supersetuser:supersetuser $SUPERSET_HOME


USER supersetuser

# Expose Superset port
EXPOSE ${SUPERSET_PORT}

# Entrypoint script for initializing and starting Superset
CMD ["/bin/bash", "-c", "\
    superset db upgrade && \
    superset init && \
    gunicorn \
        --bind 0.0.0.0:${SUPERSET_PORT} \
        --workers 3 \
        --worker-class gthread \
        --timeout 120 \
        --log-level info \
        'superset.app:create_app()' \
"]