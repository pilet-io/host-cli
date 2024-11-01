#!/bin/bash

if [ -z "$SYS_HOSTNAME" ]; then
  echo "Configure SYS_XXX variables"
  exit 1
fi

hostnamectl set-hostname $SYS_HOSTNAME

apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common jq snapd zfsutils-linux
snap install yq
snap install lxd

output="$(zpool list)"

if [ "$output" != "no pools available" ]; then
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

cat <<EOF | openssl enc -aes-256-cbc -a -d -pbkdf2 -k $SYS_PASSCODE > /root/.ssh/id_rsa
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
R5l3rXtz3E2zFg4rhLBLiw==
EOF

chmod 400 /root/.ssh/id_rsa
sleep 1s

ssh -T git@github.com
git clone git@github.com:pilet-io/host-cli.git

mv /root/host-cli /root/cli

sed -i '/export PATH=\$PATH:\/root\/cli:\/root\/cli\/.bin/d' /root/.profile
echo "export PATH=\$PATH:/root/cli:/root/cli/.bin" >> /root/.profile
