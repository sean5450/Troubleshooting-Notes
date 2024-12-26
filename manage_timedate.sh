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

# Loop through each server
for SERVER in "${SERVERS[@]}"; do
    echo "Processing $SERVER..."

    # SSH into the server and execute commands
    ssh "$USER@$SERVER" << EOF
        echo "Stopping $SERVICE service..."
        sudo systemctl stop $SERVICE
        echo "Disabling $SERVICE service..."
        sudo systemctl disable $SERVICE
EOF

    if [ $? -eq 0 ]; then
        echo "$SERVER: Successfully stopped and disabled $SERVICE."
    else
        echo "$SERVER: Failed to stop or disable $SERVICE."
    fi

done

echo "Task completed."
