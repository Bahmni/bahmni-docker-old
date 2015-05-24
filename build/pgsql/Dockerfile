FROM postgres:9.4
MAINTAINER Bahmni Team <bahmni@thoughtworks.com>

ADD init-database.sh /docker-entrypoint-initdb.d/

ADD db.pgdump.tar.gz /tmp/
