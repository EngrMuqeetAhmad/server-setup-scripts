#!/bin/bash
set -e

# -------------------------------
# Input: backend Git repo URL
# -------------------------------
read -p "Enter backend Git repository URL: " GIT_URL

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
ENV_SOURCE="$REAL_USER_HOME/server-setup-scripts/assets/backend/.env"


if [ -f "$ENV_SOURCE" ]; then
    echo "Copying .env file from $ENV_SOURCE to $DEPLOY_DIR"
    sudo cp "$ENV_SOURCE" "$DEPLOY_DIR/.env"
else
    echo "Warning: .env file not found at $ENV_SOURCE. Make sure environment variables are set!"
fi

# -------------------------------
# Install dependencies and build
# -------------------------------
echo "Installing dependencies and building..."
npm install -f
npm run build

# -------------------------------
# PM2: Remove existing backend service
# -------------------------------
if pm2 list | grep -q 'backend'; then
    echo "Stopping existing PM2 process named 'backend'..."
    pm2 stop backend || true
    pm2 delete backend || true
fi

# -------------------------------
# PM2: Start new process
# -------------------------------
echo "Starting backend with PM2..."
pm2 start dist/main.js --name backend -f
pm2 save

echo "Backend deployed successfully in $DEPLOY_DIR"
