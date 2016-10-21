#!/bin/bash

localectl set-keymap us
timedatectl set-timezone Europe/London
timedatectl set-ntp true

echo "Subscribing host."
rm -f /etc/yum.repos.d/*
subscription-manager repos --disable=*
subscription-manager repos --enable=rhel-7-server-rpms \
                --enable=rhel-7-server-optional-rpms \
                --enable=rhel-7-server-rh-common-rpms \
                --enable=rhel-7-server-extras-rpms \
                --enable=cf-me-5.5-for-rhel-7-rpms \
                --enable=rhel-server-rhscl-7-rpms
echo "Updating host"
yum install -y yum-plugin-priorities wget yum-utils vim
#yum update -y

echo "Commencing Cloudforms initial setup."
if [ -e /dev/sdb ]; then
  echo "Setup Cloudforms for Virtual Box"
  appliance_console_cli --host=$(hostname) --region=10 --internal --password="smartvm" --key --force-key --dbdisk=/dev/sdb
elif [ -e /dev/vdb ]; then
  echo "Setup Cloudforms for LibVirt"
  appliance_console_cli --host=$(hostname) --region=10 --internal --password="smartvm" --key --force-key --dbdisk=/dev/vdb
fi
echo "Completed Cloudforms initial setup."

