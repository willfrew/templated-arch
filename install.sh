#!/usr/bin/bash

ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOTDIR

if [[ "$( id -u )" != "0" ]]; then
  echo "Must be run as root!"
  exit 1
fi

ansible-playbook -i $ROOTDIR/hosts $ROOTDIR/main.yml

