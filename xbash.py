import os
import sys
import requests
import json
import subprocess
from pathlib import Path

CONFIG_FILE = Path.home() / ".config/XBash/config.json"
LOG_DIRECTORY = Path.home() / ".config/XBash"
LOG_FILE = LOG_DIRECTORY / "XBash.log"
VERSION = "1.0.1"

LOG_DIRECTORY.mkdir(parents=True, exist_ok=True)

def load_config():
    if not CONFIG_FILE.exists():
        print(f"Configuration file not found at {CONFIG_FILE}. Creating a new one...")
        CONFIG_FILE.parent.mkdir(parents=True, exist_ok=True)
        config = {
            "UPLOAD_URL": "https://sxcu.net/api/files/create",
            "TOKEN": "your-api-token-here",
            "LATEST_URL": "https://raw.githubusercontent.com/iwishkem/XBash/python-tui/latest",
            "VERSION_URL": "https://raw.githubusercontent.com/iwishkem/XBash/python-tui/version"
        }
        with open(CONFIG_FILE, "w") as f:
            json.dump(config, f, indent=4)
        print(f"Configuration file created at {CONFIG_FILE}. Please edit it to set your UPLOAD_URL and TOKEN.")
        sys.exit(1)
    with open(CONFIG_FILE, "r") as f:
        return json.load(f)

def copy_to_clipboard(text):
    if sys.platform == "win32":
        subprocess.run("clip", universal_newlines=True, input=text)
    elif sys.platform == "darwin":
        subprocess.run("pbcopy", universal_newlines=True, input=text)
    else:
        subprocess.run("xclip", universal_newlines=True, input=text, shell=True)

def check_for_updates(config):
    try:
        latest_version = requests.get(config["VERSION_URL"]).text.strip()
        if VERSION != latest_version:
            print(f"A new version ({latest_version}) is available. You are using version {VERSION}.")
            confirm = input("Do you want to update now? (y/n): ").strip().lower()
            if confirm == "y":
                print(f"Updating to version {latest_version}...")
                latest_script = requests.get(config["LATEST_URL"]).text
                with open(__file__, "w") as f:
                    f.write(latest_script)
                print("Update complete! Please restart the script.")
                sys.exit(0)
            else:
                print("Skipping update.")
    except Exception as e:
        print(f"Failed to check for updates: {e}")

def upload_image(config, image_path):
    if not Path(image_path).is_file():
        print(f"File not found: {image_path}")
        sys.exit(1)
    try:
        with open(image_path, "rb") as f:
            response = requests.post(
                config["UPLOAD_URL"],
                files={"file": f},
                data={"token": config["TOKEN"]}
            )
        response.raise_for_status()
        data = response.json()
        if "url" in data:
            image_url = data["url"]
            delete_url = data.get("del_url", "N/A")
            print(f"Image uploaded successfully: {image_url}")
            copy_to_clipboard(image_url)
            print(f"Delete Link: {delete_url}")
            with open(LOG_FILE, "a") as log:
                log.write(f"-------------------------\n")
                log.write(f"Link: {image_url}\n")
                log.write(f"Delete: {delete_url}\n")
        else:
            print(f"Error uploading image: {data}")
    except Exception as e:
        print(f"Failed to upload image: {e}")

def main():
    config = load_config()
    check_for_updates(config)
    if len(sys.argv) < 2:
        print("Usage: python xbash.py <image_path>")
        input("Press Enter to exit...")
        sys.exit(1)
    if "--version" in sys.argv or "-v" in sys.argv:
        print(f"XBash version {VERSION}")
        input("Press Enter to exit...")
        sys.exit(0)
    image_path = sys.argv[1]
    upload_image(config, image_path)
    input("Press Enter to exit...")

if __name__ == "__main__":
    main()