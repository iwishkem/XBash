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

### Supported Linux Distributions

The script supports the following Linux distributions for automatic package installation:

- Ubuntu/Debian (via `apt-get`)
- Fedora/CentOS/RHEL (via `yum`)
- Arch Linux (via `pacman`)

For unsupported distributions, you must manually install the required packages.

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/your-username/XBash.git
   cd XBash
   ```

2. **Run the install script**:

   ```bash
   ./install.sh
   ```

   This will:
   - Install required packages (`curl`, `jq`, `xclip`, `zenity`) based on your Linux distribution.
   - Copy the script to `$HOME/.local/bin/xbash`.
   - Create a configuration file at `$HOME/.config/XBash/config.cfg` if it doesn't already exist.
   - Automatically add $HOME/.local/bin to your PATH if it is not already included.

## Usage

Run the script with the following syntax:

```bash
xbash <image_path>
```

For GUI mode:

```bash
xbash --gui <image_path>
```

To check the version:

```bash
xbash --version
```

If this is the first time running the script, it will generate a configuration file at `$HOME/.config/XBash/config.cfg` instead of uploading the image.

## Configuration

### Customizing Configuration

You can modify `config.cfg` to set your own `UPLOAD_URL` and `TOKEN` values.

- `UPLOAD_URL`: The server URL to which files will be uploaded.
- `TOKEN`: Your API token for authentication (if required).

## Logs

The script writes logs to `$HOME/.config/XBash/XBash.log`. Check this log file for information on the script's operations and error messages.
