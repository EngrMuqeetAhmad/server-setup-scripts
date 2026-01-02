#!/bin/bash
set -e
set -o pipefail

read -p "Enter pgAdmin email: " PGADMIN_EMAIL
read -s -p "Enter pgAdmin password: " PGADMIN_PASSWORD
echo

echo "Creating required directories..."

# Create required directories FIRST
sudo mkdir -p /etc/pgadmin4
sudo mkdir -p /var/lib/pgadmin
sudo mkdir -p /var/log/pgadmin

# Set ownership
sudo chown -R $USER:$USER /var/lib/pgadmin /var/log/pgadmin
sudo chmod 755 /var/lib/pgadmin /var/log/pgadmin

echo "Writing pgAdmin configuration..."

# Create config file safely
sudo tee /etc/pgadmin4/config_local.py > /dev/null <<EOF
SERVER_MODE = True
DEFAULT_SERVER = '0.0.0.0'
LOG_FILE = '/var/log/pgadmin/pgadmin.log'
SQLITE_PATH = '/var/lib/pgadmin/pgadmin.db'
EOF

echo "Initializing pgAdmin..."

# Setup pgAdmin admin user
export PGADMIN_SETUP_EMAIL="$PGADMIN_EMAIL"
export PGADMIN_SETUP_PASSWORD="$PGADMIN_PASSWORD"

sudo -E python3 /usr/lib/pgadmin4/web/setup.py

echo "pgAdmin configured successfully."
