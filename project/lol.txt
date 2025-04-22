#Start base image from Alpine Linux version 3.16
FROM alpine:3.16

#Build arguments
ARG DB_NAME \
    DB_USER \
    DB_PASS \
    DB_ROOT

#Install MariaDB
RUN apk update && apk add --no-cache mariadb mariadb-client

#Prepare MySQL runtime directory and customize config file
#skip-host-cache, skip-name-resolve: Speed up DNS lookups
#bind-address=0.0.0.0: Listen on all interfaces
#Ensure network is enabled
RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf
  #tee: reads from standard input(echo) and writes to file in the same time

#Initialize MariaDB data directory:
# RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql || cat /var/lib/mysql/*.err

#Expose port
EXPOSE 3306

#Copy script into image
COPY requirements/mariadb/conf/create_db.sh .

#Make sure script runs and deletes it afterwards
RUN sh create_db.sh && rm create_db.sh

#Switch user, run as the mysql user
USER mysql

#Container starts, run MariaDB server, skipping error logs
CMD ["/usr/bin/mysqld", "--skip-log-error"]
