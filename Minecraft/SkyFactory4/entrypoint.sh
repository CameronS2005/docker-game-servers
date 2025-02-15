#!/bin/bash

set -e  # Exit on error

# Default memory settings (can be overridden by environment variables)
MIN_RAM="${MIN_RAM:-1024M}"
MAX_RAM="${MAX_RAM:-4096M}"

# Function to handle the stop signal
stop_server() {
    echo "Stopping Terraria server gracefully..."

    # Send the "save-all" command to save the world and then "stop" to shut it down
    echo "save-all" | nc -U /server/serverconsole.sock
    echo "stop" | nc -U /server/serverconsole.sock
    exit 0
}

# Trap SIGTERM and SIGINT (Ctrl+C) to call stop_server()
trap stop_server SIGTERM SIGINT

echo "Checking if server files exist..."

# Download SkyFactory4 if not present
if [ ! -d /server/TShockLauncher ]; then
    echo "Downloading TShock server..."

    curl -O https://raw.githubusercontent.com/CameronS2005/docker-game-servers/main/Terraria/TShock/TShock-5.2.2.zip
    unzip /server/TShock-5.2.2.zip -d /server
    rm /server/TShock-5.2.2.zip

    echo "TShock server files downloaded."
fi

echo "Starting TShock Terraria Server!!!"
./TShock.Server \
  "-configpath /data" \
  "-logpath /data/logs" \
  "-crashdir /data/crashes" \
  "-worldselectpath /worlds" \
  "-additionalplugins /plugins"
