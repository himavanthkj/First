#!/bin/bash

for i in a b c
do 
echo "Looping number $i"
done
pid= `ps -ef | grep tomcat | awk '{print $2}'
