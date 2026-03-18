#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

cp nat-router.sh /root/nat-router.sh || {
  echo "Copy failed"
  exit 1
}

nano /root/nat-router.sh
chmod +x /root/nat-router.sh

cp nat-router.service /etc/systemd/system/nat-router.service

systemctl daemon-reload
systemctl enable nat-router.service
systemctl start nat-router.service
