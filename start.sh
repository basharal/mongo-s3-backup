#!/bin/bash

set -e

ACCESS_KEY=${ACCESS_KEY:?"ACCESS_KEY env variable is required"}
SECRET_KEY=${SECRET_KEY:?"SECRET_KEY env variable is required"}
MONGO_HOST=${MONGO_HOST:?"MONGO_HOST env variable is required"}
S3_PATH=${S3_PATH:?"S3_PATH env variable is required"}
MONGO_PORT=${MONGO_PORT:-27017}
DATA_PATH=${DATA_PATH:-/root/}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
PARAMS=${PARAMS}

echo "access_key=$ACCESS_KEY" >> /root/.s3cfg
echo "secret_key=$SECRET_KEY" >> /root/.s3cfg

if [[ "$1" == 'no-cron' ]]; then
    exec /backup.sh
# in the future, support restore
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV="PARAMS='$PARAMS'"
    CRON_ENV="$CRON_ENV\nACCESS_KEY='$ACCESS_KEY'"
    CRON_ENV="$CRON_ENV\nSECRET_KEY='$SECRET_KEY'"
    CRON_ENV="$CRON_ENV\nDATA_PATH='$DATA_PATH'"
    CRON_ENV="$CRON_ENV\nS3_PATH='$S3_PATH'"
    CRON_ENV="$CRON_ENV\nMONGO_HOST='$MONGO_HOST'"
    CRON_ENV="$CRON_ENV\nMONGO_PORT='$MONGO_PORT'"
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /backup.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    # there is a slight race-condition where cron might not see the crontab files
    # the sleep is to avoid that
    sleep 3
    cron
    tail -f "$LOGFIFO"
fi
