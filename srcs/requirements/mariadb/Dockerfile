FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install mariadb-server mariadb-client -y

COPY ./conf/dbscript.sh /dbscript.sh

COPY ./conf/dbserver.conf /etc/mysql/mariadb.conf.d/dbserver.conf

RUN chmod +x /dbscript.sh

RUN mkdir /run/mysqld

ENTRYPOINT ["/dbscript.sh"]