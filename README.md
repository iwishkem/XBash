# XBash Image Uploader

XBash is a Bash script that uploads an image file to a specified server and copies the generated URL to the clipboard.

## Features

- Checks for a configuration file (`config.cfg`), creates a sample one if not found.
- Uploads an image to a specified URL, using the URL and token provided in the configuration.
- Copies the upload link to the clipboard and displays the link via a Zenity dialog.
- Logs all uploaded image URLs and deletion links.

## Requirements

- `bash` (version 4.0 or later)
- `curl` - for uploading the image
- `jq` - for parsing JSON responses
- `xclip` - for copying to the clipboard
- `zenity` - for GUI dialogs

## Installation

1. **Download the script** to your desired directory.
2. **Make the script executable**:

   ```bash
   chmod +x xbash.sh
   ./xbash.sh <image_path>
   ```

   If this is the first time running the script, it will generate a configuration file at `$HOME/.config/XBash/config.cfg` instead of uploading the image.

## Configuration
### Customizing Configuration

You can modify `config.cfg` to set your own `UPLOAD_URL` and `TOKEN` values.

- `UPLOAD_URL`: The server URL to which files will be uploaded.
- `TOKEN`: Your API token for authentication (if required).

## Logs

The script writes logs to `$HOME/.config/XBash/XBash.log`. Check this log file for information on the script's operations and error messages.
