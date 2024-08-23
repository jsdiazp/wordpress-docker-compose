FROM nginx:alpine

# Set system-wide locale settings
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Update alpine
RUN apk update \
    && apk upgrade

# Install bash
RUN apk add bash

# Setup shell
COPY scripts/shell.sh /shell.sh
RUN /bin/bash /shell.sh --alpine

# Installing certbot
RUN apk add certbot certbot-nginx

# Cron
RUN SLEEPTIME=$(awk 'BEGIN{srand(); print int(rand()*(3600+1))}'); echo "0 0,12 * * * root sleep $SLEEPTIME && certbot renew -q" | tee -a /etc/crontab > /dev/null
RUN echo 'crond /etc/crontab' >> docker-entrypoint.d/cron.sh \
    && chmod +x docker-entrypoint.d/cron.sh