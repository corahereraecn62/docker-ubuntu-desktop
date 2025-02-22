#!/bin/bash

# usage: ./docker_build.sh 20.04-cu11.0.3

# echo "argv: $1"
UBUNTU_VERSION=`echo $1 | awk -F '-cu' '{print $1}'`
CUDA_VERSION=`echo $1 | awk -F '-cu' '{print $2}'`
echo "ubuntu version:${UBUNTU_VERSION},cuda version:${CUDA_VERSION}"

docker run -d --restart=on-failure \
    --name my_workspace \
    --gpus all  \
    --shm-size=1024m \
    -e USER=ubuntu \
    -e PASSWORD=ubuntu \
    -e GID=$(id -g) \
    -e UID=$(id -u) \
    -e REMOTE_DESKTOP=kasmvnc \
    -p 10022:22 \
    -p 14000:4000 \
    -p 15000:5000 \
    gezp/ubuntu-desktop:20.04-cu11.0.3

# check ubuntu version
if [[(${UBUNTU_VERSION} != "18.04") && (${UBUNTU_VERSION} != "20.04") && (${UBUNTU_VERSION} != "22.04") && (${UBUNTU_VERSION} != "24.04")]];then
    echo "Invalid ubuntu version:${UBUNTU_VERSION}"
    exit -1
fi

# pull base image (ubuntu/cuda)
if [[("${CUDA_VERSION}" == "")]];then
    BASE_IMAGE=ubuntu:${UBUNTU_VERSION}
else
    BASE_IMAGE=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
fi
echo ${BASE_IMAGE}

docker pull ${BASE_IMAGE}
if [[ $? != 0 ]]; then 
    echo "Failed to pull docker image '${BASE_IMAGE}'"
    exit -2
fi

# build ubuntu-desktop image
if [[("${CUDA_VERSION}" == "")]];then
    DOCKER_TAG=${UBUNTU_VERSION}
else
    DOCKER_TAG=${UBUNTU_VERSION}-cu${CUDA_VERSION}
fi

docker build ubuntu-desktop --file ubuntu-desktop/${UBUNTU_VERSION}/Dockerfile \
             --build-arg BASE_IMAGE=${BASE_IMAGE} \
             --tag ubuntu-desktop:${DOCKER_TAG}
if [[ $? != 0 ]]; then 
    echo "Failed to build docker image 'ubuntu-desktop:${DOCKER_TAG}'"
    exit -3
fi

exit 0
