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

# Download PaperMC if not present
if [ ! -f /server/paper.jar ]; then
    echo "Downloading PaperMC server..."
    curl -o /server/paper.jar https://api.papermc.io/v2/projects/paper/versions/1.21.4/builds/150/downloads/paper-1.21.4-150.jar # too large for github free cdn :(
fi

# Download Plugins!
cd /server/plugins
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/floodgate-spigot-b115.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/geyser-spigot-b762.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/FastChunkPregenerator-2.0.9-SNAPSHOT.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/AdvancedAchievements-9.3.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/EconomyShopGUI-6.10.2.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/EssentialsX-2.20.1.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/LuckPerms-Bukkit-5.4.154.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/Vault.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/Clearlag.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/dead-chest-4.21.1.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/DropHeads.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/Minepacks.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/SilkSpawners.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/EssentialsXChat-2.20.1.jar
curl -O https://raw.githubusercontent.com/CameronS2005/GeyserMC-docker/main/plugins/EssentialsXSpawn-2.20.1.jar
cd /server

# Accept EULA automatically if not already accepted
if [ ! -f /server/eula.txt ]; then
    touch /server/eula.txt
    echo "eula=true" > /server/eula.txt
fi

echo "Starting Minecraft server..."
exec java -Xms"$MIN_RAM" -Xmx"$MAX_RAM" -jar /server/paper.jar nogui
