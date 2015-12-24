FROM centos:6.6
MAINTAINER Bahmni Team <bahmni@thoughtworks.com>

ADD install.sh /tmp/install.sh

RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

RUN yum install -y supervisor

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 443
EXPOSE 8080
EXPOSE 8000

CMD ["/usr/bin/supervisord"]
