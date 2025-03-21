#!/bin/bash

CONFIG_FILE="$HOME/.config/XBash/config.cfg"
LOG_DIRECTORY="$HOME/.config/XBash"
LOG="$LOG_DIRECTORY/XBash.log"
show_gui=false
VERSION="1.0.1"

while [[ $# -gt 0 ]]; do
    case $1 in
        --version|-v)
            echo "XBash version $VERSION"
            exit 0
            ;;
        --gui|-g)
            show_gui=true
            shift
            ;;
        *)
            IMAGE_PATH="$1"
            shift
            ;;
    esac
done

# Skip update check if GUI mode is enabled
if ! $show_gui; then
    LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/iwishkem/XBash/main/version)
    if [ "$VERSION" != "$LATEST_VERSION" ]; then
        echo "A new version ($LATEST_VERSION) is available. You are using version $VERSION."
        read -p "Do you want to update now? (y/n): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "Updating to version $LATEST_VERSION..."
            curl -o "$HOME/.local/bin/xbash" https://raw.githubusercontent.com/iwishkem/XBash/main/latest
            chmod +x "$HOME/.local/bin/xbash"
            echo "Update complete! Please restart the script."
            exit 0
        else
            # echo "Skipping update."
        fi
    fi
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file $CONFIG_FILE not found!"
    echo "Please run the install script to create the configuration file."
    exit 1
fi

source "$CONFIG_FILE"

if [ -z "$UPLOAD_URL" ] || [ -z "$TOKEN" ]; then
    echo "Error: UPLOAD_URL and TOKEN must be set in the config file."
    exit 1
fi

command -v jq >/dev/null 2>&1 || { echo "jq is required but not installed."; exit 1; }
command -v xclip >/dev/null 2>&1 || { echo "xclip is required but not installed."; exit 1; }

if [ -z "$IMAGE_PATH" ]; then
    echo "Usage: $0 [--gui|-g] <image_path>"
    exit 1
fi

if [ ! -f "$IMAGE_PATH" ]; then
    echo "File not found: $IMAGE_PATH"
    exit 1
fi

RESPONSE=$(curl -s -X POST "$UPLOAD_URL" \
    -F "file=@$IMAGE_PATH" \
    -F "token=$TOKEN")

if echo "$RESPONSE" | jq -e .url > /dev/null; then
    IMAGE_URL=$(echo "$RESPONSE" | jq -r .url)
    DEL_URL=$(echo "$RESPONSE" | jq -r .del_url)
    echo "Image uploaded successfully and copied to clipboard. Link: $IMAGE_URL"
    echo "$IMAGE_URL" | xclip -selection clipboard
    echo "Delete Link: $DEL_URL"
    mkdir -p "$LOG_DIRECTORY"
    echo "-------------------------
$(date '+%x %X')
Link: $IMAGE_URL
Delete: $DEL_URL
    " >> "$LOG"

    if $show_gui; then
        zenity --info --title="Screenshot uploaded" --text="Link: <a href='$IMAGE_URL'>$IMAGE_URL</a>\nDelete: <a href='$DEL_URL'>$DEL_URL</a>\n\nLink copied to clipboard. Links stored in:\n$LOG"
    fi
else
    echo "Error uploading image."
    if $show_gui; then
        zenity --error --text="Failed to upload screenshot"
    fi
fi