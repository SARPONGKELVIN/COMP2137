#!/bin/bash

# Variables
VERBOSE=0
HOSTNAME=""
IP=""
HOSTENTRY=()

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -verbose)
            VERBOSE=1
            shift
            ;;
        -name)
            HOSTNAME="$2"
            shift 2
            ;;
        -ip)
            IP="$2"
            shift 2
            ;;
        -hostentry)
            HOSTENTRY=("$2" "$3")
            shift 3
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
    esac
done

# Function: Update hostname
update_hostname() {
    if [[ $(hostname) != "$HOSTNAME" ]]; then
        echo "$HOSTNAME" | sudo tee /etc/hostname
        sudo sed -i "s/^127.0.1.1.*/127.0.1.1 $HOSTNAME/" /etc/hosts
        hostnamectl set-hostname "$HOSTNAME"
        [[ $VERBOSE -eq 1 ]] && echo "Hostname updated to $HOSTNAME"
        logger "Hostname updated to $HOSTNAME"
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "Hostname is already set to $HOSTNAME"
    fi
}

# Function: Update IP address
update_ip() {
    if ! grep -q "$IP" /etc/hosts; then
        sudo sed -i "/$HOSTNAME/d" /etc/hosts
        echo "$IP $HOSTNAME" | sudo tee -a /etc/hosts
        [[ $VERBOSE -eq 1 ]] && echo "IP address updated to $IP"
        logger "IP address updated to $IP"
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "IP address is already set to $IP"
    fi
}

# Function: Update host entry
update_hostentry() {
    if ! grep -q "${HOSTENTRY[1]} ${HOSTENTRY[0]}" /etc/hosts; then
        echo "${HOSTENTRY[1]} ${HOSTENTRY[0]}" | sudo tee -a /etc/hosts
        [[ $VERBOSE -eq 1 ]] && echo "Host entry added: ${HOSTENTRY[*]}"
        logger "Host entry added: ${HOSTENTRY[*]}"
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "Host entry already exists: ${HOSTENTRY[*]}"
    fi
}

# Apply configurations
[[ -n "$HOSTNAME" ]] && update_hostname
[[ -n "$IP" ]] && update_ip
[[ ${#HOSTENTRY[@]} -eq 2 ]] && update_hostentry
