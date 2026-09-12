  GNU nano 8.7.1                                                                             infra_health.check.sh *                                                                                    
#!/bin/bash

LOG_FILE="/var/log/infra_health.log"
APP_CONTAINER="trainee-app"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "infrastructure health check"

#cpy usage
CPU=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.1f", 100-$8}')
echo "cpu usage: $CPU%"

# ram usage
RAM=$(free | awk '/Mem:/ {printf "%.1f", $3/$2 * 100}')
echo "ram usage: $RAM%"

# root disk monitor
DISK=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
echo "root disk usage: $DISK%"

# verify docker
if systemctl is-active --quiet docker; then
    echo "docker: running"
else
    echo "docker: stopped"
fi

# application container
if docker ps --format '{{.Names}}' | grep -q "^${APP_CONTAINER}$"; then
    echo "application container: running"
else
    echo "[warning] application container is stopped"
    echo "$TIMESTAMP [warning] application container is stopped" >> "$LOG_FILE"
fi

# disk usage
if [ "$DISK" -gt 85 ]; then
    echo "[WARNING] root disk usage is above 85%"
    echo "$TIMESTAMP [alert] root disk usage is ${DISK}%" >> "$LOG_FILE"
fi
