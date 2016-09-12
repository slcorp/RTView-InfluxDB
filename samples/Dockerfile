# InfluxDB engine for use with RTView
#
FROM influxdb
MAINTAINER SL Corporation

RUN mkdir /opt/influxdb /opt/influxdb/conf
COPY influxdb.conf /opt/influxdb/conf/influxdb.conf

COPY run.sh init_database.sh /opt/

EXPOSE 8083 8086 8088

# use startup script instead of launching directly
CMD ["/opt/run.sh"]
