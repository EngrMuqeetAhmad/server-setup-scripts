#!/bin/bash

set -e

echo "===== SERVER update STARTED ====="
echo "[1/8]"



sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git build-essential
