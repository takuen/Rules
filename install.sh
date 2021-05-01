#!/bin/bash
set -e

WORKDIR="$(mktemp -d)"
SERVERS=(114.114.114.114 114.114.115.115 180.76.76.76)
# Not using best possible CDN pop: 1.2.4.8 210.2.4.8 223.5.5.5 223.6.6.6
# Dirty cache: 119.29.29.29 182.254.116.116


echo "Downloading latest configurations..."
wget https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf "$WORKDIR"


echo "Removing old configurations..."
rm -f /etc/dnsmasq.d/accelerated-domains.china.conf

echo "Installing new configurations..."
cp "$WORKDIR/accelerated-domains.china.conf" "/etc/dnsmasq.d/accelerated-domains.china.conf"


echo "Restarting dnsmasq service..."
if hash systemctl 2>/dev/null; then
  systemctl restart dnsmasq
elif hash service 2>/dev/null; then
  service dnsmasq restart
elif hash rc-service 2>/dev/null; then
  rc-service dnsmasq restart
elif hash busybox 2>/dev/null && [[ -d "/etc/init.d" ]]; then
  /etc/init.d/dnsmasq restart
else
  echo "Now please restart dnsmasq since I don't know how to do it."
fi

echo "Cleaning up..."
rm -r "$WORKDIR"
