#!/usr/bin/env python
import argparse
import os
import sys

DEBIAN_RELEASES = {
    "bullseye": "11"
}
IRONIC_RELEASES = ["stable/xena"]

VARIANTS = {
    'amd64': {
        'name-suffix': '-AMD64',
        'extra-elements': '',
    },
    'arm64': {
        'name-suffix': '-ARM64',
        'extra-elements': '',
    },
}


def main():
    parser = argparse.ArgumentParser(description='__doc__')

    parser.add_argument('-n', '--release', type=str, default="bullseye",
        choices=DEBIAN_RELEASES,
        help='Debian release adjective name')
    parser.add_argument('-v', '--variant', type=str, default="amd64",
        choices=VARIANTS,
        help='Image variant to build')
    parser.add_argument('-o', '--ironic', type=str, default="stable/xena",
        choices=IRONIC_RELEASES,
        help='ironic release name')

    args = parser.parse_args()

    version_number = DEBIAN_RELEASES[args.release]
    variant_info = VARIANTS[args.variant]
    image_name = f"CC-IPA-Debian{version_number}{variant_info['name-suffix']}"
    env_updates = {
        'DEBIAN_ADJECTIVE': args.release,
        'DEBIAN_VERSION': version_number,
        'IMAGE_NAME': image_name,
        'EXTRA_ELEMENTS': variant_info['extra-elements'],
        'VARIANT': args.variant,
        'IRONIC_RELEASE': args.ironic,
    }
    env = os.environ.copy()
    env.update(env_updates)

    os.execle('create-image.sh', 'create-image.sh', env)


if __name__ == '__main__':
    sys.exit(main())
