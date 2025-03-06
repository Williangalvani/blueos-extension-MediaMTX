#!/bin/sh

# Define config paths
CONFIG_DIR="/usr/blueos/extensions/mediamtx"
CONFIG_PATH="$CONFIG_DIR/mediamtx.yml"
TEMPLATE_PATH="/app/config/mediamtx.yml.template"

# Create directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Check if config file exists, if not create it from template
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Creating initial configuration file from template"
    envsubst < "$TEMPLATE_PATH" > "$CONFIG_PATH"
fi

# Start the web server (which will also manage MediaMTX)
echo "Starting web server and MediaMTX..."
exec python3 /app/webserver.py