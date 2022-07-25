FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
ENV XDG_CACHE_HOME=/root/.cache

# python3,pip,venv needed for ironic-python-agent-builder
# qemu-utils,git,cpio,procps needed for debootstrap, used for debian-minimal
# qemu-user-static needed for cross-platform builds

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    qemu-utils \
    qemu-user-static \
    sudo \
    debootstrap \
    git \
    cpio \
    procps


WORKDIR /opt/ipa_build
COPY requirements.txt .

RUN python3 -m venv .venv
RUN .venv/bin/python3 -m pip install -r requirements.txt

COPY build_image.sh .

VOLUME /root/.cache
VOLUME /opt/output

CMD ./build_image.sh
