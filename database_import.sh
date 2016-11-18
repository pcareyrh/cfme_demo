#!/bin/bash

# This script is designed to download and import a CF demo database
# into a new CF appliance.
DATABASE_URL="10.39.166.29"
CREDENTIALS_URL="10.39.166.29"

cd /repo
echo "Starting download of latest Demo DB. This may take a few minutes"
sudo wget -t 3 --progress=bar:force http://$DATABASE_URL/dumps/vmdb_production_latest.dump -O /repo/vmdb_production_latest.dump
if [ $? -ne 0 ]; then
  echo "Database download failed. Exiting."
  exit $?
else
  echo "Database downloaded successfully."
fi

echo "Starting download of Demo DB key"
sudo wget http://$CREDENTIALS_URL/credentials.txt -O /home/vagrant/credentials.txt
sudo wget http://$DATABASE_URL/dumps/v2_key -O /repo/v2_key
if [ $? -ne 0 ]; then
  echo "Database key download failed. Exiting."
  exit $?
else
  echo "Database key downloaded successfully."
fi


echo "Copy Demo DB and Key to host"
sudo su - root -c "mv -f /repo/v2_key /var/www/miq/vmdb/certs/"
sudo su - root -c "mv /repo/vmdb_production_latest.dump /var/lib/pgsql"

SERVICE="evmserverd.service"

systemctl -q is-active $SERVICE
if [ $? -ne 0 ]; then
  echo "$SERVICE is currently stopped"
else
  echo "$SERVICE was running so attempting stop"
  systemctl stop $SERVICE
  echo "$SERVICE stopped."
fi

echo "Dropping initial default database"
su - postgres -c "dropdb vmdb_production"
if [ $? -ne 0 ]; then
  echo "Database drop failed. Exiting."
  exit $?
else
  echo "Default database dropped successfully."
fi

echo "Creating Demo database"
su - postgres -c "psql -c \"create database vmdb_production\""
if [ $? -ne 0 ]; then
  echo "Database create failed. Exiting"
  exit $?
else
  echo "Database created successfully."
fi

echo "Importing demo database."
`su - postgres -c "pg_restore -e -U root -w -d vmdb_production vmdb_production_latest.dump"`
if [ $? -ne 0 ]; then
  echo "Demo database import failed. Exiting"
  exit $?
else
  echo "Demo database import successful."
fi

echo "Completed Demo database import"
echo "Connect to https://$(ifconfig eth0 | awk '/inet / { print $2 }') after the reboot"

reboot 
