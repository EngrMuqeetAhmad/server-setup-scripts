#!/bin/bash
set -e

# -------------------------------
# Ask user for input
# -------------------------------
read -p "Enter your domain or IP (e.g., example.com or 13.49.158.190): " DOMAIN
read -p "Enter root frontend folder name (e.g., patient-agent-frontend): " FRONTEND_ROOT

FRONTEND_DIST="/var/www/$FRONTEND_ROOT/dist"

# Check if frontend folder exists
if [ ! -d "$FRONTEND_DIST" ]; then
    echo "Error: Frontend folder $FRONTEND_DIST does not exist!"
    exit 1
fi

# -------------------------------
# Create NGINX config (quoted here-doc to prevent Bash expanding $)
# -------------------------------
echo "Creating NGINX site configuration..."

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

    # pgAdmin reverse proxy
    location /pgadmin4/ {
        proxy_pass http://127.0.0.1:5050/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }

    # Backend API reverse proxy
    location /api {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    # Optional gzip compression
    gzip on;
    gzip_types text/plain application/javascript application/json text/css;
}
EOF


# -------------------------------
# Enable site & reload NGINX
# -------------------------------
echo "Enabling NGINX site..."
sudo ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/

echo "Testing NGINX configuration..."
sudo nginx -t

echo "Reloading NGINX..."
sudo systemctl reload nginx

echo "------------------------------------------"
echo "NGINX configured successfully!"
echo "Frontend served from: $FRONTEND_DIST"
echo "Domain/IP: $DOMAIN"
echo "Backend API proxied at /api"
echo "pgAdmin accessible at /pgadmin4"
echo "------------------------------------------"
