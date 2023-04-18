FROM debian:stable-slim
# Metadata indicating an image maintainer.
LABEL maintainer="d3fau4@not-d3fau4.com"

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=/opt/devkitpro/devkitARM
ENV DEVKITPPC=/opt/devkitpro/devkitPPC
ENV PATH="${PATH}:${DEVKITARM}/bin/:${DEVKITPPC}/bin/:${DEVKITPRO}/bin/"


ENV WORKDIR="/build"
WORKDIR "${WORKDIR}"

# Upgrade image
RUN apt update && apt upgrade -y

# Install requirements for libtransistor 
RUN apt install -y \
    python3 \
    python3-pip \
    python3-virtualenv \
    squashfs-tools \
    build-essential \
    llvm \
    clang \
    lld \
    git \
    zip \
    unzip \
    curl \
    wget \
    libssl-dev

# Install pip
RUN pip3 install -U pip

# Build and install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2.tar.gz && tar -zxvf cmake-3.24.2.tar.gz && \
    cd cmake-3.24.2 && ./bootstrap && make && make install && cd .. && rm -rf cmake-3.24.2/


# Now resync the database and update installed packages.
RUN apt update
# Update the image
RUN apt upgrade -y

# workaround
RUN ln -s /proc/self/mounts /etc/mtab

ADD install-devkitpro-pacman ./install-devkitpro-pacman
RUN chmod +x ./install-devkitpro-pacman && ./install-devkitpro-pacman

# Install dkp-pacman
RUN curl https://apt.devkitpro.org/install-devkitpro-pacman | bash

# Install devkitARM & devkitA64
RUN dkp-pacman --noconfirm -S \
    switch-dev \
    devkitARM \
    devkita64-cmake \
    switch-box2d \
    switch-bulletphysics \
    switch-bzip2 \
    switch-cmake \
    switch-curl \
    switch-enet \
    switch-ffmpeg \
    switch-flac \
    switch-freetype \
    switch-giflib \
    switch-glad \
    switch-glfw \
    switch-glm \
    switch-harfbuzz \
    switch-jansson \
    switch-libass \
    switch-libconfig \
    switch-libdrm_nouveau \
    switch-libexpat \
    switch-libfribidi \
    switch-libgd \
    switch-libjpeg-turbo \
    switch-libjson-c \
    switch-liblzma \
    switch-liblzo2 \
    switch-libmad \
    switch-libmikmod \
    switch-libmodplug \
    switch-libmpv \
    switch-libogg \
    switch-libopus \
    switch-libpcre2 \
    switch-libpng \
    switch-libsamplerate \
    switch-libsodium \
    switch-libssh2 \
    switch-libtheora \
    switch-libtimidity \
    switch-libvorbis \
    switch-libvorbisidec\
    switch-libvpx \
    switch-libwebp \
    switch-libxml2 \
    switch-libzstd \
    switch-lz4 \
    switch-mbedtls \
    switch-mesa \
    switch-miniupnpc \
    switch-mpg123 \
    switch-ode \
    switch-oniguruma \
    switch-openal-soft \
    switch-opusfile \
    switch-physfs \
    switch-pkg-config \
    switch-sdl2 \
    switch-sdl2_gfx \
    switch-sdl2_image \
    switch-sdl2_mixer \
    switch-sdl2_net \
    switch-sdl2_ttf \
    switch-smpeg2 \
    switch-tinyxml2 \
    switch-wslay \
    switch-zlib \
    switch-zziplib

# Install Switch Tools
RUN dkp-pacman --noconfirm -S \
    hactool

# Install Libnx
RUN git clone https://github.com/switchbrew/libnx.git ${WORKDIR}/libnx \
    && cd ${WORKDIR}/libnx \
    && make \
    && make install \
    && rm -rf ${WORKDIR}/libnx

# Install normal libs
RUN pip install lz4 \
    pycryptodome
