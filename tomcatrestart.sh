#!/bin/bash

hostip=`hostname -I`
ps -ef | grep "org.apache.catalina.startup.Bootstrap" | grep -v grep  > xyz.txt
tomcat_pid=`awk '{print $2}' xyz.txt`
echo $tomcat_pid

if [ -n "$tomcat_pid" ]
then
        echo -e "Tomcat is running (pid: $tomcat_pid)"
else
        echo "Starting Tomcat as its down"
        sh /opt/tomcat/latest/bin/startup.sh
	start_id=$!
	wait $start_id
	ps -ef | grep "org.apache.catalina.startup.Bootstrap" | grep -v grep  > xyz.txt
	status_pid=`awk '{print $2}' xyz.txt`
	if [ -n "$status_pid" ]
	then
		echo "Tomcat is running (pid: $status_pid)"
	else
		echo "Please investigate as tomcat didnt start through script"
	fi
fi
