#!/bin/bash

#set -e  # Exit on error

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

echo "Starting TShock Terraria Server!!!"
./TShock.Server \
  "-configpath /data" \
  "-logpath /data/logs" \
  "-crashdir /data/crashes" \
  "-worldselectpath /worlds" \
  "-additionalplugins /plugins"
