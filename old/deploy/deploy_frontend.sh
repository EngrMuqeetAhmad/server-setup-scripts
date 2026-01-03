#!/bin/bash
set -e

# -------------------------------
# Input: frontend Git repo URL
# -------------------------------
read -p "Enter frontend Git repository URL: " GIT_URL

# Extract repo name
REPO_NAME=$(basename -s .git "$GIT_URL")
DEPLOY_DIR="/var/www/$REPO_NAME"

# -------------------------------
# Clone or pull repository
# -------------------------------
if [ ! -d "$DEPLOY_DIR" ]; then
    echo "Folder $DEPLOY_DIR does not exist. Cloning repo..."
    git clone "$GIT_URL" "$DEPLOY_DIR" || { echo "Git clone failed"; exit 1; }
else
    echo "Folder exists. Pulling latest changes..."
    cd "$DEPLOY_DIR"
    git pull --no-rebase || { echo "Git pull failed"; exit 1; }
fi

cd "$DEPLOY_DIR"

# -------------------------------
# Copy .env file
# -------------------------------

REAL_USER_HOME=$(eval echo "~$SUDO_USER")
ENV_SOURCE="$REAL_USER_HOME/server-setup-scripts/assets/frontend/.env"
HT_ACCESS_SOURCE="$REAL_USER_HOME/server-setup-scripts/assets/frontend/.htaccess"

if [ -f "$ENV_SOURCE" ]; then
    echo "Copying .env file from $ENV_SOURCE to $DEPLOY_DIR"
    sudo cp "$ENV_SOURCE" "$DEPLOY_DIR/.env"
else
    echo "Warning: .env file not found at $ENV_SOURCE. Make sure environment variables are set!"
fi

if [ -f "$HT_ACCESS_SOURCE" ]; then
    echo "Copying .htaccess file from $HT_ACCESS_SOURCE to $DEPLOY_DIR"
    sudo cp "$HT_ACCESS_SOURCE" "$DEPLOY_DIR/.htaccess"
else
    echo "Warning: .htaccess file not found at $HT_ACCESS_SOURCE."
fi

# -------------------------------
# Install dependencies and build
# -------------------------------
echo "Installing dependencies and building frontend..."
npm install -f
npm run build

# -------------------------------
# Reload NGINX
# -------------------------------
echo "Reloading NGINX..."
sudo systemctl restart nginx

echo "Frontend deployed successfully in $DEPLOY_DIR"
