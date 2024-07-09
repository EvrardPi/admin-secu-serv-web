#!/bin/bash

# Change to the directory containing the Docker Compose file
cd /home/pierre/nginx

# Debugging: Log the current directory
echo "Current directory: $(pwd)" >> /home/pierre/certbot_renew.log

# Stop the nginx service
echo "Stopping nginx service..." >> /home/pierre/certbot_renew.log
docker compose down

# Check if Certbot is already running
if pgrep -x "certbot" > /dev/null; then
    echo "Certbot is already running. Exiting script at $(date)" >> /home/pierre/certbot_renew.log
    docker compose start nginx
    exit 1
fi

# Renew the certificates and capture the output
echo "Renewing certificates..." >> /home/pierre/certbot_renew.log
renew_output=$(sudo certbot renew --force-renewal 2>&1)
echo "$renew_output" >> /home/pierre/certbot_renew.log

# Check if the renewal was successful
if echo "$renew_output" | grep -q "successfully renewed"; then
    echo "Certificates successfully renewed at $(date)" >> /home/pierre/certbot_renew.log
elif echo "$renew_output" | grep -q "No renewals were attempted"; then
    echo "No certificates were due for renewal at $(date)" >> /home/pierre/certbot_renew.log
else
    echo "Certbot encountered an error at $(date)" >> /home/pierre/certbot_renew.log
fi

# Restart the nginx service
echo "Starting nginx service..." >> /home/pierre/certbot_renew.log
docker compose up --build -d

# Log the completion of the process
echo "Docker Compose restarted at $(date)" >> /home/pierre/certbot_renew.log
