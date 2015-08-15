FROM postgres:9.4
MAINTAINER Bahmni Team <bahmni@thoughtworks.com>

ADD pgsql_backup.sql.gz /tmp/

RUN gzip -d /tmp/pgsql_backup.sql.gz

RUN cp /tmp/pgsql_backup.sql /docker-entrypoint-initdb.d/

ADD backup-pgsql.sh /tmp/

VOLUME [ "/backup" ]