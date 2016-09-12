# RTView InfluxDB Integration in Docker

##Background
RTView-InfluxDB integration in Docker helps achieve the following goal: 
* Allows RTView to use the InfluxDB instance as a data store for historical analysis. 

##Pre-requisites
* Install the Docker Engine (Docker Version 1.11) on the Server (Oracle Linux 7) where you would run the remote InfluxDB instance. 
* Ensure to update YUM and have the UEK4 (Unbreakable Enterprise Kernal 4) in the Linux server. 
* In the Client side, where you would run RTView, install Java version 1.5 and the RTView software. 

##Steps to Install and Run InfluxDB Database Instance in Docker

###Step 1: Start the Docker Engine Service using the following command. 
*sudo service docker start*
###Step 2: Copy the InfluxDB Docker file and the relevant configuration files to the Linux server.
	Dockerfile, run.sh, init_database.sh, influxdb.conf
###Step 3: Create a new directory in the server /opt/DATA with write permission. 
*mkdir /opt/DATA*
###Step 4: Build Docker image from the files copied over in step #1
*docker build -t influxdb-rtview .*
	
	You will see a message, "Successfully build..." when the image is built without any errors. 
###Step 5: Confirm if the image is indeed built by running: 
*docker images*
	
	You will see the image created with the name "influxdb-rtview"
###Step 6: Run the Docker image with the InfluxDB instance as follows:
*docker run -d -p 8086:8086 -e 'SERVICENAME=influx' -v /opt/DATA/InfluxDB:/opt/DATA --name influx influxdb-rtview*
	
	name and SERVICENAME - name of the InfluxDB instance
	p - Port number used by the InfluxDB instance
	v - Data directory
	
	You will see an alpha numeric string printing out if the run command is successful. 
###Step 7: Confirm if the InfluxDB instance started by the above step is running
*docker ps -a*
	You will see your InfluxDB instance listed as 'influx'
##Using the InfluxDB Instance for RTView History 
* Download and setup RTView in your local machine. 
* Edit 'influxdb_handlers.properties' file to include influxdb handlers jars in RTView class path. 
  sl.rtview.cp=%RTVAPM_USER_HOME%/lib/influxdb_handlers.jar
  (use forward slash for classpath even in Windows)
* Set environment variables in your local machine where the InfluxDB server can be found:
	* INFLUXDB_URL=http://192.0.0.0:8086
	* INFLUXDB_DB=RTVHISTORY
* Configure the RTView historian to use the InfluxDB Custom Historian Handler 
	* sl.rtview.historian.customhandlerclassname=com.sl.influxdb.InfluxDBHistorianHandler
* Configure the RTView dataserver to use the InfluxDB Custom Cache Extender 
	* collector.sl.rtview.cache.customclassname=com.sl.influxdb.InfluxDBCacheExtender

* You may want to start a RTView application (e.g. EMSMON) and the RTView Historian
	start_rtv.bat emsmon dataserver -properties:influxdb_handlers
	start_rtv.bat emsmon historian -properties:influxdb_handlers

* Check the historian for this message:
*INFO  main - [rtview] NOSQL InfluxDBHistorianHandler: com.sl.influxdb.InfluxDBHistorianHandler@1da51a35*

##To explore the data being written into the InfluxDB server
* Open a browser window and connect to the HTTP API
	* http://192.0.0.0:8086/query?pretty=true&db=RTVHISTORY&q=SHOW+MEASUREMENTS
	
	You should see the data being written into the InfluxDB database shown in the browser. 
* See the browser_output.jpg for the screenshot of sample output. 
	
When you restart your application, you should now see the historian information from the InfluxDB database. 

##Files in the Repository
###influxdb.conf
Contains configuration information about your Influx database instance
###run.sh
Run script
###init_database.sh
Creates default database and retention policies
###influxdb_handlers.properties
Contains necessary properties for custom handlers and its associated JAR file. 
###influxdb_handlers.jar
RTView custom influxdb handler JAR file
##Resources
* Download RTView: http://sl.com/evaluation-request/
* Download Docker Engine: https://docs.docker.com/engine/installation/
* Documentation on RTView Historian: http://sldownloads.sl.com/docs/rtview/670/CORE/Historian/Historian.htm
