#!/bin/bash

# Settings
CONTAINER_NAME="cogrigins-server"
SERVER_DIR="/home/minecraft/Server"
WORLD_NAME="Cogrigins"
BACKUP_DIR="$SERVER_DIR/backups"
DATE=$(date +%Y-%m-%d_%H-%M)

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

echo "--- Starting Backup Process ---"

# 1. Stop server via Docker
# Stop command gracefully shuts down Java and saves the world
echo "Stopping server: $CONTAINER_NAME..."
docker stop $CONTAINER_NAME

# 2. Create compressed archive
# While server is stopped, files are static and safe to copy
echo "Creating compressed archive (this may take a while)..."
tar -czf "$BACKUP_DIR/$WORLD_NAME-$DATE.tar.gz" -C "$SERVER_DIR" "$WORLD_NAME"

# 3. Start server back
echo "Starting server: $CONTAINER_NAME..."
docker start $CONTAINER_NAME

# 4. Remove backups older than 7 days
find "$BACKUP_DIR" -name "$WORLD_NAME-*.tar.gz" -type f -mtime +7 -delete

echo "DONE. Backup saved: $BACKUP_DIR/$WORLD_NAME-$DATE.tar.gz"
echo "--- Backup Finished ---"
