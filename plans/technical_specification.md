# Technical Specification: Unified Data Platform Architecture

## Overview
This document outlines the unified Docker Compose architecture for a data platform integrating Apache Superset, ClickHouse, and OpenMetadata. The goal is to provide a modular, scalable, and easy-to-maintain environment for data visualization, warehousing, and metadata management.

## Architecture Components

### 1. Data Warehouse: ClickHouse
- **Service**: `clickhouse`
- **Image**: `clickhouse/clickhouse-server:latest`
- **Role**: Core data warehouse for analytical queries.
- **Dependencies**: None.

### 2. Visualization: Apache Superset
- **Services**:
    - `superset`: Main web application.
    - `superset-db`: PostgreSQL database for Superset metadata.
    - `superset-cache`: Redis for caching queries and dashboard data.
    - `superset-worker`: Celery worker for background tasks (optional but recommended).
- **Image**: `apache/superset:latest`
- **Connectivity**: Configured to connect to ClickHouse via `clickhouse-connect`.

### 3. Metadata Management: OpenMetadata
- **Services**:
    - `openmetadata-server`: Main application server.
    - `openmetadata-db`: PostgreSQL database for OpenMetadata metadata.
    - `openmetadata-search`: OpenSearch for metadata indexing and search.
    - `openmetadata-ingestion`: For profiling and metadata extraction from ClickHouse.
- **Image**: `openmetadata/server:latest`
- **Connectivity**: Configured to profile ClickHouse.

## Networking Strategy
A single bridge network named `data-platform-network` will be used to allow seamless communication between services using their service names as hostnames.

- `clickhouse:8123` (HTTP), `9000` (Native)
- `superset:8088`
- `openmetadata-server:8585`

## Volume Strategy
Named volumes will be used for data persistence to ensure data survives container restarts and removals.

- `clickhouse_data`: `/var/lib/clickhouse`
- `superset_db_data`: `/var/lib/postgresql/data`
- `superset_home`: `/app/superset_home`
- `openmetadata_db_data`: `/var/lib/postgresql/data`
- `openmetadata_search_data`: `/usr/share/opensearch/data`

## Environment Variables (`.env`)
All sensitive information (passwords, keys) and configurable parameters (ports, versions) will be stored in a `.env` file at the root of the repository.

## Service Dependencies & Health Checks
- `superset` depends on `superset-db` and `superset-cache` being healthy.
- `openmetadata-server` depends on `openmetadata-db` and `openmetadata-search` being healthy.
- Health checks will be implemented using `pg_isready` for Postgres and `curl` for web services.

## Proposed File Structure
```text
.
├── .env                    # Centralized environment variables
├── docker-compose.yaml     # Unified orchestration file
├── docker/
│   ├── clickhouse/
│   │   ├── config.xml      # Custom ClickHouse configuration
│   │   └── users.xml       # Custom ClickHouse users
│   ├── superset/
│   │   ├── Dockerfile      # Custom build to include clickhouse-connect
│   │   ├── superset_config.py
│   │   └── requirements-local.txt
│   └── openmetadata/
│       └── conf/           # OpenMetadata specific configurations
└── scripts/
    ├── init-superset.sh    # Initialization script for Superset (DB upgrade, admin user)
    └── wait-for-it.sh      # Utility script for service synchronization
```
