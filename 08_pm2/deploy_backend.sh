#!/bin/bash

set -e

echo "===== DEPLOY STARTED ====="
echo "[8/8]"

read -p "Backend folder name at /var/www:" BACKEND

cd "/var/www/$BACKEND"

pm2 stop backend || true
pm2 delete backend || true

pm2 start dist/main.js --name backend
pm2 save
