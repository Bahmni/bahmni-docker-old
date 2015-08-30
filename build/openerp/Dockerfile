FROM tinyerp/ubuntu-openerp:7.0
MAINTAINER Bahmni Team <bahmni@thoughtworks.com>
ENV REFRESHED_AT 2015-08-30T16:22

RUN apt-get install -y wget unzip

ADD openerp.conf /etc/supervisor/conf.d/

ADD postgresql.conf /etc/supervisor/conf.d/

ADD setup-artifacts.sh /tmp/setup-artifacts.sh

RUN chmod +x /tmp/setup-artifacts.sh

RUN /tmp/setup-artifacts.sh erp

VOLUME [ "/opt/openerp/addons" ]
