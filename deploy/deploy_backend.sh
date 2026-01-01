#!/bin/bash
set -e

cd /var/www/backend

npm install -f
npm run build

pm2 start dist/main.js --name backend
pm2 save
