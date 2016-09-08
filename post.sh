#!/bin/bash

localectl set-keymap us
timedatectl set-timezone Europe/London
timedatectl set-ntp true

appliance_console_cli --host=$(hostname) --region=1 --internal --password="smartvm" --key --force-key -v

echo "Copy Demo DB and Key to host"
sudo su - root -c "mv -f /home/vagrant/v2_key /var/www/miq/vmdb/certs/"
sudo su - root -c "mv /home/vagrant/cloudformsDatabase4.1.005.db /var/lib/pgsql"

###appliance_console_cli --host=$(hostname) --region=1 --internal --password="smartvm" --key --force-key -v
/bin/systemctl stop evmserverd.service
echo "Drop initial default database"
sudo su - postgres -c "dropdb vmdb_production"
echo "Create and import Demo DB"
sudo su - postgres -c "psql -c \"create database vmdb_production\""
sudo su - postgres -c "pg_restore -U root -w -d vmdb_production cloudformsDatabase4.1.005.db"
echo "Import Complete"
#appliance_console_cli --host=$(hostname) --region=1 --internal --password="smartvm" --key --force-key
#appliance_console_cli --host=$(hostname) --internal --password="smartvm" -v
rm -f /etc/yum.repos.d/*
subscription-manager repos --disable=*
subscription-manager repos --enable=rhel-7-server-rpms \
                --enable=rhel-7-server-optional-rpms \
                --enable=rhel-7-server-rh-common-rpms \
                --enable=rhel-7-server-extras-rpms \
                --enable=cf-me-5.5-for-rhel-7-rpms \
                --enable=rhel-server-rhscl-7-rpms
echo "Update host"
#yum install -y yum-plugin-priorities wget yum-utils vim
#yum update -y

echo "Connect to http://$(ifconfig eth0 | awk '/inet / { print $2 }') after the reboot"

#reboot 
