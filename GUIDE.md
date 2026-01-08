# Data Platform Stack Guide

This guide provides detailed instructions for setting up, configuring, and maintaining the data platform stack.

## Prerequisites

Before you begin, ensure your system meets the following requirements:

- **Docker**: Version 20.10.0 or higher.
- **Docker Compose**: Version 2.0.0 or higher.
- **System Resources**:
  - Minimum 8GB RAM (16GB recommended).
  - 4 CPU cores.
  - 20GB free disk space.
- **Operating System**: Linux or macOS. Windows users should use [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install).

## Getting Started

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd pap-orchestrator
    ```

2.  **Configure Environment Variables**:
    Ensure the `.env` file is present in the root directory. Refer to the existing `.env` for required variables.

3.  **Spin up the stack**:
    ```bash
    docker compose up -d
    ```

4.  **Verify Services**:
    Check if all containers are running:
    ```bash
    docker compose ps
    ```

## Service Access

| Service | URL | Default Credentials |
| :--- | :--- | :--- |
| **ClickHouse** | `http://localhost:8123` | User: `${CLICKHOUSE_USER}`, Password: `${CLICKHOUSE_PASSWORD}` |
| **Apache Superset** | `http://localhost:8088` | User: `admin`, Password: `admin` (initialized via script) |
| **OpenMetadata** | `http://localhost:8585` | User: `admin`, Password: `admin` |

> **Note**: Refer to your `.env` file for the actual values of `${CLICKHOUSE_USER}` and `${CLICKHOUSE_PASSWORD}`.

## Configuration

### Connecting Superset to ClickHouse

To visualize data from ClickHouse in Superset:

1.  Log in to Superset (`http://localhost:8088`).
2.  Navigate to **Settings** > **Database Connections**.
3.  Click **+ Database**.
4.  Select **ClickHouse** from the list (or "Other" if not listed).
5.  Use the following SQLAlchemy URI format:
    ```text
    clickhouse+http://admin:admin_password@clickhouse:8123/default
    ```
    *Replace `admin`, `admin_password`, and `default` with values from your `.env` file.*
    *Note: Use `clickhouse` as the hostname since both services are in the same Docker network.*

### Setting up OpenMetadata to profile ClickHouse

To ingest metadata and profile ClickHouse in OpenMetadata:

1.  Log in to OpenMetadata (`http://localhost:8585`).
2.  Go to **Settings** > **Services** > **Databases**.
3.  Click **Add New Service** and select **Clickhouse**.
4.  Provide a name for the service.
5.  In the **Connection Config**, enter:
    - **Host and Port**: `clickhouse:8123`
    - **Username**: `${CLICKHOUSE_USER}`
    - **Password**: `${CLICKHOUSE_PASSWORD}`
    - **Database**: `${CLICKHOUSE_DB}`
6.  Test the connection and save.
7.  Set up an **Ingestion Pipeline** to schedule metadata extraction and profiling.

## Maintenance

### Basic Commands

- **View Logs**:
  ```bash
  docker compose logs -f [service_name]
  ```
- **Stop Services**:
  ```bash
  docker compose stop
  ```
- **Restart Services**:
  ```bash
  docker compose restart
  ```
- **Clean Up (Remove containers and networks)**:
  ```bash
  docker compose down
  ```
- **Clean Up (Including Volumes - WARNING: Data Loss)**:
  ```bash
  docker compose down -v
  ```

## Troubleshooting

### Common Issues

1.  **Superset fails to start**:
    - Check logs: `docker compose logs superset`.
    - Ensure `superset-db` is healthy.
    - Verify `SUPERSET_SECRET_KEY` is set in `.env`.

2.  **ClickHouse connection refused**:
    - Ensure you are using the service name `clickhouse` when connecting from other containers.
    - Check if port `8123` is occupied on the host.

3.  **OpenMetadata Server not reachable**:
    - It may take a few minutes for the server to fully initialize after the database and search services are up.
    - Check logs: `docker compose logs openmetadata-server`.

4.  **Insufficient Memory**:
    - If services crash unexpectedly, ensure Docker has enough memory allocated (especially on macOS/Windows).
