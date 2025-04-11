#!/bin/bash

echo "==================== System Health Check ===================="

# Uptime
echo -e "\n🕒 Uptime:"
uptime

# CPU Load
echo -e "\n🔥 CPU Load (1/5/15 min):"
cat /proc/loadavg | awk '{print "1 min: " $1 ", 5 min: " $2 ", 15 min: " $3}'

# Memory Usage
echo -e "\n🧠 Memory Usage:"
free -h

# Disk Usage
echo -e "\n💽 Disk Usage:"
df -h --total | grep -E "^Filesystem|^total"

# Top 5 CPU Processes
echo -e "\n⚙️ Top 5 CPU-consuming processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

# Network Interfaces
echo -e "\n🌐 Network Interfaces (IP addresses):"
ip -4 addr show | grep inet | awk '{print $2 " -> " $NF}'

# Listening Ports
echo -e "\n🔌 Listening Ports:"
ss -tuln | grep LISTEN

# Last Reboot
echo -e "\n🔁 Last Reboot:"
who -b

# Updates (Debian/Ubuntu)
if command -v apt &> /dev/null; then
    echo -e "\n📦 Available Updates:"
    apt list --upgradable 2>/dev/null | tail -n +2
fi

echo -e "\n✅ System health check complete."
echo "============================================================="
