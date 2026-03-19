#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

cp nat-router.sh /root/nat-router.sh || {
  echo "Copy failed"
  exit 1
}
echo "Choose your local network and public Internet Interfaces"
echo
ip -4 addr | awk '/^[0-9]+:/ {iface=$2} /inet / {print iface, $2}'
read -p "Enter local network interface name(Not the IP or number after /):" LAN_IF
read -p "Enter public Internet network interface name:" WAN_IF  
echo "LAN_IF=$LAN_IF" > /etc/nat-router.conf
echo "WAN_IF=$WAN_IF" >> /etc/nat-router.conf

chmod +x /root/nat-router.sh

cp nat-router.service /etc/systemd/system/nat-router.service

systemctl daemon-reload
systemctl enable nat-router.service
systemctl start nat-router.service
if [ "$?" -eq 0 ]; then
echo "Router was successfully installed. Set the computers Default gateway to the ip address of this computer."
exit 0
fi
echo "Failed see the lines above"
