#!/usr/bin/env bash
# You must have sudo ability on your machine
machine=$1
if [ -z $machine ]; then
  echo "usage $0 {machine_name}"
  exit
fi
docker-machine ls | grep ${machine}
if [ $? == 1 ]; then
  echo "${machine} is not a docker-machine"
  exit 1
fi
dm_ip=`docker-machine ip ${machine} | awk -F. '{print $1"."$2"."$3}'` 
fwrule=`sudo ipfw -a list | grep "deny ip from any to any"`
fwrule_id=`echo $fwrule | awk '{ print $1 }'`
if [ "$fwrule" != "" ]; then
    echo "Found blocking firewall rule: $(tput setaf 1)${fwrule}$(tput sgr0)"
    printf "Deleting rule ${fwrule_id} ... "
    sudo ipfw delete ${fwrule_id}
    if [ $? == 0 ]; then
	echo "$(tput setaf 2)[OK]$(tput sgr0)"
    else
    echo "$(tput setaf 1)[FAIL]$(tput sgr0)"
        exit 1
    fi
else
    echo "No rules found. You are good to go"
fi
docker_interface=$(VBoxManage showvminfo ${machine} | grep -o -E 'vboxnet\d\d?')
if [ -z "${docker_interface}" ]; then
    echo "No docker VM found!"
    exit 1
else
    echo "Found docker interface at $(tput setaf 1)${docker_interface}$(tput sgr0). Changing routes ..."
    current_route=$(sudo netstat -rn | grep ${dm_ip})
    if [ -z "${current_route}" ]; then
        # no route, let's add it!
        sudo route -nv add -net ${dm_ip} -interface ${docker_interface}
    else
        sudo route -nv change -net ${dm_ip} -interface ${docker_interface}
    fi
 
    if [ $? == 0 ]; then
        echo "$(tput setaf 2)[OK]$(tput sgr0)"
    else
        echo "$(tput setaf 1)[FAIL]$(tput sgr0)"
        exit 1
    fi
fi