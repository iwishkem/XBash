#!/bin/bash
echo "Installing XBash..."

# Check the Linux distribution and install required packages
if [[ "$(uname -s)" == "Linux" ]]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                echo "Detected $ID. Installing required packages..."
                sudo apt-get update
                sudo apt-get install -y curl jq xclip zenity
                ;;
            fedora|centos|rhel)
                echo "Detected $ID. Installing required packages..."
                sudo yum install -y curl jq xclip zenity
                ;;
            arch)
                echo "Detected Arch Linux. Installing required packages..."
                sudo pacman -Syu --noconfirm curl jq xclip zenity
                ;;
            *)
                echo "Unsupported Linux distribution: $ID. Please install 'curl', 'xclip', 'zenity' and 'jq' manually."
                ;;
        esac
    else
        echo "Unable to detect Linux distribution. Please install 'curl', 'xclip', 'zenity' and 'jq' manually."
    fi

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

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "$HOME/.local/bin is not in PATH. Adding it..."
    SHELL_CONFIG="$HOME/.bashrc"
    echo "export PATH=\$PATH:\$HOME/.local/bin" >> "$SHELL_CONFIG"
    echo "Added $HOME/.local/bin to PATH in $SHELL_CONFIG. Please restart your shell or run 'source $SHELL_CONFIG'."
else
    echo "$HOME/.local/bin is already in PATH."
fi

echo "Installation complete."