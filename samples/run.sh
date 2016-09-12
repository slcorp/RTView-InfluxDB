#!/bin/sh

if [ "$SERVICENAME" = "" ]
then	
	echo ... required environment variable not found: SERVICENAME
	exit 1
fi

if [ ! -d /opt/DATA ]
then
	echo ... required directory not found: /opt/DATA
	exit 1
fi

# Create a directory to hold influx data if it doesn't exist
cd /opt/DATA
if [ ! -d $SERVICENAME ]
then
	echo ... creating influxdb data directory: /opt/DATA/$SERVICENAME 
	mkdir $SERVICENAME
fi

# Link influxdb to this directory
ln -s /opt/DATA/$SERVICENAME /opt/DATA-INFLUXDB

# launch script to create database in a loop, so it happens after influx started
/opt/init_database.sh &

# launch influxdb
/usr/bin/influxd -config /opt/influxdb/conf/influxdb.conf
