#!/bin/bash

VERBOSE=0
if [[ "$1" == "-verbose" ]]; then
    VERBOSE=1
    shift
fi

OPTIONS=""
[[ $VERBOSE -eq 1 ]] && OPTIONS="-verbose"

# Transfer and execute configuration on server1
scp configure-host.sh root@server1:/root/
ssh root@server1 "/root/configure-host.sh -name loghost -ip 192.168.16.3 -hostentry webhost 192.168.16.4 $OPTIONS"

# Transfer and execute configuration on server2
scp configure-host.sh root@server2:/root/
ssh root@server2 "/root/configure-host.sh -name webhost -ip 192.168.16.4 -hostentry loghost 192.168.16.3 $OPTIONS"

# Update local host entries
./configure-host.sh -hostentry loghost 192.168.16.3 $OPTIONS
./configure-host.sh -hostentry webhost 192.168.16.4 $OPTIONS

