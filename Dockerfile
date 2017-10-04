FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    g++ \
    gcc \
    cmake \
    ccache \
    git \
    ninja-build \
    tar \
    curl \
    python

ARG UNAME=test
ARG UID
ARG GID
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME

USER $UNAME

VOLUME /opt/lib
VOLUME /opencv
VOLUME /opencv_extra
VOLUME /opencv_contrib
VOLUME /build
VOLUME /scripts
VOLUME /cache

CMD /bin/bash
