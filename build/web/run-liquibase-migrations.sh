#!/bin/sh
set -e -x

java -Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=openmrs -jar /var/lib/tomcat7/webapps/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar --url=jdbc:mysql://mysql:3306/openmrs --changeLogFile=$1 --classpath=/var/lib/tomcat7/webapps/openmrs/WEB-INF/lib/mysql-connector-java-5.1.28.jar --username=openmrs-user --password=password update