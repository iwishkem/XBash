# XBash Image Uploader

XBash is a Python script that uploads an image file to a specified server and copies the generated URL to the clipboard.

## Features

- Checks for a configuration file (`config.json`), creates a sample one if not found.
- Uploads an image to a specified URL, using the URL and token provided in the configuration.
- Copies the upload link to the clipboard.
- Logs all uploaded image URLs and deletion links.

## Requirements

- Python 3.6 or later
- `requests` - for HTTP requests
- `xclip` (Linux) or equivalent clipboard utility for your OS

### Supported Platforms

The script supports the following platforms:

- Linux (requires `xclip` for clipboard functionality)
- macOS (uses `pbcopy` for clipboard functionality)
- Windows (uses `clip` for clipboard functionality)

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/iwishkem/XBash.git
   cd XBash
   ```

2. **Install dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

3. **Run the script**:

   ```bash
   python xbash.py <image_path>
   ```

## Usage

Run the script with the following syntax:

```bash
python xbash.py <image_path>
```

To check the version:

```bash
python xbash.py --version
```

If this is the first time running the script, it will generate a configuration file at `$HOME/.config/XBash/config.json` instead of uploading the image.

## Configuration

### Customizing Configuration

You can modify `config.json` to set your own `UPLOAD_URL` and `TOKEN` values.

- `UPLOAD_URL`: The server URL to which files will be uploaded.
- `TOKEN`: Your API token for authentication (if required).

## Logs

The script writes logs to `$HOME/.config/XBash/XBash.log`. Check this log file for information on the script's operations and error messages.