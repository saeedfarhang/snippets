# MongoDB Backup and Restore Scripts

This repository contains two scripts for managing MongoDB backups and restores within a Docker container. These scripts allow you to:

1. Take a timestamped backup of a MongoDB database inside a Docker container.
2. Restore a MongoDB database from a backup into a Docker container.

## Prerequisites

- Docker installed and running on your system.
- A running MongoDB Docker container.

## Installation

To download the scripts to `/root/`, use the following commands:

```bash
# Download the backup script
curl -s https://raw.githubusercontent.com/saeedfarhang/snippets/main/mongo-backup/docker/dump.sh -o /root/dump.sh
chmod +x /root/dump.sh

# Download the restore script
curl -s https://raw.githubusercontent.com/saeedfarhang/snippets/main/mongo-backup/docker/restore.sh -o /root/restore.sh
chmod +x /root/restore.sh
```

## Usage

### Backup Script: `dump.sh`

This script creates a MongoDB dump inside the specified Docker container and copies it to your local machine.

#### Command

```bash
/root/dump.sh <mongo_container_name>
```

#### Example

```bash
/root/dump.sh my_mongo_container
```

#### Script Description

- Takes the MongoDB container name as an argument.
- Creates a timestamped directory inside `/home/dumps` in the container.
- Runs `mongodump` to export the database to the timestamped directory.
- Removes older backups in `/home/dumps` in the container, keeping only the most recent one.
- Copies the latest dump to a specified local directory (`/path/to/local/mongo_backups`).

### Restore Script: `restore.sh`

This script restores a MongoDB database from a dump into the specified Docker container.

#### Command

```bash
/root/restore.sh <dump_directory> <mongo_container_name>
```

#### Example

```bash
/root/restore.sh /path/to/local/dump my_mongo_container
```

#### Script Description

- Takes the local dump directory and MongoDB container name as arguments.
- Copies the dump directory into the specified Docker container.
- Runs `mongorestore` with the `--drop` option to replace the existing database data.
- Removes the copied dump directory from the container after the restore is complete.

## Updating the Scripts

To update the scripts from GitHub, run the following commands:

```bash
# Update the backup script
curl -s https://raw.githubusercontent.com/saeedfarhang/snippets/main/mongo-backup/docker/dump.sh -o /root/dump.sh
chmod +x /root/dump.sh

# Update the restore script
curl -s https://raw.githubusercontent.com/saeedfarhang/snippets/main/mongo-backup/docker/restore.sh -o /root/restore.sh
chmod +x /root/restore.sh
```

Run these commands periodically to ensure you have the latest version of each script.

## Important Notes

- **Local Backup Directory**: Adjust the local backup directory in `dump.sh` as needed (currently set to `/path/to/local/mongo_backups`).
- **Permissions**: Ensure appropriate permissions are set for `/root/` or any other directory used to store the scripts.
- **Docker Access**: Ensure Docker has access to `/root/` if necessary for running commands.
