if [ ! -d "./superset/" ]; then
    echo "Superset does not exist. Creating it now..."
    git clone --depth=1  https://github.com/apache/superset.git
fi
cd superset
docker compose up --build