#!/bin/bash
set -e

GO_USER=guest
GO_PWD=p@ssw0rd
BASE_URL="https://ci-bahmni.thoughtworks.com"
BRANCH=master
ARTIFACTS_PIPELINE_VERSION="Latest"
CONFIG_PIPELINE_VERSION="Latest"
WGET="wget --no-check-certificate --user=$GO_USER --password=$GO_PWD --auth-no-challenge"
ERP_URL=$BASE_URL/go/files/OpenERP_$BRANCH/$ARTIFACTS_PIPELINE_VERSION/runFunctionalTestsStage/Latest/runFunctionalTestsJob/deployables/openerp-modules.zip

function setup_erp(){
	$WGET $ERP_URL -O /tmp/openerp-modules.zip
	unzip -o -q /tmp/openerp-modules.zip -d /tmp
	chown -R openerp:openerp /tmp; chmod -R 775 /tmp; 
	echo "Now copying files"
	yes | cp -r /tmp/openerp-modules/* /opt/openerp-7.0-20130301-002301/openerp/addons
	chown -R openerp:openerp /opt/openerp-7.0-20130301-002301
	rm -rf /tmp/openerp-modules
	rm -f /tmp/openerp-modules.zip
}

case "$1" in
	"erp" )
		echo -e "ERP Selected"
		setup_erp
		;;
	"start" )
		start
		;;
	"status" )
		status
		;;
	* )
		echo -e "Invalid option $1"
		;;
esac