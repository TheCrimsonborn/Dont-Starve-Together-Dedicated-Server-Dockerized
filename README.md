# Don't Starve Together Dedicated Server (Dockerized)

This repository provides a fully containerized setup for hosting a **Don't Starve Together (DST)** dedicated server using **Docker** and **Docker Compose**. It includes both `Master` and `Caves` shards in separate containers, sharing a common volume for persistent data.

**GitHub Repository:**  
👉 [https://github.com/TheCrimsonborn/Dont-Starve-Together-Dedicated-Server-Dockerized](https://github.com/TheCrimsonborn/Dont-Starve-Together-Dedicated-Server-Dockerized)

---

## 📦 Folder Structure

Your project should follow this folder structure:

```
Dont-Starve-Together-Dedicated-Server-Dockerized/
├── docker-compose.yml
├── Dockerfile
└── dst_data/
    └── DoNotStarveTogether/
        └── MyDediServer/
            ├── cluster.ini
            ├── cluster_token.txt
            ├── Master/
            │   ├── server.ini
            │   └── worldgenoverride.lua
            └── Caves/
                ├── server.ini
                └── worldgenoverride.lua
```

---

## 🚀 How to Run

### 1. Clone the repository

```bash
git clone https://github.com/TheCrimsonborn/Dont-Starve-Together-Dedicated-Server-Dockerized.git
cd Dont-Starve-Together-Dedicated-Server-Dockerized
```

### 2. Configure and Download Server Settings from Klei

Before starting the server, generate and download valid server configurations from your Klei account:

1. Visit [https://accounts.klei.com/account](https://accounts.klei.com/account) and log in.
2. Navigate to the **GAMES** tab.
3. Under **Don’t Starve Together**, select **Game Servers**.
4. Click **ADD NEW SERVER** or configure an existing server.
5. Complete the server configuration (e.g., cluster name, description, game mode).
6. Click **Download Settings** and extract the downloaded ZIP file.
7. Place the extracted `MyDediServer` folder in the following directory of your project:

```
./dst_data/DoNotStarveTogether/MyDediServer/
```

Ensure your folder includes:
- `cluster.ini`
- `cluster_token.txt` *(mandatory for online access)*
- `Master/server.ini` and optionally `Master/worldgenoverride.lua`
- `Caves/server.ini` and optionally `Caves/worldgenoverride.lua`

---

### 3. Build and Start Containers

Build and run the containers using Docker Compose:

```bash
docker compose up --build -d
```

This command:
- Builds the Docker images from the provided Dockerfile.
- Starts two containers:
  - `dst-master`: Master shard
  - `dst-caves`: Caves shard

---

## 🔧 Configuration Files

### cluster.ini
Global cluster settings including:
- Game mode
- Player limit
- Network configurations

### server.ini
Each shard (`Master` and `Caves`) uses a separate `server.ini` for shard-specific settings, including ports and shard roles.

### worldgenoverride.lua
Optional Lua file to control world generation settings, presets, and customizations.

---

## 🧠 Important Notes

- DST game server binaries are automatically downloaded using `steamcmd` within the container.
- Your `dst_data` folder is persistently mounted into the Docker containers.

To gracefully stop and remove containers:

```bash
docker compose down
```

---

## 🐧 Requirements

- Linux Server (Ubuntu recommended)
- Docker (latest recommended)
- Docker Compose (v2 recommended)

---

## 🙌 Acknowledgements

Special thanks to the Klei community and all Docker enthusiasts who continuously enhance and maintain game server deployments!

---

🎮 **Happy Starving Together!** 🌲

