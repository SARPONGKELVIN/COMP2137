#!/bin/bash

#This script is for assignment 1 , create a system report
#started October 9th 2024 by Kelvin
#We need to gather a bunch of data, then format

#The first line might be generated using:
#echo "system report generated by $user, $(date)"

#we have a lot of lines to produce, so we will use a template instead of generating one output line at a time

#gather data into variables
myusername="USER"
currentdatetime="$(date)"

#we get the distro name and version from /etc/os-release
#this would not work on computers without an /etc/os-release file!!

#produce report
cat <<EOF

System Report generated by USERNAME, DATE/TIME
 
System Information
------------------
Hostname: HOSTNAME
OS: DISTROWITHVERSION
Uptime: UPTIME
 
Hardware Information
--------------------
cpu: PROCESSOR MAKE AND MODEL
Speed: CURRENT AND MAXIMUM CPU SPEED
Ram: SIZE OF INSTALLED RAM
Disk(s): MAKE AND MODEL AND SIZE FOR ALL INSTALLED DISKS
Video: MAKE AND MODEL OF VIDEO CARD
 
Network Information
-------------------
FQDN: FQDN
Host Address: IP ADDRESS FOR THE HOSTNAME
Gateway IP: GATEWAY ADDRESS
DNS Server: IP OF DNS SERVER
 
InterfaceName: MAKE AND MODEL OF NETWORK CARD
IP Address: IP Address in CIDR format
 
System Status
-------------
Users Logged In: USER,USER,USER...
Disk Space: FREE SPACE FOR LOCAL FILESYSTEMS IN FORMAT: /MOUNTPOINT N
Process Count: N
Load Averages: N, N, N
Memory Allocation: DATA FROM FREE
Listening Network Ports: N, N, N, ...
UFW Rules: DATA FROM UFW SHOW

EOF
