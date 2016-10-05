#!/bin/sh

DBURL=$1
if [ "$DBURL" = "" ]
then
	DBURL="localhost:8086"
fi

#cd /opt/DATA
#cd INFLUXDB/data

#echo ... test for database 

COUNTER=0
SUCCESS=0

while [ ! -f RTVHISTORY ]
do

	echo ... attempt database creation: $COUNTER

	STATUS=$(curl -s -G "http://$DBURL/query" --data-urlencode "q=CREATE DATABASE RTVHISTORY" )
	echo ... status = $STATUS

	if [ "${STATUS#*already}" != "$STATUS" ]
	then
	   echo ... database now exists
	   SUCCESS=1
	   break
	fi

	STATUS=$(curl -G "http://$DBURL/query" --data-urlencode "q=CREATE RETENTION POLICY m1 ON RTVHISTORY DURATION 1h REPLICATION 1 DEFAULT")
	echo ... status = $STATUS

	STATUS=$(curl -G "http://$DBURL/query" --data-urlencode "q=CREATE RETENTION POLICY m5 ON RTVHISTORY DURATION 1d REPLICATION 1")
	#echo ... status = $STATUS

	STATUS=$(curl -G "http://$DBURL/query" --data-urlencode "q=CREATE RETENTION POLICY m15 ON RTVHISTORY DURATION 12w REPLICATION 1")
	#echo ... status = $STATUS

	COUNTER=$((COUNTER+1))
	#echo ... count is $COUNTER
	
	if [ "$COUNTER" = "20" ]
	then
	  break
	fi

	sleep 3

done

if [ "$SUCCESS" = "1" ]
then
  echo ... database creation successful  
else
  echo ... database creation failed
fi