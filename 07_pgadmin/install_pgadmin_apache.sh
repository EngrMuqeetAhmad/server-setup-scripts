#!/bin/bash
set -e

echo "===== INSTALLING pgWeb ====="

# -------------------------------
# Ask user for PostgreSQL credentials
# -------------------------------
read -p "Enter PostgreSQL host (default: localhost): " PG_HOST
PG_HOST=${PG_HOST:-localhost}

read -p "Enter PostgreSQL port (default: 5432): " PG_PORT
PG_PORT=${PG_PORT:-5432}

read -p "Enter PostgreSQL username: " PG_USER
read -s -p "Enter PostgreSQL password: " PG_PASS
echo

read -p "Enter default database name: " PG_DB

# -------------------------------
# Install dependencies
# -------------------------------
sudo apt update
sudo apt install -y wget unzip

# -------------------------------
# Download pgWeb (AMD64)
# -------------------------------
TMP_DIR=$(mktemp -d)
PGWEB_URL="https://github.com/sosedoff/pgweb/releases/download/v0.17.0/pgweb_linux_amd64.zip"

echo "Downloading pgWeb..."
wget -q --show-progress -O "$TMP_DIR/pgweb.zip" "$PGWEB_URL"

echo "Extracting pgWeb..."
unzip -q "$TMP_DIR/pgweb.zip" -d "$TMP_DIR"

sudo mv "$TMP_DIR/pgweb" /usr/local/bin/pgweb
sudo chmod +x /usr/local/bin/pgweb
rm -rf "$TMP_DIR"

echo "pgWeb installed successfully"

# -------------------------------
# Create system user
# -------------------------------
if ! id pgweb &>/dev/null; then
    sudo useradd --system --no-create-home --shell /usr/sbin/nologin pgweb
fi

# -------------------------------
# Create config directory
# -------------------------------
sudo mkdir -p /etc/pgweb
sudo chmod 700 /etc/pgweb

DB_URL="postgres://${PG_USER}:${PG_PASS}@${PG_HOST}:${PG_PORT}/${PG_DB}?sslmode=disable"

sudo tee /etc/pgweb/pgweb.env > /dev/null <<EOF
DATABASE_URL=$DB_URL
EOF

sudo chmod 600 /etc/pgweb/pgweb.env
sudo chown pgweb:pgweb /etc/pgweb/pgweb.env

# -------------------------------
# Create systemd service
# -------------------------------
sudo tee /etc/systemd/system/pgweb.service > /dev/null <<EOF
[Unit]
Description=pgWeb PostgreSQL Web UI
After=network.target

[Service]
User=pgweb
Group=pgweb
EnvironmentFile=/etc/pgweb/pgweb.env
ExecStart=/usr/local/bin/pgweb \\
  --bind=127.0.0.1 \\
  --listen=5050 \\
  --url=\$DATABASE_URL
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# -------------------------------
# Start service
# -------------------------------
sudo systemctl daemon-reload
sudo systemctl enable --now pgweb

echo "=================================="
echo "pgWeb installed & running"
echo "Listening on: http://127.0.0.1:5050"
echo "Ready for NGINX reverse proxy"
echo "=================================="
