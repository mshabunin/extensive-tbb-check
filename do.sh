#!/bin/bash

set -e
set -x

IMG=check-tbb

docker build \
    -t $IMG \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    --build-arg http_proxy="$http_proxy=" \
    --build-arg https_proxy="$https_proxy=" \
    - < Dockerfile

mkdir -p cache

docker run --interactive --tty --rm \
    --env http_proxy=${http_proxy} \
    --env https_proxy=${https_proxy} \
    --volume $(readlink -f $HOME/Libs):/opt/lib:ro \
    --volume $(readlink -f ../opencv):/opencv \
    --volume $(readlink -f ../opencv_extra):/opencv_extra \
    --volume $(readlink -f ../opencv_contrib):/opencv_contrib \
    --volume $(readlink -f ../build):/build \
    --volume $(readlink -f scripts):/scripts \
    --volume $(readlink -f cache):/cache \
    $IMG \
    /bin/bash
