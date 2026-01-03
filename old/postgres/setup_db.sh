#!/bin/bash
set -e

read -p "Enter DB name: " DB_NAME
read -p "Enter DB user: " DB_USER
read -sp "Enter DB password: " DB_PASS

sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOF
