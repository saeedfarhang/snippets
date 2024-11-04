#!/bin/bash

# Check if container name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <mongo_container_name>"
  exit 1
fi

# Set variables
CONTAINER_NAME=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DUMP_DIR="/home/dumps"
TARGET_DIR="${DUMP_DIR}/${TIMESTAMP}"
LOCAL_DIR="/path/to/local/mongo_backups"

# Step 1: Create a timestamped directory in /home/dumps
docker exec "$CONTAINER_NAME" mkdir -p "$TARGET_DIR"

# Step 2: Run mongodump inside the Docker container and capture the logs
echo "Starting mongodump in container $CONTAINER_NAME..."
docker exec "$CONTAINER_NAME" mongodump --uri="mongodb://localhost:27017/docmed" --out="$TARGET_DIR" 2>&1 | tee /tmp/mongodump_log.txt

# Display the log output in the bash terminal
cat /tmp/mongodump_log.txt

# Step 3: Remove all dumps except the most recent one
docker exec "$CONTAINER_NAME" bash -c "cd $DUMP_DIR && ls -dt */ | tail -n +2 | xargs -I {} rm -rf {}"

# Step 4: Copy the latest dump directory to the local machine
docker cp "$CONTAINER_NAME:$TARGET_DIR" "$LOCAL_DIR"

# Notify user
echo "MongoDB dump from $CONTAINER_NAME created and moved to $LOCAL_DIR"
