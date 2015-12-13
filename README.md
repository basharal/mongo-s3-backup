basharal/backup-to-s3
======================

Docker container that periodically backups MongoDB instance to Amazon S3 using [s3cmd put](http://s3tools.org/s3cmd-put), mongodump, and cron.

### Usage

    docker run -d [OPTIONS] basharal/mongo-s3-backup

### Parameters:

* `-e ACCESS_KEY=<AWS_KEY>`: Your AWS key.
* `-e SECRET_KEY=<AWS_SECRET>`: Your AWS secret.
* `-e S3_PATH=s3://<BUCKET_NAME>/<PATH>/`: S3 Bucket name and path. Should end with trailing slash.
* `-e MONGO_HOST=<MONGODB_HOSTNAME>`: Hostname for MongoDB

### Optional parameters:

* `-e MONGO_PORT=27017`: Port for MongoDB, default is 27017 
* `-e PARAMS="--dry-run"`: parameters to pass to the s3cmd put command ([full list here](http://s3tools.org/usage)).
* `-e DATA_PATH=/data/`: container's backup directory (where backups will be stored locally before uploading to S3). 
   Default is `/root/`. Should end with trailing slash.
* `-e 'CRON_SCHEDULE=0 1 * * *'`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)). Default is `0 1 * * *` (runs every day at 1:00 am).
* `no-cron`: run container once and exit (no cron scheduling).

### Examples:

Run upload to S3 everyday at 12:00pm:

    docker run -d \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e S3_PATH=s3://my-bucket/backup/ \
        -e MONGO_HOST=localhost \
        -e 'CRON_SCHEDULE=0 12 * * *' \
        basharal/mongo-s3-backup

Run once then delete the container:

    docker run --rm \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e MONGO_HOST=localhost \
        -e S3_PATH=s3://my-bucket/backup/ \
        basharal/mongo-s3-backup no-cron

