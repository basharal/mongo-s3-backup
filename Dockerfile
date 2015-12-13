FROM mongo:latest
MAINTAINER Bashar Al-Rawi <basharal@live.com>

RUN apt-get update && \
    apt-get install -y python python-pip cron && \
    rm -rf /var/lib/apt/lists/*

RUN pip install s3cmd

ADD s3cfg /root/.s3cfg

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD backup.sh /backup.sh
RUN chmod +x /backup.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
