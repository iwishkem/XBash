#!/bin/bash
echo "Installing XBash..."
mkdir -p "$HOME/.local/bin"
cp xbash.sh "$HOME/.local/bin/xbash"
chmod +x "$HOME/.local/bin/xbash"

CONFIG_FILE="$HOME/.config/XBash/config.cfg"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating configuration file at $CONFIG_FILE..."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    cat <<EOF > "$CONFIG_FILE"
UPLOAD_URL="https://sxcu.net/api/files/create"
TOKEN="your-api-token-here"
EOF
    echo "Configuration file created. Please edit $CONFIG_FILE to set your UPLOAD_URL and TOKEN."
else
    echo "Configuration file already exists at $CONFIG_FILE. Skipping creation."
fi

echo "Installation complete. Add $HOME/.local/bin to your PATH if not already done."