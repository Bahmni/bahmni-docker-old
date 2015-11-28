FROM bahmni/bahmni-base
MAINTAINER Bahmni Team <bahmni@thoughtworks.com>

ADD install.sh /tmp/install.sh

RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh
RUN yum install -y supervisor

COPY supervisord.conf /etc/supervisord.conf
COPY run-functional-tests.sh /run-functional-tests.sh
RUN chmod +x run-functional-tests.sh

EXPOSE 443
EXPOSE 8080
EXPOSE 8000
EXPOSE 8069
EXPOSE 8081
EXPOSE 3306
EXPOSE 5432

CMD ["/usr/bin/supervisord"]
