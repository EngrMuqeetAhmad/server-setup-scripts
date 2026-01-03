#!/bin/bash
set -e

sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
