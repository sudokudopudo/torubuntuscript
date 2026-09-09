#!/bin/bash

# ============================================================================
# Setup Tor - Automated Tor Installation and Configuration
# ============================================================================
# Author: sudokudopudo
# Version: 1.0
# Description: Automated Tor installation and configuration with systemd integration
# ============================================================================

# Start notification
notify-send "Setup Tor" "Script is running..." -i dialog-information &

# Install Tor
echo "Installing Tor..."
sudo apt update
sudo apt install -y tor

# Stop Tor service for configuration
echo "Stopping Tor service..."
sudo systemctl stop tor

# Backup original configuration
echo "Backing up original torrc..."
sudo cp /etc/tor/torrc /etc/tor/torrc.backup

# Create new configuration
echo "Configuring Tor..."
sudo tee /etc/tor/torrc > /dev/null << 'EOF'
# Tor configuration file
SocksPort 9050
ControlPort 9051
CookieAuthentication 1
EOF

# Set correct permissions
echo "Setting permissions..."
sudo chown debian-tor:debian-tor /etc/tor/torrc
sudo chmod 600 /etc/tor/torrc

# Start Tor service
echo "Starting Tor service..."
sudo systemctl start tor
sudo systemctl enable tor

# Create ~/.local/bin directory if it doesn't exist
mkdir -p ~/.local/bin

# Create tor-status.sh without sudo
echo "Creating tor-status.sh..."
cat > ~/.local/bin/tor-status.sh << 'EOF'
#!/bin/bash
if systemctl is-active --quiet tor; then
    notify-send "Tor Status" "✅ Tor is running" -i dialog-information &
    echo "Tor is running"
else
    notify-send "Tor Status" "❌ Tor is stopped" -i dialog-error &
    echo "Tor is stopped"
fi
EOF
chmod +x ~/.local/bin/tor-status.sh

# Create tor-start.sh
echo "Creating tor-start.sh..."
cat > ~/.local/bin/tor-start.sh << 'EOF'
#!/bin/bash
sudo systemctl start tor
notify-send "Tor" "✅ Tor started" -i dialog-information &
EOF
chmod +x ~/.local/bin/tor-start.sh

# Create tor-stop.sh
echo "Creating tor-stop.sh..."
cat > ~/.local/bin/tor-stop.sh << 'EOF'
#!/bin/bash
sudo systemctl stop tor
notify-send "Tor" "⏹️ Tor stopped" -i dialog-error &
EOF
chmod +x ~/.local/bin/tor-stop.sh

# Create tor-restart.sh
echo "Creating tor-restart.sh..."
cat > ~/.local/bin/tor-restart.sh << 'EOF'
#!/bin/bash
sudo systemctl restart tor
notify-send "Tor" "🔄 Tor restarted" -i dialog-information &
EOF
chmod +x ~/.local/bin/tor-restart.sh

# Create tor-newidentity.sh
echo "Creating tor-newidentity.sh..."
cat > ~/.local/bin/tor-newidentity.sh << 'EOF'
#!/bin/bash
echo "SIGNAL NEWNYM" | nc localhost 9051
notify-send "Tor" "🔄 New identity requested" -i dialog-information &
EOF
chmod +x ~/.local/bin/tor-newidentity.sh

# Configure NOPASSWD in sudoers
echo "Configuring sudo NOPASSWD for Tor commands..."
sudo tee -a /etc/sudoers.d/tor-nopasswd > /dev/null << 'EOF'
%sudo ALL=(ALL) NOPASSWD: /bin/systemctl start tor, /bin/systemctl stop tor, /bin/systemctl restart tor, /bin/systemctl is-active tor
EOF
sudo chmod 440 /etc/sudoers.d/tor-nopasswd

# Verify Tor service status
echo "Verifying Tor service..."
sleep 2
systemctl is-active --quiet tor && echo "✅ Tor service is active" || echo "❌ Tor service failed"

# Final notification
notify-send "Setup Tor" "✅ Script completed successfully!" -i dialog-information &

echo "Setup completed!"
