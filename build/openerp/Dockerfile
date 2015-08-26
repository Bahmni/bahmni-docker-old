FROM ubuntu:14.04
MAINTAINER Bahmni Team <bahmni@thoughtworks.com>
ENV REFRESHED_AT 2015-05-02T07:24

RUN apt-get update;

RUN apt-get install -y python-dateutil python-feedparser python-gdata python-ldap \
    python-libxslt1 python-lxml python-mako python-openid python-psycopg2 \
    python-pybabel python-pychart python-pydot python-pyparsing python-reportlab \
    python-simplejson python-tz python-vatnumber python-vobject python-webdav \
    python-werkzeug python-xlwt python-yaml python-zsi curl python-dev python-pip \
    wget unzip libldap2-dev libsasl2-dev libssl-dev 

RUN curl -SL https://www.dropbox.com/s/wjf7jlcm4c3txbc/openerp-7.0-20130301-002301.tar.gz | tar xzf - -C /opt/

RUN pip install --upgrade setuptools

RUN pip install --upgrade six>=1.7

WORKDIR /opt/openerp-7.0-20130301-002301

RUN [ "python", "setup.py", "-q", "install" ]

RUN adduser openerp

ADD setup-artifacts.sh /tmp/setup-artifacts.sh

RUN chmod +x /tmp/setup-artifacts.sh

RUN /tmp/setup-artifacts.sh erp

EXPOSE 8069

VOLUME [ "/opt/openerp-7.0-20130301-002301" ]

USER openerp

CMD [ "sh", "-c" ,"openerp-server --update all --without-demo all --db_user ${DB_USER} --db_host ${DB_HOST}" ]
