#!/bin/bash
set -e

echo "===== INSTALL & CONFIGURE pgAdmin4 (Standalone) ====="

# -------------------------------
# Ask user for NGINX domain or IP
# -------------------------------
read -p "Enter domain or IP for pgAdmin4 (e.g., example.com or 13.53.110.48): " DOMAIN

# -------------------------------
# Add pgAdmin repo
# -------------------------------
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add -
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

sudo apt update

# -------------------------------
# Install pgAdmin4 standalone
# -------------------------------
sudo apt install -y pgadmin4

# -------------------------------
# Create directories
# -------------------------------
sudo mkdir -p /var/lib/pgadmin /var/log/pgadmin /etc/pgadmin4
sudo chown -R $USER:$USER /var/lib/pgadmin /var/log/pgadmin

# -------------------------------
# Create config_local.py
# -------------------------------
sudo tee /etc/pgadmin4/config_local.py > /dev/null <<EOF
SERVER_MODE = True
DEFAULT_SERVER = '127.0.0.1'
LOG_FILE = '/var/log/pgadmin/pgadmin.log'
SQLITE_PATH = '/var/lib/pgadmin/pgadmin.db'
EOF

# -------------------------------
# Create systemd service
# -------------------------------
sudo tee /etc/systemd/system/pgadmin4.service > /dev/null <<EOF
[Unit]
Description=pgAdmin4 Standalone
After=network.target

[Service]
User=$USER
Environment=PGADMIN_SETUP_EMAIL=admin@example.com
Environment=PGADMIN_SETUP_PASSWORD=admin
ExecStart=/usr/pgadmin4/bin/pgAdmin4
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# -------------------------------
# Enable & start service
# -------------------------------
sudo systemctl daemon-reload
sudo systemctl enable pgadmin4
sudo systemctl start pgadmin4

echo "===== pgAdmin4 Standalone Installed and Running ====="
echo "pgAdmin4 service is listening on 127.0.0.1:5050"

# -------------------------------
# Configure NGINX reverse proxy
# -------------------------------
echo "===== CONFIGURING NGINX REVERSE PROXY FOR pgAdmin4 ====="

sudo tee /etc/nginx/sites-available/pgadmin <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location /pgadmin4/ {
        proxy_pass http://127.0.0.1:5050/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/pgadmin /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

echo "===== pgAdmin4 Setup Complete ====="
echo "Access pgAdmin4 at http://$DOMAIN/pgadmin4/"
