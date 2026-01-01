#!/bin/bash
set -e

cd /var/www/frontend

npm install -f
npm run build

sudo systemctl restart nginx
