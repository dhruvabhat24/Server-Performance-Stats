#!/bin/bash

# Simple health check script
# Run as sudo for full stats (failed logins)

# Colors for a bit of flair
GREEN='\033[0;32m'
NC='\033[0m' 

echo -e "${GREEN}--- SYSTEM STATUS ---${NC}"

# OS & Uptime
uptime -p
grep "PRETTY_NAME" /etc/os-release | cut -d'=' -f2 | tr -d '"'
echo "Load Avg: $(uptime | awk -F'load average:' '{print $2}')"

echo "----------------------------"

# CPU - Pulling from /proc/stat or top is messy, 
# this is the most reliable "quick" way
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
cpu_used=$(echo "100 - $cpu_idle" | bc 2>/dev/null || awk "BEGIN {print 100 - $cpu_idle}")
echo "CPU Usage: $cpu_used%"

# Mem - Use /proc/meminfo or free -m
echo "Memory:"
free -m | awk 'NR==2{printf "  Used: %dMB, Free: %dMB (%.1f%%)\n", $3, $4, $3*100/$2}'

# Disk - Filter out tmpfs and devtmpfs
echo "Disk (Root):"
df -h / | awk 'NR==2{printf "  Used: %s, Free: %s, Space: %s\n", $3, $4, $5}'

echo "----------------------------"

# Process lists - nobody likes the headers repeating, so we tail +2
echo "Top 5 CPU Procs:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | sed 's/^/  /'

echo ""
echo "Top 5 Mem Procs:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | sed 's/^/  /'

echo "----------------------------"

# Extra stuff
echo "Users logged in: $(who | wc -l)"
# Check journal for ssh fails - might need sudo
failed_ssh=$(journalctl _SYSTEMD_UNIT=sshd.service 2>/dev/null | grep -c "Failed password")
echo "Recent SSH failures: ${failed_ssh:-"check sudo"}"

echo -e "${GREEN}--- DONE ---${NC}"