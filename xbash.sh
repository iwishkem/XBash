#!/bin/bash

CONFIG_FILE="$HOME/.config/XBash/config.cfg"
LOG_DIRECTORY="$HOME/.config/XBash"
LOG="$LOG_DIRECTORY/XBash.log"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file $CONFIG_FILE not found!"
    echo "Creating an example config file..."
    mkdir -p "$(dirname "$CONFIG_FILE")"

    cat <<EOF > "$CONFIG_FILE"
UPLOAD_URL="https://im-a-loser.pleasedontbully.me/api/files/create"
TOKEN="your-api-token-here"
EOF

    echo "Example config file created at $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

if [ -z "$UPLOAD_URL" ] || [ -z "$TOKEN" ]; then
    echo "Error: UPLOAD_URL and TOKEN must be set in the config file."
    exit 1
fi

IMAGE_PATH="$1"

command -v jq >/dev/null 2>&1 || { echo "jq is required but not installed."; exit 1; }
command -v xclip >/dev/null 2>&1 || { echo "xclip is required but not installed."; exit 1; }

if [ -z "$IMAGE_PATH" ]; then
    echo "Usage: $0 <image_path>"
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
Delete: $DEL_URL" >> "$LOG"

    zenity --info --title="Screenshot uploaded" --text="Link: <a href='$IMAGE_URL'>$IMAGE_URL</a>
Delete: <a href='$DEL_URL'>$DEL_URL</a>

Link copied to clipboard. Links stored in:
$LOG"
else
    echo "Error uploading image."
    zenity --error --text="Failed to upload screenshot"
fi
