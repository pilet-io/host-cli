#!/bin/bash

if [[ -z "$SYS_HOSTNAME" ]]; then
  echo "Configure SYS_XXX variables"
  exit 1
fi

hostnamectl set-hostname $SYS_HOSTNAME

apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common jq snapd zfsutils-linux
snap install yq
snap install lxd

apt autoremove
apt install -y python3
apt install -y python3-pip
pip install rsa

output="$(zpool list)"

if [[ $output != "no pools available" ]]
then
  echo "ZPOOL is already configured, skipping"
else
  echo "Configuring ZPOOL"
  SECTOR=$(sgdisk -p /dev/nvme0n1 | grep FD00 | grep ' 3 ' | awk '{print $3}')
  sgdisk -n 5:${SECTOR}:0 /dev/nvme0n1
  partprobe /dev/nvme0n1

  SECTOR=$(sgdisk -p /dev/nvme1n1 | grep FD00 | grep ' 3 ' | awk '{print $3}')
  sgdisk -n 5:${SECTOR}:0 /dev/nvme1n1
  partprobe /dev/nvme1n1

  zpool create -f main /dev/nvme0n1p5 /dev/nvme1n1p5
  zpool list
fi

sed -i 's|::2/64|::2/128|g' /etc/netplan/01-netcfg.yaml
netplan apply
