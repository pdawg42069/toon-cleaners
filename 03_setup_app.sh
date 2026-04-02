#!/bin/bash
# =============================================================
# 03_setup_app.sh
# Installs Node.js, app dependencies, and registers the
# toon-cleaners app as a systemd service
# =============================================================

set -e

APP_DIR="$HOME/toon-cleaners"
SERVICE_NAME="toon-cleaners"
APP_USER="$USER"

echo "==> Installing Node.js..."
sudo apt update -qq
sudo apt install -y nodejs npm

echo "==> Node version: $(node -v)"
echo "==> NPM version:  $(npm -v)"

echo "==> Installing app dependencies..."
cd "$APP_DIR"
npm install

echo "==> Checking for .env file..."
if [ ! -f "$APP_DIR/.env" ]; then
  echo ""
  echo "    ERROR: No .env file found at $APP_DIR/.env"
  echo "    Create a .env file with your DB credentials before running this script."
  echo ""
  exit 1
fi

echo "==> Creating systemd service..."
sudo tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null <<EOF
[Unit]
Description=Toon Cleaners App
After=network.target postgresql.service

[Service]
Type=simple
User=${APP_USER}
WorkingDirectory=${APP_DIR}
ExecStart=/usr/bin/node ${APP_DIR}/server.js
Restart=on-failure
RestartSec=5
EnvironmentFile=${APP_DIR}/.env

[Install]
WantedBy=multi-user.target
EOF

echo "==> Enabling and starting service..."
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo ""
echo "==> Done. Toon Cleaners is running."
echo "    Status: sudo systemctl status $SERVICE_NAME"
echo "    Logs:   journalctl -u $SERVICE_NAME -f"
echo "    URL:    http://$(hostname -I | awk '{print $1}'):3000"
