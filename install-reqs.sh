#!/bin/bash

set -x
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

python --version

pip install --upgrade pip
pip install diskimage-builder
