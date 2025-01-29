FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install mariadb-server mariadb-client -y

COPY ./conf/init-db.sh /init-db.sh

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /init-db.sh

RUN mkdir /run/mysqld

ENTRYPOINT ["/init-db.sh"]
