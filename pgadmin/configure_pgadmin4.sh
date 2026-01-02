#!/bin/bash
set -e
set -o pipefail

read -p "Enter pgAdmin email: " PGADMIN_EMAIL
read -s -p "Enter pgAdmin password: " PGADMIN_PASSWORD
echo

echo "Creating required directories..."

# Required directories
sudo mkdir -p /etc/pgadmin4
sudo mkdir -p /var/lib/pgadmin
sudo mkdir -p /var/log/pgadmin

sudo chown -R $USER:$USER /var/lib/pgadmin /var/log/pgadmin
sudo chmod 755 /var/lib/pgadmin /var/log/pgadmin

echo "Writing pgAdmin configuration..."

sudo tee /etc/pgadmin4/config_local.py > /dev/null <<EOF
SERVER_MODE = True
DEFAULT_SERVER = '127.0.0.1'
LOG_FILE = '/var/log/pgadmin/pgadmin.log'
SQLITE_PATH = '/var/lib/pgadmin/pgadmin.db'
EOF

echo "Initializing pgAdmin (official setup)..."

# Use official pgAdmin setup script (modern versions)
sudo PGADMIN_SETUP_EMAIL="$PGADMIN_EMAIL" \
     PGADMIN_SETUP_PASSWORD="$PGADMIN_PASSWORD" \
     /usr/pgadmin4/bin/setup-web.sh --yes

echo "pgAdmin configured successfully."
