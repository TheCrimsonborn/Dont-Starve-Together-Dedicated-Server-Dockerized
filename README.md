
# Don't Starve Together Dedicated Server (Dockerized)

This repository provides a fully containerized setup for hosting a Don't Starve Together (DST) dedicated server using Docker and Docker Compose. It includes both `Master` and `Caves` shards in separate containers with shared configuration volumes.

**GitHub Repository:**  
👉 https://github.com/TheCrimsonborn/Dont-Starve-Together-Dedicated-Server-Dockerized

---

## 📦 Folder Structure

```
Dont-Starve-Together-Dedicated-Server-Dockerized/
├── docker-compose.yml
├── Dockerfile
├── start_master.sh
├── start_caves.sh
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

### 2. Configure and download the server settings from Klei

Before starting the server, you need to generate and download a valid server configuration from Klei’s account dashboard:

1. Go to [https://accounts.klei.com/account](https://accounts.klei.com/account) and log in to your Klei account.
2. Click on the **GAMES** tab.
3. Scroll down to **Don’t Starve Together** and click the **Game Servers** button.
4. If you don’t have any servers yet, click **ADD NEW SERVER**. Otherwise, click the green **CONFIGURE** button next to an existing one.
5. Fill out the server configuration form (cluster name, description, game mode, etc.).
6. Click **Download Settings** once you're done.
7. Extract the ZIP file and move the resulting `MyDediServer` folder into:

   ```
   ~/.klei/DoNotStarveTogether/
   ```

> In this Docker setup, that means placing it inside:
> ```
> dst-dedicated-docker-server/dst_data/DoNotStarveTogether/MyDediServer/
> ```

Make sure it includes:
- `cluster.ini`
- `Master/server.ini` and `Master/worldgenoverride.lua`
- `Caves/server.ini` and `Caves/worldgenoverride.lua`

> **Note:** `cluster_token.txt` is optional. Without it, the server will only be accessible on LAN and not over the internet.

---

### 3. Build and Start the Containers

```bash
docker compose up --build -d
```

This will:
- Build the image using the provided Dockerfile
- Create and start two containers:
  - `dst-master`: Master shard
  - `dst-caves`: Caves shard

---

## 🔧 Configuration Files

### cluster.ini
Contains global cluster settings like game mode, player limits, and network info.

### server.ini
Each shard (Master and Caves) uses its own `server.ini` with specific ports.

### worldgenoverride.lua
Controls the world generation presets (e.g., SURVIVAL_TOGETHER, DST_CAVE).

---

## 🧠 Important Notes

- The DST game server binaries are downloaded using `steamcmd` automatically inside each container.
- Make sure the `dst_data` folder and `dst_server_data` Docker volume are correctly mounted and persistent.
- To stop the server:
```bash
docker compose down
```

---

## 🐧 Requirements

- A Linux server
- Docker
- Docker Compose

---

## 🙌 Acknowledgements

Thanks to the Klei community and all Docker warriors out there building and tweaking their own game servers!

---

Happy starving, in clusters! 🎮
