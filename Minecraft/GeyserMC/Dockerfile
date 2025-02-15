# Use an official OpenJDK image as the base image
FROM openjdk:21-jdk-slim

# Set the working directory inside the container
WORKDIR /server

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create the minecraft user with UID 1000 and GID 1000
RUN groupadd -g 1000 minecraft && useradd -r -u 1000 -g minecraft -m minecraft

# Set the ownership of the /server directory to the minecraft user
RUN chown -R minecraft:minecraft /server

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy server properties and EULA (optional, only if you want predefined configs)
COPY server.properties /server/server.properties

# Expose the necessary ports
EXPOSE 25565/tcp 19132/udp

# Switch to the minecraft user
USER minecraft

# Use the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
