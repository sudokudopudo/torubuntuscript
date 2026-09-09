# Tor Ubuntu Script

Automated Tor installation and configuration of desktop shortcuts on Ubuntu.

## Features

- Installs and configures Tor
- Creates desktop shortcuts
- Sets up Tor control socket (SOCKS5 proxy on port 9050)

## Requirements

- Ubuntu 20.04 LTS or newer (tested on Ubuntu 26.04 LTS)
- Works on Kubuntu, Xubuntu, and other Ubuntu variants
- sudo privileges

## Browser Configuration

After running the script:

    Open your browser (Firefox, Librewolf, etc.)
    Go to Settings → Network → Proxy
    Configure SOCKS5:
        Host: 127.0.0.1
        Port: 9050
    Restart Tor and test your connection



## Installation
```bash
cd ~/Downloads
bash setup-tor-complete.sh
