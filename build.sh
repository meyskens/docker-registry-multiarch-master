#!/bin/bash -e

for i in "$@"
    do
        case $i in
        --arch=*)
            ARCH="${i#*=}"
        ;;
        --qemuarch=*)
            QEMU_ARCH="${i#*=}"
        ;;
        --goach=*)
            GO_ATCH="${i#*=}"
        ;;
        --qemuversion=*)
            QEMU_VER="${i#*=}"
        ;;
        --repo=*)
            DOCKER_REPO="${i#*=}"
        ;;
        --version=*)
            VERSION="${i#*=}"
        ;;
        --checkout=*)
            CHECKOUT="${i#*=}"
        ;;
        *)
        # unknown option
        ;;
    esac
done

# install qemu-user-static
if [ -n "${QEMU_ARCH}" ]; then
    if [ ! -f x86_64_qemu-${QEMU_ARCH}-static.tar.gz ]; then
        wget -N https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_VER}/x86_64_qemu-${QEMU_ARCH}-static.tar.gz
    fi
    tar -xvf x86_64_qemu-${QEMU_ARCH}-static.tar.gz -C $ROOTFS/usr/bin/
fi

docker build --build-arg arch="${ARCH}" --build-arg go_arch="${GO_ARCH}"  --build-arg registry_version="${VERSION}" --build-arg checkout="${CHECKOUT}" -t "${DOCKER_REPO}:${ARCH}-${VERSION}" ./