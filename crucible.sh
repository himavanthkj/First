#!/bin/bash

#pid=`ps -ef | grep tomcat | grep -v grep | tr -s " " | cut -d" " -f2`
#echo $pid
hostip=`hostname -I`
#URL=`http://${hostip}:8080`
#urlstatus=`curl -Is http://${hn}:8080 | head -1 | awk '{print $2}'`
#if curl -o /dev/null --silent --head --fail "$URL"; then
#echo "service is up"
#else 
#echo "service is not running"
#fi
ps -ef | grep "org.apache.catalina.startup.Bootstrap" | grep -v grep  > xyz.txt
tomcat_pid=`awk '{print $2}' xyz.txt`
echo $tomcat_pid

#Tomcat_pid=$(tomcat_pid)
if [ -n "$tomcat_pid" ]
then
        echo -e "Tomcat is running (pid: $tomcat_pid)"
	hostip=`hostname -I`
	urlstatus=`curl -Is http://${hostip}:8080 | head -1 | awk '{print $2}'`
	if [ $urlstatus = 200 ]
	then
		echo "Url as well loading fine with (status: $urlstatus)"
	else
		echo -e "URL is not loading, so will kill the (pid: $tomcat_pid) and start the tomcat"
		kill -9 $tomcat_pid
		sh /opt/tomcat/latest/bin/startup.sh
		wait $! #It will let wait the next command until previous one completes
		ps -ef | grep "org.apache.catalina.startup.Bootstrap" | grep -v grep  > xyz.txt
		status_pid=`awk '{print $2}' xyz.txt`	
       		if [ -n "$status_pid" ]
        	then
        		echo "Tomcat is running (pid: $status_pid) after a restart"
        	else
       			echo "Please investigate as tomcat didnt start through script"
        	fi
	fi
else
        echo "Starting Tomcat as its down"
        sh /opt/tomcat/latest/bin/startup.sh
	start_id=$!
	#echo $hima
	wait $start_id
	#status_pid=`ps -ef | grep tomcat | grep -v grep | tr -s " " | cut -d" " -f2`
	ps -ef | grep "org.apache.catalina.startup.Bootstrap" | grep -v grep  > xyz.txt
	status_pid=`awk '{print $2}' xyz.txt`
	if [ -n "$status_pid" ]
	then
		echo "Tomcat is running (pid: $status_pid)"
	else
		echo "Please investigate as tomcat didnt start through script"
	fi
fi
