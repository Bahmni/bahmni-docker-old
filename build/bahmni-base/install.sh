#!/bin/bash

#install_virtual_box_specifics(){
##    yum -y install gcc make gcc-c++ kernel-devel-`uname -r` perl
#    yum -y install kernel-devel-`uname -r`
#}

setup_repos(){
echo "[bahmni]
name            = Bahmni YUM Repository
baseurl         = https://bahmni-repo.twhosted.com/packages/bahmni/
enabled         = 1
gpgcheck        = 0" > /etc/yum.repos.d/bahmni.repo

echo "# Enable to use MySQL 5.6
[mysql56-community]
name=MySQL 5.6 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/6/x86_64
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql" > /etc/yum.repos.d/mysql56.repo

    yum install -y wget
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
    rpm -Uvh epel-release-latest-6.noarch.rpm
    yum -y update
}

install_oracle_jre(){
    #Optional - Ensure that jre is installed
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jre-7u79-linux-x64.rpm"
    yum localinstall -y jre-7u79-linux-x64.rpm
}

install_mysql(){
    yum remove -y mysql-libs
    yum clean all
    yum install -y mysql-community-server
    service mysqld start
    mysqladmin -u root password password
}

install_pgsql(){
    wget http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-7.noarch.rpm
    rpm -ivh pgdg-centos92-9.2-7.noarch.rpm
    yum install -y postgresql92-server
    service postgresql-9.2 initdb
    sed -i 's/peer/trust/g' /var/lib/pgsql/9.2/data/pg_hba.conf
    sed -i 's/ident/trust/g' /var/lib/pgsql/9.2/data/pg_hba.conf
    service postgresql-9.2 start
}

install_ruby(){
    yum install -y which tar
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    curl -sSL get.rvm.io | bash -s stable
    source /etc/profile.d/rvm.sh
    rvm install 2.0.0
    gem install bundler
}

install_firefox(){
    yum install -y firefox Xvfb
}

collect_garbage() {
    rm jre-7u79-linux-x64.rpm
    rm pgdg-centos92-9.2-7.noarch.rpm
    yum clean packages
}

setup_repos
install_oracle_jre
install_mysql
install_pgsql
install_ruby
install_firefox
collect_garbage
