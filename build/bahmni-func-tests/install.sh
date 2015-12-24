#!/bin/bash

setup_repos(){
    echo "# Enable to use MySQL 5.6
[mysql56-community]
name=MySQL 5.6 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/6/x86_64
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql" > /etc/yum.repos.d/mysql56.repo

    echo "[google64]
name=Google - x86_64
baseurl=http://dl.google.com/linux/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" > /etc/yum.repos.d/google.repo

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

install_ruby(){
    yum install -y which tar
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3
}

install_chrome(){
    wget ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/zgyarmati:/hhphp/CentOS_CentOS-5/x86_64/libstdc++47-4.7.0-16.1.x86_64.rpm
    rpm -ivh libstdc++47-4.7.0-16.1.x86_64.rpm
    yum install -y google-chrome-stable
}

setup_repos
install_oracle_jre
install_mysql
install_chrome
install_ruby
