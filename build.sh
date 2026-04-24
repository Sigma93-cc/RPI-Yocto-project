#!/bin/bash


docker build -t radxa-yocto:latest . && \
docker run -it --rm  \
       -v .:/home/ubuntu/work/yocto \
       -w /home/ubuntu/work/yocto \
       radxa-yocto:latest 
       # bash -c "source sources/poky/oe-init-build-env 
       #          bitbake my-image"