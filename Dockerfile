# Use a stable Ubuntu LTS release
FROM ubuntu:22.04

LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Don't Starve Together Dedicated Server Image"

ARG STEAM_USER=steam
ARG DST_APP_ID=343050
ARG DST_SERVER_DIR_BASE=/home/${STEAM_USER}
ARG DST_SERVER_DIR=${DST_SERVER_DIR_BASE}/dst_server
# Config/Save data will be mounted here from the host/volume
ARG DST_CLUSTER_PARENT_DIR=${DST_SERVER_DIR_BASE}/.klei
ARG DST_CLUSTER_NAME=MyDediServer

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    lib32gcc-s1 \
    screen \
    libcurl3-gnutls \
    && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user to run the server
RUN useradd -m ${STEAM_USER}

# --- SteamCMD Installation ---
USER ${STEAM_USER}
WORKDIR ${DST_SERVER_DIR_BASE}

RUN mkdir steamcmd && \
    cd steamcmd && \
    wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf - && \
    # Add a small wait/retry in case of CDN issues during build
    ./steamcmd.sh +quit || (sleep 1 && ./steamcmd.sh +quit)

# --- DST Server Installation ---
# Create server directory owned by steam user BEFORE logging in anonymous
RUN mkdir -p ${DST_SERVER_DIR}

# Download/Update DST Dedicated Server
# Use full paths to steamcmd.sh and specify install dir explicitly
RUN ./steamcmd/steamcmd.sh \
    +force_install_dir ${DST_SERVER_DIR} \
    +login anonymous \
    +app_update ${DST_APP_ID} validate \
    +quit || \
    # Retry logic
    ( \
    echo "SteamCMD download failed, retrying..." && \
    sleep 5 && \
    ./steamcmd/steamcmd.sh \
        +force_install_dir ${DST_SERVER_DIR} \
        +login anonymous \
        +app_update ${DST_APP_ID} validate \
        +quit \
    )

# --- Configuration & Runtime Setup ---
# Copy start scripts into the image
COPY --chown=${STEAM_USER}:${STEAM_USER} start_master.sh start_caves.sh ${DST_SERVER_DIR_BASE}/
RUN chmod +x ${DST_SERVER_DIR_BASE}/start_master.sh ${DST_SERVER_DIR_BASE}/start_caves.sh

# Create the expected parent directory for the cluster data mount point
# The actual cluster data (MyDediServer) will be mounted from the host
RUN mkdir -p ${DST_CLUSTER_PARENT_DIR} && chown ${STEAM_USER}:${STEAM_USER} ${DST_CLUSTER_PARENT_DIR}

# Set the working directory for the final command execution
WORKDIR ${DST_SERVER_DIR_BASE}

# Ports the server listens on (UDP)
EXPOSE 10999/udp
EXPOSE 11000/udp

# Default user
USER ${STEAM_USER}

# Default command (will be overridden by docker-compose)
CMD ["bash"]
