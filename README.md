
# Don't Starve Together Dedicated Server (Dockerized)

This repository provides a fully containerized setup for hosting a Don't Starve Together (DST) dedicated server using Docker and Docker Compose. It includes both `Master` and `Caves` shards in separate containers with shared configuration volumes.

---

## 📦 Folder Structure

```
dst-dedicated-docker-server/
├── docker-compose.yml
├── Dockerfile
├── start_master.sh
├── start_caves.sh
└── dst_data/
    └── DoNotStarveTogether/
        └── MyDediServer/
            ├── cluster.ini
            ├── cluster_token.txt
            ├── server.ini
            └── worldgenoverride.lua
```

---

## 🚀 How to Run

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/dst-dedicated-docker-server.git
cd dst-dedicated-docker-server
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
- `server.ini`
- `cluster_token.txt`
- `worldgenoverride.lua`

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
Each shard (Master and Caves) uses a separate `server.ini` with its own ports.

### worldgenoverride.lua
Controls the world generation presets (e.g., SURVIVAL_TOGETHER, DST_CAVE).

### cluster_token.txt
Contains your Klei token for hosting online games.

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
- A valid `cluster_token.txt` from your Klei account

---

## 🙌 Acknowledgements

Thanks to the Klei community and all Docker warriors out there building and tweaking their own game servers!

---

Happy starving, in clusters! 🎮
