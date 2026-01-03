#!/bin/bash
set -e

echo "===== SERVER SETUP STARTED ====="


./01_system/update_system.sh
./02_git/clone_repos.sh
./03_node/install_node.sh
./04_build/build_frontend.sh
./04_build/build_backend.sh
./05_nginx/install_nginx.sh
./05_nginx/configure_nginx.sh
./06_postgres/install_postgres.sh
./06_postgres/setup_db.sh
./06_postgres/install_pgvector.sh
./06_postgres/attach_pgvector.sh
./07_pgadmin/install_pgadmin_apache.sh
./08_pm2/deploy_backend.sh

echo "===== SERVER SETUP COMPLETED ====="
