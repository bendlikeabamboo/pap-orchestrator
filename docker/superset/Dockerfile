# Use official Superset 5.0.0 image
FROM apache/superset:5.0.0

USER root

# Set environment variables
ENV SUPERSET_ENV=production \
    SUPERSET_PORT=8088 \
    SUPERSET_HOME=/app/superset_home \
    PYTHONUNBUFFERED=1 \
    FLASK_ENV=production \
    PYTHONPATH=/app/pythonpath

# Install additional Python packages
COPY requirements-local.txt /app/requirements-local.txt
RUN pip install --no-cache-dir --prefix=/app/.venv -r /app/requirements-local.txt

# Copy custom Superset config
COPY superset_config.py /app/pythonpath/superset_config.py

# Ensure superset_home exists and has correct permissions
RUN mkdir -p ${SUPERSET_HOME} && chown -R superset:superset ${SUPERSET_HOME}

# Use the default superset user
USER superset

# Expose Superset port
EXPOSE ${SUPERSET_PORT}
