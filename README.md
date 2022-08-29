# Ironic Agent Builder

This directory contains the scripts used to generate the Chameleon IPA images.

## Requirements

Install with `install-reqs.sh`. It installs

* [disk-image-builder](http://docs.openstack.org/developer/diskimage-builder)

## Usage

The main script takes an output variant as a single input parameter:
```
python create-image.py [--release <release>] [--variant <variant>] [--ironic <ironic release>]
```

* release: Debian release; default value `bullseye`
* variant: Image variant; default value `amd64`
* ironic: Ironic release; default value `stable/xena`
