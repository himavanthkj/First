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
#fii

ps -ef | grep "crucible" | grep -v grep  > xyz.txt
crucible_pid=`awk '{print $2}' xyz.txt`
echo $crucible_pid

#Tomcat_pid=$(tomcat_pid)
if [ -n "$crucible_pid" ]
then
        echo -e "Crucible is running (pid: $crucible_pid)"
		hostip=`hostname -I`
        	urlstatus=`curl -Is http://${hostip}:8080 | head -1 | awk '{print $2}'`

		if [ $urlstatus = 200 ]
		then
		echo "Url as well loading fine with (status: $urlstatus)"
		else
		echo -e "URL is not loading, so will kill the (pid: $tomcat_pid) and start the tomcat"
		cd /home/hima/
		if ![[ lsof -- /home/hima/tmp.txt ]]
		then
			echo "Backing up, so exiting"
			break
		else
		if ! sh /opt/tomcat/latest/bin/shutdown.sh
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
