#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

# Variables
## Remote Server Config
REMOTE_DB_HOST="${REMOTE_DB_HOST:-localhost}"
REMOTE_DB_PORT="${REMOTE_DB_PORT:-5432}"
REMOTE_DB_USER="${REMOTE_DB_USER:-postgres}"
REMOTE_DB_PASSWORD="${REMOTE_DB_PASSWORD:-password}"
REMOTE_DB_NAME="${REMOTE_DB_NAME:-dbName}"
## Local Server Config
LOCAL_DB_USER="${LOCAL_DB_USER:-postgres}"
LOCAL_DB_NAME="${LOCAL_DB_NAME:-dbName}"
BACKUP_FILE="${BACKUP_FILE:-backup.sql}"
INITDB_DIR="${INITDB_DIR:-initdb}"


# Function to perform backup from remote server
perform_backup() {
    echo "Backing up remote database..."
    export PGPASSWORD=$REMOTE_DB_PASSWORD
    pg_dump -h $REMOTE_DB_HOST -p $REMOTE_DB_PORT -U $REMOTE_DB_USER -d $REMOTE_DB_NAME -F c -b -v -f $BACKUP_FILE
    unset PGPASSWORD
}

# Ensure initdb directory exists
mkdir -p $INITDB_DIR

# Check if the backup file exists in the current directory or initdb directory
if [ ! -f "$BACKUP_FILE" ] && [ ! -f "$INITDB_DIR/$BACKUP_FILE" ]; then
    perform_backup
    echo "Copying backup file to initdb directory..."
    mv $BACKUP_FILE $INITDB_DIR/
elif [ -f "$BACKUP_FILE" ]; then
    echo "Backup file already exists in the current directory. Moving to initdb directory..."
    mv $BACKUP_FILE $INITDB_DIR/
else
    echo "Backup file already exists in the initdb directory. Skipping remote backup."
fi

# Import the backup into local Docker PostgreSQL
echo "Importing backup into local PostgreSQL..."
docker-compose down
docker-compose up -d

# Wait for PostgreSQL to start
echo "Waiting for PostgreSQL to start..."
sleep 30

# Restore the backup
echo "Restoring the backup start..."
docker exec -i my_postgres pg_restore --no-owner --no-privileges -U $LOCAL_DB_USER -d $LOCAL_DB_NAME < $INITDB_DIR/$BACKUP_FILE
echo "Backup Restore Completed :)"
# Cleanup
echo "Cleaning up..."
# rm $INITDB_DIR/$BACKUP_FILE

echo "Backup and import completed successfully!"