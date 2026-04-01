#!/bin/bash
# =============================================================
# 01_setup_postgres.sh
# Installs PostgreSQL and sets up the toon_cleaners database
# =============================================================

set -e  # exit on any error

DB_USER="apirillo"
DB_PASSWORD="password"  # change this after setup
DB_NAME="toon_cleaners"

echo "==> Updating apt..."
sudo apt update -qq

echo "==> Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib

echo "==> Starting PostgreSQL..."
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "==> Creating user '$DB_USER'..."
sudo -u postgres psql -c "CREATE USER $DB_USER WITH SUPERUSER PASSWORD '$DB_PASSWORD';" 2>/dev/null \
  || echo "    User '$DB_USER' already exists, skipping."

echo "==> Creating database '$DB_NAME'..."
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;" 2>/dev/null \
  || echo "    Database '$DB_NAME' already exists, skipping."

echo ""
echo "==> Done. Postgres is running."
echo "    User:     $DB_USER"
echo "    Password: $DB_PASSWORD  <-- change this"
echo "    Database: $DB_NAME"
echo ""
echo "To populate the database, run:"
echo "    psql -U $DB_USER -h localhost -d $DB_NAME -f toon_cleaners.sql"
