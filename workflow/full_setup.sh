#!/bin/bash
set -e

./common/update_system.sh
./common/install_dependencies.sh

./node/install_node.sh

./nginx/install_nginx.sh
./nginx/configure_nginx.sh
./nginx/reverse_proxy.sh

./postgres/install_postgres.sh
./postgres/setup_db.sh
./postgres/install_pgvector.sh
./postgres/attach_pgvector.sh

./pgadmin/install_pgadmin4.sh

./deploy/deploy_backend.sh
./deploy/deploy_frontend.sh
