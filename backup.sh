#!/bin/bash

echo "Starting Drupal backup..."

# Ensure containers are running
if ! docker ps | grep -q drupal_container; then
  echo "ERROR: Drupal container is not running. Start the containers first."
  exit 1
fi

if ! docker ps | grep -q postgres_container; then
  echo "ERROR: PostgreSQL container is not running. Start the containers first."
  exit 1
fi

# Install zip inside Drupal container if not installed
echo "Checking if zip is installed inside Drupal container..."
docker exec -it drupal_container bash -c "command -v zip >/dev/null 2>&1 || (apt update && apt install -y zip)"

# Backup Drupal files
echo "Backing up Drupal files..."
docker exec -it drupal_container bash -c "cd /var/www/html && zip -r /drupal_files.zip ."
docker cp drupal_container:/drupal_files.zip ~/Desktop/drupal_files.zip
docker exec -it drupal_container rm /drupal_files.zip

# Backup PostgreSQL database
echo "Backing up PostgreSQL database..."
docker exec -it postgres_container pg_dump -U drupal -d drupal_db > ~/Desktop/backup.sql

# Compress database backup
echo "Compressing database backup..."
zip -j ~/Desktop/backup.zip ~/Desktop/backup.sql
rm ~/Desktop/backup.sql

echo "Backup completed successfully!"
echo "Drupal files backup: ~/Desktop/drupal_files.zip"
echo "Database backup: ~/Desktop/backup.zip"

