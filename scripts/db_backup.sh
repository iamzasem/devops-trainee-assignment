#!/bin/bash

BACKUP_DIR="/var/backups/db"
DATE=$(date +%Y%m%d)
BACKUP_FILE="$BACKUP_DIR/db_backup_$DATE.sql.gz"

docker exec trainee-db pg_dump -U trainee trainee_db | gzip > "$BACKUP_FILE"

echo "Database backup completed:"
echo "$BACKUP_FILE"


