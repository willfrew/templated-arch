#!/bin/env bash

guix pull

guix describe -f channels > `dirname "$0"`/roles/guix/files/channels.scm
