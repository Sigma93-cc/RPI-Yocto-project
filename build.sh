#!/bin/bash


CUSTOM_COMMAND=
KAS_IMAGE="kas_image.yml"
BUILD_SDK=0
USE_CUSTOM_COMMAND=0
ADDITIONAL_MOUNT=
DOCKER_V_PATH=

while getopts "sdc:e:" opt; do
  case $opt in
    d) KAS_IMAGE="${KAS_IMAGE}:kas_debug.yml"
    ;;
    c) USE_CUSTOM_COMMAND=1       
       CUSTOM_COMMAND=${OPTARG}
    ;;
    s) BUILD_SDK=1 
    ;;
    e) ADDITIONAL_MOUNT="${OPTARG}"
    ;;
    ?) echo "
Available options:
  -d                  - build image with debug_info.
  -c                  - run custom command
  -s                  - build sdk"
       exit 1
    ;;
  esac
done

if [ -n "$ADDITIONAL_MOUNT" ]; then
       name="${ADDITIONAL_MOUNT%:*}"           
       path="${ADDITIONAL_MOUNT##*:}"           
cat <<EXTERNAL_SOURCES > ./kas_external_pn-${name}.yml
header:
  version: 18

local_conf_header: 
  external-sources: |
    INHERIT += "externalsrc"
    EXTERNALSRC:pn-${name} = "/home/ubuntu/work/${name}"
EXTERNAL_SOURCES
       KAS_IMAGE="${KAS_IMAGE}:kas_external_pn-${name}.yml"
       DOCKER_V_PATH="-v ${path}:/home/ubuntu/work/${name}"
fi

BUILD_COMMAND="kas build ${KAS_IMAGE}"

if [[ ${BUILD_SDK} == 1 ]]; then 
       BUILD_COMMAND="${BUILD_COMMAND} && kas shell ${KAS_IMAGE} -c 'bitbake my-image -c populate_sdk' "
fi

if [[ ${USE_CUSTOM_COMMAND} == 1 ]]; then 
       BUILD_COMMAND="${BUILD_COMMAND} && kas shell ${KAS_IMAGE} -c '${CUSTOM_COMMAND}' "
fi

echo ${BUILD_COMMAND} ${DOCKER_V_PATH}

docker build -t radxa-yocto:latest . && \
docker run -it --rm  \
       -v .:/home/ubuntu/work/yocto \
       ${DOCKER_V_PATH} \
       -w /home/ubuntu/work/yocto \
       radxa-yocto:latest \
       bash -c "${BUILD_COMMAND}"

       