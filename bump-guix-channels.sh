#!/bin/env bash

CHANNELS=`dirname "$0"`/roles/guix/files/channels.scm

# Bare pull to grab latest version of guix
guix pull

guix describe -f channels > $CHANNELS
