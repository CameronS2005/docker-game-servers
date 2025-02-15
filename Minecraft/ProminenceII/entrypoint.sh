#!/bin/bash

set -e  # Exit on error

# Default memory settings (can be overridden by environment variables)
MIN_RAM="${MIN_RAM:-1024M}"
MAX_RAM="${MAX_RAM:-4096M}"

# Function to handle the stop signal
stop_server() {
    echo "Stopping Minecraft server gracefully..."

    # Send the "save-all" command to save the world and then "stop" to shut it down
    echo "save-all" | nc -U /server/serverconsole.sock
    echo "stop" | nc -U /server/serverconsole.sock
    exit 0
}

# Trap SIGTERM and SIGINT (Ctrl+C) to call stop_server()
trap stop_server SIGTERM SIGINT

echo "Checking if server files exist..."

# Ensure /server directory exists
mkdir -p /server/plugins

# Download Fabric if not present
if [ ! -f /server/fabric.jar ]; then
    echo "Downloading PaperMC server..."
    curl -o /server/fabric.jar https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.16.10/1.0.1/server/jar
    wget https://mediafilez.forgecdn.net/files/6162/20/Prominence_II_RPG_Hasturian_Era_Server_Pack_v3.1.1.zip -O /server/prominence2.zip
    unzip /server/prominence2.zip -d /server
    rm /server/prominence2.zip
fi

# Accept EULA automatically if not already accepted
if [ ! -f /server/eula.txt ]; then
    touch /server/eula.txt
    echo "eula=true" > /server/eula.txt
fi

echo "Starting Minecraft server..."
exec java -Xms"$MIN_RAM" -Xmx"$MAX_RAM" -jar /server/fabric.jar nogui
