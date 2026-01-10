# 📘 User Documentation

This guide provides instructions for end users and system administrators to manage the Inception infrastructure.

## 1. Services Overview
The stack provides a complete web infrastructure composed of three main services:

* **Website (WordPress):** A Content Management System (CMS) to build and manage the website.
* **Web Server (NGINX):** The entry point that handles secure connections (HTTPS) and serves the site.
* **Database (MariaDB):** Stores all the website data (users, posts, configurations).

## 2. Starting and Stopping the Project

The project is managed via a `Makefile` at the root of the directory.

* **To START the services:**
    Open a terminal in the project root and run:
    ```bash
    make
    ```
    *The system will build the images (if necessary) and start the containers in the background.*

* **To STOP the services:**
    Run:
    ```bash
    make down
    ```

* **To REMOVE everything (Stop + Delete Containers):**
    Run:
    ```bash
    make fclean
    ```

## 3. Accessing the Website

Once the project is running:

1.  Open your web browser.
2.  Navigate to: **`https://veragarc.42.fr`**
3.  **Security Warning:** Since we use self-signed certificates for development, your browser will warn you that the connection is not private. You must accept the risk/proceed to access the site.

### Accessing the Administration Panel
To manage the WordPress content:
1.  Navigate to: **`https://veragarc.42.fr/wp-admin`**
2.  Log in using the **WordPress Admin** credentials (see Section 4).

## 4. Credentials Management

Usernames are not hardcoded in the scripts. They are stored safely in a hidden file named `.env` inside the `srcs/` folder.

To view or change credentials, edit the `.env` file:

| Variable in `.env` | Purpose |
| :--- | :--- |
| `WP_ADMIN_USER` | Username for the WordPress Admin Panel. |
| `WP_ADMIN_PASS` | Password for the WordPress Admin Panel. |
| `SQL_USER` | Internal Database username. |

## 5. Checking Service Status

To verify that the infrastructure is running correctly, use the following command in your terminal:

```bash
docker ps
```

**Expected Result**: You should see three containers (`nginx´, `wordpress´, `mariadb´) with the status Up.

To view the live logs of a specific service (e.g., NGINX), run:

```bash
docker logs -f nginx
```