#!/bin/bash
set -e

read -p "DB Name to enable pgvector: " DB_NAME

sudo -u postgres psql "$DB_NAME" <<EOF
CREATE EXTENSION IF NOT EXISTS vector;
EOF
