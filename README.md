*This proyect has been created as part of the 42 curriculum by veragarc.*

# Inception

![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![NGINX](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-%23117AC9.svg?style=for-the-badge&logo=WordPress&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)

---

## 📝 Description

This project aims to broaden the knowledge of system administration by using **Docker**. It requires setting up a small infrastructure composed of different services following specific rules for performance, security, and modularity.

The goal is to build a complete web infrastructure using **Docker Compose**, running on a Virtual Machine, where each service runs in a separate container but communicates within a secure internal network.

---

## 📋 Instructions

Follow these steps to deploy the infrastructure:

### 1. Prerequisites
* Docker Engine & Docker Compose installed.
* Make.
* Root privileges (required for `/etc/hosts` configuration).

### 2. Environment Setup
Ensure you have a `.env` file inside `srcs/` containing your secrets.
**Example `.env`:**
```env
DOMAIN_NAME=veragarc.42.fr
SQL_DATABASE=wordpress
SQL_USER=veragarc
WP_ADMIN_USER=veragarc
```

### 3. Local Domain Configuration
Map the domain to your local machine using the Makefile helper:
```Bash
make host
```

This command adds `127.0.0.1 veragarc.42.fr` to your `/etc/hosts` file.

### 4. Build and Run
Execute the following command to build images and start the containers:
```Bash
make
```

### 5. Access
Open your browser and visit:👉 **https://www.google.com/search?q=https://veragarc.42.fr**

**Makefile Commands**

| Command | Description |
| :--- | :--- |
| `make` | Builds images and starts the infrastructure (detached mode). |
| `make up` | Builds the images without starting the containers. |
| `make down` | Stops and removes containers and networks. |
| `make clean` | Removes containers and Docker images. |
| `make fclean` | **Deep Clean**: Removes containers, images, and **persistent data volumes** (Database & WP files). |
| `make re` | Rebuilds everything from scratch (`fclean` + `make`). |
| `make host` | Configures the local domain in `/etc/hosts` (requires sudo). |
| `make up` | Start services. |

---

## 🏗️ Project Description
The infrastructure consists of three main services interacting via a dedicated Docker network.

### 1. NGINX (Entry Point)
- **Role:** Web Server & Reverse Proxy.

- **Ports:** Exposes only port 443 (HTTPS).

- **Security**: Uses TLS v1.2/v1.3 with self-signed certificates.

- **Configuration**: Proxies PHP requests to the WordPress container and serves static content.

### 2. WordPress + PHP-FPM
- **Role**: Content Management System (CMS).

- **Port**: 9000 (Internal access only).

- **Automation**: Installs and configures itself automatically using a custom shell script (creates admin user, installs theme, etc.).

- **Storag**: Shares the /var/www/html volume with NGINX.

### 3. MariaDB
- **Role**: Database Management System.

- **Port**: 3306 (Internal access only).

- **Initialization**: A script checks if the database exists; if not, it initializes the schema, creates the user/password securely, and secures the root account.

### 4. Core Concepts & Decisions

During the development, several architectural decisions were made based on Docker best practices:

* **Virtual Machines vs Docker**
    * **VM:** Virtualizes the hardware. Each VM runs a full Operating System kernel (Heavy, slow boot).
    * **Docker:** Virtualizes the OS. Containers share the host's Linux kernel but maintain isolated user spaces (Lightweight, instant boot). In this project, we run Docker *inside* a VM to simulate a production server environment.

* **Secrets vs Environment Variables**
    * **Env Vars:** Configuration settings stored in plain text or loaded from files.
    * **Secrets:** Secure storage for sensitive data. This ensures credentials are not hardcoded in the codebase, preventing security leaks if the code is pushed to a repository.

* **Docker Network vs Host Network**
    * **Host Network:** The container shares the IP and ports of the host machine (No isolation).
    * **Docker Network:** We use a **Custom Bridge Network**. This isolates the containers from the outside world. They can communicate internally using their container names as DNS hostnames (e.g., NGINX talks to `wordpress:9000`), but only the ports we explicitly expose (443) are accessible from the host.

* **Docker Volumes vs Bind Mounts**
    * **Docker Volumes:** Managed strictly by Docker (stored in `/var/lib/docker/volumes/`). Harder to access manually.
    * **Bind Mounts:** Map a specific file or directory on the host machine to the container. We use **Bind Mounts** (pointing to `/home/veragarc/data/`) to ensure data persistence. This allows us to easily inspect backups and ensures data survives even if Docker is completely reset.

### 5. File Structure

```text
Inception/
├── Makefile
├── README.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── ssl/
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

---

## 📚 Resources

Here is a list of the official documentation and tools used to build and understand this project:

### Official Documentation
* [Docker Engine Documentation](https://docs.docker.com/) - Core concepts of containers and images.
* [Docker Compose File V3 Reference](https://docs.docker.com/compose/compose-file/) - Syntax for `docker-compose.yml`.
* [NGINX Documentation](https://nginx.org/en/docs/) - Configuration directives and reverse proxy setup.
* [MariaDB Knowledge Base](https://mariadb.com/kb/en/documentation/) - SQL commands and server configuration.
* [WordPress.org](https://wordpress.org/support/) - CLI commands and installation requirements.

### Tools & References
* [Alpine Linux Wiki](https://wiki.alpinelinux.org/wiki/Main_Page) - Lightweight Linux distribution used for the containers.
* [OpenSSL](https://www.openssl.org/) - Used for generating self-signed TLS certificates.
* [GNU Make](https://www.gnu.org/software/make/manual/make.html) - Used for automating the build process.

---

## 🤖 IA (AI Usage)

This project was developed with the assistance of Generative AI tools acting as a technical mentor. The AI was used to understand complex errors and optimize configuration logic, while the implementation and verification were done by the student.

**Key areas where AI provided assistance:**

**1. Debugging "Race Conditions"**:

- Diagnosed Connection Refused errors between NGINX and WordPress.

- Solution: Implemented sleep timers and connection checks in entrypoint scripts to ensure services start in the correct order.

**2. Permission Management (Fixing 403/502 Errors)**:

- Helped identify the conflict between the installation user (root) and the execution user (www-data).

- Provided the logic for the chown -R www-data:www-data command within the WordPress start script to fix persistent permission issues.

**3. Script Idempotency**:

- Refined the MariaDB initialization script to prevent "Access Denied" errors on container restarts by adding checks to verify if the database directory already exists.

**4. Syntax Verification**:

- Assisted in detecting typo errors in configuration files (e.g., nginx.conf) that caused container crashes.

**5.  Documentation & Manuals:**
- Assisted in structuring and drafting the **README.md** file and project guides to ensure professional formatting, clear instructions, and correct Markdown syntax.
