#!/bin/bash
# Simple NAT router for Lubuntu
source /etc/nat-router.conf
echo "[+] Enabling IP forwarding"
sysctl -w net.ipv4.ip_forward=1

echo "[+] Flushing old iptables rules"
iptables -F
iptables -t nat -F
iptables -X

echo "[+] Setting default policies"
iptables -P FORWARD DROP
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

echo "[+] Allow forwarding from LAN to WAN"
iptables -A FORWARD -i "$LAN_IF" -o "$WAN_IF" -s "$LAN_NET" -j ACCEPT

echo "[+] Allow established/related connections back in"
iptables -A FORWARD -i "$WAN_IF" -o "$LAN_IF" \
  -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "[+] Enable NAT (MASQUERADE)"
iptables -t nat -A POSTROUTING -o "$WAN_IF" -j MASQUERADE

echo "[?] NAT router enabled"
