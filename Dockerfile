# Snapraid 12.0
FROM alpine:latest

RUN apk --update add python3 git smartmontools tzdata && \
    apk add snapraid --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted && \
    git clone https://github.com/Chronial/snapraid-runner.git /app/snapraid-runner && \
    chmod +x /app/snapraid-runner/snapraid-runner.py && \
    rm -rf /var/cache/apk/*

RUN echo '0 3 * * * /usr/bin/python3 /app/snapraid-runner/snapraid-runner.py -c /config/snapraid-runner.conf' > /etc/crontabs/root

VOLUME /mnt /config

COPY /docker-entry.sh  /
RUN chmod 755 /docker-entry.sh

CMD ["/docker-entry.sh"]
