#!/bin/bash

# List of servers (add your server IPs or hostnames here)
SERVERS=(
    "server1.example.com"
    "server2.example.com"
    "server3.example.com"
)

# SSH username
USER="your-username"

# Sudo password
SUDO_PASSWORD="ilovedogs"

# Loop through each server
for SERVER in "${SERVERS[@]}"; do
    echo "Processing $SERVER..."

    # SSH into the server and execute commands
    ssh "$USER@$SERVER" << EOF
        echo "Disabling NTP on $SERVER..."
        echo "$SUDO_PASSWORD" | sudo -S timedatectl set-ntp no
        if [ $? -ne 0 ]; then
            echo "$SERVER: Failed to disable NTP. Ensure sudo permissions are configured."
            exit 1
        fi
EOF

    if [ $? -eq 0 ]; then
        echo "$SERVER: Successfully disabled NTP."
    else
        echo "$SERVER: Encountered an error while disabling NTP."
    fi

done

echo "Task completed."
