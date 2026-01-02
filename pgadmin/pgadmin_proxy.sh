#!/bin/bash
set -e

read -p "Enter domain or subdomain for pgAdmin (e.g. pgadmin.example.com): " DOMAIN

sudo tee /etc/nginx/sites-available/pgadmin <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://127.0.0.1:5050;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/pgadmin /etc/nginx/sites-enabled/

sudo nginx -t
sudo systemctl reload nginx

echo "pgAdmin accessible at http://$DOMAIN"
