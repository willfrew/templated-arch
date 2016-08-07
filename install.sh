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
ANS_CONF=/etc/ansible

HOSTS=hosts
GROUP_VARS=group_vars
HOST_VARS=host_vars

install_sl "hosts" $CONF/$HOSTS $ANS_CONF/$HOSTS
install_sl "group variables" $CONF/$GROUP_VARS $ANS_CONF/$GROUP_VARS
install_sl "host variables" $CONF/$HOST_VARS $ANS_CONF/$HOST_VARS

