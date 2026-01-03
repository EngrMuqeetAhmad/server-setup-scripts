#!/bin/bash
set -e

echo "====================================="
echo " Starting Full Server Setup Workflow "
echo "====================================="

# -------------------------------
# System & Base Dependencies
# -------------------------------
echo ""
echo ">>> [1/6] Updating system and installing base dependencies..."
./common/update_system.sh
./common/install_dependencies.sh

# -------------------------------
# Node.js (Latest) + PM2
# -------------------------------
echo ""
echo ">>> [2/6] Installing Node.js (latest) and PM2..."
./node/install_node.sh

# -------------------------------
# NGINX + Frontend Reverse Proxy
# -------------------------------
echo ""
echo ">>> [3/6] Installing and configuring NGINX..."
./nginx/install_nginx.sh
./nginx/configure_nginx.sh
./nginx/reverse_proxy.sh

# -------------------------------
# PostgreSQL + DB + pgvector
# -------------------------------
echo ""
echo ">>> [4/6] Installing PostgreSQL, setting up database, and enabling pgvector..."
./postgres/install_postgres.sh
./postgres/setup_db.sh
./postgres/install_pgvector.sh
./postgres/attach_pgvector.sh

# -------------------------------
# pgAdmin4 (Standalone + NGINX)
# -------------------------------
echo ""
echo ">>> [5/6] Installing and configuring pgAdmin4 (standalone, via NGINX)..."
./pgadmin/install_pgadmin4.sh
./pgadmin/configure_pgadmin4.sh
./pgadmin/run_pgadmin4.sh
# ./pgadmin/pgadmin_proxy.sh

# -------------------------------
# Deployment (optional)
# -------------------------------
# echo ""
# echo ">>> [6/6] Deployment scripts are currently disabled (optional step)"
# ./deploy/deploy_backend.sh
# ./deploy/deploy_frontend.sh

echo ""
echo "====================================="
echo " Server Setup Completed Successfully "
echo "====================================="
