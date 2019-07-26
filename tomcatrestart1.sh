#!/bin/bash
SHUTDOWN_WAIT=5

tomcat_pid() {
  echo `ps aux | grep org.apache.catalina.startup.Bootstrap | grep -v grep | awk '{ print $2 }'`
}

start() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ] 
  then
    echo "Tomcat is already running (pid: $pid)"
  else
    # Start tomcat
    echo "Starting tomcat"
    /bin/sh /opt/tomcat/latest/bin/startup.sh
  fi


  return 0
}

stop() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo "Stoping Tomcat"
    /bin/sh  /opt/tomcat/latest/bin/shutdown.sh

    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\nwaiting for processes to exit";
      sleep 1
      let count=$count+1;
    done

    if [ $count -gt $kwait ]; then
      echo -n -e "\nkilling processes which didn't stop after $SHUTDOWN_WAIT seconds"
      kill -9 $pid
      echo  " \nprocess killed manually"
    fi
  else
    echo "Tomcat is not running"
  fi

  return 0
}
pid=$(tomcat_pid)

 if [ -n "$pid" ]
  then
    echo "Tomcat is running with pid: $pid"
    stop
  else
    echo "Tomcat is not running"
    start
  fi
exit 0
