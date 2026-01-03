#!/bin/bash

set -e


echo "===== INSTALL Postgresql STARTED ====="
echo "[6/8]"



sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql