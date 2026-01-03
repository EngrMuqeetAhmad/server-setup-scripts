#!/bin/bash

set -e


echo "===== INSTALL NGINX STARTED ====="
echo "[5/8]"



sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
