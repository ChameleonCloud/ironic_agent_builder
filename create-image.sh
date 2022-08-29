#!/bin/bash

set -e -u -o pipefail

export DIB_RELEASE="$DEBIAN_ADJECTIVE"
export ARCH="$VARIANT"

if [ ! -d ironic-python-agent-builder ]; then
  git clone https://github.com/openstack/ironic-python-agent-builder.git
fi

# Set DIB elements path based on install location
export ELEMENTS_PATH="dib:ironic-python-agent-builder/dib"


IRONIC_BRANCH=$IRONIC_RELEASE
# set references for stable/xena release, not master
export DIB_REPOREF_ironic_python_agent=${IRONIC_BRANCH}
export DIB_REPOREF_ironic_lib=${IRONIC_BRANCH}
export DIB_REPOREF_requirements=${IRONIC_BRANCH}

#10s timeout for dhcp
export DIB_DHCP_TIMEOUT=10
# disable module if networkmanager found
export DIB_DHCP_NETWORK_MANAGER_AUTO=true

TMPDIR=`mktemp -d`
mkdir -p $TMPDIR/common
OUTPUT_FILE="$TMPDIR/common/$IMAGE_NAME"
INITRAMFS_FILE="${OUTPUT_FILE}.initramfs"
KERNEL_FILE="${OUTPUT_FILE}.kernel"
INITRAMFS_NAME="${IMAGE_NAME}.initramfs"
KERNEL_NAME="${IMAGE_NAME}.kernel"

disk-image-create \
	-o $OUTPUT_FILE \
	ironic-python-agent-ramdisk \
	burn-in \
	chi-extra-drivers \
	extra-hardware \
	dynamic-login \
	debian-minimal

if [ $? -eq 0 ]; then
  # The below line echoed to stdout is used by Abracadabra
  echo "Image built in $OUTPUT_FILE"
  if [ -f "$INITRAMFS_FILE" ]; then
    echo "to add the initramfs image in glance run the following command:"
    echo "openstack image create --disk-format aki --container-format aki --file $INITRAMFS_FILE \"${INITRAMFS_NAME}\""
  fi
  if [ -f "$KERNEL_FILE" ]; then
    echo "to add the kernel image in glance run the following command:"
    echo "openstack image create --disk-format aki --container-format aki --file $KERNEL_FILE \"${KERNEL_NAME}\""
  fi
else
  echo "Failed to build image"
  exit 1
fi
