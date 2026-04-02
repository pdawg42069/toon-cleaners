#!/bin/bash
# =============================================================
# 02_setup_pgadmin.sh
# Installs pgAdmin4 web and creates an admin login account
# =============================================================

set -e  # exit on any error

PGADMIN_EMAIL="admin@tooncleaner.com"
PGADMIN_PASSWORD="password"  # change this after setup

echo "==> Installing dependencies..."
sudo apt install -y curl gnupg2

echo "==> Adding pgAdmin apt repository..."
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub \
  | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] \
  https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" \
  > /etc/apt/sources.list.d/pgadmin4.list'

echo "==> Installing pgAdmin4 web..."
sudo apt update -qq
sudo apt install -y pgadmin4-web

echo "==> Configuring Apache for pgAdmin..."
sudo /usr/pgadmin4/bin/setup-web.sh --yes 2>/dev/null || true

echo "==> Creating pgAdmin admin user..."
sudo /usr/pgadmin4/venv/bin/python3 /usr/pgadmin4/web/setup.py \
  add-user --admin "$PGADMIN_EMAIL" "$PGADMIN_PASSWORD"


echo ""
echo "==> Done. pgAdmin is available at:"
echo "    http://$(hostname -I | awk '{print $1}')/pgadmin4"
echo ""
echo "    Email:    $PGADMIN_EMAIL  <-- change this"
echo "    Password: $PGADMIN_PASSWORD  <-- change this"
