#!/bin/bash

apt update

git clone https://github.com/pilet-io/host-cli.git
mv /root/host-cli /root/cli

echo "export PATH=$PATH:/root/cli" >> /root/.profile
source /root/.profile

with host configure with-completion