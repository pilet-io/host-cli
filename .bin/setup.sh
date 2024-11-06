#!/bin/bash

apt update

git clone git@github.com:pilet-io/host-cli.git
mv /root/host-cli /root/cli

sed -i '/export PATH=\$PATH:\/root\/cli' /root/.profile
echo "export PATH=\$PATH:/root/cli" >> /root/.profile
source /root/.profile

with host configure with-completion