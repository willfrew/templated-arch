#!/usr/bin/bash
set -eux

ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOTDIR

if [[ "$( id -u )" != "0" ]]; then
  echo "Must be run as root!"
  exit 1
fi

HOST=$([[ -e /etc/hostname  ]] && cat /etc/hostname)
if [[ "$HOST" == "" ]]; then
  echo "/etc/hostname must be populated with name of this ansible host"
  exit 1
fi

cd $ROOTDIR
git submodule init
git submodule update --remote --checkout

# Update pacman cache
pacman -Sy
# System upgrade
pacman -Su

ansible-playbook $ROOTDIR/main.yml --inventory $ROOTDIR/hosts --limit $HOST "$@"

