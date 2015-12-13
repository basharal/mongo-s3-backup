#!/bin/bash

set -e

echo "Job started: $(date)"
BACKUP_NAME="$DATA_PATH/backup-$(date +%Y-%m-%dT%H:%M:%S).gz"
/usr/bin/mongodump --host="$MONGO_HOST" --port=$MONGO_PORT --gzip --archive="$BACKUP_NAME"
/usr/local/bin/s3cmd put $PARAMS "$BACKUP_NAME" "$S3_PATH"

echo "Job finished: $(date)"
