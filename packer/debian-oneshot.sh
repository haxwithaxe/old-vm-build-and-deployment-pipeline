#!/bin/bash

# This script is referenced in one of the packer templates so it's being
#   included here for reference.

echo '###################################################'
echo before $@
REPO="$1"
shift
BRANCH="${1:-main}"  # Or commit or tag
shift
echo '###################################################'
echo after $@

DEBIAN_NONINTERACTIVE=true
apt update -y
apt install --no-install-recommends --no-install-suggests -q -y python3-pip python3-venv git
python3 -m venv /tmp/ansible-venv
source /tmp/ansible-venv/bin/activate
pip install ansible
apt purge -y --autoremove python3-pip python3-venv
ansible-pull -U "$REPO" -C "$BRANCH" $@
rm -rf /tmp/ansible-venv ~/.ansible
