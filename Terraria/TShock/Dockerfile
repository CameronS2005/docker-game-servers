### Base image
FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/sdk:6.0 AS builder

# Set the working directory
WORKDIR /data

# Copy the project files
COPY ./TShock-5.2.2/* . 

# Build the application
RUN dotnet build -v m

# Publish the application
RUN dotnet publish -o output/ -r linux-x64 -v m -f net6.0 -c Release -p:PublishSingleFile=true --self-contained false

### Runtime image
FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/runtime:6.0 AS runner
WORKDIR /server

# Copy the published files from the builder stage
COPY --from=builder /data/output ./

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Handle volumes and ports
VOLUME ["/data", "/worlds", "/plugins"]
EXPOSE 7777

# Container entry script
ENTRYPOINT ["/entrypoint.sh"]
