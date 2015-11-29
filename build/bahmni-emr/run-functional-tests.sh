#!/bin/sh
yum localinstall -y /packages/*.rpm
service openmrs restart
service httpd restart
cd emr-functional-tests
mkdir screenshots || true
chmod 777 screenshots || true
mkdir spec-results || true
chmod 777 spec-results || true
sleep 30s
sh scripts/run.sh
