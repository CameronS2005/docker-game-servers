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

# Download SkyFactory4 if not present
if [ ! -f /server/settings.sh ]; then
    echo "Downloading SkyFactory4 server..."
    curl -L -o /server/sf4.zip https://mediafilez.forgecdn.net/files/3565/687/SkyFactory-4_Server_4_2_4.zip
    unzip /server/sf4.zip -d /server
    rm /server/sf4.zip
    echo "SkyFactory4 server files downloaded."
fi

# Accept EULA automatically if not already accepted
if [ ! -f /server/eula.txt ]; then
    touch /server/eula.txt
    echo "eula=true" > /server/eula.txt
    echo "EULA accepted."
fi

# Install the server if not already installed
if [ ! -f /server/.installed ]; then
    echo "Installing SkyFactory4 Server!"
    java -jar /server/forge-1.12.2-14.23.5.2860-installer.jar --installServer
    touch /server/.installed
    echo "Installation complete."
    rm /server/forge-1.12.2-14.23.5.2860-installer.jar
    echo "Installer removed."
fi

# Start the server in the foreground with dynamically set memory
echo "Starting SkyFactory4 Server with $MIN_RAM min and $MAX_RAM max memory..."
exec java -server -Xms"$MIN_RAM" -Xmx"$MAX_RAM" -XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -Dfml.readTimeout=180 -jar /server/forge-1.12.2-14.23.5.2860.jar nogui
