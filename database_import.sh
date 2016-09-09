#!/bin/bash

#Stop evmserverd from running while we import the demo db.
if /bin/systemctl -q is-active evmserverd.service
  then
    echo "Stopping evmserverd"
    sudo systemctl stop evmserverd.service
fi

#Drop the newly created database.
if /opt/rh/rh-postgresql94/root/usr/bin/dropdb --if-exists vmdb_production
then
  echo "Drop initial default database"
else
  echo "Drop database failed."
fi

#Create new database for the demo db import.
echo "Create and import Demo DB"
if [[ `sudo su - postgres -c "psql -c \"create database vmdb_production\""` ]]; then
  echo "Create database complete"
else
  echo "Create new database failed"
  exit 1
fi

#Import demo database.
if /opt/rh/rh-postgresql94/root/usr/bin/pg_restore -U root -w -d vmdb_production /var/lib/pgsql/cloudformsDatabase4.1.005.db
then
  echo "Import Complete"
else
  echo "Import failed"
  exit 1
fi
#  if [ ! $? -eq 1 ]; then

