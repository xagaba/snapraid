FROM alpine:latest

RUN apk --update add python git smartmontools && \
    apk add snapraid --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted && \
    apk add --no-cache bash && \
    git clone https://github.com/Chronial/snapraid-runner.git /app/snapraid-runner && \
    chmod +x /app/snapraid-runner/snapraid-runner.py && \
    rm -rf /var/cache/apk/*

RUN echo '0 3 * * * /usr/bin/python /app/snapraid-runner/snapraid-runner.py -c /config/snapraid-runner.conf 2>&1' > /etc/crontabs/root

VOLUME /mnt /config

COPY /docker-entry.sh  /
RUN chmod 755 /docker-entry.sh

CMD ["/docker-entry.sh"]
