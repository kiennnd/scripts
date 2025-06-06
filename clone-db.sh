#!/bin/bash
set -o allexport
source .db
set +o allexport

# Tên file backup
BACKUP_FILE="develop_db_backup.sql"


# Cấu hình thông tin Docker container local
DOCKER_CONTAINER="airdata-cms-api-postgres-1"  # Tên hoặc ID container Docker chạy PostgreSQL
LOCAL_USER="postgres"                          # Tên user trong Docker PostgreSQL
LOCAL_PASSWORD="postgres"                      # Mật khẩu user trong Docker PostgreSQL

# Export mật khẩu develop để sử dụng tự động
export PGPASSWORD=$DEVELOP_PASSWORD

echo "--------------------------------------------------------------------"
echo
echo "Connecting to database at $DEVELOP_HOST:$DEVELOP_PORT with user $DEVELOP_USER"
echo 
echo "--------------------------------------------------------------------"

echo
echo "Fetching list of databases from the develop environment..."
DB_LIST=$(psql -h $DEVELOP_HOST -p $DEVELOP_PORT -U $DEVELOP_USER -d postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")
if [ $? -ne 0 ]; then
  echo "Error: Unable to fetch database list from develop environment."
  exit 1
fi

echo
echo "Available databases:"
echo "$DB_LIST" | nl
echo

read -p "Enter the number corresponding to the database you want to backup: " DB_NUMBER
SELECTED_DB=$(echo "$DB_LIST" | sed -n "${DB_NUMBER}p" | xargs)
if [ -z "$SELECTED_DB" ]; then
  echo "Error: Invalid selection."
  exit 1
fi

echo
echo "You selected database: $SELECTED_DB"

# Bước 1: Dump database từ develop
echo
echo "--------------------------------------------------------------------"
echo
echo "Dumping database $SELECTED_DB from develop environment..."
echo
echo
pg_dump --verbose -h $DEVELOP_HOST -p $DEVELOP_PORT -U $DEVELOP_USER -d $SELECTED_DB -F c -f $BACKUP_FILE
if [ $? -ne 0 ]; then
  echo "Error: Failed to dump database $SELECTED_DB from develop environment."
  exit 1
fi

echo
echo
echo "Database dumped successfully to $BACKUP_FILE."

echo "--------------------------------------------------------------------"
# Bước 2: Xóa database cũ trong container Docker
echo "Dropping old database $SELECTED_DB in Docker container..."
docker exec -e PGPASSWORD=$LOCAL_PASSWORD $DOCKER_CONTAINER psql -U $LOCAL_USER -d postgres -c "DROP DATABASE IF EXISTS $SELECTED_DB;"
if [ $? -ne 0 ]; then
  echo "Error: Failed to drop the old database $SELECTED_DB in Docker container."
  exit 1
fi

# Bước 3: Tạo database mới trong container Docker
echo "Creating new database $SELECTED_DB in Docker container..."
docker exec -e PGPASSWORD=$LOCAL_PASSWORD $DOCKER_CONTAINER psql -U $LOCAL_USER -d postgres -c "CREATE DATABASE $SELECTED_DB;"
if [ $? -ne 0 ]; then
  echo "Error: Failed to create the new database $SELECTED_DB in Docker container."
  exit 1
fi

# Bước 4: Copy file backup vào container Docker
echo "Copying backup file into Docker container..."
docker cp $BACKUP_FILE $DOCKER_CONTAINER:/tmp/$BACKUP_FILE
if [ $? -ne 0 ]; then
  echo "Error: Failed to copy backup file into Docker container."
  exit 1
fi

# Bước 5: Restore database trong Docker container
echo "Restoring database $SELECTED_DB in Docker container..."
docker exec -e PGPASSWORD=$LOCAL_PASSWORD $DOCKER_CONTAINER pg_restore -U $LOCAL_USER -d $SELECTED_DB -F c /tmp/$BACKUP_FILE
if [ $? -ne 0 ]; then
  echo "Error: Failed to restore database $SELECTED_DB in Docker container."
  exit 1
fi

# Bước 6: Xóa file backup trong container và local
echo "Cleaning up backup files..."
rm -f $BACKUP_FILE
docker exec $DOCKER_CONTAINER rm -f /tmp/$BACKUP_FILE

echo
echo "Database $SELECTED_DB sync from develop to local (Docker) completed successfully!"
