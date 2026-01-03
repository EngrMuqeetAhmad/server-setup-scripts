#!/bin/bash
set -e

echo "Creating pgAdmin systemd service..."

sudo tee /etc/systemd/system/pgadmin4.service <<EOF
[Unit]
Description=pgAdmin4
After=network.target

[Service]
User=$USER
Group=$USER
WorkingDirectory=/usr/lib/pgadmin4/web
Environment="PGADMIN_CONFIG_FILE=/etc/pgadmin4/config_local.py"
ExecStart=/usr/bin/python3 /usr/lib/pgadmin4/web/pgAdmin4.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable pgadmin4
sudo systemctl start pgadmin4

echo "pgAdmin4 is running on localhost:5050"
