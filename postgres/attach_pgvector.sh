#!/bin/bash
set -e

read -p "Enter DB name: " DB_NAME

sudo -u postgres psql -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS vector;"
