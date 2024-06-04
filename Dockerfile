FROM debian:stable-slim
# Metadata indicating an image maintainer.
LABEL maintainer="d3fau4@not-d3fau4.com"

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=/opt/devkitpro/devkitARM
ENV DEVKITPPC=/opt/devkitpro/devkitPPC
ENV PATH="${PATH}:${DEVKITARM}/bin/:${DEVKITPPC}/bin/:${DEVKITPRO}/bin/"
ENV CMAKE_VERSION="3.29.3"

ENV WORKDIR="/build"
WORKDIR "${WORKDIR}"

# Upgrade image
RUN apt update && apt upgrade -y

# Install requirements for libtransistor 
RUN apt install -y \
    python3 \
    python3-pip \
    python3-virtualenv \
    python-is-python3 \
    squashfs-tools \
    build-essential \
    llvm \
    clang \
    cmake \
    lld \
    git \
    zip \
    unzip \
    curl \
    wget

# workaround
RUN ln -s /proc/self/mounts /etc/mtab

# Install dkp-pacman
ADD install-devkitpro-pacman ./install-devkitpro-pacman
RUN chmod +x ./install-devkitpro-pacman && ./install-devkitpro-pacman
# RUN curl https://apt.devkitpro.org/install-devkitpro-pacman | bash

# Install devkitARM & devkitA64
RUN dkp-pacman -S $(dkp-pacman -Ssq switch-*) --noconfirm

# Install Switch Tools
RUN dkp-pacman --noconfirm -S \
    hactool

# Install Libnx
RUN git clone https://github.com/switchbrew/libnx.git ${WORKDIR}/libnx \
    && cd ${WORKDIR}/libnx \
    && make \
    && make install \
    && rm -rf ${WORKDIR}/libnx

# Install pip
RUN pip3 install -U pip --break-system-packages

# Install normal libs
RUN pip install lz4 \
    pycryptodome \
    --break-system-packages

# Install Cmake
RUN rm -rf /var/lib/apt/lists/* \
  && wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /opt/cmake-${CMAKE_VERSION} \
      && /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-${CMAKE_VERSION} \
      && rm /tmp/cmake-install.sh \
      && ln -s /opt/cmake-${CMAKE_VERSION}/bin/* /usr/local/bin

# Install GDB
RUN dkp-pacman -Syu devkitA64-gdb --noconfirm