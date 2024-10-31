#!/bin/bash

if [[ -z "$SYS_HOSTNAME" ]]; then
  echo "Configure SYS_XXX variables"
  exit 1
fi

hostnamectl set-hostname $SYS_HOSTNAME

apt update
apt install -y apt-transport-https ca-certificates curl apt-utils software-properties-common gnupg jq
