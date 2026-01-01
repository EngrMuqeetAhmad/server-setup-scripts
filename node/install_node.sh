#!/bin/bash
set -e

# Fetch the latest Node.js LTS setup script from NodeSource
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -

# Install Node.js
sudo apt install -y nodejs

# Install PM2 globally
sudo npm install -g pm2

# Verify installation
echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"
echo "PM2 version: $(pm2 -v)"
