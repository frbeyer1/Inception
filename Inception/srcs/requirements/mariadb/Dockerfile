FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY tools/mariadb-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

ENTRYPOINT ["mariadb-entrypoint.sh"]
