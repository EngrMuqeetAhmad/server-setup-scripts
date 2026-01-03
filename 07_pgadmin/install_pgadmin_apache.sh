#!/bin/bash
set -e

echo "===== INSTALL pgadmin STARTED ====="
echo "[7/8]"

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add -
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

sudo apt update
sudo apt install -y pgadmin4
sudo /usr/pgadmin4/bin/setup-web.sh
