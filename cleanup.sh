#!/bin/bash

echo "Cleaning up the Drupal project..."

# Define backup location
BACKUP_DIR=~/Desktop/backups

# Stop and remove Docker containers
echo "Stopping and removing containers..."
docker stop drupal_container postgres_container
docker rm drupal_container postgres_container

# Remove Docker network
echo "Removing Docker network..."
docker network rm drupal_network 2>/dev/null || echo "Network already removed."

# Remove configuration files, but KEEP backups
echo "Removing configuration files..."
rm -f ~/Desktop/postgresql.conf
rm -f ~/Desktop/settings.php

# Keep backups safe
echo "Backups are stored safely in: $BACKUP_DIR"
echo "Skipping backup file deletion."

# Remove any leftover Docker volumes
echo "Removing unused Docker volumes..."
docker volume prune -f

# Remove Drupal and PostgreSQL images (optional)
read -p "Do you want to remove the Docker images for Drupal and PostgreSQL? (y/n): " REMOVE_IMAGES
if [ "$REMOVE_IMAGES" == "y" ]; then
  docker rmi drupal:latest postgres:latest
fi

echo "Cleanup completed! The environment is now back to its original state."

