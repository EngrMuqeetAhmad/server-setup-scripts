#!/bin/bash
set -e

read -p "Enter pgAdmin email: " PGADMIN_EMAIL
read -s -p "Enter pgAdmin password: " PGADMIN_PASSWORD
echo

sudo mkdir -p /var/lib/pgadmin
sudo mkdir -p /var/log/pgadmin

sudo chown -R $USER:$USER /var/lib/pgadmin /var/log/pgadmin

# Create pgAdmin config
sudo tee /etc/pgadmin4/config_local.py <<EOF
SERVER_MODE = True
DEFAULT_SERVER = '0.0.0.0'
LOG_FILE = '/var/log/pgadmin/pgadmin.log'
SQLITE_PATH = '/var/lib/pgadmin/pgadmin.db'
EOF

# Setup pgAdmin user
export PGADMIN_SETUP_EMAIL=$PGADMIN_EMAIL
export PGADMIN_SETUP_PASSWORD=$PGADMIN_PASSWORD

python3 /usr/lib/pgadmin4/web/setup.py

echo "pgAdmin configured successfully."
