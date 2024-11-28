#!/bin/bash

VERBOSE=0
if [[ "$1" == "-verbose" ]]; then
    VERBOSE=1
    shift
fi

OPTIONS=""
[[ $VERBOSE -eq 1 ]] && OPTIONS="-verbose"

# Deploy and configure server1
lxc file push configure-host.sh server1/root/
lxc exec server1 -- bash /root/configure-host.sh -name loghost -ip 192.168.16.3 -hostentry webhost 192.168.16.4 $OPTIONS

# Deploy and configure server2
lxc file push configure-host.sh server2/root/
lxc exec server2 -- bash /root/configure-host.sh -name webhost -ip 192.168.16.4 -hostentry loghost 192.168.16.3 $OPTIONS

# Update local host entries
./configure-host.sh -hostentry loghost 192.168.16.3 $OPTIONS
./configure-host.sh -hostentry webhost 192.168.16.4 $OPTIONS

