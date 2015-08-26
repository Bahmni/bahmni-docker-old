# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos7"
  config.vm.box_url = "https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box"

  config.vm.network :forwarded_port, guest: 8080, host: 8081
  config.vm.network :forwarded_port, guest: 443, host: 8082
  config.vm.network :forwarded_port, guest: 80, host: 8083
  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |v|
     v.customize ["modifyvm", :id, "--memory", 3092, "--cpus", 2]
  end

  config.vm.synced_folder "~/bahmni-code", "/root/bahmni-code", :owner => "root"

  config.vm.provision :shell, :inline => <<-EOT
    #
    # upgrade device-mapper-libs
    #
    yum upgrade -y device-mapper-libs
    #
    # yum repository
    #
    rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
    yum install -y vim-enhanced telnet
    #
    # docker
    #
    yum install -y docker-io
    sed -i 's,^other_args=.*$,other_args="-H tcp://0.0.0.0:4243 -H unix:// --dns 8.8.8.8",g' /etc/sysconfig/docker
    chkconfig docker on
    service docker restart
  EOT

  config.vm.provision :docker_compose, yml: "/vagrant/profiles/prod.yml",project_name: "bahmni", run: "always"
end
