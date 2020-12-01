#!/bin/bash

hostip=`hostname -i`
tomcat_pid() {
  echo `ps aux | grep org.apache.catalina.startup.Bootstrap | grep -v grep | awk '{ print $2 }'`
}
status(){
	PID=$(tomcat_pid)
	if [ -n $PID ]
	then
		echo "Tomcat has  been started and running"
	else
		echo "Tomcat is not running after a start, please have a look into it"
	fi
	}
US(){
	upid=$(tomcat_pid)
	urlstatus=`curl -IsS http://${hostip}:8080 | head -1 | awk '{print $2}'`
	if [ $urlstatus == 200 ]
	then
		echo "Tomcat URL is loading with (pid: $upid)"
	else
		/opt/tomcat/latest/bin/startup.sh
		wait $!
		status
	fi
	}
tomcat_pid
pid=$(tomcat_pid)
if [ -n "$pid" ]
then
	echo "tomcat is running with (pid: $pid)"
	US
else
	echo "Starting tomcat as its not running"
	/opt/tomcat/latest/bin/startup.sh
	wait $!
	status
fi
