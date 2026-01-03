#!/bin/bash
set -e

echo "===== INSTALLING pgWeb ====="

# Ask user for PostgreSQL credentials
read -p "Enter PostgreSQL host (default: localhost): " PG_HOST
PG_HOST=${PG_HOST:-localhost}

read -p "Enter PostgreSQL port (default: 5432): " PG_PORT
PG_PORT=${PG_PORT:-5432}

read -p "Enter PostgreSQL username: " PG_USER
read -s -p "Enter PostgreSQL password: " PG_PASS
echo

read -p "Enter default database name: " PG_DB

# Download latest pgweb binary
TMP_DIR=$(mktemp -d)
PGWEB_URL="https://github.com/sosedoff/pgweb/releases/latest/download/pgweb_linux_amd64.tar.gz"

echo "Downloading pgweb..."
wget -O "$TMP_DIR/pgweb.tar.gz" --quiet --show-progress --max-redirect=10 "$PGWEB_URL"

if [ ! -f "$TMP_DIR/pgweb.tar.gz" ]; then
    echo "Error: pgweb download failed!"
    exit 1
fi

echo "Extracting pgweb..."
tar -xzf "$TMP_DIR/pgweb.tar.gz" -C "$TMP_DIR" || { echo "Extraction failed"; exit 1; }

sudo mv "$TMP_DIR/pgweb" /usr/local/bin/pgweb
sudo chmod +x /usr/local/bin/pgweb
rm -rf "$TMP_DIR"

echo "pgWeb installed at /usr/local/bin/pgweb"

# -------------------------------
# Setup systemd service
# -------------------------------
SERVICE_FILE="/etc/systemd/system/pgweb.service"

sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=pgWeb PostgreSQL Web Interface
After=network.target

[Service]
Type=simple
User=$USER
Environment=PGWEB_DB_URL="postgres://$PG_USER:$PG_PASS@$PG_HOST:$PG_PORT/$PG_DB?sslmode=disable"
ExecStart=/usr/local/bin/pgweb --bind=127.0.0.1 --listen=5050 --url \$PGWEB_DB_URL
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start service
sudo systemctl daemon-reload
sudo systemctl enable --now pgweb

echo "pgWeb service started on port 5050"
echo "Access it locally: http://127.0.0.1:5050"
