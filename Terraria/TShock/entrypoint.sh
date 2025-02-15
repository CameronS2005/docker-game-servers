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
    curl -L -o /server/sf4.zip https://mediafilez.forgecdn.net/files/3565/687/SkyFactory-4_Server_4_2_4.zip
    unzip /server/sf4.zip -d /server
    rm /server/sf4.zip
    echo "SkyFactory4 server files downloaded."
fi
