#!/bin/bash

set -e -u -o pipefail

# Set DIB elements path based on install location
export ELEMENTS_PATH=.venv/share/ironic-python-agent-builder/dib:/opt/ipa_build/dib

# set references for stable/xena release, not master
export DIB_REPOREF_ironic_python_agent=stable/xena
export DIB_REPOREF_ironic_lib=stable/xena
export DIB_REPOREF_requirements=stable/xena

#10s timeout for dhcp
# export DIB_DHCP_TIMEOUT=10
# disable module if networkmanager found
export DIB_DHCP_NETWORK_MANAGER_AUTO=true

#don't remove firmware
# export IPA_REMOVE_FIRMWARE=[]

export ARCH=amd64
export DIB_RELEASE=bullseye

IMAGE_NAME="ipa-debian-${DIB_RELEASE}-${ARCH}-stable-xena"
INITRAMFS_NAME="${IMAGE_NAME}.initramfs"
KERNEL_NAME="${IMAGE_NAME}.kernel"

source .venv/bin/activate

disk-image-create \
	-o "${IMAGE_NAME}" \
	ironic-python-agent-ramdisk \
	burn-in \
	chi-extra-drivers \
	extra-hardware \
	dynamic-login \
	debian-minimal
