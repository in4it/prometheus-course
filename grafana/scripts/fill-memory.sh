#!/bin/bash
if [ ! -e /usr/bin/stress ] ; then 
  apt-get install stress 
fi
stress --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.5;}' < /proc/meminfo)k --vm-keep -m 1
