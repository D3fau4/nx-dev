FROM archlinux/archlinux

# Metadata indicating an image maintainer.
LABEL maintainer="d3fau4@not-d3fau4.tk"

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=/opt/devkitpro/devkitARM
ENV DEVKITPPC=/opt/devkitpro/devkitPPC
ENV PATH="${PATH}:${DEVKITARM}/bin/:${DEVKITPPC}/bin/"


ENV WORKDIR="/build"
WORKDIR "${WORKDIR}"

# Upgarde image
RUN pacman --noconfirm -Syu

# Install requirements for libtransistor 
RUN pacman --noconfirm -S \
    llvm \
    clang \
    lld \
    python \
    python-pip \
    python-virtualenv \
    squashfs-tools \
    base-devel \
    git \
    cmake \
    libx11 \
    zip \
    unzip

RUN pacman-key --init
# Install devkitpro 
# doc source :
# https://devkitpro.org/wiki/devkitPro_pacman

# First import the key which is used to validate the packages 
RUN pacman-key --recv BC26F752D25B92CE272E0F44F7FD5492264BB9D0 --keyserver keyserver.ubuntu.com
RUN pacman-key --lsign BC26F752D25B92CE272E0F44F7FD5492264BB9D0

# Add the devkitPro repositories
ADD devkit_repo ./devkit_repo
RUN cat ./devkit_repo >> /etc/pacman.conf
# Install the keyring which adds more keys which may be used to verify the packages. 
RUN pacman --noconfirm -U https://pkg.devkitpro.org/devkitpro-keyring.pkg.tar.xz
# Now resync the database and update installed packages.
RUN pacman -Sy
# Update the image
RUN pacman --noconfirm -Syu

# Install devkitARM & devkitA64
RUN pacman --noconfirm -S \
    switch-dev \
    devkitARM \
    switch-box2d \
    switch-bulletphysics \
    switch-bzip2 \
    switch-cmake \
    switch-curl \
    switch-enet \
    switch-examples \
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

# Install Libnx
RUN git clone https://github.com/switchbrew/libnx.git ${WORKDIR}/libnx \
    && cd ${WORKDIR}/libnx \
    && make \
    && make install \
    && rm -rf ${WORKDIR}/libnx

# Install pip
RUN pip3 install -U pip

# Install normal libs
RUN pip install lz4 \
    pycryptodome