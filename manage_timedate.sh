#!/bin/bash

# List of servers (add your server IPs or hostnames here)
SERVERS=(
    "server1.example.com"
    "server2.example.com"
    "server3.example.com"
)

# SSH username
USER="your-username"

# Service name to stop and disable
SERVICE="timedate"

# Sudo password
SUDO_PASSWORD="ilovecats"

# Loop through each server
for SERVER in "${SERVERS[@]}"; do
    echo "Processing $SERVER..."

    # SSH into the server and execute commands
    ssh "$USER@$SERVER" << EOF
        echo "Stopping $SERVICE service..."
        echo "$SUDO_PASSWORD" | sudo -S systemctl stop $SERVICE
        if [ $? -ne 0 ]; then
            echo "$SERVER: Failed to stop $SERVICE. Ensure sudo permissions are configured."
            exit 1
        fi
        echo "Disabling $SERVICE service..."
        echo "$SUDO_PASSWORD" | sudo -S systemctl disable $SERVICE
        if [ $? -ne 0 ]; then
            echo "$SERVER: Failed to disable $SERVICE. Ensure sudo permissions are configured."
            exit 1
        fi
EOF

    if [ $? -eq 0 ]; then
        echo "$SERVER: Successfully stopped and disabled $SERVICE."
    else
        echo "$SERVER: Encountered an error while stopping or disabling $SERVICE."
    fi

done

echo "Task completed."
