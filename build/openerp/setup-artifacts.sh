#!/bin/bash
set -e

GO_USER=guest
GO_PWD=p@ssw0rd
BASE_URL="https://ci-bahmni.thoughtworks.com"
BRANCH=Released
BAHMNI_VERSION=0.74
ARTIFACTS_PIPELINE_VERSION="Latest"
CONFIG_PIPELINE_VERSION="Latest"
WGET="wget --no-check-certificate --user=$GO_USER --password=$GO_PWD --auth-no-challenge"
ERP_URL=$BASE_URL/go/files/OpenERP_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/runFunctionalTestsStage/Latest/runFunctionalTestsJob/deployables/openerp-modules.zip
BAHMNI_DISTRO_URL=$BASE_URL/go/files/Bahmni_MRS_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/BuildDistroStage/Latest/BahmniDistro/openmrs-distro-bahmni-artifacts/distro-$BAHMNI_VERSION-SNAPSHOT-distro.zip
ELIS_URL=$BASE_URL/go/files/OpenElis_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/Build/Latest/build/deployables/openelis.war
JSS_CONFIG_URL=$BASE_URL/go/files/Build_jss_config_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/BuildStage/Latest/Build/jss_config.zip
BAHNMI_APPS_URL=$BASE_URL/go/files/Bahmni_MRS_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/BuildStage/Latest/BahmniApps/bahmniapps.zip
BAHMNI_ERP_ATOMFEED_SERVICE=$BASE_URL/go/files/OpenERP_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/runFunctionalTestsStage/Latest/openerp-atomfeed-service/openerp-atomfeed-service.war
BAHMNI_REPORTS_URL=$BASE_URL/go/files/Bahmni_Reports_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/BuildStage/Latest/Build-Bahmni-Reports/deployables/bahmnireports.war

function setup_erp(){
	$WGET $ERP_URL -O /tmp/openerp-modules.zip
	unzip -o -q /tmp/openerp-modules.zip -d /tmp
	chown -R openerp:openerp /tmp; chmod -R 775 /tmp; 
	echo "Now copying files"
	mkdir -p /opt/openerp/addons
	yes | cp -r /tmp/openerp-modules/* /opt/openerp/addons
	rm -rf /tmp/openerp-modules
	rm -f /tmp/openerp-modules.zip
}

function setup_web(){
	setup_mrs
	setup_elis
	setup_openerp_atomfeed
	setup_reports
}

function setup_mrs(){
	$WGET $BAHMNI_DISTRO_URL -O /tmp/distro.zip
	mkdir -p /root/.OpenMRS/modules
	unzip -o -q /tmp/distro.zip -d /tmp/
	cp -r /tmp/distro-$BAHMNI_VERSION-SNAPSHOT/* /root/.OpenMRS/modules
	cp /root/.OpenMRS/modules/openmrs-webapp-*.war /var/lib/tomcat7/webapps/openmrs.war
 	rm -f /tmp/distro.zip
 	rm -rf /tmp/distro-5.6-SNAPSHOT

	$WGET $JSS_CONFIG_URL -O /tmp/jss_config.zip
	unzip -o -q /tmp/jss_config.zip -d /tmp/bahmni_config
	cp -rf /tmp/bahmni_config/openmrs/obscalculator /root/.OpenMRS/obscalculator
	mkdir -p /var/www
	unzip -o -q /tmp/jss_config.zip -d /var/www/bahmni_config
}
function setup_reports(){
	$WGET $BAHMNI_REPORTS_URL -O /tmp/bahmnireports.war
	unzip /tmp/bahmnireports.war -d /var/lib/tomcat7/webapps/bahmnireports/
	cp -f /tmp/reports.properties /var/lib/tomcat7/webapps/bahmnireports/WEB-INF/classes/application.properties
}

function setup_elis(){
	$WGET $ELIS_URL -O /tmp/openelis.war
	unzip /tmp/openelis.war -d /var/lib/tomcat7/webapps/openelis/
}

function setup_openerp_atomfeed(){
	$WGET $BAHMNI_ERP_ATOMFEED_SERVICE -O /tmp/openerp-atomfeed-service.war
	unzip /tmp/openerp-atomfeed-service.war -d /var/lib/tomcat7/webapps/openerp-atomfeed-service/
}

function setup_apache(){
	$WGET $JSS_CONFIG_URL -O /tmp/jss_config.zip
	unzip -o -q /tmp/jss_config.zip -d /var/www/bahmni_config
	rm -f /tmp/jss_config.zip

	$WGET $BAHNMI_APPS_URL -O /tmp/bahmniapps.zip
	unzip -o -q /tmp/bahmniapps.zip -d /var/www/bahmniapps
	rm -f /tmp/bahmniapps.zip
}

case "$1" in
	"erp" )
		echo -e "ERP Selected"
		setup_erp
		;;
	"web" )
		echo -e "Setting up Web"
		setup_web
		;;
	"apache" )
		echo -e "Setting up Apache"
		setup_apache
		;;
	"status" )
		status
		;;
	* )
		echo -e "Invalid option $1"
		;;
esac