# pap-orchestrator

Orchestrator for the **Punan ang Patlang** data platform stack.

## Overview

This repository contains the Docker Compose configuration to spin up a modern data platform stack consisting of:

- **[ClickHouse](https://clickhouse.com/)**: A fast open-source column-oriented database management system that allows generating analytical data reports in real-time using SQL.
- **[Apache Superset](https://superset.apache.org/)**: A modern data exploration and visualization platform.
- **[OpenMetadata](https://openmetadata.org/)**: A unified metadata management solution that includes data discovery, governance, and quality.

## Quick Start

1.  **Prerequisites**: Ensure you have Docker and Docker Compose installed.
2.  **Environment**: Copy `.env.example` to `.env` (if available) or ensure `.env` is configured.
3.  **Launch**:
    ```bash
    docker compose up -d
    ```

## Documentation

For detailed instructions on setup, configuration, and maintenance, please refer to the [**GUIDE.md**](GUIDE.md).

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.
