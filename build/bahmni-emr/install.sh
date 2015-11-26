#!/bin/bash

restore_mysql_database(){
    #Optional Step
    rm -rf mysql_backup.sql.gz mysql_backup.sql
    wget https://github.com/Bhamni/emr-functional-tests/blob/master/dbdump/mysql_backup.sql.gz?raw=true -O mysql_backup.sql.gz
    gzip -d mysql_backup.sql.gz
    mysql -uroot -ppassword < mysql_backup.sql
    echo "FLUSH PRIVILEGES" > flush.sql
    mysql -uroot -ppassword < flush.sql
}

restore_pgsql_db(){
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

install_ruby(){
    yum install -y which tar
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3
}

install_ruby
restore_mysql_database
restore_pgsql_db
install_bahmni
config_services

