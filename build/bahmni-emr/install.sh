#!/bin/bash

restore_mysql_database(){
    #Optional Step
    service mysqld start
    rm -rf mysql_backup.sql.gz mysql_backup.sql
    wget https://github.com/Bhamni/emr-functional-tests/blob/master/dbdump/mysql_backup.sql.gz?raw=true -O mysql_backup.sql.gz
    gzip -d mysql_backup.sql.gz
    mysql -uroot -ppassword < mysql_backup.sql
    echo "FLUSH PRIVILEGES" > flush.sql
    mysql -uroot -ppassword < flush.sql
}

restore_pgsql_db(){
    service postgresql-9.2 start
    wget https://github.com/Bhamni/emr-functional-tests/blob/master/dbdump/pgsql_backup.sql.gz?raw=true -O pgsql_backup.sql.gz
    gzip -d pgsql_backup.sql.gz
    psql -Upostgres < pgsql_backup.sql >/dev/null
}

install_bahmni(){
    yum install -y openmrs bahmni-emr-0.78 bahmni-web-0.78
}

config_services(){
    chkconfig mysqld on
    chkconfig httpd on
    chkconfig openmrs on
}

restore_mysql_database
restore_pgsql_db
install_bahmni
config_services
