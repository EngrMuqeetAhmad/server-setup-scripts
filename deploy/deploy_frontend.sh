#!/bin/bash
set -e

read -p "Enter frontend Git repository URL: " GIT_URL

REPO_NAME=$(basename -s .git $GIT_URL)

DEPLOY_DIR="/var/www/$REPO_NAME"

if [ ! -d "$DEPLOY_DIR" ]; then
    echo "Folder $DEPLOY_DIR does not exist. Cloning repo..."
    git clone "$GIT_URL" "$DEPLOY_DIR" || { echo "Git clone failed"; exit 1; }
else
    echo "Folder exists. Pulling latest changes..."
    cd "$DEPLOY_DIR"
    git pull --no-rebase || { echo "Git pull failed"; exit 1; }
fi

cd "$DEPLOY_DIR"

npm install -f
npm run build

sudo systemctl restart nginx

echo "Frontend deployed successfully in $DEPLOY_DIR"
