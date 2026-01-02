#!/bin/bash
set -e

# Ask user for domain
read -p "Enter your domain (e.g., example.com): " DOMAIN
read -p "Enter root frontend folder name: " FRONTEND_ROOT
# Path to your frontend build folder
FRONTEND_DIST="/var/www/$FRONTEND_ROOT/dist"

# Create NGINX config
sudo tee /etc/nginx/sites-available/app <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $FRONTEND_DIST;
    index index.html;

    # Serve React frontend
    location / {
        try_files \$uri /index.html;
    }

    location /pgadmin4/ {
        proxy_pass http://127.0.0.1:5050/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_redirect off;
    }

    # Proxy backend API
    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    # Optional: gzip compression
    gzip on;
    gzip_types text/plain application/javascript application/json text/css;
}
EOF

# Enable site
sudo ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/

# Test config & reload
sudo nginx -t
sudo systemctl reload nginx

echo "NGINX configured: frontend served from $FRONTEND_DIST, backend proxied at /api"
echo "Domain set to: $DOMAIN"
