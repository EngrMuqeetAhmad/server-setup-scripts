#!/bin/bash
set -e

sudo apt install -y postgresql-$(psql -V | awk '{print $3}' | cut -d. -f1)-pgvector
