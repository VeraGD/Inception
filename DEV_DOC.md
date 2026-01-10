# 🛠️ Developer Documentation

This document describes the technical setup, build process, and data management for the Inception project.

## 1. Environment Setup

### Prerequisites
* **OS:** Linux / Virtual Machine.
* **Tools:** Docker Engine, Docker Compose, Make, sudo privileges.

### Configuration Files
The project relies on a `.env` file located at `srcs/.env` to inject environment variables into `docker-compose.yml`.

**Required `.env` structure:**
```env
DOMAIN_NAME=veragarc.42.fr
SQL_DATABASE=wordpress
SQL_USER=veragarc
WP_ADMIN_USER=veragarc
```

**Host Configuration**
The domain `veragarc.42.fr` must point to the local machine (`127.0.0.1`).You can configure this automatically using the Makefile:

```bash
make host
```

(This appends the entry to `/etc/hosts`).

## 2. Building and Launching
The project uses a **Makefile** to automate Docker Compose commands.
- **Build images and start containers**:
    ```bash
    make
    ```
    
    This runs `docker compose -f srcs/docker-compose.yml up --build -d`.

- **Rebuild from scratch**:If you modify configuration files (e.g., `nginx.conf` or `script.sh`), force a rebuild:
   ```bash
    make re
    ```

**Makefile Commands**

| Command | Description |
| :--- | :--- |
| `make` | Builds images and starts the infrastructure (detached mode). |
| `make build` | Builds the images without starting the containers. |
| `make down` | Stops and removes containers and networks. |
| `make clean` | Removes containers and Docker images. |
| `make fclean` | **Deep Clean**: Removes containers, images, and **persistent data volumes** (Database & WP files). |
| `make re` | Rebuilds everything from scratch (`fclean` + `make`). |
| `make host` | Configures the local domain in `/etc/hosts` (requires sudo). |
| `make up` | Start services. |
   
## 3. Container Management
CommandDescriptionmake stopPauses the containers without removing them.make downStops containers and removes the network.make cleanRemoves containers, networks, and Docker images.make fcleanDestructive: Performs clean AND deletes the persistent data volumes.
**Accessing Containers**
To execute commands inside a running container (e.g., to check files in WordPress):
```bash
docker exec -it wordpress /bin/bash
```

## 4. Data Storage and Persistence
Data persistence is handled via **Docker Volumes** mapped to the host machine. This ensures data survives container restarts.

**Storage Location**

The data is stored on the host machine at:

- **Database**: `/home/veragarc/data/mariadbWordPress`
- **Files**: `/home/veragarc/data/wordpressHow`

**Persistence Works**
1. **Docker Compose** maps these host directories to internal container paths (`/var/lib/mysql` and `/var/www/html`).
2. If you restart containers (`make down` -> `make up`), the data remains intact.
3. **To reset data**: Run `make fclean`. This command explicitly deletes the contents of the `/home/veragarc/data/` directories to allow a fresh installation.