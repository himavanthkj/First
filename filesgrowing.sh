#!/bin/bash

# This script is to find out the files growing on this node

sudo touch newer_than_this_file

sudo find / -newer newer_than_this_file -size +1M -not -path "/proc/*" -exec ls -lh {} \; >fg.txt
res=`cat fg.txt | awk '{print $5}'`

