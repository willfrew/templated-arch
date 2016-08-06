#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# Ensure we're root
if [[ "$(id -u)" != "0" ]]; then
  fatal "This script must be run as root"
  exit 1
fi

##
# Load Helper Functions
##
UTILS=$DIR/util
source $UTILS/logging.sh
source $UTILS/install_sl.sh

##
# Install Script
##

CONF=$DIR/inventory
HOSTS=$CONF/hosts

ANS_CONF=/etc/ansible
ANS_HOSTS=$ANS_CONF/hosts

install_sl "ansible inventory hosts" $HOSTS $ANS_HOSTS
