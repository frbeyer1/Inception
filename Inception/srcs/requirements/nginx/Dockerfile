FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y nginx openssl bash && \
    mkdir -p /usr/local/bin /etc/nginx/ssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY tools/nginx-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/nginx-entrypoint.sh

ENTRYPOINT ["nginx-entrypoint.sh"]
