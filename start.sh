#!/bin/sh

# Replace environment variable in config file
envsubst < /app/config/mediamtx.yml.template > /app/config/mediamtx.yml

# Start the server
exec ./mediamtx /app/config/mediamtx.yml