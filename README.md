# Database Backup Script 

This project focuses on automating the backup retrieval process from a remote server and replicating it onto a local system. 

## Files Included

1. **`.env`**

   - This file contains configuration variables used by the project, such as database credentials and environment-specific settings.

2. **`backup-script.sh`**

   - This script performs backups of a remote database and imports it into a local Dockerized PostgreSQL instance and we can also use this script to backup for many databases like MySQL, Postgres, Mongodb, Casandra etc.

3. **`docker-compose.yml`**

   - This file defines the Docker services required for the project, including setting up a PostgreSQL database and integrating with environment variables from `.env`.

## Setup Instructions

Follow these steps to set up and run the project:

### 1. Clone the repository

```bash
git clone https://github.com/PANKAJ172/database-backup-script.git
cd database-backup-script
```

### 2. Create `.env` file
Copy the provided .env.example file to create your own .env file and populate it with your configuration. This file will hold environment-specific variables required for the project. Here's how to do it:

```bash
cp .env.example .env
```

Open the .env file and configure the variables as needed. Here's an example:

```bash
# .env
LOCAL_DB_USER=postgres
LOCAL_DB_PASSWORD=mysecretpassword
LOCAL_DB_NAME=postgresdb
```
Replace LOCAL_DB_USER, LOCAL_DB_PASSWORD, and LOCAL_DB_NAME with your actual database credentials.
### 3. Run the backup script
Execute the backup script to perform a backup of the remote database and import it into your local PostgreSQL instance.
```bash
sh ./backup-script.sh
```

### 4.  Access your database
After the services are up and running, access your database using below command : 
```bash
psql -h localhost -p 5431 -U postgres -d dbname
```

## Install Postgres (If not installed on local system)
### 1. Update System Packages
```bash
sudo apt update
```

### 2. Install PostgreSQL
```bash
sudo apt install postgresql-14
systemctl status postgresql
```
