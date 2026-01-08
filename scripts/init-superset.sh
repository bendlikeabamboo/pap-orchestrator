#!/bin/bash

set -e

echo "Initializing Superset..."

# Upgrade DB
superset db upgrade

# Create admin user
superset fab create-admin \
    --username admin \
    --firstname Admin \
    --lastname User \
    --email admin@example.com \
    --password admin

# Initialize Superset
superset init

echo "Superset initialization complete."
