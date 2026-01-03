#!/bin/bash
set -e

read -p "DB Name: " DB_NAME
read -p "DB User: " DB_USER
read -s -p "DB Password: " DB_PASS
echo

sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASS';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOF
