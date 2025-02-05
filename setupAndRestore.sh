#!/bin/bash

echo "Setting up Docker infrastructure for Drupal..."

# Find the local machine's IP
LOCAL_IP=$(ip route get 8.8.8.8 | awk '{print $7; exit}')
echo "Detected local IP: $LOCAL_IP"

# Create an internal Docker network
docker network create drupal_network 2>/dev/null || echo "Network already exists"

# Start PostgreSQL container
echo "Starting PostgreSQL container..."
docker run -d --name postgres_container --network=drupal_network \
  -e POSTGRES_DB=drupal_db \
  -e POSTGRES_USER=drupal \
  -e POSTGRES_PASSWORD=my-secret-pw \
  -p 5432:5432 postgres:latest

# Start Drupal container
echo "Starting Drupal container..."
docker run -d --name drupal_container --network=drupal_network \
  -p 8080:80 drupal:latest

# Wait for the containers to be ready
sleep 10

# Restore Drupal files
if [ -f ~/Desktop/drupal_files.zip ]; then
  echo "Restoring Drupal files..."
  docker cp ~/Desktop/drupal_files.zip drupal_container:/drupal_files.zip
  docker exec -it drupal_container bash -c "apt update && apt install -y unzip && cd /var/www/html && unzip /drupal_files.zip && chown -R www-data:www-data /var/www/html"
else
  echo "ERROR: Drupal files backup not found at ~/Desktop/drupal_files.zip!"
  exit 1
fi


# Ensure database backup archive exists before extracting
if [ -f ~/Desktop/backup.zip ]; then
  echo "Extracting database backup..."
  unzip -o ~/Desktop/backup.zip -d ~/Desktop/
else
  echo "ERROR: Database backup archive (backup.zip) is missing!"
  exit 1
fi

# Restore Database
if [ -f ~/Desktop/backup.sql ]; then
  echo "Restoring database..."
  docker cp ~/Desktop/backup.sql postgres_container:/backup.sql
  docker exec -it postgres_container psql -U drupal -d drupal_db -f /backup.sql
else
  echo "ERROR: Database backup (backup.sql) is missing! Cannot restore database."
  exit 1
fi

# Fix `settings.php`
echo "Updating Drupal settings.php..."
docker exec -it drupal_container bash -c "if [ -f /var/www/html/sites/default/settings.php ]; then sed -i \"s/'host' => '[^']*'/'host' => '$LOCAL_IP'/g\" /var/www/html/sites/default/settings.php; else echo 'WARNING: settings.php not found!'; fi"

# Restart containers to apply changes
echo "Restarting containers..."
docker restart drupal_container postgres_container

echo "✅ Setup completed successfully!"
echo "You can now access your Drupal site at: http://localhost:8080/"

