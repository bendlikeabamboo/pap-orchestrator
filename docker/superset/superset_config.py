import os

# Superset Secret Key
SECRET_KEY = os.getenv("SUPERSET_SECRET_KEY", "change_me_in_production")

# Database connection string
SQLALCHEMY_DATABASE_URI = f"postgresql://{os.getenv('SUPERSET_DB_USER')}:{os.getenv('SUPERSET_DB_PASSWORD')}@{os.getenv('SUPERSET_DB_HOST', 'superset-db')}:{os.getenv('SUPERSET_DB_PORT', '5432')}/{os.getenv('SUPERSET_DB_NAME')}"

# Redis for caching
REDIS_HOST = os.getenv("REDIS_HOST", "superset-cache")
REDIS_PORT = os.getenv("REDIS_PORT", "6379")

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_REDIS_HOST": REDIS_HOST,
    "CACHE_REDIS_PORT": REDIS_PORT,
    "CACHE_REDIS_DB": 1,
}

DATA_CACHE_CONFIG = CACHE_CONFIG

# Enable ClickHouse support
ADDITIONAL_MODULES = ["clickhouse-connect"]
