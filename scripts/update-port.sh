#!/bin/bash
# Get forwarded port and public VPN IP
PIA_PORT=$(cat /gluetun/forwarded_port)
VPN_IP=$(wget -qO- ipaddress.ai/ip | tr -d '[:space:]')

# Validate IP format
if [[ ! $VPN_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "ERROR: Invalid IP detected ($VPN_IP)" >&2
  exit 1
fi

# Config file location
CONFIG_FILE="/etc/rtorrent/.rtlocal.rc"

# Create atomic update
{
  # Preserve all existing config except network settings
  grep -v -E "^(network.port_range.set|network.local_address.set)" "$CONFIG_FILE"
  
  # Add updated network config
  echo "network.port_range.set = ${PIA_PORT}-${PIA_PORT}"
  echo "network.local_address.set = ${VPN_IP}"
} > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

# Reload rTorrent (SIGUSR1 preserves active downloads)
pkill -SIGUSR1 rtorrent

echo "Updated config:"
grep -E "^(network.port_range.set|network.local_address.set)" "$CONFIG_FILE"
