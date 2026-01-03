#!/bin/bash
set -e

echo "Installing pgAdmin4 (standalone, no Apache)..."

# Add pgAdmin repository
curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/pgadmin-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/pgadmin-keyring.gpg] \
https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" \
| sudo tee /etc/apt/sources.list.d/pgadmin4.list

# Install pgAdmin in server mode only
sudo apt update
sudo apt install -y pgadmin4

echo "pgAdmin4 installed (no Apache)."
