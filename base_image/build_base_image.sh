#!/bin/bash

docker build -t base_image_builder - < Dockerfile 

docker run --privileged \
    -v ${PWD}/generated:/root/generated \
    -v ${PWD}/debian_homelab.yaml:/root/debian_homelab.yaml \
    base_image_builder \
    sh -c "distrobuilder build-lxc /root/debian_homelab.yaml /root/generated && chown 1000:1000 /root/generated/*"
