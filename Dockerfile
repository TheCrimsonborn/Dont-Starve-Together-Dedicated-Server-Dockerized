FROM ubuntu:22.04

# Enable i386 architecture and install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    libstdc++6:i386 \
    libgcc1:i386 \
    lib32stdc++6 \
    lib32gcc-s1 \
    libc6-i386 \
    libcurl4-gnutls-dev:i386 \
    screen \
    libcurl4 \
    tar \
    curl \
    locales && \
    rm -rf /var/lib/apt/lists/*

# Set up locales
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Create a user for the server
RUN useradd -m -s /bin/bash dst
USER dst
WORKDIR /home/dst

# Create directories
RUN mkdir -p /home/dst/server && \
    mkdir -p /home/dst/.klei/DoNotStarveTogether && \
    mkdir -p /home/dst/steamcmd

# Install SteamCMD
RUN cd /home/dst/steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Install DST Dedicated Server
RUN /home/dst/steamcmd/steamcmd.sh +force_install_dir /home/dst/server +login anonymous +app_update 343050 validate +quit

# Set volumes for persisting data
VOLUME ["/home/dst/.klei/DoNotStarveTogether"]

# Default environment variables
ENV SHARD_NAME="unknown" \
    SERVER_PORT="10999" \
    MASTER_SERVER_PORT="27018" \
    AUTHENTICATION_PORT="8768" \
    IS_MASTER="true" \
    CLUSTER_NAME="MyDediServer"

# Create the startup script
RUN echo '#!/bin/bash \n\
cd /home/dst/server/bin \n\
\n\
# Start the server \n\
./dontstarve_dedicated_server_nullrenderer -console -cluster ${CLUSTER_NAME} -shard ${SHARD_NAME}' > /home/dst/start_dst.sh && \
    chmod +x /home/dst/start_dst.sh

# Set entrypoint
ENTRYPOINT ["/home/dst/start_dst.sh"]
