#!/usr/bin/env bash
# AudioForge prerelease installer for Decky Loader on SteamOS
# Installs the latest prerelease (test) build from GitHub
set -euo pipefail

PLUGIN_NAME="AudioForge"
PLUGINS_DIR="/home/deck/homebrew/plugins"
TEMP_ZIP="/tmp/${PLUGIN_NAME}.zip"
REPO="neoseek/AudioForge"
API_URL="https://api.github.com/repos/${REPO}/releases"

echo "Installing ${PLUGIN_NAME} (prerelease)..."

echo "Fetching latest prerelease..."
DOWNLOAD_URL=$(curl -fsSL "$API_URL" \
  | python3 -c "
import json, sys
releases = json.load(sys.stdin)
for r in releases:
    if r['prerelease']:
        for a in r['assets']:
            if a['name'] == '${PLUGIN_NAME}.zip':
                print(a['browser_download_url'])
                sys.exit(0)
print('', file=sys.stderr)
sys.exit(1)
")

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: No prerelease found with ${PLUGIN_NAME}.zip asset"
  exit 1
fi

echo "Downloading from: ${DOWNLOAD_URL}"
curl -L -o "$TEMP_ZIP" "$DOWNLOAD_URL"

echo "Extracting to ${PLUGINS_DIR}..."
sudo unzip -o "$TEMP_ZIP" -d "$PLUGINS_DIR"

rm -f "$TEMP_ZIP"

echo "Restarting Decky Loader..."
sudo systemctl restart plugin_loader.service

echo "AudioForge prerelease installed successfully!"
