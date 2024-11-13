#!/bin/bash

echo "Starting system configuration script..."

# Step 1: Configure Network Interface
NETPLAN_FILE="/etc/netplan/50-cloud-init.yaml"
TARGET_IP="192.168.16.21/24"

echo "Configuring network interface..."

if ! grep -q "$TARGET_IP" "$NETPLAN_FILE"; then
    echo "Setting network IP to $TARGET_IP..."
    sudo sed -i '/addresses:/c\ \ \ \ \ \ addresses: ['$TARGET_IP']' "$NETPLAN_FILE"
    sudo netplan apply
    echo "Network configuration updated."
else
    echo "Network configuration is already correct."
fi

# Step 2: Update /etc/hosts
echo "Updating /etc/hosts..."

HOST_ENTRY="192.168.16.21 server1"
if grep -q "192.168.16.21" /etc/hosts; then
    sudo sed -i '/192.168.16.21/c\'"$HOST_ENTRY" /etc/hosts
else
    echo "$HOST_ENTRY" | sudo tee -a /etc/hosts
fi
echo "/etc/hosts updated."

# Step 3: Install Required Software
echo "Checking and installing required software..."

# Install Apache2
if ! dpkg -l | grep -q apache2; then
    echo "Installing apache2..."
    sudo apt update
    sudo apt install -y apache2
else
    echo "Apache2 is already installed."
fi

# Install Squid
if ! dpkg -l | grep -q squid; then
    echo "Installing squid..."
    sudo apt install -y squid
else
    echo "Squid is already installed."
fi
echo "Software installation complete."

# Step 4: Create User Accounts
echo "Configuring user accounts..."

USERS=("dennis" "aubrey" "captain" "snibbles" "brownie" "scooter" "sandy" "perrier" "cindy" "tiger" "yoda")

for user in "${USERS[@]}"; do
    if ! id "$user" &>/dev/null; then
        sudo useradd -m -s /bin/bash "$user"
        echo "User $user created."
    else
        echo "User $user already exists."
    fi
    
    # Create .ssh directory and add SSH keys
    sudo mkdir -p /home/"$user"/.ssh
    sudo ssh-keygen -t rsa -f /home/"$user"/.ssh/id_rsa -N "" -q
    sudo ssh-keygen -t ed25519 -f /home/"$user"/.ssh/id_ed25519 -N "" -q
    
    cat /home/"$user"/.ssh/id_rsa.pub | sudo tee -a /home/"$user"/.ssh/authorized_keys
    cat /home/"$user"/.ssh/id_ed25519.pub | sudo tee -a /home/"$user"/.ssh/authorized_keys
    
    if [ "$user" == "dennis" ]; then
        echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm" | sudo tee -a /home/"$user"/.ssh/authorized_keys
        sudo usermod -aG sudo "$user"
        echo "User dennis given sudo access."
    fi
    
    sudo chown -R "$user":"$user" /home/"$user"/.ssh
    echo "SSH keys setup for user $user."
done
echo "User accounts configuration complete."

echo "System configuration script completed."
