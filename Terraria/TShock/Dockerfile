### Base image 
FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:6.0 AS builder

# Build and package release based on target architecture
RUN dotnet build -v m
WORKDIR /data

# Make TARGETPLATFORM available to the container.
ARG TARGETPLATFORM

RUN dotnet publish -o output/ -r linux-x64 -v m -f net6.0 -c Release -p:PublishSingleFile=true --self-contained false

# Runtime image
FROM --platform=${TARGETPLATFORM} mcr.microsoft.com/dotnet/runtime:6.0 AS runner
WORKDIR /data
COPY --from=builder ./

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Handle volumes, and ports.
VOLUME ["/data]
EXPOSE 7777

# Container entry script
ENTRYPOINT ["/entrypoint.sh"]