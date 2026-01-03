#!/bin/bash
set -e

echo "===== NGINX CONFIGURE STARTED ====="
echo "[5/8]"

sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t

read -p "Enter domain or IP: " DOMAIN
read -p "Frontend folder name: " FRONTEND
read -p "Backend port (default 3000): " BACKEND_PORT
BACKEND_PORT=${BACKEND_PORT:-3000}

sudo tee /etc/nginx/sites-available/app <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root /var/www/$FRONTEND/dist;
    index index.html;

    location /pgweb/ {
        proxy_pass http://127.0.0.1:5050/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }

    location / {
        try_files \$uri /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:$BACKEND_PORT/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

echo "NGINX configured: frontend at /, backend at /api/"
