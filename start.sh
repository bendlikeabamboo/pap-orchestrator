
# Open metadata
mkdir openmetadata-docker && cd openmetadata-docker
wget https://github.com/open-metadata/OpenMetadata/releases/download/1.9.1-release/docker-compose-postgres.yml
docker compose -f docker-compose-postgres.yml up --detach

cd ../
git clone --depth=1  https://github.com/apache/superset.git

