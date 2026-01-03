#!/bin/bash

set -e


echo "===== BUILD FRONTEND STARTED ====="
echo "[4/8]"



read -p "Enter frontend folder name in /var/www:" FRONTEND

FRONTEND_DIR="/var/www/$FRONTEND"

REAL_USER_HOME=$(eval echo "~$SUDO_USER")

ENV_SOURCE="$REAL_USER_HOME/server-setup-scripts/assets/frontend/.env"

HTACCESS_SOURCE="$REAL_USER_HOME/server-setup-scripts/assets/frontend/.htaccess"

if [ -f $ENV_SOURCE ]; then
  cp $ENV_SOURCE "$FRONTEND_DIR/.env"
fi 

cd "$FRONTEND_DIR"

npm install -f
npm run build

if [ -f $HTACCESS_SOURCE ]; then
  cp $HTACCESS_SOURCE "$FRONTEND_DIR/dist/.htaccess"
fi