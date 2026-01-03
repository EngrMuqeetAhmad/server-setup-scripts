#!/bin/bash
set -e


echo "===== NODE SETUP STARTED ====="
echo "[3/8]"



curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g pm2
