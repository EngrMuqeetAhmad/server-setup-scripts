#!/bin/bash

set -e


echo "===== BUILD BACKEND STARTED ====="
echo "[4/8]"



read -p "Enter backend folder name in /var/www:" BACKEND

BACKEND_DIR="/var/www/$BACKEND"

REAL_USER_HOME=$(eval echo "~$SUDO_USER")

ENV_SOURCE="$REAL_USER_HOME/server-setup-scripts/assets/backend/.env"


if [ -f $ENV_SOURCE ]; then
  cp $ENV_SOURCE "$BACKEND_DIR/.env"
fi

cd "$BACKEND_DIR"

npm install -f
npm run build
