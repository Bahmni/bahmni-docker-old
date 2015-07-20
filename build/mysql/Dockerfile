FROM mysql:5.6
MAINTAINER Bahmni Team <bahmni@thoughtworks.com>
ENV REFRESHED_AT 2015-05-04T11:25
ENV MYSQL_ROOT_PASSWORD password

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ADD mysql_backup.sql.tar.gz /tmp/
RUN chown root:root /tmp/mysql_backup.sql

VOLUME [ "/backup" ]
CMD ["mysqld"]