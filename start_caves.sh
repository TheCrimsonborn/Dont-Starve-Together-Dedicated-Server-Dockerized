#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# Use environment variables or assign default values
STEAM_USER=${STEAM_USER:-steam}
DST_SERVER_DIR_BASE=${DST_SERVER_DIR_BASE:-/home/${STEAM_USER}}
DST_SERVER_DIR=${DST_SERVER_DIR:-${DST_SERVER_DIR_BASE}/dst_server}
DST_CLUSTER_PARENT_DIR=${DST_CLUSTER_PARENT_DIR:-${DST_SERVER_DIR_BASE}/.klei}
DST_CLUSTER_NAME=${DST_CLUSTER_NAME:-MyDediServer}
DST_APP_ID=343050

CLUSTER_PATH="${DST_CLUSTER_PARENT_DIR}/DoNotStarveTogether/${DST_CLUSTER_NAME}"
SERVER_BINARY="${DST_SERVER_DIR}/bin/dontstarve_dedicated_server_nullrenderer"
STEAMCMD_PATH="${DST_SERVER_DIR_BASE}/steamcmd/steamcmd.sh" # Path to SteamCMD as defined in the Dockerfile

# --- Check Server Files (master should have already downloaded them, but double-check) ---
# Normally the master shard downloads them, this is just a safety check
if [ ! -f "$SERVER_BINARY" ]; then
  echo ">>> Server files not found or incomplete at ($DST_SERVER_DIR)."
  echo ">>> Likely an issue occurred when starting the master shard or a volume is not shared properly."
  echo ">>> Attempting to download/update using SteamCMD..."
  if [ ! -f "$STEAMCMD_PATH" ]; then
      echo "ERROR: SteamCMD not found at: $STEAMCMD_PATH . Please check the Dockerfile." >&2
      exit 1
  fi
  "$STEAMCMD_PATH" \
      +force_install_dir "$DST_SERVER_DIR" \
      +login anonymous \
      +app_update "$DST_APP_ID" validate \
      +quit
  echo ">>> Server files downloaded/updated successfully."
else
  echo ">>> Server files exist at ($DST_SERVER_DIR)."
fi

# --- Check Configuration Files ---
if [ ! -d "$CLUSTER_PATH" ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >&2
    echo "ERROR: Cluster directory not found: '$CLUSTER_PATH'" >&2
    echo "Please ensure the configuration volume is correctly mounted." >&2
    echo "Expected path: <mount_point>/DoNotStarveTogether/${DST_CLUSTER_NAME}/..." >&2
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >&2
    exit 1
fi

# --- Start the server ---
echo ">>> Starting Caves Shard..."
# Call the executable directly with its full path
"$SERVER_BINARY" -console -cluster "${DST_CLUSTER_NAME}" -shard Caves
