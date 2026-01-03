#!/bin/bash

set -e



echo "===== CLONE REPOS STARTED ====="
echo "[2/8]"



read -p "Enter frontend git repo URL:" FRONTEND_GIT
read -p "Enter backendend git repo URL:" BACKEND_GIT


sudo mkdir -p /var/www

sudo chown -R $USER:$USER /var/www


clone_repo () {
    GIT_URL=$1
    REPO_NAME=$(basename -s .git "$GIT_URL")
    TARGET="/var/www/$REPO_NAME"

    if [ ! -d "$TARGET"]: then
      git clone "$GIT_URL" "$TARGET"
    else
      cd "$TARGET"
      git pull
    fi
}

clone_repo "$FRONTEND_GIT"
clone_repo "$BACKEND_GIT"