#!/bin/bash

set -e -u -o pipefail

# Set DIB elements path based on install location
export ELEMENTS_PATH=.venv/share/ironic-python-agent-builder/dib:./dib


IRONIC_BRANCH=${IRONIC_BRANCH-stable/xena}
# set references for stable/xena release, not master
export DIB_REPOREF_ironic_python_agent=${IRONIC_BRANCH}
export DIB_REPOREF_ironic_lib=${IRONIC_BRANCH}
export DIB_REPOREF_requirements=${IRONIC_BRANCH}

#10s timeout for dhcp
export DIB_DHCP_TIMEOUT=10
# disable module if networkmanager found
export DIB_DHCP_NETWORK_MANAGER_AUTO=true

#don't remove firmware
# export IPA_REMOVE_FIRMWARE=[]

export ARCH=${ARCH-amd64}
export DIB_RELEASE=bullseye

IMAGE_NAME="ipa-debian-${DIB_RELEASE}-${ARCH}-stable-xena"
INITRAMFS_NAME="${IMAGE_NAME}.initramfs"
KERNEL_NAME="${IMAGE_NAME}.kernel"

source .venv/bin/activate

disk-image-create \
	-o "output/${IMAGE_NAME}" \
	ironic-python-agent-ramdisk \
	burn-in \
	chi-extra-drivers \
	extra-hardware \
	dynamic-login \
	debian-minimal
