#!/bin/bash

sed -i 's/REPLACE_STRING/'"$MYSQL"'/g' /root/.OpenMRS/openmrs-runtime.properties

sed -i 's/localhost/'"$PGSQL"'/g' /var/lib/tomcat7/webapps/openelis/WEB-INF/classes/us/mn/state/health/lims/hibernate/hibernate.cfg.xml

sed -i 's/openerp.host=localhost/openerp.host='"$OPENERP"'/g' /var/lib/tomcat7/webapps/openerp-atomfeed-service/WEB-INF/classes/atomfeed.properties

sed -i 's/localhost/'"$DOCKERHOST"'/g' /var/lib/tomcat7/webapps/openelis/WEB-INF/classes/atomfeed.properties

sed -i 's/localhost/'"$DOCKERHOST"'/g' /var/lib/tomcat7/webapps/openerp-atomfeed-service/WEB-INF/classes/atomfeed.properties

if [ "$NO_ELIS" == "true" ]; then
    echo "Removing openelis. The environment variable NO_ELIS is set"
    rm -rf /var/lib/tomcat7/webapps/openelis
    rm -f /var/lib/tomcat7/webapps/openelis.war
fi

if [ "$NO_ERP" == "true" ]; then
    echo "Removing openerp-atomfeed-service. The environment variable NO_ERP is set"
    rm -rf /var/lib/tomcat7/webapps/openerp-atomfeed-service
    rm -f /var/lib/tomcat7/webapps/openerp-atomfeed-service.war
fi

exec /usr/share/tomcat7/bin/catalina.sh jpda run
