#!/bin/bash

# Check if both arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <dump_directory> <mongo_container_name>"
  exit 1
fi

# Set variables
DUMP_DIRECTORY=$1
CONTAINER_NAME=$2
CONTAINER_DUMP_PATH="/home/docmed"

# Step 1: Copy the dump directory to the container
echo "Copying dump directory to the container..."
docker cp "$DUMP_DIRECTORY" "$CONTAINER_NAME:$CONTAINER_DUMP_PATH"

# Step 2: Run mongorestore inside the Docker container
echo "Running mongorestore in container $CONTAINER_NAME..."
docker exec "$CONTAINER_NAME" mongorestore --uri="mongodb://localhost:27017/docmed" --drop "$CONTAINER_DUMP_PATH"

# Step 3: Clean up the dump files from the container
echo "Cleaning up the dump files from the container..."
docker exec "$CONTAINER_NAME" rm -rf "$CONTAINER_DUMP_PATH"

# Notify user
echo "MongoDB restore from $DUMP_DIRECTORY completed in container $CONTAINER_NAME."
