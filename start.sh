#!/bin/sh

# Replace environment variable in config file
envsubst < /app/config/mediamtx.yml.template > /app/config/mediamtx.yml

# Start the web server in the background
python3 /app/webserver.py &

# Start the MediaMTX server
exec ./mediamtx /app/config/mediamtx.yml